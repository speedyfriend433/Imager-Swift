//
// ShareSheetView.swift
//
// Created by Speedyfriend67 on 02.07.24
//
 
import SwiftUI
import UIKit

struct ShareSheetView: View {
    let text: String
    @Binding var isPresented: Bool

    var body: some View {
        VStack {
            Text("Share this text")
            Text(text)
            Button("Share") {
                isPresented = false
                shareText(text)
            }
        }
    }

    private func shareText(_ text: String) {
        let av = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)
    }
}