import SwiftUI
import RealmSwift
import GoogleSignIn

// TODO : anonymous -> email/password
class LoginViewModel: ObservableObject {
    @EnvironmentObject var errorHandler: ErrorHandler
    @Published var isLoggingIn = false
    
    
    func loginAnonymous() async {
        do {
            let user = try await app.login(credentials: .anonymous)
            print("Successfully logged in user: \(user)")
        } catch {
            print("Failed to log in user: \(error.localizedDescription)")
            errorHandler.error = error
        }
    }

    
    
}
