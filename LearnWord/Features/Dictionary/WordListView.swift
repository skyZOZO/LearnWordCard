import SwiftUI

struct WordListView: View {

    let title: String
    let filter: WordFilter

    @State private var showAddWord = false
    @State private var selectedSort: WordSort = .createdDesc
    @EnvironmentObject var vm: DictionaryViewModel

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

                        // Удаление
                        Button(role: .destructive) {
                            vm.delete(word)
                        } label: {
                            Text("Удалить")
                        }
                    }
            }
            .onDelete { indexSet in
                for index in indexSet {
                    vm.delete(vm.words[index])
                }
            }
        }
        .navigationTitle(title)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    ForEach(WordSort.allCases, id: \.self) { sort in
                        Button(sort.title) {    // <-- используем title, а не rawValue
                            selectedSort = sort
                            vm.sort = sort
                            vm.load(filter: filter)
                        }
                    }
                } label: {
                    Image(systemName: "arrow.up.arrow.down")
                }
            }
        }
        .onAppear {
            vm.load(filter: filter)
        }
        .onChange(of: showAddWord) { _, isShown in
            if !isShown {
                vm.load(filter: filter)
            }
        }
    }

    // MARK: - Row

    struct AddWordView: View {

        let onSave: () -> Void

        @Environment(\.dismiss) private var dismiss

        var body: some View {
            VStack {
                // поля ввода

                Button("Сохранить") {
                    // сохранение слова в CoreData
                    onSave()
                    dismiss()
                }
            }
            .padding()
        }
    }

    private func wordRow(_ word: WordEntity) -> some View {
        HStack {
            Text(word.english ?? "")
                .font(.headline)

            Spacer()

            Text(word.russian ?? "")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(12)
        .background(colorForStatus(word.status))
        .cornerRadius(14)
    }

    private func colorForStatus(_ status: Int16) -> Color {
        switch status {
        case WordStatus.new.rawValue:
            return Color(.systemBackground)
        case WordStatus.learning.rawValue:
            return Color.gray.opacity(0.15)
        case WordStatus.learned.rawValue:
            return Color.green.opacity(0.2)
        case WordStatus.known.rawValue:
            return Color.green.opacity(0.35)
        default:
            return .clear
        }
    }
}
