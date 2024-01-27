import SwiftUI

struct TextFieldwithTitle: View {
    let title: String
    let titleWidth: CGFloat
    @Binding var text: String
    
    var body: some View {
        HStack {
            Text(title)
                .frame(width: 100, alignment: .leading)
            TextField(title, text: $text)
                .textFieldStyle(.roundedBorder)
        }
    }
}
