import SwiftUI
import RealmSwift
import Combine
import GoogleSignIn

class MyPageTabViewModel: ObservableObject {
    
    func logout(user: User) async {
        do {
            try await user.logOut()
            GIDSignIn.sharedInstance.signOut()
            print("Successfully logged user out")
        } catch {
            print("Failed to log user out: \(error.localizedDescription)")
        }
    }
}
