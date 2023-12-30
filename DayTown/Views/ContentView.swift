import SwiftUI
import RealmSwift

struct ContentView: View {
    @ObservedObject var app: RealmSwift.App
    @EnvironmentObject var errorHandler: ErrorHandler

    var body: some View {
        // 로그인 되어 있으면
        if let user = app.currentUser {
            // 현재 사용자에 대한 Realm Sync Configuration 설정
            let config = user.flexibleSyncConfiguration(initialSubscriptions: { subs in
                subs.remove(named: K.allItems)
                // Subscription 있는지 확인
                if let _ = subs.first(named: K.myItems) {
                    return
                } else {
                // Subscription 없으면 사용자의 Todo를 구독
                    subs.append(QuerySubscription<Todo>(name: K.myItems) {
                        $0.owner_id == user.id
                    })
                }
            })
            // config를 environment로 저장하고 OpenRealmView로 이동
            OpenRealmView(user: user)
                .environment(\.realmConfiguration, config)
        // 로그인 안 되어 있으면 LoginView로 이동
        } else {
            LoginView()
        }
    }
}
