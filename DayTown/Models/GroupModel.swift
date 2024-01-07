import RealmSwift

class Group: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var name: String
    @Persisted var isPrivate: Bool
    @Persisted var password: String?
    
    let members = List<UserModel>()
    let challenges = List<Challenge>()
}
