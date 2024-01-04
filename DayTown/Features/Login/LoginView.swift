import SwiftUI
import RealmSwift
import GoogleSignInSwift

struct LoginView: View {
    @ObservedObject var loginViewModel: LoginViewModel
//    @State var email = ""
//    @State var password = ""
    
    init() {
        loginViewModel = LoginViewModel()
    }

    var body: some View {
        VStack {
            if loginViewModel.isLoggingIn {
                ProgressView()
            }
            VStack {
                Text("DayTown")
                    .font(.title)
//                TextField("Email", text: $email)
//                    .textInputAutocapitalization(.never)
//                    .textFieldStyle(.roundedBorder)
//                    .autocorrectionDisabled(true)
//                SecureField("Password", text: $password)
//                    .textFieldStyle(.roundedBorder)
//                Button("Log In") {
//                    loginViewModel.isLoggingIn = true
//                    Task.init {
//                        await loginViewModel.loginAnonymous()
//                        loginViewModel.isLoggingIn = false
//                    }
//                }
//                .disabled(loginViewModel.isLoggingIn)
//                .frame(width: 150, height: 50)
//                .background(.blue)
//                .foregroundColor(.white)
//                .clipShape(Capsule())
//                Button("Create Account") {
//                    loginViewModel.isLoggingIn = true
//                    Task {
//                        await loginViewModel.signUp(email: email, password: password)
//                        loginViewModel.isLoggingIn = false
//                    }
//                }
//                .disabled(loginViewModel.isLoggingIn)
//                .frame(width: 150, height: 50)
//                .background(.blue)
//                .foregroundColor(.white)
//                .clipShape(Capsule())
                GoogleSignInButton(action: loginViewModel.googleSignIn)
            }.padding(20)
        }
    }
}
