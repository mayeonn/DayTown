import SwiftUI

struct HomeTabView: View {
    @ObservedObject var viewModel: HomeTabViewModel
    @StateObject private var weekViewModel = WeekViewModel()
    
    var body: some View {
        VStack {
            WeekView(viewModel: weekViewModel)
            Spacer()
            
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
