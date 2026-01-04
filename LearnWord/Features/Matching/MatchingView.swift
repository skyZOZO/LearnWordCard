import SwiftUI

struct MatchingView: View {

    @StateObject private var vm = MatchingViewModel()

    var body: some View {
        VStack(spacing: 16) {

            Text("Сопоставление")
                .font(.title2)
                .bold()

            HStack(spacing: 16) {

                // Левая колонка (EN)
                VStack(spacing: 12) {
                    ForEach(vm.leftItems) { item in
                        wordCard(
                            text: item.word.english ?? "",
                            state: state(for: item, isLeft: true)   // 👈 ВОТ ТУТ
                        )
                        .onTapGesture {
                            vm.selectLeft(item)
                        }
                    }
                }

                // Правая колонка (RU)
                VStack(spacing: 12) {
                    ForEach(vm.rightItems) { item in
                        wordCard(
                            text: item.word.russian ?? "",
                            state: state(for: item, isLeft: false)  // 👈 И ВОТ ТУТ
                        )
                        .onTapGesture {
                            vm.selectRight(item)
                        }
                    }
                }
            }

            Spacer()
        }
        .padding()
    }

    // MARK: - UI

    private func wordCard(text: String, state: CardState) -> some View {
        Text(text)
            .frame(maxWidth: .infinity)
            .padding()
            .background(background(for: state))
            .cornerRadius(14)
            .animation(.easeInOut, value: state)
    }

    private func background(for state: CardState) -> Color {
        switch state {
        case .normal: return Color(.secondarySystemBackground)
        case .selected: return Color.blue.opacity(0.3)
        case .correct: return Color.green
        case .wrong: return Color.red
        }
    }

    // MARK: - State

    private func state(
        for item: MatchingItem,
        isLeft: Bool
    ) -> CardState {

        if vm.correctIDs.contains(item.id) {
            return .correct
        }

        if vm.wrongIDs.contains(item.id) {
            return .wrong
        }

        if isLeft && vm.selectedLeft?.id == item.id {
            return .selected
        }

        if !isLeft && vm.selectedRight?.id == item.id {
            return .selected
        }

        return .normal
    }

}

enum CardState {
    case normal
    case selected
    case correct
    case wrong
}
