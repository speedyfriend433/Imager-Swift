import SwiftUI
import Vision
import UIKit

struct ContentView: View {
    @State private var selectedImage: UIImage?
    @State private var detectedText: String = ""
    @State private var editedText: String = ""
    @State private var isEditing = false
    @State private var isShowingImagePicker = false
    @State private var keyboardHeight: CGFloat = 0
    @State private var isSaveButtonVisible = false
    @StateObject private var viewModel = HistoryViewModel() // ViewModel 추가

    var body: some View {
        TabView {
            NavigationView {
                ZStack {
                    Color.gray.opacity(0.1) // Solid color background

                    ScrollView {
                        VStack(spacing: 20) {
                            if selectedImage == nil {
                                Text("Select image to extract text")
                                    .font(.title)
                                    .foregroundColor(.gray)
                                    .padding()
                            }

                            Button("Select Image") {
                                self.isShowingImagePicker.toggle()
                            }
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(10)

                            if let image = selectedImage {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFit()
                                    .cornerRadius(10)

                                Text("Detected Text:")
                                    .font(.title)
                                    .foregroundColor(.blue)

                                if isEditing {
                                    ScrollView {
                                        TextEditor(text: $editedText)
                                            .padding()
                                            .background(Color.gray.opacity(0.1))
                                            .cornerRadius(10)
                                    }
                                    .frame(maxHeight: .infinity)
                                } else {
                                    Text(detectedText)
                                        .padding()
                                        .background(Color.gray.opacity(0.1))
                                        .cornerRadius(10)
                                        .font(.body)
                                }

                                HStack {
                                    if !isEditing {
                                        Button("Edit") {
                                            editedText = detectedText
                                            isEditing.toggle()
                                        }
                                        .padding()
                                        .foregroundColor(.white)
                                        .background(Color.blue)
                                        .cornerRadius(10)
                                    } else {
                                        Spacer()

                                        Button("Save") {
                                            detectedText = editedText
                                            isEditing.toggle()
                                            withAnimation {
                                                self.isSaveButtonVisible = false
                                            }
                                            if let index = viewModel.historyItems.firstIndex(where: { $0.extractedText == detectedText }) {
                                                viewModel.historyItems[index].editedText = editedText // Update edited text in history
                                                viewModel.saveHistoryItems() // Save history items
                                            }
                                        }
                                        .padding()
                                        .foregroundColor(.white)
                                        .background(Color.green)
                                        .cornerRadius(10)
                                        .offset(y: -keyboardHeight + (isSaveButtonVisible ? -40 : 0))
                                        .animation(.easeInOut)
                                    }

                                    Button("Copy") {
                                        UIPasteboard.general.string = detectedText
                                    }
                                    .padding()
                                    .foregroundColor(.white)
                                    .background(Color.blue)
                                    .cornerRadius(10)

                                    Button("Export") {
                                        if !detectedText.isEmpty {
                                            exportTextAsFile(detectedText)
                                        }
                                    }
                                    .padding()
                                    .foregroundColor(.white)
                                    .background(Color.blue)
                                    .cornerRadius(10)

                                    Button("Re-scan") {
                                        if let image = selectedImage {
                                            extractTextFromImage(image: image)
                                        }
                                    }
                                    .padding()
                                    .foregroundColor(.white)
                                    .background(Color.blue)
                                    .cornerRadius(10)
                                }
                                .padding(.bottom, 50) // Add padding to ensure buttons are above the keyboard
                            }
                        }
                        .padding()
                    }
                    .edgesIgnoringSafeArea(.all)
                    .sheet(isPresented: $isShowingImagePicker, onDismiss: processImage) {
                        ImagePicker(image: self.$selectedImage)
                    }
                    .onAppear {
                        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { notification in
                            guard let keyboardSize = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
                            self.keyboardHeight = keyboardSize.height
                        }
                        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
                            self.keyboardHeight = 0
                        }
                    }
                }
            }
            .tabItem {
                Label("Home", systemImage: "house")
            }

            HistoryView(viewModel: viewModel)
    .tabItem {
        Label("History", systemImage: "clock")
    }
        }
    }

    func processImage() {
        guard let selectedImage = selectedImage else { return }
        extractTextFromImage(image: selectedImage)
    }

    func extractTextFromImage(image: UIImage) {
        guard let cgImage = image.cgImage else { return }

        let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        let request = VNRecognizeTextRequest { request, error in
            guard let observations = request.results as? [VNRecognizedTextObservation] else { return }
            var detectedText = ""
            for observation in observations {
                guard let topCandidate = observation.topCandidates(1).first else { continue }
                detectedText += topCandidate.string + "\n"
            }
            DispatchQueue.main.async {
                self.detectedText = detectedText
                let historyItem = HistoryItem(date: Date(), extractedText: detectedText, editedText: detectedText) // Initialize HistoryItem with detected text
                self.viewModel.historyItems.append(historyItem) // Add to historyItems
                self.viewModel.saveHistoryItems() // Save history items
            }
        }

        do {
            try requestHandler.perform([request])
        } catch {
            print("Unable to perform OCR request: \(error)")
        }
    }

    func exportTextAsFile(_ text: String) {
        let filename = "detected_text.txt"
        let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(filename)

        do {
            try text.write(to: path!, atomically: true, encoding: String.Encoding.utf8)
            let av = UIActivityViewController(activityItems: [path!], applicationActivities: nil)
            UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)
        } catch {
            print("Error exporting text: \(error)")
        }
    }
}