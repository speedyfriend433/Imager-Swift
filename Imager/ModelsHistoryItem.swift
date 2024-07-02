//
// ModelsHistoryItem.swift
//
// Created by Speedyfriend67 on 02.07.24
//
 
import Foundation

struct HistoryItem: Identifiable, Codable {
    var id = UUID()
    var date: Date
    var extractedText: String
    var editedText: String
    var isFavorite: Bool = false // 즐겨찾기 속성 추가
}

let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    return formatter
}()