import SwiftUI
import RealmSwift
import GoogleSignInSwift
import GoogleSignIn

struct LoginView: View {
    @ObservedObject var loginViewModel: LoginViewModel
    @EnvironmentObject var errorHandler: ErrorHandler
    @Binding var googleProfile: GIDProfileData?
    //    @State var email = ""
    //    @State var password = ""
    
    
    
    init(googleProfile: Binding<GIDProfileData?>) {
        _googleProfile = googleProfile  // 초기화
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
                GoogleSignInButton(action: googleSignIn)
                
            }.padding(20)
        }
    }
    
    func googleSignIn() {
        guard let presentingViewController = (UIApplication.shared.connectedScenes.first
                                              as? UIWindowScene)?.windows.first?.rootViewController else {return}
        GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController) { signInResult, error in
            if let error = error {
                self.errorHandler.error = error
                return
            }
            if let googleUser = signInResult?.user {
                let credentials = Credentials.googleId(token: googleUser.idToken!.tokenString)
                googleProfile = googleUser.profile
                
                app.login(credentials: credentials) { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .failure(let error):
                            print("Failed to log in to MongoDB Realm: \(error)")
                        case .success(let user):
                            print("Successfully logged in user: \(user)")
                        }
                    }
                }
            }
        }
    }
}
