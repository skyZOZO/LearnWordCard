//
//  HomeViewModel.swift
//  LearnWord
//
//  Created by Аружан Куаныш on 02.01.2026.
//

import SwiftUI
import CoreData

final class HomeViewModel: ObservableObject {

    @Published var words: [WordEntity] = []
    @Published var currentIndex = 0

    private let storage = StorageService.shared

    init() {
        loadWords()
    }

    func loadWords() {
        words = storage.fetchOrFillActiveWords()
        currentIndex = 0
    }

    var currentWord: WordEntity? {
        guard currentIndex < words.count else { return nil }
        return words[currentIndex]
    }

    // MARK: - Actions

    func markAsKnown() {
        updateCurrentWord(status: .known)
    }

    func markAsLearning() {
        updateCurrentWord(status: .learning)
    }

    func markAsLearned() {
        updateCurrentWord(status: .learned)
    }

    private func updateCurrentWord(status: WordStatus) {
        guard let word = currentWord else { return }

        word.status = status.rawValue
        word.lastReviewed = Date()
        storage.save()

        moveToNext()
    }

    private func moveToNext() {
        currentIndex += 1

        if currentIndex >= words.count {
            loadWords()
        }
    }
}
