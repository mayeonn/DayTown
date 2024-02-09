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
    
    func processImage(image: UIImage) -> String?{
        if let jpegData = image.jpegData(compressionQuality: 0.5) {
            return jpegData.base64EncodedString()
        }
        return nil
    }
    
    func uploadImageAndGetUrl(userId: String, image: UIImage?) async -> String? {
        guard let user = app.currentUser else {
            print("No current user")
            return nil
        }
        
        do {
            let key: String = "userProfileImage/" + userId + ".jpg";
            
            if let resizedImage = image {
                if let base64EncodedImage = processImage(image: resizedImage) {
                    let result = try await user.functions.uploadImageToAWS([AnyBSON(base64EncodedImage), AnyBSON(key)])
                    return result.stringValue
                }
            }
            else {
                print("No image selected")
            }
            return nil
        } catch {
            print("Function call failed: \(error.localizedDescription)")
            return nil
        }
    }
}
