import SwiftUI
import Realm
import GoogleSignIn

struct MyPageTabView: View {
    @ObservedObject var viewModel: MyPageTabViewModel
    @State var isLoggingOut = false
    
    init() {
        self.viewModel = MyPageTabViewModel()
    }
    
    var body: some View {
        VStack {
            Text(app.currentUser?.id ?? "e")
            
            LogoutButton(myPageTabViewModel: viewModel)
            .customNavigationBarTitle(title: "마이페이지")
        }
    }
}
