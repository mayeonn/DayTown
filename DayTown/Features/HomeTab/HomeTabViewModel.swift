import SwiftUI
import Combine
import RealmSwift

class HomeTabViewModel: ObservableObject {
    @Published var todoList: [Todo] = []
    @Published var weekDragOffset: CGSize = CGSize()
    let calendar = Calendar.current
    private let realm = RealmManager.realm
    
    private var cancellables: Set<AnyCancellable> = []
    private var notificationToken: NotificationToken?
    
    init() {        
        let results = realm.objects(Todo.self)
            .filter("date == %@", "12/18")
            .sorted(byKeyPath: "date")
        
        // results의 변경 감지
        notificationToken = results.observe { [weak self] changes in
            guard let self = self else {return}
            switch changes {
            case .initial, .update:
                // Result를 Todo로 mapping
                self.todoList = Array(results).map{ Todo(value: $0) }
                // View에 변경을 알림
                self.objectWillChange.send()
            case .error(let error):
                print("Error observing changes: \(error)")
            }
        }
    }
    deinit {
        notificationToken?.invalidate()
    }
    
    func setWeekDragOffset(_ size: CGSize) {
        Future<CGSize, Never> { promise in
            DispatchQueue.global().async {
                promise(.success(size))
            }
        }
        .receive(on: DispatchQueue.main)
        .assign(to: \.weekDragOffset, on: self)
        .store(in: &cancellables)
    }
    
    func addTodo(title: String, memo: String, date: String) {
        let newTodo = Todo()
        newTodo.title = title
        newTodo.memo = memo
        newTodo.date = date
        try! realm.write {
            realm.add(newTodo)
        }
    }
    
    func deleteTodo(_ todo: Todo) {
        try! realm.write {
            let todoItem = realm.objects(Todo.self).filter {
                $0.id == todo.id
            }.first
            
            if let todoItemToDelete = todoItem {
                realm.delete(todoItemToDelete)
            }
        }
    }
    
    func toggleCompletion(for todo: Todo) {
        let todoItem = realm.objects(Todo.self).where{
            $0.id == todo.id
        }.first!
        
        try! realm.write {
            todoItem.isCompleted.toggle()
        }
    }
    
    func editTodo(for todo: Todo, title: String, memo: String?) {
        let todoItem = realm.objects(Todo.self).where {
            $0.id == todo.id
        }.first!
        
        try! realm.write {
            todoItem.title = title
            todoItem.memo = memo
        }
    }
    
    func moveTodoCell () {
        
    }
}
