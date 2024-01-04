import SwiftUI
import RealmSwift
import Combine
import GoogleSignInSwift
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

    func googleSignIn() {
        guard let presentingViewController = (UIApplication.shared.connectedScenes.first
                                              as? UIWindowScene)?.windows.first?.rootViewController else {return}
        GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController) { signInResult, error in
            if let error = error {
                self.errorHandler.error = error
                return
            }
            
            
            if let idToken = signInResult?.user.idToken {
                let credentials = Credentials.googleId(token: idToken.tokenString)
                app.login(credentials: credentials) { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .failure(let error):
                            print("Failed to log in to MongoDB Realm: \(error)")
                        case .success(let user):
                            print("\(user) Successfully logged in to MongoDB Realm using Google OAuth.")
                        }
                    }
                }
            }
        }
    }
    
}
