//
//  CustomPersistenceContainer.swift
//  hwappsecond
//

import CoreData

class CustomPersistentContainer: NSPersistentContainer {
    override open class func defaultDirectoryURL() -> URL {
        let storeURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.ru.it.kot.hwappsecond")
        return storeURL!
    }
}
