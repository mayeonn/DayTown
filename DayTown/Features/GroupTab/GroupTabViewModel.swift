import SwiftUI
import RealmSwift
import Combine

class GroupTabViewModel: ObservableObject {
    @Published var currentUser: UserModel?
    @Published var myGroups: [Group] = []
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        $myGroups
            .compactMap { $0 }
            .sink { [weak self] user in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
    }
    
    func processImage(image: UIImage) -> String?{
        if let jpegData = image.jpegData(compressionQuality: 0.5) {
            return jpegData.base64EncodedString()
        }
        return nil
    }
    
    func uploadImageAndGetUrl(groupId: String, image: UIImage?) async -> String? {
        guard let user = app.currentUser else {
            print("No current user")
            return nil
        }
        
        // MongoDB Realm Functions 호출
        do {
            let key: String = "groupProfileImage/" + groupId + ".jpg";
            
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
