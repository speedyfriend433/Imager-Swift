//
// HistoryViewModel.swift
//
// Created by Speedyfriend67 on 02.07.24
//
 
import Foundation

class HistoryViewModel: ObservableObject {
    @Published var historyItems: [HistoryItem] = []

    init() {
        loadHistoryItems()
    }

    func toggleFavorite(for item: HistoryItem) {
        if let index = historyItems.firstIndex(where: { $0.id == item.id }) {
            historyItems[index].isFavorite.toggle()
            saveHistoryItems()
        }
    }

    func deleteHistoryItem(_ item: HistoryItem) {
        if let index = historyItems.firstIndex(where: { $0.id == item.id }) {
            historyItems.remove(at: index)
            saveHistoryItems()
        }
    }

    func saveHistoryItems() { // 공개 함수로 변경
        if let encoded = try? JSONEncoder().encode(historyItems) {
            UserDefaults.standard.set(encoded, forKey: "historyItems")
        }
    }

    private func loadHistoryItems() { // 비공개로 유지
        if let savedItems = UserDefaults.standard.data(forKey: "historyItems") {
            if let decodedItems = try? JSONDecoder().decode([HistoryItem].self, from: savedItems) {
                historyItems = decodedItems
            }
        }
    }
}