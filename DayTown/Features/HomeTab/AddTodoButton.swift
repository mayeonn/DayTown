import SwiftUI
import RealmSwift

struct AddTodoButton: View {
    @Environment(\.realm) private var realm
    @State private var showAlert = false
    @State private var todoTitle: String = ""
    @State private var todoMemo: String = ""
    @State var user: User
    private var date: String
    
    init(date: String, user: User) {
        self.user = user
        self.date = date
    }
    
    var body: some View {
        HStack{
            Spacer()
            Button(
                action: {
                    showAlert = true
                },
                label: {
                    Image(systemName: "plus.circle")
                        .font(.system(size: 36))
                        .foregroundStyle(.blue)
                }
            )
            .frame(alignment: .center)
            .alert(Text("\(date) Todo 추가"), isPresented: $showAlert) {
                Button("취소") {
                    todoTitle = ""
                    todoMemo = ""
                    showAlert = false
                }
                Button("추가") {
                    try? realm.write {
                        let newTodo = Todo()
                        newTodo.title = todoTitle
                        newTodo.memo = todoMemo
                        newTodo.date = date
                        newTodo.owner_id = user.id
                        realm.add(newTodo)
                    }
                    todoTitle = ""
                    todoMemo = ""
                    showAlert = false
                }
                TextField("title", text: $todoTitle)
                TextField("memo", text: $todoMemo)
            }
            Spacer()
        }
        .padding(8)
    }
}
