import SwiftUI
import RealmSwift

struct LogoutButton: View {
    @State var isLoggingOut = false
    @State var error: Error?
    @State var errorMessage: ErrorMessage? = nil
    let myPageTabViewModel: MyPageTabViewModel
    
    var body: some View {
        if isLoggingOut {
            ProgressView()
        }
        Button(
            action: {
                guard let user = app.currentUser else {
                    return
                }
                isLoggingOut = true
                Task {
                    await myPageTabViewModel.logout(user: user)
                    isLoggingOut = false
                }
            }, label: {
                Text("로그아웃")
                    .foregroundStyle(.red)
                    .frame(maxWidth: .infinity, alignment: .leading)
            })
        .disabled(app.currentUser == nil || isLoggingOut)
        .alert(item: $errorMessage) { errorMessage in
            Alert(
                title: Text("Failed to log out"),
                message: Text(errorMessage.errorText),
                dismissButton: .cancel()
            )
        }
    }
}

// 로그아웃 에러 메세지 Alert로 보여줌
struct ErrorMessage: Identifiable {
    let id = UUID()
    let errorText: String
}
