import SwiftUI
import Combine
import RealmSwift

class HomeTabViewModel: ObservableObject {
    @Published var todoList: [Todo] = []
    @Published var weekDragOffset: CGSize = CGSize()
    let calendar = Calendar.current
    private let realm = RealmManager.realm
    
    private var cancellables: Set<AnyCancellable> = []
    
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

    func getTodoList(on pickedDate: String){
        let todo = realm.objects(Todo.self)
            .filter("date == %@", pickedDate)
            .sorted(byKeyPath: "date")
        
        todo
            .collectionPublisher
            .map{ Array($0) }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
            .sink(
                receiveCompletion: { completion in },
                receiveValue: { todo in
                    self.todoList = todo
                }
            )
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
    
    func deleteTodo(id: ObjectId) {
        try! realm.write {
            let objectToDelete = realm.objects(Todo.self).filter("objectId == 'id'").first
            
            if let objectToDelete = objectToDelete {
                realm.delete(objectToDelete)
            }
        }
    }
}
