import SwiftUI
import Combine

// TODO : anonymous -> email/password
class LoginViewModel: ObservableObject {
    @EnvironmentObject var errorHandler: ErrorHandler
    @Published var isLoggingIn = false

    func login(email: String, password: String) async {
        do {
            let user = try await app.login(credentials: .anonymous)
//            let user = try await app.login(credentials: Credentials.emailPassword(email: email, password: password))
            print("Successfully logged in user: \(user)")
        } catch {
            print("Failed to log in user: \(error.localizedDescription)")
            errorHandler.error = error
        }
    }
    
    func signUp(email: String, password: String) async {
        do {
            try await app.emailPasswordAuth.registerUser(email: email, password: password)
            print("Successfully registered user")
            await login(email: email, password: password)
        } catch {
            print("Failed to register user: \(error.localizedDescription)")
            errorHandler.error = error
        }
    }
}
