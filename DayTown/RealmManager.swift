import RealmSwift

class RealmManager {
    static var realm: Realm {
        if Thread.isMainThread {
            let config = Realm.Configuration(schemaVersion: 2)
            return try! Realm(configuration: config)
        } else {
            if let realm = Thread.current.threadDictionary["realm"] as? Realm {
                return realm
            } else {
                let realm = try! Realm()
                Thread.current.threadDictionary["realm"] = realm
                return realm
            }
        }
    }
    
    
    static func resetRealm() {
        try! realm.write {
            realm.deleteAll()
        }
    }
}
