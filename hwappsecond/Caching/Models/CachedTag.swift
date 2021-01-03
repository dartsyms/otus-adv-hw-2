//
//  CachedTag.swift
//  hwappsecond
//

import Foundation
import RealmSwift

final class CachedTag: Object, Identifiable {
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var title: String?

    convenience init(title: String?) {
        self.init()
        self.title = title
    }
    
    override static func primaryKey() -> String? {
        return "title"
    }
}

extension CachedTag {
    static func all(in realm: Realm) -> Results<CachedTag> {
        return realm.objects(CachedTag.self)
    }
}
