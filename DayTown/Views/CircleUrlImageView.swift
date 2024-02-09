import SwiftUI

struct CircleUrlImageView: View {
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
                .frame(width: size, height: size)
                .clipShape(Circle())
            
        } else {
            Image(systemName: "person.fill")
                .frame(width: size, height: size)
                .scaledToFill()
        }
    }
}

