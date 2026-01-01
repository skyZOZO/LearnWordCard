import SwiftUI

struct MenuView: View {
    var body: some View {
        NavigationStack {
            Text("Menu")
                .font(.largeTitle)
                .navigationTitle("Menu")
        }
    }
}

#Preview {
    MenuView()
}
