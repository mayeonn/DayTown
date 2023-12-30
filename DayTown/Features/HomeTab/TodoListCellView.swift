import SwiftUI

struct TodoListCellView: View {
    let todo: Todo
    @State private var showAlert = false
    @State private var todoTitle: String
    @State private var todoMemo: String
    @Environment(\.realm) private var realm
    
    init(viewModel: HomeTabViewModel, todoItem: Todo) {
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
                        if let todoToModify = realm.object(ofType: Todo.self, forPrimaryKey: todo._id) {
                            try! realm.write {
                                todoToModify.isCompleted.toggle()
                            }
                        }
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
                if let todoToModify = realm.object(ofType: Todo.self, forPrimaryKey: todo._id) {
                    try! realm.write {
                        todoToModify.title = todoTitle
                        todoToModify.memo = todoMemo
                    }
                }
            }
            TextField("title", text: $todoTitle)
            TextField("memo", text: $todoMemo)
        }
        .padding(8)
    }
}
