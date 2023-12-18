import RealmSwift

class Todo: Object, Identifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var title: String = ""
    @Persisted var memo: String?
    @Persisted var isCompleted: Bool = false
    @Persisted var date: String
    @Persisted var groupId: String?
}
