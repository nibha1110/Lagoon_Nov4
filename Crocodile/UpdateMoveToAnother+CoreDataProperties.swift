//
//  UpdateMoveToAnother+CoreDataProperties.swift
//  Crocodile
//
//  Created by Nibha Aggarwal on 16/12/16.
//  Copyright © 2016 Nibha Aggarwal. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension UpdateMoveToAnother {

    @NSManaged var from_penid: String?
    @NSManaged var from_xx: String?
    @NSManaged var from_yy: String?
    @NSManaged var to_penid: String?
    @NSManaged var to_xx: String?
    @NSManaged var to_yy: String?

}
