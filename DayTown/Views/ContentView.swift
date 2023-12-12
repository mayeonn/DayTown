import SwiftUI

struct ContentView: View {
    @StateObject private var homeTabViewModel = HomeTabViewModel()
    @StateObject private var groupTabViewModel = GroupTabViewModel()
    @StateObject private var chatTabViewModel = ChatTabViewModel()
    @StateObject private var myPageTabViewModel = MyPageTabViewModel()
    
    var body: some View {
        
        TabView{
            NavigationView {
                HomeTabView(viewModel: homeTabViewModel)
            }
            .tabItem {
                Image(systemName: "house.fill")
            }
            
            NavigationView {
                GroupTabView(viewModel: groupTabViewModel)
            }
            .tabItem {
                Image(systemName: "person.2.fill")
            }
            NavigationView {
                ChatTabView(viewModel: chatTabViewModel)
            }
            .tabItem {
                Image(systemName: "message.fill")
            }
            NavigationView {
                MyPageTabView(viewModel: myPageTabViewModel)
            }
            .tabItem {
                Image(systemName: "person.circle.fill")
            }
        }
    }
}

#Preview {
    ContentView()
}
