import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ContentViewModel()
    
    var body: some View {
        TabView(selection: $viewModel.tabSelection){
            ForEach(0...3, id: \.self) { index in
                NavigationView {
                    switch index {
                    case 0:
                        HomeTabView(viewModel: viewModel.homeTabViewModel)
                    case 1:
                        GroupTabView(viewModel: viewModel.groupTabViewModel)
                    case 2:
                        ChatTabView(viewModel: viewModel.chatTabViewModel)
                    default:
                        MyPageTabView(viewModel: viewModel.myPageTabViewModel)
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
