import SwiftUI
import RealmSwift
import GoogleSignIn

struct MyPageTabView: View {
    @ObservedObject var viewModel: MyPageTabViewModel
    @State var isLoggingOut = false
    @Environment(\.realm) private var realm
    @State var user: User
    
    var body: some View {
        List {
            if let userModel = viewModel.currentUser {
                VStack {
                    // UserInfoView
                    HStack(spacing: 12) {
                        ProfileImage(url: userModel.profileImageURL, size: 100)
                        
                        VStack(alignment: .leading) {
                            Text(userModel.name)
                                .font(.system(size: 20).bold())
                            if let intro = userModel.introduction {
                                Text(intro)
                                    .foregroundStyle(.gray)
                            }
                        }
                    }
                    // Profile Edit Button
                    HStack {
                        Spacer()
                            .frame(width: 120)
                        Text(K.editProfile)
                            .background(
                                NavigationLink("", destination: ProfileEditView(viewModel: viewModel))
                                    .opacity(0)
                            )
                            .lineLimit(1)
                            .frame(width: 100, height: 40, alignment: .center)
                            .overlay(
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(.gray, lineWidth: 1)
                            )
                    }
                }
                .listRowSeparator(.hidden)
                
                
                
                // Email information
                HStack {
                    Text("이메일")
                    Spacer()
                    Text(viewModel.currentUser?.email ?? "")
                        .foregroundStyle(.gray)
                }
                
                
                LogoutButton(myPageTabViewModel: viewModel)
                    .customNavigationBarTitle(title: "마이페이지")
            }
        }
        .listStyle(.plain)
        .onAppear {
            viewModel.currentUser = realm.object(ofType: UserModel.self, forPrimaryKey: user.id)
        }
        
    }
}

