import SwiftUI

struct MyPageTabView: View {
    @ObservedObject var viewModel: MyPageTabViewModel
    
    var body: some View {
        VStack {
            Text(viewModel.content)
            
            .customNavigationBarTitle(title: "마이페이지")
            .onAppear {
                viewModel.fetchData()
            }
        }
    }
}
