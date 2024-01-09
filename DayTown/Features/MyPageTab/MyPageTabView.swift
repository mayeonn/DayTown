import SwiftUI
import RealmSwift
import GoogleSignIn

struct MyPageTabView: View {
    @ObservedObject var viewModel: MyPageTabViewModel
    @State var isLoggingOut = false
    @Environment(\.realm) private var realm
    @State var user: User
    
    init(user: User) {
        self.viewModel = MyPageTabViewModel()
        self.user = user
    }
    
    var body: some View {
        List {
            if let userModel = realm.object(ofType: UserModel.self, forPrimaryKey: user.id) {
                UserInfoView(userId: user.id)
                    .listRowSeparator(.hidden)
                
                // Profile Edit Button
                HStack {
                    Spacer()
                        .frame(width: 120)
                    Text(K.editProfile)
                        .background(
                            NavigationLink("", destination: ProfileEditView(userModel: userModel))
                                .opacity(0)
                        )
                        .lineLimit(1)
                        .frame(width: 100, height: 40, alignment: .center)
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(.gray, lineWidth: 1)
                        )
                }
                

                LogoutButton(myPageTabViewModel: viewModel)
                    .customNavigationBarTitle(title: "마이페이지")
            }
        }
        .listStyle(.plain)
        
    }
}

