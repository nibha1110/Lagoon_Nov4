//
//  HelperClass.swift
//  Crocodile
//
//  Created by Nibha Aggarwal on 15/04/17.
//  Copyright © 2017 Nibha Aggarwal. All rights reserved.
//

import Foundation

class HelperClass{
    
    
    static func UpDateTableEvent(groupcode: String!) -> AddSectionTable? {
        
        if (true) {
            let fetchRequest = NSFetchRequest(entityName: "AddSectionTable")
            let predicate = NSPredicate(format: "groupcode = '\(toPass_array[8] as! String)'", argumentArray: nil)
            fetchRequest.predicate = predicate
            fetchRequest.returnsObjectsAsFaults = false
            fetchRequest.fetchBatchSize = 20
            do {
                let fetchedResults = try appDel.managedObjectContext.executeFetchRequest(fetchRequest)
                if fetchedResults.count != 0 {
                    for i in 0 ..< fetchedResults.count {
                        if let objTable: AddSectionTable = fetchedResults[i] as? AddSectionTable {
                            var intvaa : Int = Int(objTable.available! as String)!
                            intvaa = intvaa - 1
                            objTable.available = String(intvaa)
                            do {
                                try self.appDel.managedObjectContext.save()
                            } catch {
                            }
                            return objTable
                        }
                    }
                }
            }catch let error as NSError {
                // failure
                print("Fetch failed: \(error.localizedDescription)")
            }
        }
        
        
        return nil
    }
}
