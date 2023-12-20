import SwiftUI

struct TodoListCellView: View {
    @ObservedObject var homeTabViewModel: HomeTabViewModel
    let todo: Todo
    @State private var showAlert = false
    @State private var todoTitle: String
    @State private var todoMemo: String
    
    init(viewModel: HomeTabViewModel, todoItem: Todo) {
        homeTabViewModel = viewModel
        todo = todoItem
        todoTitle = todo.title
        todoMemo = todo.memo ?? ""
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text(todo.title)
                    .font(.system(size: 20))
                Spacer()
                Image(systemName: todo.isCompleted ? "checkmark.square" : "square")
                    .foregroundColor(todo.isCompleted ? .blue : .gray)
                    .font(.system(size: 32))
                    .onTapGesture {
                        homeTabViewModel.toggleCompletion(for: todo)
                    }
            }
            if let memoText = todo.memo {
                Text(memoText)
                    .lineLimit(0)
                    .foregroundColor(.gray)
            }
        }
        .onTapGesture {
            showAlert.toggle()
        }
        .alert(Text("수정") ,isPresented: $showAlert) {
            Button("취소") {}
            Button("저장") {
                homeTabViewModel.editTodo(for: todo, title: todoTitle, memo: todoMemo)
            }
            TextField("title", text: $todoTitle)
            TextField("memo", text: $todoMemo)
        }
        .padding(8)
    }
}
