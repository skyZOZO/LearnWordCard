import Foundation

enum WordFilter: String, CaseIterable {
    case all
    case new
    case learning
    case learned
    case known

    var title: String {
        switch self {
        case .all: return "Мои слова"
        case .new: return "Новые"
        case .learning: return "В обучении"
        case .learned: return "Запомнила"
        case .known: return "Уже знаю"
        }
    }
}
