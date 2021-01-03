//
//  CachedLocation.swift
//  hwappsecond
//

import Foundation
import RealmSwift

final class CachedLocation: Object, Identifiable {
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var street: String?
    @objc dynamic var city: String?
    @objc dynamic var state: String?
    @objc dynamic var country: String?
    @objc dynamic var timezone: String?

    convenience init(street: String?, city: String?, state: String?, country: String?, timezone: String?) {
        self.init()
        self.street = street
        self.city = city
        self.state = state
        self.country = country
        self.timezone = timezone
    }
}
