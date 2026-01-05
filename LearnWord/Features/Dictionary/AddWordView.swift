import SwiftUI

struct AddWordView: View {

    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var vm: DictionaryViewModel

    @State private var english = ""
    @State private var russian = ""

    private let storage = StorageService.shared

    var body: some View {
        NavigationStack {
            Form {
                Section("Английский") {
                    TextField("apple", text: $english)
                }

                Section("Перевод") {
                    TextField("яблоко", text: $russian)
                }
            }
            .navigationTitle("Новое слово")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Отмена") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Сохранить") {
                        vm.addWord(english: english, russian: russian) // 👈 через vm
                        dismiss()
                    }
                    .disabled(english.isEmpty || russian.isEmpty)
                }
            }
        }
    }

    private func save() {
        storage.addWord(
            english: english,
            russian: russian,
            status: WordStatus.new.rawValue // 👈 ВСЕГДА НОВОЕ
        )
        dismiss()
    }
}
