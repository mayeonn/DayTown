import SwiftUI

struct ChatTabView: View {
    @ObservedObject var viewModel: ChatTabViewModel
    
    init() {
        self.viewModel = ChatTabViewModel()
    }
    
    var body: some View {
        VStack {
            Text(viewModel.content)
            
            .customNavigationBarTitle(title: "채팅")
            .onAppear {
                viewModel.fetchData()
            }
        }
    }
}
