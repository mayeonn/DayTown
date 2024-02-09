import SwiftUI

struct GroupInfoView: View {
    let group: Group
    
    var body: some View {
        HStack(spacing: 12) {
            CircleUrlImageView(url: group.profileImageURL, size: 80)
            
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 8) {
                    Text(group.name)
                        .font(.system(size: 20).bold())
                    Text(String(group.members.count))
                        .fontWeight(.bold)
                        .foregroundStyle(Color(UIColor.lightGray))
                }
                
                if group.introduction.isEmpty==false {
                    Text(group.introduction)
                        .foregroundStyle(.gray)
                }
            }
            
        }
    }
}
