
Usage

Select Image: Tap the "Select Image" button to choose an image from the photo library.
Text Extraction: Once an image is selected, the app extracts text from it using OCR.
Text Editing: Users can edit the extracted text directly within the app if needed.
Export: Tap the "Export" button to save the extracted text as a text file and share it.
History: Navigate to the "History" tab to view past text extraction entries, share them, or delete them.
Code Overview

ContentView: Main view containing the image picker, text extraction, editing, and export functionality.
ImagePicker: SwiftUI representation of the UIKit UIImagePickerController for selecting images from the photo library.
HistoryView: View for displaying a list of past text extraction history entries with share and delete functionality.
ShareSheetView: View for sharing extracted text via system share sheet.
HistoryItem: Model representing a single entry in the extraction history.
Technologies Used

SwiftUI: Apple's declarative UI framework for building user interfaces across all Apple platforms.
UIKit: Apple's framework for building iOS and macOS applications.
Vision: Apple's framework for computer vision tasks, used for OCR text extraction.
Requirements

iOS 14.0+ / macOS 11.0+
Xcode 12.0+
Swift 5.3+
Installation

Clone the repository: git clone https://github.com/your-username/swiftui-image-text-extractor.git
Open the project in Xcode. (i didn't build on Xcode , i used Swifty by sparkclechanJB but you can build your own ipa with the contentview.swift file. i wrote almost every code into it lol)
Run the app on a simulator or device.
Credits

This app is created by Speedyfriend67.

License

This project is licensed under the MIT License.
