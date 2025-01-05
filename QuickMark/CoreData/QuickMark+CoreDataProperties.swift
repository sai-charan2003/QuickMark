//
//  QuickMark+CoreDataProperties.swift
//  QuickMark
//
//  Created by Sai Charan on 25/12/24.
//
//

import Foundation
import CoreData


extension QuickMark {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<QuickMark> {
        return NSFetchRequest<QuickMark>(entityName: "Entity")
    }

    @NSManaged public var createdAt: Date?
    @NSManaged public var hostURL: String?
    @NSManaged public var imageURL: String?
    @NSManaged public var title: String?
    @NSManaged public var uuid: UUID?
    @NSManaged public var websiteURL: String?

}
