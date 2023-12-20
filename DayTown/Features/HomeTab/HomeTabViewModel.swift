import SwiftUI
import Combine
import RealmSwift

class HomeTabViewModel: ObservableObject {
    @Published var todoList: [Todo] = []
    @Published var weekDragOffset: CGSize = CGSize()
    @Published var weekViewModel: WeekViewModel
    
    let calendar = Calendar.current
    private let realm = RealmManager.realm
    
    private var cancellables: Set<AnyCancellable> = []
    private var notificationToken: NotificationToken?
    
    init() {
        weekViewModel = WeekViewModel()
        
        // weekViewModel.pickedDate 변경 감지
        weekViewModel.$pickedDate
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.setupNotificationToken()
            }
            .store(in: &cancellables)
        
        setupNotificationToken()    // 초기 설정
    }
    deinit {
        notificationToken?.invalidate()
    }
    
    private func setupNotificationToken() {
        notificationToken?.invalidate()
        // results의 변경 감지
        notificationToken = realm.objects(Todo.self)
            .filter("date == %@", weekViewModel.pickedDate)
            .sorted(byKeyPath: "date")
            .observe { [weak self] changes in
                guard let self = self else {return}
                switch changes {
                case .initial, .update:
                    getTodoList()
                case .error(let error):
                    print("Error observing changes: \(error)")
                }
            }
    }
    
    func getTodoList() {
        let results = realm.objects(Todo.self)
            .filter("date == %@", weekViewModel.pickedDate)
            .sorted(byKeyPath: "date")
        // results를 Todo로 mapping
        todoList = Array(results).map { Todo(value: $0) }
        // View에 변경을 알림
        objectWillChange.send()
    }
    
    func addTodo(title: String, memo: String) {
        let newTodo = Todo()
        newTodo.title = title
        newTodo.memo = memo
        newTodo.date = weekViewModel.pickedDate
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
}
