import RealmSwift

// User(RLMUser)와 다른 Custom UserModel Collection
class UserModel: Object, ObjectKeyIdentifiable {    
    @Persisted(primaryKey: true) var _id: String
    @Persisted var name: String
    @Persisted var email: String
    @Persisted var profileImageURL: String?
    @Persisted var introduction: String?
    
    // 해당 사용자가 속한 그룹 리스트
    let groups = LinkingObjects(fromType: Group.self, property: "members")  //List와 LinkingObjects는 Realm에서 자동으로 관리되는 객체로, @Persisted 명시하지 않아도 됨
}
