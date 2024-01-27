import SwiftUI
import RealmSwift
import GoogleSignIn

/// Called when login completes. Opens the realm and navigates to the Items screen.
struct OpenRealmView: View {
    // @AutoOpen은 비동기적으로 Realm을 열고 그 상태를 관리함(Environment에서 realm과 config를 찾음)
    @AutoOpen(appId: theAppConfig.appId, timeout: 2000) var autoOpen
    @State private var tabSelection: Int = 1
    @State var user: User
    @Environment(\.realm) private var realm
    @Binding var googleProfile: GIDProfileData?

    var body: some View {
        switch autoOpen {
        case .connecting:
            // Starting the Realm.autoOpen process.
            ProgressView()
        case .waitingForUser:
            // Waiting for a user to be logged in before executing Realm.asyncOpen.
            ProgressView("Waiting for user to log in...")
        case .open(let realm):
            // The realm has been opened and is ready for use.
            TabView(selection: $tabSelection){
                ForEach(0...3, id: \.self) { index in
                    NavigationStack {
                        switch index {
                        case 0:
                            HomeTabView(viewModel: HomeTabViewModel(), weekViewModel: WeekViewModel(), user: user)
                            
                        case 1:
                            GroupTabView(viewModel: GroupTabViewModel(), user: user)
                        case 2:
                            ChatTabView()
                        default:
                            MyPageTabView(user: user)
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
            .onAppear {
                // 로그인 화면 거쳐서 들어오면 profile is not nil
                if let profile = googleProfile {
                    // 기존에 없던 유저면 new UserModel 추가
                    let users = realm.objects(UserModel.self)
                    if users.where({$0._id == user.id}).isEmpty {
                        do {
                            try realm.write {
                                let newUser = UserModel()
                                newUser._id = user.id
                                newUser.name = profile.name
                                newUser.email = profile.email
                                newUser.profileImageURL = profile.imageURL(withDimension: 1)?.description
                                realm.add(newUser)
                                print("add newUser")
                            }
                        } catch {
                            print("Failed to add new user: \(error.localizedDescription)")
                        }
                    }
                }
            }
            case .progress(let progress):
                // The realm is currently being downloaded from the server.
                ProgressView(progress)
            case .error(let error):
                // Opening the Realm failed.
                ErrorView(error: error)
            }
        
        
    }
}
