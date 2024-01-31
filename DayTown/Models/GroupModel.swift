import RealmSwift


class Group: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id: String
    @Persisted var name: String
    @Persisted var introduction: String
    @Persisted var isPrivate: Bool
    @Persisted var password: String?
    @Persisted var owner_id: String
    @Persisted var profileImageURL: String?
    
    @Persisted var members = List<UserModel>()
    @Persisted var challenges = List<Challenge>()
}
