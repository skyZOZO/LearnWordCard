import SwiftUI
import CoreData

final class DictionaryViewModel: ObservableObject {

    @Published var words: [WordEntity] = []
    @Published var currentFilter: WordFilter = .all

    private let storage = StorageService.shared

    func load(filter: WordFilter) {
        currentFilter = filter  
        let allWords = storage.fetchAllWords()

        switch filter {
        case .all:
            words = allWords

        case .new:
            words = allWords.filter { $0.status == WordStatus.new.rawValue }

        case .learning:
            words = allWords.filter { $0.status == WordStatus.learning.rawValue }

        case .learned:
            words = allWords.filter { $0.status == WordStatus.learned.rawValue }

        case .known:
            words = allWords.filter { $0.status == WordStatus.known.rawValue }
        }
    }

    func delete(_ word: WordEntity) {
        storage.delete(word)
        load(filter: currentFilter)
    }

    func updateStatus(_ word: WordEntity, to status: WordStatus) {
        storage.update(word, status: status)
        load(filter: currentFilter)  
    }
}

