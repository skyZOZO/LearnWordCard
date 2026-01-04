import SwiftUI

final class MatchingViewModel: ObservableObject {

    @Published var leftItems: [MatchingItem] = []
    @Published var rightItems: [MatchingItem] = []

    @Published var selectedLeft: MatchingItem?
    @Published var selectedRight: MatchingItem?

    @Published var correctIDs: Set<UUID> = []
    @Published var wrongIDs: Set<UUID> = []

    private let storage = StorageService.shared
    private let maxVisible = 5
    private let sessionLimit = 20

    private var pool: [WordEntity] = []

    init() {
        loadSession()
        fillVisible()
    }

    // MARK: - Load

    private func loadSession() {
        pool = storage.fetchActiveWords(limit: sessionLimit)
            .filter { $0.status == WordStatus.learning.rawValue }
    }

    private func fillVisible() {
        let needed = maxVisible - leftItems.count
        guard needed > 0 else { return }

        let newWords = pool.prefix(needed)
        pool.removeFirst(min(needed, pool.count))

        let items = newWords.map { MatchingItem(word: $0) }
        leftItems.append(contentsOf: items)
        rightItems.append(contentsOf: items)

        shuffleRight()
    }

    // MARK: - Selection

    func selectLeft(_ item: MatchingItem) {
        selectedLeft = item
        tryMatch()
    }

    func selectRight(_ item: MatchingItem) {
        selectedRight = item
        tryMatch()
    }

    private func tryMatch() {
        guard let left = selectedLeft, let right = selectedRight else { return }

        if left.word.objectID == right.word.objectID {
            handleCorrect(left, right)
        } else {
            handleWrong(left, right)
        }
    }

    // MARK: - Correct / Wrong

    private func handleCorrect(_ left: MatchingItem, _ right: MatchingItem) {
        correctIDs.insert(left.id)
        correctIDs.insert(right.id)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.leftItems.removeAll { $0.id == left.id }
            self.rightItems.removeAll { $0.id == right.id }

            self.correctIDs.removeAll()
            self.selectedLeft = nil
            self.selectedRight = nil

            self.fillVisible()
            self.shuffleRight()
        }
    }

    private func handleWrong(_ left: MatchingItem, _ right: MatchingItem) {
        wrongIDs.insert(left.id)
        wrongIDs.insert(right.id)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.wrongIDs.removeAll()
            self.selectedLeft = nil
            self.selectedRight = nil
            self.shuffleRight()
        }
    }

    private func shuffleRight() {
        rightItems.shuffle()
    }
}
