import CoreData
import SwiftUI

final class StorageService {

    static let shared = StorageService()

    let container: NSPersistentContainer

    private init() {
        container = NSPersistentContainer(name: "LearnWordModel")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Core Data store failed: \(error.localizedDescription)")
            }
        }
    }

    var context: NSManagedObjectContext {
        container.viewContext
    }

    // MARK: - Save

    func save() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Failed saving: \(error)")
            }
        }
    }

    // MARK: - Words

    func addWord(
        english: String,
        russian: String,
        status: Int16 = WordStatus.new.rawValue
    ) {
        let word = WordEntity(context: context)
        word.id = UUID()
        word.english = english
        word.russian = russian
        word.status = status
        word.createdAt = Date()
        save()
    }

    func fetchActiveWords(limit: Int = 20) -> [WordEntity] {
        let request: NSFetchRequest<WordEntity> = WordEntity.fetchRequest()
        request.predicate = NSPredicate(
            format: "status == %d OR status == %d",
            WordStatus.new.rawValue,
            WordStatus.learning.rawValue
        )
        request.fetchLimit = limit

        return (try? context.fetch(request)) ?? []
    }

    func fetchOrFillActiveWords(limit: Int = 20) -> [WordEntity] {
        var active = fetchActiveWords(limit: limit)

        if active.count < limit {
            let need = limit - active.count
            let newWords = fetchNewWords(limit: need)
            active.append(contentsOf: newWords)
        }

        return active
    }

    private func fetchNewWords(limit: Int) -> [WordEntity] {
        let request: NSFetchRequest<WordEntity> = WordEntity.fetchRequest()
        request.predicate = NSPredicate(
            format: "status == %d",
            WordStatus.new.rawValue
        )
        request.fetchLimit = limit

        return (try? context.fetch(request)) ?? []
    }

    func markWord(_ word: WordEntity, status: WordStatus) {
        word.status = status.rawValue
        word.lastReviewed = Date()
        save()
    }

    func fetchReplacementWord() -> WordEntity? {
        let request: NSFetchRequest<WordEntity> = WordEntity.fetchRequest()
        request.predicate = NSPredicate(
            format: "status == %d",
            WordStatus.new.rawValue
        )
        request.fetchLimit = 1

        return try? context.fetch(request).first
    }

    // MARK: - Mock

    func addMockWordsIfNeeded() {
        let request: NSFetchRequest<WordEntity> = WordEntity.fetchRequest()
        request.fetchLimit = 1

        if let count = try? context.count(for: request), count > 0 {
            return
        }

        addWord(english: "apple", russian: "яблоко")
        addWord(english: "book", russian: "книга")
        addWord(english: "sun", russian: "солнце")
        addWord(english: "water", russian: "вода")
        addWord(english: "love", russian: "любовь")
        addWord(english: "you", russian: "ты")
        addWord(english: "moon", russian: "луна")
        addWord(english: "to know", russian: "знать")
        addWord(english: "to see", russian: "видеть")
    }

    // MARK: - Statistics ✅ (ВАЖНО)

    func totalLearnedWords() -> Int {
        let request: NSFetchRequest<WordEntity> = WordEntity.fetchRequest()
        request.predicate = NSPredicate(
            format: "status == %d",
            WordStatus.learned.rawValue
        )
        return (try? context.count(for: request)) ?? 0
    }

    func firstWordDate() -> Date? {
        let request: NSFetchRequest<WordEntity> = WordEntity.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(key: "createdAt", ascending: true)
        ]
        request.fetchLimit = 1

        return try? context.fetch(request).first?.createdAt
    }

    func activeTodayWordsCount() -> Int {
        let request: NSFetchRequest<WordEntity> = WordEntity.fetchRequest()
        request.predicate = NSPredicate(
            format: "status == %d OR status == %d",
            WordStatus.new.rawValue,
            WordStatus.learning.rawValue
        )
        return (try? context.count(for: request)) ?? 0
    }
    
    // MARK: - Daily Progress

    private var todayKey: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let today = formatter.string(from: Date())
        return "learnedToday_\(today)"
    }
    
    func incrementLearnedToday() {
        let current = UserDefaults.standard.integer(forKey: todayKey)
        UserDefaults.standard.set(current + 1, forKey: todayKey)
    }
    
    func learnedTodayCount() -> Int {
        UserDefaults.standard.integer(forKey: todayKey)
    }

    func todayProgress() -> Double {
        let count = learnedTodayCount()
        return min(Double(count) / 20.0, 1.0)
    }

}
