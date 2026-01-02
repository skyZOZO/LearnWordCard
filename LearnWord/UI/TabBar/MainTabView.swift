import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home111")
                }
            
            DictionaryView()
                .tabItem {
                    Image(systemName: "book.fill")
                    Text("Dictionary222")
                }
            
            MenuView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("Menu333")
                }
        }
    }
}

#Preview {
    MainTabView()
}
