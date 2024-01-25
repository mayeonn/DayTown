import SwiftUI
import RealmSwift

struct AddGroupView: View {
    @Environment(\.realm) private var realm
    @EnvironmentObject var errorHandler: ErrorHandler
    @Binding private var showModal: Bool
    @State private var groupName: String = ""
    @State private var isPrivate: Bool = false
    @State private var password: String = ""
    @State var user: User
    
    init(user: User, showModal: Binding<Bool>) {
        self.user = user
        _showModal = showModal
    }
    
    var body: some View {
        NavigationView{
            VStack(spacing: 24) {
                HStack {
                    Text("그룹 이름")
                        .frame(width: 100, alignment: .leading)
                    TextField("그룹 이름", text: $groupName)
                    .textFieldStyle(.roundedBorder)
                }
                
                Toggle("비공개 그룹", isOn: $isPrivate)
                if isPrivate {
                    HStack {
                        Text("참여 비밀번호")
                            .frame(width: 100, alignment: .leading)
                        TextField("참여 비밀번호", text: $password)
                            .textFieldStyle(.roundedBorder)
                    }
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
                        do {
                            try realm.write {
                                let newGroup = Group()
                                newGroup._id = ObjectId.generate().stringValue
                                newGroup.name = groupName
                                newGroup.isPrivate = isPrivate
                                newGroup.password = password
                                newGroup.owner_id = user.id
                                realm.add(newGroup)
                            }
                        } catch {
                            self.errorHandler.error = error
                        }
                        
                        dismiss()
                    }
                }
            }
        }
    }
    
    
    private func dismiss() {
        groupName = ""
        isPrivate = false
        password = ""
        showModal = false
    }
}

