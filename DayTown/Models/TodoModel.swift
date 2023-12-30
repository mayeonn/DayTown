import RealmSwift

class Todo: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var title: String = ""
    @Persisted var memo: String?
    @Persisted var isCompleted: Bool = false
    @Persisted var date: String
    @Persisted var owner_id: String
    @Persisted var group_id: String?
}
