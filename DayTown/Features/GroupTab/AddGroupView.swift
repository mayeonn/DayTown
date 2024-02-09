import SwiftUI
import RealmSwift
import PhotosUI

struct AddGroupView: View {
    //    @State var user: User
    @ObservedObject var viewModel: GroupTabViewModel
    @Environment(\.realm) private var realm
    @EnvironmentObject var errorHandler: ErrorHandler
    @Environment(\.dismiss) var dismiss
    
    @State private var showAlert = false
    @State private var alertMessage: String = ""
    @State private var groupName: String = ""
    @State private var groupIntro: String = ""
    @State private var isPrivate: Bool = false
    @State private var password: String = ""
    @State private var selectedImage: PhotosPickerItem? = nil
    @State private var selectedUIImage: UIImage? = nil
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                if let uiImage = selectedUIImage {
                    CircleImageView(image: Image(uiImage: uiImage), size: 250)
                        .overlayPhotosPicker(selectedItem: $selectedImage, inset: 20)
                } else {
                    CircleImageView(image: Image(systemName: "person.2.circle.fill"), size: 250)
                        .opacity(0.1)
                        .overlayPhotosPicker(selectedItem: $selectedImage, inset: 20)
                }
                
                TextFieldwithTitle(title: "그룹 이름", titleWidth: 100, text: $groupName)
                TextFieldwithTitle(title: "그룹 소개글", titleWidth: 100, text: $groupIntro)
                
                Toggle("비공개 그룹", isOn: $isPrivate)
                if isPrivate {
                    TextFieldwithTitle(title: "참여 비밀번호", titleWidth: 100, text: $password)
                }
                
                
                Spacer()
            }
            .padding(24)
            
            .navigationTitle("그룹 만들기")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("취소", role: .cancel) {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("추가") {
                        
                        if validate() {
                            Task {
                                let newGroup = Group()
                                newGroup._id = ObjectId.generate().stringValue
                                newGroup.profileImageURL = await viewModel.uploadImageAndGetUrl(groupId: newGroup._id, image: selectedUIImage)
                                newGroup.name = groupName
                                newGroup.isPrivate = isPrivate
                                newGroup.password = password
                                newGroup.introduction = groupIntro
                                if let currentUser = viewModel.currentUser {
                                    newGroup.owner_id = currentUser._id
                                    newGroup.members.append(currentUser)
                                    viewModel.myGroups.append(newGroup)
                                }
                                
                                try? realm.write {
                                    realm.add(newGroup)
                                }
                            }
                            
                            dismiss()
                        }
                    }
                    .alert(alertMessage, isPresented: $showAlert) {
                        Button("확인", role: .cancel){}
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
        }
    }
    
    private func validate() -> Bool {
        if groupName.isEmpty {
            showAlert = true
            alertMessage = "그룹 이름을 입력하세요."
            return false
        }
        else if groupIntro.isEmpty {
            showAlert = true
            alertMessage = "그룹 소개글을 입력하세요."
            return false
        }
        return true
    }
    
    
 
}



