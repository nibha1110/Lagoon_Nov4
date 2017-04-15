//
//  SingleAllocatedPen+CoreDataProperties.swift
//  Crocodile
//
//  Created by Nibha Aggarwal on 7/5/16.
//  Copyright © 2016 Nibha Aggarwal. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension SingleAllocatedPen {
    
    @NSManaged var colorcode: String?
    @NSManaged var dateadded: String?
    @NSManaged var entrydate: String?
    @NSManaged var entryConvert: NSDate?
    @NSManaged var addedConvert: NSDate?
    @NSManaged var groupcode: String?
    @NSManaged var groupcodedisp: String?
    @NSManaged var namexx: String?
    @NSManaged var nameyy: String?
    @NSManaged var penid: String?
    @NSManaged var pennodisp: String?
    @NSManaged var recheckcount: String?
    @NSManaged var skin_size: String?
    @NSManaged var state: String?
    @NSManaged var int_recheckcount: NSNumber?
    @NSManaged var ispink: String?
    @NSManaged var comment: String?
}
