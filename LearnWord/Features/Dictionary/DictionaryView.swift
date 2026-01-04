import SwiftUI

struct DictionaryView: View {

    var body: some View {
        NavigationStack {
            List {
                NavigationLink("📘 Мои слова") {
                    WordListView(
                        title: "Мои слова",
                        filter: .all
                    )
                }

                NavigationLink("🆕 Новые") {
                    WordListView(
                        title: "Новые слова",
                        filter: .new
                    )
                }

                NavigationLink("📖 В обучении") {
                    WordListView(
                        title: "В обучении",
                        filter: .learning
                    )
                }

                NavigationLink("🧠 Запомнила") {
                    WordListView(
                        title: "Запомнила",
                        filter: .learned
                    )
                }

                NavigationLink("✅ Уже знаю") {
                    WordListView(
                        title: "Уже знаю",
                        filter: .known
                    )
                }
            }
            .navigationTitle("Словарь")
        }
    }
}
