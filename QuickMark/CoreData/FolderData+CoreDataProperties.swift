//
//  FolderData+CoreDataProperties.swift
//  QuickMark
//
//  Created by Sai Charan on 10/01/25.
//
//

import Foundation
import CoreData


extension FolderData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FolderData> {
        return NSFetchRequest<FolderData>(entityName: "FolderData")
    }

    @NSManaged public var folderName: String?
    @NSManaged public var folderId: Int64
    @NSManaged public var uuid: UUID?
    @NSManaged public var createdAt: Date?
    @NSManaged public var bookmark: QuickMark?

}

extension FolderData : Identifiable {

}
