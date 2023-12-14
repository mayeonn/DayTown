import SwiftUI

struct HomeTabView: View {
    @ObservedObject var viewModel: HomeTabViewModel
    @StateObject private var weekViewModel = WeekViewModel()
    
    @State var dragOffset: CGSize = CGSize()
    
    var body: some View {
        VStack {
            WeekView(viewModel: weekViewModel)
                .offset(dragOffset)
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                            dragOffset = CGSize(width: gesture.translation.width, height: 0)
                        }
                        .onEnded { gesture in
                            withAnimation(.default) {
                                if gesture.translation.width < -100 {
                                    weekViewModel.updateStartOfWeek(by: 1)
                                } else if gesture.translation.width > 100 {
                                    weekViewModel.updateStartOfWeek(by: -1)
                                }
                                dragOffset = CGSize()
                            }
                        }
                )
            Spacer()
                .customNavigationBarTitle(title: "ToDo")
                .onAppear {
                    viewModel.fetchData()
                }
        }
    }
}

#Preview {
    ContentView()
}
