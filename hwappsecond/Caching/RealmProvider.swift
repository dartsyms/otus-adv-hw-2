//
//  RealmProvider.swift
//  hwappsecond
//

import Foundation
import RealmSwift

struct RealmProvider {
    let configuration: Realm.Configuration
    
    var realm: Realm? {
        return try? Realm(configuration: configuration)
    }
    
    internal init(config: Realm.Configuration) {
        configuration = config
    }
    
    private static let readOnlyConfig = Realm.Configuration(
        fileURL: RealmProvider.cacheFileUrl(fileName: "main.realm"),
        readOnly: false,
        schemaVersion: 1
    )
    
    private static let writableConfig = Realm.Configuration(
        fileURL: RealmProvider.cacheFileUrl(fileName: "main.realm"),
        readOnly: false,
        schemaVersion: 1
    )
    
    public static var readOnly: RealmProvider = {
        return RealmProvider(config: readOnlyConfig)
    }()
    
    public static var writable: RealmProvider = {
        return RealmProvider(config: writableConfig)
    }()
    
    static func cacheFileUrl(fileName: String) -> URL? {
        guard let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        return directory.appendingPathComponent(fileName)
    }
}
