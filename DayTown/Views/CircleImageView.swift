import SwiftUI

struct CircleImageView: View {
    let image: Image
    
    var body: some View {
        image
            .resizable()
            .scaledToFill()
            .frame(width: 250, height: 250)
            .clipShape(Circle())
        
    }
}
