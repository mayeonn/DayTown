import RealmSwift

// User(RLMUser)와 다른 Custom UserModel Collection
class UserModel: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id: String
    @Persisted var name: String
    @Persisted var email: String
    @Persisted var profileImageURL: String?
    @Persisted var introduction: String?
    
    @Persisted(originProperty: "members") var groups: LinkingObjects<Group>
}
