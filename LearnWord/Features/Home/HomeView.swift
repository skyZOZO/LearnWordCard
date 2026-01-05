import SwiftUI

struct HomeView: View {
    @State private var learnedCount = 0
    @State private var daysLearning = 0
    @State private var todayWords = 0
    @AppStorage("learnedTodayShared") private var learnedTodayShared = 0

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
            .navigationTitle("Учить карточки📝")
            .onAppear {
                reloadStats()
            }.onChange(of: learnedTodayShared) { _ in
                reloadStats()
            }

        }
    }
    
    
    private func statsBlock() -> some View {
        HStack(spacing: 20) {

            ProgressCircle(
                progress: min(Double(learnedCount) / 20.0, 1.0),
                text: "\(learnedCount)/20"
            )

            VStack(alignment: .leading, spacing: 12) {
                statLine(title: "В обучении", value: "\(todayWords)")
                statLine(title: "Дней учусь", value: "\(daysLearning)")
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(20)
    }
    
    private func statLine(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.gray)

            Spacer()

            Text(value)
                .font(.headline)
        }
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

        // 1. Сколько выучено сегодня (для круга)
        learnedCount = storage.learnedTodayCount()

        // 2. Сколько в обучении (ещё показать)
        todayWords = storage.learningWordsCount()

        // 3. Сколько дней учусь
        daysLearning = storage.streakCount

    }

    struct ProgressCircle: View {
        let progress: Double   // 0.0 ... 1.0
        let text: String

        var body: some View {
            ZStack {
                Circle()
                    .stroke(Color.blue.opacity(0.2), lineWidth: 10)

                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(
                        Color.blue,
                        style: StrokeStyle(
                            lineWidth: 10,
                            lineCap: .round
                        )
                    )
                    .rotationEffect(.degrees(-90))
                    .animation(.easeOut, value: progress)

                Text(text)
                    .font(.headline)
            }
            .frame(width: 90, height: 90)
        }
    }
}
