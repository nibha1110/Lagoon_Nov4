//
//  GraderTable+CoreDataProperties.swift
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

extension GraderTable {

    @NSManaged var fname: String?
    @NSManaged var id: NSNumber?
    @NSManaged var lname: String?
    @NSManaged var grader_id: String?

}
