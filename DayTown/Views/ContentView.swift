import SwiftUI

struct ContentView: View {
    @State private var tabSelection: Int = 0
    
    var body: some View {
        TabView(selection: $tabSelection){
            ForEach(0..<3, id: \.self) { index in
                NavigationView {
                    switch index {
                    case 0:
                        HomeTabView()
                    case 1:
                        GroupTabView()
                    case 2:
                        ChatTabView()
                    default:
                        MyPageTabView()
                    }
                }
                .tag(index)
                .tabItem {
                    Image(systemName: K.tabItemIcons[index])
                }
                .ignoresSafeArea()
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    ContentView()
}
