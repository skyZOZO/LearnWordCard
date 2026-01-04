import Foundation

struct MatchingItem: Identifiable, Equatable {
    let id = UUID()
    let word: WordEntity
}
