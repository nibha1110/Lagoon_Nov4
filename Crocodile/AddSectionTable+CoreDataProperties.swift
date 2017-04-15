//
//  AddSectionTable+CoreDataProperties.swift
//  Crocodile
//
//  Created by Nibha Aggarwal on 6/28/16.
//  Copyright © 2016 Nibha Aggarwal. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension AddSectionTable {

    @NSManaged var id: NSNumber?
    @NSManaged var groupname: String?
    @NSManaged var groupcode: String?
    @NSManaged var available: String?
    @NSManaged var total: String?

}
