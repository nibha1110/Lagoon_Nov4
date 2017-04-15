//
//  Move_animal+CoreDataProperties.swift
//  Crocodile
//
//  Created by Nibha Aggarwal on 7/6/16.
//  Copyright © 2016 Nibha Aggarwal. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Move_animal {

    @NSManaged var id: NSNumber?
    @NSManaged var from_namexx: String?
    @NSManaged var from_nameyy: String?
    @NSManaged var to_namexx: String?
    @NSManaged var to_nameyy: String?
    @NSManaged var no_animals: String?
    @NSManaged var moved_on: String?
    @NSManaged var moved_by: String?
    @NSManaged var offline: String?
    @NSManaged var from_groupname: String?
    @NSManaged var to_groupname: String?

}
