import SwiftUI
import CoreData

final class DictionaryViewModel: ObservableObject {

    @Published var words: [WordEntity] = []
    @Published var filter: WordFilter = .all
    @Published var sort: WordSort = .createdDesc
    @Published private(set) var currentFilter: WordFilter = .all

    private let storage = StorageService.shared

    func load(filter: WordFilter) {
        currentFilter = filter
        let allWords = storage.fetchAllWords()

        let filtered: [WordEntity]

        switch filter {
        case .all:
            filtered = allWords
        case .new:
            filtered = allWords.filter { $0.status == WordStatus.new.rawValue }
        case .learning:
            filtered = allWords.filter { $0.status == WordStatus.learning.rawValue }
        case .learned:
            filtered = allWords.filter { $0.status == WordStatus.learned.rawValue }
        case .known:
            filtered = allWords.filter { $0.status == WordStatus.known.rawValue }
        }

        words = applySort(filtered)
    }


    func delete(_ word: WordEntity) {
        storage.delete(word)
        load(filter: currentFilter)
    }

    func updateStatus(_ word: WordEntity, to status: WordStatus) {
        storage.update(word, status: status)
        load(filter: currentFilter)
    }

    func addWord(english: String, russian: String) {
        storage.addWord(english: english, russian: russian, status: WordStatus.new.rawValue)
        load(filter: currentFilter) // обновляем words и пересчитываем цифры
    }

    func count(for filter: WordFilter) -> Int {
        switch filter {
        case .all: return words.count
        case .new: return words.filter { $0.status == WordStatus.new.rawValue }.count
        case .learning: return words.filter { $0.status == WordStatus.learning.rawValue }.count
        case .learned: return words.filter { $0.status == WordStatus.learned.rawValue }.count
        case .known: return words.filter { $0.status == WordStatus.known.rawValue }.count
        }
    }



    func applySort(_ words: [WordEntity]) -> [WordEntity] {
        switch sort {
        case .createdDesc:
            return words.sorted { ($0.createdAt ?? .distantPast) > ($1.createdAt ?? .distantPast) }
            
        case .createdAsc:
            return words.sorted { ($0.createdAt ?? .distantPast) < ($1.createdAt ?? .distantPast) }
            
        case .alphabetAsc:
            return words.sorted {
                ($0.english ?? "").lowercased() < ($1.english ?? "").lowercased()
            }
            
        case .alphabetDesc:
            return words.sorted {
                ($0.english ?? "").lowercased() > ($1.english ?? "").lowercased()
            }
        }
    }
}
