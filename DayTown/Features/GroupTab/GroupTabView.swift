import SwiftUI
import RealmSwift

struct GroupTabView: View {
    @ObservedObject var viewModel: GroupTabViewModel
    @Environment(\.realm) private var realm
    @State var user: User
    @State private var showModal = false
    
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.myGroups) { group in
                    NavigationLink {
                        Text(group.name)
                    } label: {
                        GroupInfoView(group: group)
                    }
                }
            }
            .listStyle(.plain)
            
            
            .customNavigationBarTitle(title: "그룹")
            .toolbar {
                // Add Group Button
                Button(
                    action: {
                        showModal = true
                    },
                    label: {
                        Image(systemName: "plus")
                            .font(.system(size: 20))
                    }
                )
                .sheet(isPresented: $showModal) {
                    AddGroupView(viewModel: viewModel, showModal: $showModal)
                }
                // Group Search Button
                NavigationLink {
                    GroupSearchView(viewModel: viewModel)
                } label: {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.blue)
                        .font(.system(size: 20))
                }
            }
        }
        
        .onAppear {
            if let user = realm.object(ofType: UserModel.self, forPrimaryKey: user.id) {
                viewModel.currentUser = user
                viewModel.myGroups = Array(user.groups)
            }
        }
    }
}
