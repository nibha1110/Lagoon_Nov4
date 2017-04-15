//
//  PinkMarkTable+CoreDataProperties.swift
//  Crocodile
//
//  Created by Nibha Aggarwal on 15/11/16.
//  Copyright © 2016 Nibha Aggarwal. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension PinkMarkTable {

    @NSManaged var ispink: String?
    @NSManaged var offline: String?
    @NSManaged var penid: String?

}
