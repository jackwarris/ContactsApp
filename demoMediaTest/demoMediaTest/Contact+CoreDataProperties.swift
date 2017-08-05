//
//  Contact+CoreDataProperties.swift
//  demoMediaTest
//
//  Created by Jack Warris on 05/08/2017.
//  Copyright © 2017 com.jackwarris. All rights reserved.
//

import Foundation
import CoreData


extension Contact {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Contact> {
        return NSFetchRequest<Contact>(entityName: "Contact")
    }

    @NSManaged public var address: String?
    @NSManaged public var avatar: NSData?
    @NSManaged public var createdAt: String?
    @NSManaged public var email: String?
    @NSManaged public var firstname: String?
    @NSManaged public var phoneNumber: String?
    @NSManaged public var surname: String?
    @NSManaged public var title: String?
    @NSManaged public var updatedAt: String?

}
