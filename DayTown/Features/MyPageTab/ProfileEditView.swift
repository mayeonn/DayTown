import SwiftUI
import RealmSwift

struct ProfileEditView: View {
    @Environment(\.realm) private var realm
    @EnvironmentObject var errorHandler: ErrorHandler
    @Environment(\.dismiss) var dismiss
    @ObservedObject var userModel: UserModel
    @State private var userName: String
    @State private var userIntro: String
    
    
    init(userModel: UserModel) {
        self.userModel = userModel
        self._userName = State(initialValue: userModel.name)
        self._userIntro = State(initialValue: userModel.introduction ?? "")
    }
    
    var body: some View {
        VStack(spacing: 8) {
            ProfileImage(url: userModel.profileImageURL, size: 100)
                .padding(40)

            HStack {
                Text("이름")
                    .frame(width: 60, alignment: .leading)
                TextField("이름", text: $userName)
                    .textFieldStyle(.roundedBorder)
            }
            HStack() {
                Text("소개")
                    .frame(width: 60, alignment: .leading)
                TextField("소개", text: $userIntro)
                    .textFieldStyle(.roundedBorder)
            }
            Spacer()
        }
        .navigationTitle(K.editProfile)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("저장") {
                    if let userToModify = realm.object(ofType: UserModel.self, forPrimaryKey: userModel._id) {
                        do {
                            try realm.write {
                                userToModify.name = userName
                                userToModify.introduction = userIntro
                            }
                        } catch {
                            errorHandler.error = error
                        }
                    }
                    dismiss()
                }
            }
        }
        .padding(24)
    }
}

