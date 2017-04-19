//
//  HelperClass.swift
//  Crocodile
//
//  Created by Nibha Aggarwal on 15/04/17.
//  Copyright © 2017 Nibha Aggarwal. All rights reserved.
//

import Foundation
import UIKit
import CoreData


class HelperClass{
    static var appDel : AppDelegate! = (UIApplication.sharedApplication().delegate as! AppDelegate)
    
    //MARK: - Update AddSectionTable
    static func UpDateTableEvent(groupcode: String!) {
        if (true) {
            let fetchRequest = NSFetchRequest(entityName: "AddSectionTable")
            let predicate = NSPredicate(format: "groupcode = '\(groupcode)'", argumentArray: nil)
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
                            
                        }
                    }
                }
            }catch let error as NSError {
                // failure
                print("Fetch failed: \(error.localizedDescription)")
            }
        }
    }
    
    //MARK: - NetworkLost
    static func NetworkLost(str: String!, view1: UIViewController)
    {
        if str == "netLost" {
            
            let alertView = UIAlertController(title: nil, message: Server.netLost, preferredStyle: .Alert)
            alertView.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
            view1.presentViewController(alertView, animated: true, completion: nil)
            
            self.appDel.remove_HUD()
            view1.view.userInteractionEnabled = true
        }
        else if (str == "noResponse")
        {
            let alertView = UIAlertController(title: nil, message: Server.ErrorMsg, preferredStyle: .Alert)
            alertView.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
            view1.presentViewController(alertView, animated: true, completion: nil)
            
            self.appDel.remove_HUD()
            view1.view.userInteractionEnabled = true
        }
    }

    
    static func MessageAletOnly(Message: String, selfView: UIViewController)
    {
        let alertView = UIAlertController(title: nil, message: Message, preferredStyle: .Alert)
        alertView.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
        selfView.presentViewController(alertView, animated: true, completion: nil)
    }
}
