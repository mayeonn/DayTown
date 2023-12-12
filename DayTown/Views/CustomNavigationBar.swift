import SwiftUI

// CustomNavigationBarTitle ViewModifier 정의
struct CustomNavigationBarTitle: ViewModifier {
    let title: String
    
    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text(title)
                        .font(.system(size: 24))
                }
            }
    }
}

// View 확장(extension)을 사용하여 사용하기 편하게 만듦
extension View {
    func customNavigationBarTitle(title: String) -> some View {
        modifier(CustomNavigationBarTitle(title: title))
    }
}

#Preview {
    ContentView()
}
