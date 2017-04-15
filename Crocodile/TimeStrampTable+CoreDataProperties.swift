//
//  TimeStrampTable+CoreDataProperties.swift
//  Crocodile
//
//  Created by Nibha Aggarwal on 9/26/16.
//  Copyright © 2016 Nibha Aggarwal. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension TimeStrampTable {

    @NSManaged var allocatedPenTym: String?
    @NSManaged var animalCountTym: String?
    @NSManaged var availableTym: String?
    @NSManaged var emptyPenTym: String?

}
