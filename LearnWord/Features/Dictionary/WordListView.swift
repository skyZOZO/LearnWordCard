import SwiftUI

struct WordListView: View {

    let title: String
    let filter: WordFilter

    @StateObject private var vm = DictionaryViewModel()
    @State private var selectedWord: WordEntity?

    var body: some View {
        List {
            ForEach(vm.words, id: \.objectID) { word in
                wordRow(word)
                    .contextMenu {
                        Button("В новые") {
                            vm.updateStatus(word, to: .new)
                        }
                        Button("В обучении") {
                            vm.updateStatus(word, to: .learning)
                        }
                        Button("Запомнила") {
                            vm.updateStatus(word, to: .learned)
                        }
                        Button("Уже знаю") {
                            vm.updateStatus(word, to: .known)
                        }

                        Divider()

                        Button(role: .destructive) {
                            vm.delete(word)
                        } label: {
                            Text("Удалить")
                        }
                    }
            }
        }
        .navigationTitle(title)
        .onAppear {
            vm.load(filter: filter)
        }
    }

    private func wordRow(_ word: WordEntity) -> some View {
        HStack {
            Text(word.english ?? "")
                .bold()
            Spacer()
            Text(word.russian ?? "")
        }
        .padding()
        .background(backgroundColor(word))
        .cornerRadius(12)
    }

    private func backgroundColor(_ word: WordEntity) -> Color {
        switch WordStatus(rawValue: word.status) {
        case .new:
            return Color(.systemBackground)
        case .learning:
            return .gray.opacity(0.2)
        case .learned:
            return .green.opacity(0.2)
        case .known:
            return .green.opacity(0.35)
        default:
            return .clear
        }
    }
}
