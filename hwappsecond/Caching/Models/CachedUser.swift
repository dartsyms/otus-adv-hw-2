//
//  CachedUser.swift
//  hwappsecond
//

import Foundation
import RealmSwift

final class CachedUser: Object, Identifiable {
    @objc dynamic var userId: String?
    @objc dynamic var title: String?
    @objc dynamic var firstName: String?
    @objc dynamic var lastName: String?
    @objc dynamic var gender: String?
    @objc dynamic var email: String?
    @objc dynamic var location: CachedLocation?
    @objc dynamic var dateOfBirth: String?
    @objc dynamic var registerDate: String?
    @objc dynamic var phone: String?
    @objc dynamic var picture: String?

    convenience init(userId: String?, title: String?, firstName: String?, lastName: String?, gender: String?, email: String?, location: CachedLocation?, dateOfBirth: String?, registerDate: String?, phone: String?, picture: String?) {
        self.init()
        self.userId = userId
        self.title = title
        self.firstName = firstName
        self.lastName = lastName
        self.gender = gender
        self.email = email
        self.location = location
        self.dateOfBirth = dateOfBirth
        self.registerDate = registerDate
        self.phone = phone
        self.picture = picture
    }
    
    override static func primaryKey() -> String? {
        return "userId"
    }
    
    var name: String {
        get {
            return "\(firstName ?? "Unknown") \(lastName ?? "Person")"
        }
    }
}

extension CachedUser {
    static func getUser(in realm: Realm?, with id: String) -> CachedUser? {
        return realm?.objects(CachedUser.self).filter({$0.userId == id }).first
    }
    
    static func all(in realm: Realm) -> Results<CachedUser> {
        return realm.objects(CachedUser.self)
    }
}
