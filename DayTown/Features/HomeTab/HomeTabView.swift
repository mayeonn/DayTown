import SwiftUI

struct HomeTabView: View {
    @ObservedObject var viewModel: HomeTabViewModel
    @ObservedObject var weekViewModel: WeekViewModel
    @State private var showAlert = false
    @State private var todoTitle: String = ""
    @State private var todoMemo: String = ""
    
    init() {
        self.viewModel = HomeTabViewModel()
        self.weekViewModel = WeekViewModel()
        self.weekViewModel.homeTabViewModel = viewModel
    }
    
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
            List (viewModel.todoList) { todo in
                Text(todo.title)
            }
            .listStyle(.grouped)
            .background(.red)
            
            Button(
                action: {
                    showAlert.toggle()
                },
                label: {
                    Image(systemName: "plus.circle")
                        .font(.system(size: 36))
                }
            )
            .alert(Text("Todo 추가"), isPresented: $showAlert) {
                Button("취소") {
                    todoTitle = ""
                    todoMemo = ""
                }
                Button("추가") {
                    viewModel.addTodo(title: todoTitle, memo: todoMemo, date: weekViewModel.pickedDate)
                    todoTitle = ""
                    todoMemo = ""
                }
                TextField("title", text: $todoTitle)
                TextField("memo", text: $todoMemo)
            }
            
            
            .customNavigationBarTitle(title: "ToDo")
        }
    }
}

#Preview {
    ContentView()
}
