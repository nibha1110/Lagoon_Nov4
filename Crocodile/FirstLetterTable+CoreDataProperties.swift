//
//  FirstLetterTable+CoreDataProperties.swift
//  Crocodile
//
//  Created by Nibha Aggarwal on 14/01/17.
//  Copyright © 2017 Nibha Aggarwal. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension FirstLetterTable {

    @NSManaged var first_letter: String?
    @NSManaged var group_code: String?

}
