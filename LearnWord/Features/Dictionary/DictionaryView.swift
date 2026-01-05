import SwiftUI

struct DictionaryView: View {
    
    @StateObject private var vm = DictionaryViewModel()
    @State private var showAddWord = false
    
    var body: some View {
        NavigationStack {
            List {
                NavigationLink {
                    WordListView(title: "Мои слова", filter: .all)
                        .environmentObject(vm) // <-- добавляем
                } label: {
                    HStack {
                        Text("📘 Мои слова")
                        Spacer()
                        Text("\(vm.count(for: .all))")
                            .foregroundColor(.secondary)
                    }
                }
                
                NavigationLink {
                    WordListView(title: "Новые слова", filter: .new)
                        .environmentObject(vm)
                } label: {
                    HStack {
                        Text("🆕 Новые")
                        Spacer()
                        Text("\(vm.count(for: .new))")
                            .foregroundColor(.secondary)
                    }
                }
                
                NavigationLink {
                    WordListView(title: "В обучении", filter: .learning)
                        .environmentObject(vm) // <-- добавляем
                } label: {
                    HStack {
                        Text("📖 В обучении")
                        Spacer()
                        Text("\(vm.count(for: .learning))")
                            .foregroundColor(.secondary)
                    }
                }
                
                NavigationLink {
                    WordListView(title: "Запомнила", filter: .learned)
                        .environmentObject(vm) // <-- добавляем
                } label: {
                    HStack {
                        Text("🧠 Запомнила")
                        Spacer()
                        Text("\(vm.count(for: .learned))")
                            .foregroundColor(.secondary)
                    }
                }
                
                NavigationLink {
                    WordListView(title: "Уже знаю", filter: .known)
                        .environmentObject(vm)
                } label: {
                    HStack {
                        Text("✅ Уже знаю")
                        Spacer()
                        Text("\(vm.count(for: .known))")
                            .foregroundColor(.secondary)
                    }
                }
                .navigationTitle("Словарь")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            showAddWord = true
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                }
                .sheet(isPresented: $showAddWord, onDismiss: {
                    vm.load(filter: .all)
                }) {
                    AddWordView()
                        .environmentObject(vm) // <-- передаём vm
                }.onAppear {
                    vm.load(filter: .all) // <-- добавляем сюда
                }
            }
        }
    }
}
