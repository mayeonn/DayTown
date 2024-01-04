import SwiftUI

struct MyPageTabView: View {
    @ObservedObject var viewModel: MyPageTabViewModel
    @State var isLoggingOut = false
    
    init() {
        self.viewModel = MyPageTabViewModel()
    }
    
    var body: some View {
        VStack {
            LogoutButton(myPageTabViewModel: viewModel)
            .customNavigationBarTitle(title: "마이페이지")
        }
    }
}
