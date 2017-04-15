//
//  SPMoveBulkTable+CoreDataProperties.swift
//  Crocodile
//
//  Created by Nibha Aggarwal on 02/02/17.
//  Copyright © 2017 Nibha Aggarwal. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension SPMoveBulkTable {

    @NSManaged var from_namexx: String?
    @NSManaged var from_nameyy: String?
    @NSManaged var fromGroup: String?
    @NSManaged var to_namexx: String?
    @NSManaged var to_nameyy: String?
    @NSManaged var toGroup: String?

}
