import SwiftUI
import RealmSwift

struct GroupSearchView: View {
    @ObservedResults(Group.self) var groupList
    @State private var searchText: String = ""
    @State var user: User
    
    var body: some View {
        List {
            ForEach(groupList) { group in
                GroupInfoView(group: group)
            }
        }
        .listStyle(.plain)
        .searchable(text: $searchText,
                    placement: .navigationBarDrawer(displayMode: .always),
                    prompt: "그룹 이름, 소개글로 검색해보세요") {
            ForEach(groupList.where{ $0.name.contains(searchText, options: .caseInsensitive) || $0.introduction.contains(searchText, options: .caseInsensitive)}) { group in
                GroupInfoView(group: group)
            }
        }
    }
}
