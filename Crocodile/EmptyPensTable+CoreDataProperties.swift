//
//  EmptyPensTable+CoreDataProperties.swift
//  Crocodile
//
//  Created by Nibha Aggarwal on 07/11/16.
//  Copyright © 2016 Nibha Aggarwal. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension EmptyPensTable {

    @NSManaged var groupcode: String?
    @NSManaged var grpnamedisp: String?
    @NSManaged var id: NSNumber?
    @NSManaged var namexx: String?
    @NSManaged var nameyy: String?
    @NSManaged var penid: String?
    @NSManaged var pennodisp: String?

}
