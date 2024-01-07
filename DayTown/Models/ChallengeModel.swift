import RealmSwift

class Challenge: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var title: String
    @Persisted var group_id: String
    let weekDays = List<Int>()
}
