import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
            
            DictionaryView()
                .tabItem {
                    Image(systemName: "book.fill")
                    Text("Dictionary")
                }
            
            MenuView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("Menu")
                }
        }
    }
}

#Preview {
    MainTabView()
}
