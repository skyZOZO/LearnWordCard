import Foundation

enum WordSort: String, CaseIterable {
    case createdDesc
    case createdAsc
    case alphabetAsc
    case alphabetDesc

    var title: String {
        switch self {
        case .createdDesc: return "Сначала новые"
        case .createdAsc: return "Сначала старые"
        case .alphabetAsc: return "A → Z"
        case .alphabetDesc: return "Z → A"
        }
    }
}
