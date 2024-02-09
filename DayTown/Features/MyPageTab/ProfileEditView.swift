import SwiftUI
import RealmSwift
import PhotosUI

struct ProfileEditView: View {
    @ObservedObject var viewModel: MyPageTabViewModel
    @Environment(\.realm) private var realm
    @EnvironmentObject var errorHandler: ErrorHandler
    @Environment(\.dismiss) var dismiss
    
    @State private var userName: String
    @State private var userIntro: String
    @State private var selectedImage: PhotosPickerItem? = nil
    @State private var selectedUIImage: UIImage? = nil
    
    init(viewModel: MyPageTabViewModel) {
        self.viewModel = viewModel
        self._userName = State(initialValue: viewModel.currentUser?.name ?? "")
        self._userIntro = State(initialValue: viewModel.currentUser?.introduction ?? "")
    }
    
    var body: some View {
        VStack(spacing: 8) {
            if let uiImage = selectedUIImage {
                CircleImageView(image: Image(uiImage: uiImage), size: 160)
                    .overlayPhotosPicker(selectedItem: $selectedImage, inset: 12)
            } else {
                CircleUrlImageView(url: viewModel.currentUser?.profileImageURL, size: 160)
                    .overlayPhotosPicker(selectedItem: $selectedImage, inset: 12)
            }
            Spacer()
                .frame(height: 40)
            TextFieldwithTitle(title: "이름", titleWidth: 40, text: $userName)
            TextFieldwithTitle(title: "소개", titleWidth: 40, text: $userIntro)
            Spacer()
        }
        .navigationTitle(K.editProfile)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("저장") {
                    if let userToModify = realm.object(ofType: UserModel.self, forPrimaryKey: viewModel.currentUser?._id) {
                        do {
                            if let image = selectedUIImage {
                                Task {
                                    let url = await viewModel.uploadImageAndGetUrl(userId: userToModify._id, image: image)
                                    
                                    try realm.write {
                                        userToModify.name = userName
                                        userToModify.introduction = userIntro
                                        userToModify.profileImageURL = url
                                    }
                                    viewModel.currentUser = userToModify
                                }
                            } else {
                                try realm.write {
                                    userToModify.name = userName
                                    userToModify.introduction = userIntro
                                }
                                viewModel.currentUser = userToModify
                            }
                            
                            
                            
                        } catch {
                            errorHandler.error = error
                        }
                        
                        
                        
                        
                    }
                    dismiss()
                }
            }
        }
        .onChange(of: selectedImage, { oldValue, newValue in
            Task {
                if let data = try? await newValue?.loadTransferable(type: Data.self) {
                    if let image = UIImage(data: data) {
                        selectedUIImage = image.resizeToSquare(width: 300)
                    }
                }
            }
        })
        .padding(24)
    }
}

