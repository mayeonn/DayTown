import SwiftUI
import RealmSwift
import PhotosUI

struct AddGroupView: View {
    @ObservedObject var viewModel: GroupTabViewModel
    @Environment(\.realm) private var realm
    @EnvironmentObject var errorHandler: ErrorHandler
    @Binding private var showModal: Bool
    
    @State private var showAlert = false
    @State private var alertMessage: String = ""
    @State private var groupName: String = ""
    @State private var groupIntro: String = ""
    @State private var isPrivate: Bool = false
    @State private var password: String = ""
    
    @State private var selectedImage: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil
    
    
    init(viewModel: GroupTabViewModel, showModal: Binding<Bool>) {
        self.viewModel = viewModel
        _showModal = showModal
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                if let selectedImageData,
                   let uiImage = UIImage(data: selectedImageData) {
                    CircleImageView(image: Image(uiImage: uiImage))
                        .overlayPhotosPicker(selectedItem: $selectedImage)
                } else {
                    CircleImageView(image: Image(systemName: "person.2.circle.fill"))
                        .opacity(0.1)
                        .overlayPhotosPicker(selectedItem: $selectedImage)
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
                            do {
                                try realm.write {
                                    let newGroup = Group()
                                    newGroup._id = ObjectId.generate().stringValue
                                    newGroup.name = groupName
                                    newGroup.isPrivate = isPrivate
                                    newGroup.password = password
                                    newGroup.introduction = groupIntro
                                    if let currentUser = viewModel.currentUser {
                                        newGroup.owner_id = currentUser._id
                                        newGroup.members.append(currentUser)
                                        viewModel.myGroups.append(newGroup)
                                    }
                                    realm.add(newGroup)
                                }
                                
                                
                            } catch {
                                self.errorHandler.error = error
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
                    // Retrive selected asset in the form of Data
                    if let data = try? await newValue?.loadTransferable(type: Data.self) {
                        selectedImageData = data
                    }
                }
            })
        }
    }
    
    
    
    
    private func dismiss() {
        groupName = ""
        isPrivate = false
        password = ""
        showModal = false
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
    
    
    func uploadImageAndGetUrl() async {
        guard let imageData = selectedImageData else {
            print("No image selected")
            return
        }
        
        // MongoDB Realm Functions 호출
        do {
            let imageURLResult = try await app.currentUser?.functions.uploadGroupProfileImage([AnyBSON(imageData)])
            print("Called function 'uploadGroupProfileImage' and got result: \(String(describing: imageURLResult))")
        } catch {
            print("Function call failed: \(error.localizedDescription)")
        }
        
    }
}


