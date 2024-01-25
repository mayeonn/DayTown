import SwiftUI
import RealmSwift

struct ProfileEditView: View {
    @ObservedObject var viewModel: MyPageTabViewModel
    @Environment(\.realm) private var realm
    @EnvironmentObject var errorHandler: ErrorHandler
    @Environment(\.dismiss) var dismiss
    
    @State private var userName: String
    @State private var userIntro: String
    
    
    init(viewModel: MyPageTabViewModel) {
        self.viewModel = viewModel
        self._userName = State(initialValue: viewModel.currentUser?.name ?? "")
        self._userIntro = State(initialValue: viewModel.currentUser?.introduction ?? "")
    }
    
    var body: some View {
        VStack(spacing: 8) {
            ProfileImage(url: viewModel.currentUser?.profileImageURL, size: 100)
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
                    if let userToModify = realm.object(ofType: UserModel.self, forPrimaryKey: viewModel.currentUser?._id) {
                        do {
                            try realm.write {
                                userToModify.name = userName
                                userToModify.introduction = userIntro
                            }
                        } catch {
                            errorHandler.error = error
                        }
                        viewModel.currentUser = userToModify
                    }
                    
                    dismiss()
                }
            }
        }
        .padding(24)
    }
}

