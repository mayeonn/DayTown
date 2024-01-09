import SwiftUI

struct UserInfoView: View {
    let userId: String
    @Environment(\.realm) private var realm
    
    var body: some View {
        if let userModel = realm.object(ofType: UserModel.self, forPrimaryKey: userId) {
            HStack(spacing: 12) {
                ProfileImage(url: userModel.profileImageURL, size: 100)
                
                VStack(alignment: .leading) {
                    Text(userModel.name)
                        .font(.system(size: 20).bold())
                    if let intro = userModel.introduction {
                        Text(intro)
                            .foregroundStyle(.gray)
                    }
                }
                
            }
        }
    }
}
