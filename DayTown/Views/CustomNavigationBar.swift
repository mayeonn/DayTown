import SwiftUI

struct CustomNavigationBarTitle: ViewModifier {
    let title: String
    
    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    Text(title)
                        .font(.system(size: 24))
                }
            }
    }
}

extension View {
    func customNavigationBarTitle(title: String) -> some View {
        modifier(CustomNavigationBarTitle(title: title))
    }
}

#Preview {
    ContentView()
}
