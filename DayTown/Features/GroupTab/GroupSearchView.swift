import SwiftUI
import RealmSwift

struct GroupSearchView: View {
    @ObservedObject var viewModel: GroupTabViewModel
    @ObservedResults(Group.self) var groupList
    @State private var searchText: String = ""
    @Environment(\.realm) private var realm
    @State private var showAlert = false
    @State private var alertMessage = ""
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        List {
            ForEach(groupList) { group in
                HStack {
                    GroupInfoView(group: group)
                    Spacer()
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    joinGroup(groupId: group._id)
                }
                .alert(alertMessage, isPresented: $showAlert) {
                    Button("확인", role: .cancel){}
                }
            }
        }
        .listStyle(.plain)
        .searchable(text: $searchText,
                    placement: .navigationBarDrawer(displayMode: .always),
                    prompt: "그룹 이름, 소개글로 검색해보세요") {
            ForEach(groupList.where{ $0.name.contains(searchText, options: .caseInsensitive) || $0.introduction.contains(searchText, options: .caseInsensitive)}) { group in
                HStack {
                    GroupInfoView(group: group)
                    Spacer()
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    joinGroup(groupId: group._id)
                }
                .alert("이미 참여 중인 그룹입니다.", isPresented: $showAlert) {
                    Button("확인", role: .cancel){}
                }
            }
        }
    }
    
    private func joinGroup(groupId: String) {
        if let groupToModify = realm.object(ofType: Group.self, forPrimaryKey: groupId), let currentUser = viewModel.currentUser {
            
            if viewModel.myGroups.contains(groupToModify) {
                showAlert = true
                alertMessage = "이미 참여 중인 그룹입니다."
            }
            else if groupToModify.isPrivate {
                showAlert = true
                alertMessage = "참여 비밀번호를 입력하세요."
            }
            else {
                try! realm.write {
                    groupToModify.members.append(currentUser)
                    viewModel.myGroups.append(groupToModify)
                }
                dismiss()
            }
        }
    }
}
