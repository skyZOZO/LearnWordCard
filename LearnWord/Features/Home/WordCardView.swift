import SwiftUI

struct WordCardView: View {

    let word: WordEntity
    let onKnow: () -> Void
    let onLearn: () -> Void

    @State private var showTranslation = false

    var body: some View {
        VStack(spacing: 24) {

            Spacer()

            Text(showTranslation ? (word.russian ?? "") : (word.english ?? ""))
                .font(.system(size: 32, weight: .bold))
                .multilineTextAlignment(.center)
                .padding()
                .onTapGesture {
                    showTranslation.toggle()
                }

            Text("Нажми, чтобы увидеть перевод")
                .font(.caption)
                .foregroundColor(.gray)

            Spacer()

            HStack(spacing: 24) {

                Button {
                    onKnow()
                } label: {
                    Text("Знаю")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green.opacity(0.8))
                        .foregroundColor(.white)
                        .cornerRadius(16)
                }

                Button {
                    onLearn()
                } label: {
                    Text("Учить")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue.opacity(0.8))
                        .foregroundColor(.white)
                        .cornerRadius(16)
                }

            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color(.systemBackground))
                .shadow(radius: 8)
        )
        .padding()
    }
}
