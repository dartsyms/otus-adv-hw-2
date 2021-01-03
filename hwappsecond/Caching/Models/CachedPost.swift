//
//  CachedPost.swift
//  hwappsecond
//

import Foundation
import RealmSwift

final class CachedPost: Object, Identifiable {
    @objc dynamic var postId: String?
    @objc dynamic var text: String?
    @objc dynamic var image: String?
    @objc dynamic var likes = 0.0
    @objc dynamic var link: String?
    @objc dynamic var publishDate: String?
    @objc dynamic var owner: CachedUser?
    
    let tags = List<CachedTag>()

    convenience init(postId: String?, text: String?, image: String?, likes: Double?, link: String?, tags: [CachedTag], publishDate: String?, owner: CachedUser?) {
        self.init()
        self.postId = postId
        self.text = text
        self.image = image
        self.link = link
        self.likes = likes ?? 0.0
        self.publishDate = publishDate
        self.owner = owner
        
        append(tags)
    }
    
    override static func primaryKey() -> String? {
        return "postId"
    }
    
    func append(_ newTags: [CachedTag]) {
        
        let updateTags = {
            self.tags.append(objectsIn: newTags)
        }
        
        if let realm = realm, !realm.isInWriteTransaction {
            do {
                try realm.write(updateTags)
            } catch {
                print("Error in realm write")
            }
        } else {
            updateTags()
        }
    }
    
}

extension CachedPost {
    static func getPost(in realm: Realm?, with id: String) -> CachedPost? {
        return realm?.objects(CachedPost.self).filter({$0.postId == id }).first
    }
    
    static func all(in realm: Realm) -> Results<CachedPost> {
        return realm.objects(CachedPost.self)
    }
}
