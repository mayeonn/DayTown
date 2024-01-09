import SwiftUI

struct ProfileImage: View {
    var url: String?
    let size: CGFloat
    
    init(url: String?, size: CGFloat) {
        self.url = url
        self.size = size
    }
    
    
    var body: some View {
        if let imageUrl = url {
            AsyncImage(url: URL(string: imageUrl)) { img in
                    img.resizable()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 100, height: 100)
                .clipShape(Circle())
            
        } else {
            Image(systemName: "person.fill")
        }
    }
}

