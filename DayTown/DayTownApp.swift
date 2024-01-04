import SwiftUI
import RealmSwift
import GoogleSignIn

let theAppConfig = loadAppConfig()
let app = App(id: theAppConfig.appId, configuration: AppConfiguration(baseURL: theAppConfig.baseUrl, transport: nil))

@main
struct DayTownApp: SwiftUI.App {
    @StateObject var errorHandler = ErrorHandler(app: app)
    
    var body: some Scene {
        WindowGroup {
            ContentView(app: app)
                .environmentObject(errorHandler)
                .alert(Text("Error"), isPresented: .constant(errorHandler.error != nil)) {
                    Button("OK", role: .cancel) { errorHandler.error = nil }
                } message: {
                    Text(errorHandler.error?.localizedDescription ?? "")
                }
                .onOpenURL { url in
                    GIDSignIn.sharedInstance.handle(url)
                }
                .onAppear {
                    GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
                        // Check if `user` exists; otherwise, do something with `error`
                        
                    }
                }
        }
    }
}


final class ErrorHandler: ObservableObject {
    @Published var error: Swift.Error?
    
    init(app: RealmSwift.App) {
        // Sync Manager listens for sync errors.
        app.syncManager.errorHandler = { syncError, syncSession in
            self.error = syncError
        }
    }
}
