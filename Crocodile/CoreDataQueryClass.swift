//
//  CoreDataQueryClass.swift
//  Crocodile
//
//  Created by Nibha Aggarwal on 6/25/16.
//  Copyright © 2016 Nibha Aggarwal. All rights reserved.
//

import UIKit
import CoreData

protocol CoreDataProtocol: class {
//    func responseCoreDataQueryClass(objEvent :NSObject)
    func GetDataResponseCoreData(array: NSArray)
}

class CoreDataQueryClass: NSObject {
    var appDel : AppDelegate!
    var delegate:CoreDataProtocol!
    

    func getAllData(entityNameStr: String!, formatStr: String!, whereStr: String!)
    {
        var str : String!
        
       // "offline = 'NO'"
        if formatStr == nil && whereStr == nil {
            str = nil
        }
//        str = String(format: "%@ = \'%@\'",formatStr,whereStr)
        
//        str = String(format: "offline = \'NO\'")
//        str = str!.stringByReplacingOccurrencesOfString("\'", withString: "'")
        let fetchRequest = NSFetchRequest(entityName: "\(entityNameStr)")
        if str != nil {
            let predicate = NSPredicate(format: str, argumentArray: nil)
            fetchRequest.predicate = predicate
        }
        
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.fetchBatchSize = 20
        fetchRequest.resultType = NSFetchRequestResultType.DictionaryResultType
        do {
            let results = try self.appDel.managedObjectContext.executeFetchRequest(fetchRequest)
            if (results.count > 0)
            {
                self.delegate.GetDataResponseCoreData(results)
            }
            
            
            // success ...
        } catch let error as NSError {
            // failure
            print("Fetch failed: \(error.localizedDescription)")
        }
    }
    
    /*
    func UpDatefetchEvent(ID: String!, keyName: String!, entityname: String!, className: NSManagedObject) {
        
        let anyObj : NSManagedObject = className
        appDel = (UIApplication.sharedApplication().delegate as! AppDelegate)
        // Define fetch request/predicate/sort descriptors
        let fetchRequest = NSFetchRequest(entityName: (entityname))
        let predicate = NSPredicate(format: "\(keyName) == \(ID)", argumentArray: nil)
        
        fetchRequest.predicate = predicate
        
        // Handle results
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let fetchedResults = try appDel.managedObjectContext.executeFetchRequest(fetchRequest)
            if fetchedResults.count != 0 {
                for i in 0 ..< fetchedResults.count {
                    if let objTable: KillTable = fetchedResults[i] as? KillTable {
                        print("Fetched object with ID = \(ID). The title of this object is '\(objTable.offline)'")
                        objTable.offline = "YES"
                        do {
                            try self.appDel.managedObjectContext.save()
                        } catch {
                        }
                        
                        self.delegate.responseCoreDataQueryClass(objTable)
                    }
                }
            }
        }catch let error as NSError {
            // failure
            print("Fetch failed: \(error.localizedDescription)")
        }
        
        
//        return nil
    }
    */
    
}
