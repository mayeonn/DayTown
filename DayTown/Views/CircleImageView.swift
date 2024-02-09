import SwiftUI

struct CircleImageView: View {
    let image: Image
    let size: CGFloat
    
    var body: some View {
        image
            .resizable()
            .scaledToFill()
            .frame(width: size, height: size)
            .clipShape(Circle())
        
    }
}
