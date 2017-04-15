//
//  ConditionTable+CoreDataProperties.swift
//  Crocodile
//
//  Created by Nibha Aggarwal on 6/29/16.
//  Copyright © 2016 Nibha Aggarwal. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension ConditionTable {

    @NSManaged var conditionid: String?
    @NSManaged var conditionname: String?
    @NSManaged var id: NSNumber?

}
