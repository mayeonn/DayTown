import SwiftUI
import RealmSwift

/// Called when login completes. Opens the realm and navigates to the Items screen.
struct OpenRealmView: View {
    // @AutoOpen은 비동기적으로 Realm을 열고 그 상태를 관리함
    @AutoOpen(appId: theAppConfig.appId, timeout: 2000) var autoOpen
    @State private var tabSelection: Int = 0
    @State var user: User
    @State var isInOfflineMode = false
    // AutoOpen이 Realm을 열 때 사용된 Config. Realm 객체도 @Environment(\.realm)로 주입됨
    @Environment(\.realmConfiguration) private var config
    
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
                    NavigationView {
                        switch index {
                        case 0:
                            HomeTabView(viewModel: HomeTabViewModel(), weekViewModel: WeekViewModel(), user: user)
                        case 1:
                            GroupTabView()
                        case 2:
                            ChatTabView()
                        default:
                            MyPageTabView()
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
            .onChange(of: isInOfflineMode) { newValue in
                let syncSession = realm.syncSession!
                newValue ? syncSession.suspend() : syncSession.resume()
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
