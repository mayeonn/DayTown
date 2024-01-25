import SwiftUI
import RealmSwift

struct GroupTabView: View {
    @ObservedObject var viewModel: GroupTabViewModel
    @Environment(\.realm) private var realm
    @State var user: User
    @State private var showModal = false
    @ObservedResults(Group.self) var groupList
    
    
    
    var body: some View {
        VStack {
            List {
                ForEach(groupList) { group in
                    Text(group.name)
                }
            }
            
            .customNavigationBarTitle(title: "그룹")
            .toolbar {
                Button(
                    action: {
                        showModal = true
                    },
                    label: {
                        Image(systemName: "plus.circle")
                            .font(.system(size: 20))
                    }
                )
                .sheet(isPresented: $showModal) {
                    AddGroupView(user: user, showModal: $showModal)
                }
            }
            .onAppear {
                viewModel.fetchData()
            }
        }
    }
}
