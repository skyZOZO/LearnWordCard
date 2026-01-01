import SwiftUI

struct HomeView: View {
    @State private var learnedCount = 0
    @State private var daysLearning = 0
    @State private var todayWords = 0
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    
                    // MARK: - Статистика
                    statsBlock()
                    
                    // MARK: - Основные действия
                    NavigationLink(destination: LearnView()) {
                        actionCard(
                            title: "Учить слова",
                            subtitle: "20 слов в день",
                            icon: "rectangle.stack.fill"
                        )
                    }
                    
                    NavigationLink(destination: MatchingView()) {
                        actionCard(
                            title: "Сопоставление",
                            subtitle: "Закрепи изучаемые слова",
                            icon: "square.grid.2x2.fill"
                        )
                    }
                    
                    NavigationLink(destination: ReviewView()) {
                        actionCard(
                            title: "Повторение",
                            subtitle: "Выученные слова",
                            icon: "clock.fill"
                        )
                    }
                }
                .padding()
            }
            .navigationTitle("Home")
        }
    }
    
    
    private func statsBlock() -> some View {
        HStack(spacing: 16) {
            statItem(value: "\(daysLearning)", title: "дней учусь")
            statItem(value: "\(learnedCount)", title: "выучено")
            statItem(value: "\(todayWords)", title: "в обучении")
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(20)
    }
    
    private func statItem(value: String, title: String) -> some View {
        VStack {
            Text(value)
                .font(.title)
                .bold()
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
    }
    
    private func actionCard(title: String, subtitle: String, icon: String) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.headline)
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.blue)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(20)
        .shadow(radius: 4)
    }
    
    private func reloadStats() {
        let storage = StorageService.shared
        
        learnedCount = storage.totalLearnedWords()
        todayWords = storage.activeTodayWordsCount()
        
        if let firstDate = storage.firstWordDate() {
            daysLearning = Calendar.current.dateComponents(
                [.day],
                from: firstDate,
                to: Date()
            ).day ?? 0
        } else {
            daysLearning = 0
        }
    }
}
