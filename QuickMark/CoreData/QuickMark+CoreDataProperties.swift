//
//  QuickMark+CoreDataProperties.swift
//  QuickMark
//
//  Created by Sai Charan on 10/01/25.
//
//

import Foundation
import CoreData


extension QuickMark {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<QuickMark> {
        return NSFetchRequest<QuickMark>(entityName: "Bookmark")
    }

    @NSManaged public var createdAt: Date?
    @NSManaged public var hostURL: String?
    @NSManaged public var imageURL: String?
    @NSManaged public var title: String?
    @NSManaged public var uuid: UUID?
    @NSManaged public var websiteURL: String?
    @NSManaged public var folderUUID: UUID?
    @NSManaged public var folder: NSSet?

}

// MARK: Generated accessors for folder
extension QuickMark {

    @objc(addFolderObject:)
    @NSManaged public func addToFolder(_ value: FolderData)

    @objc(removeFolderObject:)
    @NSManaged public func removeFromFolder(_ value: FolderData)

    @objc(addFolder:)
    @NSManaged public func addToFolder(_ values: NSSet)

    @objc(removeFolder:)
    @NSManaged public func removeFromFolder(_ values: NSSet)

}

extension QuickMark : Identifiable {

}
