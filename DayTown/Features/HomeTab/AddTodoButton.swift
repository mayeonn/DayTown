import SwiftUI

struct AddTodoButton: View {
    @ObservedObject var homeTabViewModel: HomeTabViewModel
    @State private var showAlert = false
    @State private var todoTitle: String = ""
    @State private var todoMemo: String = ""
    
    var body: some View {
        HStack{
            Spacer()
            Button(
                action: {
                    showAlert.toggle()
                },
                label: {
                    Image(systemName: "plus.circle")
                        .font(.system(size: 36))
                        .foregroundStyle(.blue)
                }
            )
            .frame(alignment: .center)
            .alert(Text("Todo 추가"), isPresented: $showAlert) {
                Button("취소") {
                    todoTitle = ""
                    todoMemo = ""
                }
                Button("추가") {
                    homeTabViewModel.addTodo(title: todoTitle, memo: todoMemo)
                    todoTitle = ""
                    todoMemo = ""
                }
                TextField("title", text: $todoTitle)
                TextField("memo", text: $todoMemo)
            }
            Spacer()
        }
        .padding(8)
    }
}
