import SwiftUI
import RealmSwift
import GoogleSignIn

struct ContentView: View {
    @ObservedObject var app: RealmSwift.App
    @EnvironmentObject var errorHandler: ErrorHandler
    @State private var googleProfile: GIDProfileData?
    
    var body: some View {
        // 로그인 되어 있으면
        if let user = app.currentUser {
            // 현재 사용자에 대한 Realm Sync 설정
            var config = user.flexibleSyncConfiguration(initialSubscriptions: { subs in
                // Todo 동기화
                if let _ = subs.first(named: K.myTodoItems) {
                    return
                } else {
                    subs.append(QuerySubscription<Todo>(name: K.myTodoItems) {
                        $0.owner_id == user.id
                    })
                }
                
                // UserModel 동기화
                subs.remove(named: K.users)
                if let _ = subs.first(named: K.users) {
                    return
                } else {
                    subs.append(QuerySubscription<UserModel>(name: K.users))
                }
            })
            // config를 environment로 저장하고(@AutoOpen이 찾아서 사용함) OpenRealmView로 이동
            OpenRealmView(user: user, googleProfile: $googleProfile)
                .environment(\.realmConfiguration, config)
        
        // 로그인 안 되어 있으면 LoginView로 이동
        } else {
            LoginView(googleProfile: $googleProfile)
        }
    }
}
