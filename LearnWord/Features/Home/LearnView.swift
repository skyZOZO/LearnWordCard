import SwiftUI

struct LearnView: View {

    @State private var words: [WordEntity] = []
    @State private var currentIndex = 0
    @State private var showTranslation = false

    var body: some View {
        VStack {
            if !words.isEmpty {
                wordCard()
                actionButtons()
            } else {
                Text("Слова закончились 🎉")
            }
        }
        .padding()
        .navigationTitle("Учить слова")
        .onAppear {
            loadWords()
        }
    }

    // MARK: - UI

    private func wordCard() -> some View {
        VStack(spacing: 20) {
            Spacer()

            Text(displayedText)
                .font(.system(size: 32, weight: .bold))
                .multilineTextAlignment(.center)
                .padding()
                .onTapGesture {
                    showTranslation.toggle()
                }

            Text("Нажми, чтобы перевернуть")
                .font(.caption)
                .foregroundColor(.gray)

            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color(.systemBackground))
                .shadow(radius: 6)
        )
    }

    private func actionButtons() -> some View {
        HStack(spacing: 16) {

            Button {
                leftAction()
            } label: {
                Text(leftButtonTitle)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green.opacity(0.85))
                    .foregroundColor(.white)
                    .cornerRadius(16)
            }

            Button {
                rightAction()
            } label: {
                Text(rightButtonTitle)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue.opacity(0.85))
                    .foregroundColor(.white)
                    .cornerRadius(16)
            }
        }
        .padding(.top)
    }

    // MARK: - Logic

    private func loadWords() {
        words = StorageService.shared.fetchOrFillActiveWords()
        currentIndex = 0
        showTranslation = false
    }

    private var currentWord: WordEntity {
        words[currentIndex]
    }

    private var displayedText: String {
        if showTranslation {
            return currentWord.russian ?? ""
        } else {
            return currentWord.english ?? ""
        }
    }

    private var leftButtonTitle: String {
        currentWord.status == WordStatus.new.rawValue
        ? "Уже знаю"
        : "Запомнила"
    }

    private var rightButtonTitle: String {
        currentWord.status == WordStatus.new.rawValue
        ? "Учить"
        : "Ещё показать"
    }

    private func leftAction() {
        let word = currentWord

        if word.status == WordStatus.new.rawValue {
            StorageService.shared.markWord(word, status: .known)
        } else {
            StorageService.shared.markWord(word, status: .learned)
        }

        replaceCurrentWord()
    }

    private func rightAction() {
        let word = currentWord

        if word.status == WordStatus.new.rawValue {
            StorageService.shared.markWord(word, status: .learning)
        }

        moveWordToEnd()
    }

    private func replaceCurrentWord() {
        words.remove(at: currentIndex)

        if let newWord = StorageService.shared.fetchReplacementWord() {
            words.append(newWord)
        }

        resetIndex()
    }

    private func moveWordToEnd() {
        let word = words.remove(at: currentIndex)
        words.append(word)
        resetIndex()
    }

    private func resetIndex() {
        showTranslation = false
        if currentIndex >= words.count {
            currentIndex = 0
        }
    }
}
