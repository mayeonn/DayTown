import SwiftUI
import RealmSwift

@main
struct DayTownApp: SwiftUI.App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    
    init() {
        print(RealmManager.realm.configuration.fileURL)
//        RealmManager.resetRealm()
    }
}
