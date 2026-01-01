import SwiftUI

struct DictionaryView: View {

    @State private var english = ""
    @State private var russian = ""
    @State private var showAlert = false

    var body: some View {
        NavigationView {
            Form {

                Section(header: Text("Новое слово")) {
                    TextField("English", text: $english)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)

                    TextField("Russian", text: $russian)
                }

                Section {
                    Button {
                        addWord()
                    } label: {
                        Text("Добавить слово")
                            .frame(maxWidth: .infinity)
                    }
                    .disabled(english.isEmpty || russian.isEmpty)
                }
            }
            .navigationTitle("Dictionary")
            .alert("Слово добавлено ✅", isPresented: $showAlert) {
                Button("OK", role: .cancel) {}
            }
        }
    }

    // MARK: - Logic

    private func addWord() {
        StorageService.shared.addWord(
            english: english.trimmingCharacters(in: .whitespaces),
            russian: russian.trimmingCharacters(in: .whitespaces),
            status: WordStatus.new.rawValue
        )

        english = ""
        russian = ""
        showAlert = true
    }
}
