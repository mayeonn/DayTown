import SwiftUI

struct HomeTabView: View {
    @ObservedObject var viewModel: HomeTabViewModel
    @ObservedObject var weekViewModel = WeekViewModel()
    
    var body: some View {
        VStack {
            WeekView(viewModel: weekViewModel)
                .offset(viewModel.weekDragOffset)
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                            viewModel.setWeekDragOffset(CGSize(width: gesture.translation.width, height: 0))
                        }
                        .onEnded { gesture in
                            withAnimation(.linear(duration: 1)) {
                                if gesture.translation.width < -100 {
                                    weekViewModel.updateStartOfWeek(by: 1)
                                } else if gesture.translation.width > 100 {
                                    weekViewModel.updateStartOfWeek(by: -1)
                                }
                                viewModel.setWeekDragOffset(CGSize())
                            }
                        }
                )
            Text(weekViewModel.pickedDate.description)
            Spacer()
            .customNavigationBarTitle(title: "ToDo")
        }
    }
}

#Preview {
    ContentView()
}
