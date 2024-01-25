import SwiftUI
import RealmSwift
import Combine
import GoogleSignIn

class MyPageTabViewModel: ObservableObject {
    @Published var currentUser: UserModel?
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        $currentUser
            .compactMap { $0 }
            .sink { [weak self] user in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
    }
    
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
