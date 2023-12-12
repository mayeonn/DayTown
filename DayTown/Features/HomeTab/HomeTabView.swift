import SwiftUI

struct HomeTabView: View {
    @ObservedObject var viewModel: HomeTabViewModel
    
    var body: some View {
        VStack {
            Text(viewModel.content)
            
            .customNavigationBarTitle(title: "ToDo")
            .onAppear {
                viewModel.fetchData()
            }
        }
    }
}

#Preview {
    ContentView()
}
