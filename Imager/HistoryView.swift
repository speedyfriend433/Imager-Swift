//
// HistoryView.swift
//
// Created by Speedyfriend67 on 02.07.24
//
 
import SwiftUI

struct HistoryView: View {
    @ObservedObject var viewModel: HistoryViewModel
    @State private var selectedHistoryItem: HistoryItem?
    @State private var isShareSheetPresented = false

    var body: some View {
        NavigationView {
            ZStack {
                Color.gray.opacity(0.1) // Solid color background

                List {
                    ForEach(viewModel.historyItems) { item in
                        HStack {
                            VStack(alignment: .leading) {
                                Text("\(item.date, formatter: dateFormatter)")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                Text(item.extractedText)
                                    .lineLimit(1)
                                    .font(.body)
                                    .foregroundColor(.blue)
                            }
                            .onTapGesture {
                                selectedHistoryItem = item
                            }

                            Spacer()

                            Button(action: {
                                viewModel.toggleFavorite(for: item)
                            }) {
                                Image(systemName: item.isFavorite ? "star.fill" : "star")
                                    .foregroundColor(item.isFavorite ? .yellow : .gray)
                            }

                            Button(action: {
                                viewModel.deleteHistoryItem(item)
                            }) {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                            }
                        }
                    }
                }
                .navigationTitle("History")
                .sheet(item: $selectedHistoryItem) { historyItem in
                    ShareSheetView(text: historyItem.extractedText, isPresented: $isShareSheetPresented)
                }
            }
        }
    }
}