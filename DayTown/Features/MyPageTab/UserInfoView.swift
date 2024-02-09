import SwiftUI

struct UserInfoView: View {
    let user: UserModel
    
    var body: some View {
        HStack(spacing: 12) {
            CircleUrlImageView(url: user.profileImageURL, size: 100)
            
            VStack(alignment: .leading) {
                Text(user.name)
                    .font(.system(size: 20).bold())
                if let intro = user.introduction {
                    Text(intro)
                        .foregroundStyle(.gray)
                }
            }
        }
    }
}
