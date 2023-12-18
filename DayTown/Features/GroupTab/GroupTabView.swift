import SwiftUI

struct GroupTabView: View {
    @ObservedObject var viewModel: GroupTabViewModel
    
    init() {
        self.viewModel = GroupTabViewModel()
    }
    
    var body: some View {
        VStack {
            Text(viewModel.content)
            
            .customNavigationBarTitle(title: "그룹")
            .onAppear {
                viewModel.fetchData()
            }
        }
    }
}
