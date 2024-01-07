import SwiftUI
import RealmSwift

struct HomeTabView: View {
    @Environment(\.realm) private var realm
    @ObservedObject var viewModel: HomeTabViewModel
    @ObservedObject var weekViewModel: WeekViewModel
    @State var user: User
    @ObservedResults(Todo.self, sortDescriptor: SortDescriptor(keyPath: "_id", ascending: true)) var todoList
    
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
                Section(footer: AddTodoButton(date: weekViewModel.pickedDate, user: user)){
                    ForEach(todoList.filter {$0.date == weekViewModel.pickedDate}) { todo in
                        TodoListCellView(viewModel: viewModel, todoItem: todo)
                    }
                    .onDelete(perform: $todoList.remove)
                    
                }
                .listSectionSeparator(.hidden)
            }
            .listStyle(.plain)
            
            
            .customNavigationBarTitle(title: "ToDo")
        }
        .onAppear {
            print("\n", realm.configuration.fileURL!, "\n")
        }
        
    }
}
