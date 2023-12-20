import SwiftUI

struct HomeTabView: View {
    @ObservedObject var viewModel: HomeTabViewModel
    @ObservedObject var weekViewModel: WeekViewModel
    
    init() {
        self.viewModel = HomeTabViewModel()
        self.weekViewModel = WeekViewModel()
//        self.weekViewModel.homeTabViewModel = viewModel
    }
    
    var body: some View {
        VStack(spacing: 0) {
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
            
            List {
                Section(footer: AddTodoButton(homeTabViewModel: viewModel, weekViewModel: weekViewModel)){
                    ForEach(viewModel.todoList, id: \.self) { todo in
                        TodoListCellView(viewModel: viewModel, todoItem: todo)
                    }
                    .onMove(perform: { indices, newOffset in
                        viewModel.moveTodoCell()
                    })
                    .onDelete { indexSet in
                        viewModel.deleteTodo(viewModel.todoList[indexSet.first!])
                    }
                }
                .listSectionSeparator(.hidden)
            }
            .listStyle(.plain)
            .onAppear {
                //viewModel.getTodoList(on: weekViewModel.pickedDate)
            }
            
            
            .customNavigationBarTitle(title: "ToDo")
        }
    }
}

#Preview {
    ContentView()
}
