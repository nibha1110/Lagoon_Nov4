//
//  DataOffline.swift
//  Crocodile
//
//  Created by Nibha Aggarwal on 9/3/16.
//  Copyright © 2016 Nibha Aggarwal. All rights reserved.
//

import UIKit
import CoreData

protocol dataOfflineProtocol {
    func responsedataOffline(Str: String)
}

class DataOffline: NSObject , responseProtocol{
    var objwebservice : webservice! = webservice()
    var str_webservice: NSString!
    var str_webPacket: String! = ""
    var appDel : AppDelegate! = (UIApplication.sharedApplication().delegate as! AppDelegate)
    var arrayKill: [AnyObject] = []
    var arraySinglePen: [AnyObject] = []
    var arrayEmptyMove: [AnyObject] = []
    var arrayMoveHatchling: [AnyObject] = []
    var arrayMoveAddAnimal: [AnyObject] = []
    var arrayMoveSection: [AnyObject] = []
    var arraySingleSection: [AnyObject] = []
    var arrayGroupSection: [AnyObject] = []
    var arrayGroupKillSection: [AnyObject] = []
    var arrayAddToKillSection: [AnyObject] = []
    var arrayRecheck: [AnyObject] = []
    var arrayRevert: [AnyObject] = []
    var arrayPink: [AnyObject] = []
    var arraySkinSize: [AnyObject] = []
    var arrayUpdateMove: [AnyObject] = []
    
    var arrayForPacket: NSMutableArray! = []
    var dictForPacket: NSMutableDictionary! = NSMutableDictionary()
    let dateFormatter: NSDateFormatter = NSDateFormatter()
    var killIndex: Int!
    
    var delegate: dataOfflineProtocol!
    
    override init() {
        super.init()
        objwebservice.delegate = self
    }
    
    
    func  backgroundDeletethread()
    {
        if self.str_webPacket == ""
        {
            methodKillTable_d()
        }
//        methodKillTable()
        else
        
        {
            self.appDel.remove_HUD()
        }
    }
    
    
    //MARK: - BackGroung Methods
    func methodKillTable()
    {
//        var myQueue = dispatch_queue_create("My Queue", nil)
//        dispatch_async(myQueue, {() -> Void in
//            // Perform long running process
//            dispatch_async(dispatch_get_main_queue(), {() -> Void in
//                // Update the UI
//            })
//        })

        
        let fetchRequest = NSFetchRequest(entityName: "KillTable")
        let predicate = NSPredicate(format: "offline = 'YES' AND killedFrom = 'Kill'", argumentArray: nil)
        fetchRequest.predicate = predicate
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.fetchBatchSize = 20
        fetchRequest.resultType = NSFetchRequestResultType.DictionaryResultType
        do {
            let results = try appDel.managedObjectContext.executeFetchRequest(fetchRequest)
            if results.count > 0 {
                
                arrayKill = results
                print(results)
                self.appDel.managedObjectContext.persistentStoreCoordinator!.performBlock {
                    autoreleasepool {
                        dispatch_async(dispatch_get_main_queue()) {
                            self.appDel.Show_HUD()
                        }
                        for i in 0 ..< self.arrayKill.count
                        {
                            self.killIndex = i
                            self.GetKillList(self.arrayKill[i]["killid"] as! String)
                        }
                        self.methodAddingSinglePenTable()
                    }
                }
            }
            else
            {
                self.methodAddingSinglePenTable()
            }
            
        } catch {
            // Do something in response to error condition
        }
    }
    
    func  methodAddingSinglePenTable()
    {
        let fetchRequest1 = NSFetchRequest(entityName: "AddingSinglePenTable")
        let predicate1 = NSPredicate(format: "offline = 'YES'", argumentArray: nil)
        fetchRequest1.predicate = predicate1
        fetchRequest1.returnsObjectsAsFaults = false
        fetchRequest1.fetchBatchSize = 20
        fetchRequest1.resultType = NSFetchRequestResultType.DictionaryResultType
        do {
            let results = try self.appDel.managedObjectContext.executeFetchRequest(fetchRequest1)
            if results.count > 0 {
                arraySinglePen = results
                self.appDel.managedObjectContext.persistentStoreCoordinator!.performBlock {
                    autoreleasepool {
                        
                        for i in 0 ..< self.arraySinglePen.count
                        {
                                //////////
                                self.killIndex = i
                                self.AddingToSinglePenService(self.arraySinglePen[i])
                                
                        }
                        self.methodEmptyMove()
                        
                    }
                    
                }
            }
            else
            {
                self.methodEmptyMove()
            }
            
        } catch {
            // Do something in response to error condition
        }
    }
    
    func  methodEmptyMove()
    {
        let fetchRequest2 = NSFetchRequest(entityName: "AnimalgroupEmpty")
        fetchRequest2.returnsObjectsAsFaults = false
        fetchRequest2.fetchBatchSize = 20
        fetchRequest2.resultType = NSFetchRequestResultType.DictionaryResultType
        do {
            let results = try self.appDel.managedObjectContext.executeFetchRequest(fetchRequest2)
            if results.count > 0 {
                arrayEmptyMove = results
                self.appDel.managedObjectContext.persistentStoreCoordinator!.performBlock {
                    autoreleasepool {
                        for i in 0 ..< self.arrayEmptyMove.count
                        {
                            self.killIndex = i
                            self.MovePenToEmptyService(self.arrayEmptyMove[i])
                        }
                        self.methodMoveAddAnimal()
                    }
                }
                
                
            }
            else
            {
                self.methodMoveAddAnimal()
            }
            
        } catch {
            // Do something in response to error condition
        }
    }
    
    func  methodMoveAddAnimal()
    {
        let fetchRequest2 = NSFetchRequest(entityName: "MoveAddAnimal")
        fetchRequest2.returnsObjectsAsFaults = false
        fetchRequest2.fetchBatchSize = 20
        fetchRequest2.resultType = NSFetchRequestResultType.DictionaryResultType
        do {
            let results = try self.appDel.managedObjectContext.executeFetchRequest(fetchRequest2)
            if results.count > 0 {
                arrayMoveAddAnimal = results
                self.appDel.managedObjectContext.persistentStoreCoordinator!.performBlock {
                    autoreleasepool {
                        for i in 0 ..< self.arrayMoveAddAnimal.count
                        {
                            self.killIndex = i
                            self.MoveAddAnimaltoPen(self.arrayMoveAddAnimal[i])
                        }
                        self.methodMoveHatchling()
                    }
                    
                }
                
                
            }
            else
            {
                self.methodMoveHatchling()
            }
            
        } catch {
            // Do something in response to error condition
        }
    }
    
    
    func  methodMoveHatchling()
    {
        let fetchRequest2 = NSFetchRequest(entityName: "MoveHatchlings")
        fetchRequest2.returnsObjectsAsFaults = false
        fetchRequest2.fetchBatchSize = 20
        fetchRequest2.resultType = NSFetchRequestResultType.DictionaryResultType
        do {
            let results = try self.appDel.managedObjectContext.executeFetchRequest(fetchRequest2)
            if results.count > 0 {
                arrayMoveHatchling = results
                self.appDel.managedObjectContext.persistentStoreCoordinator!.performBlock {
                    autoreleasepool {
                        for i in 0 ..< self.arrayMoveHatchling.count
                        {
                            self.killIndex = i
                            self.MoveFromIncubatorToPenService(self.arrayMoveHatchling[i])
                        }
                        self.methodMoveSection()
                    }
                }
                
                
            }
            else
            {
                self.methodMoveSection()
            }
            
        } catch {
            // Do something in response to error condition
        }
    }
    
    func  methodMoveSection()
    {
        let fetchRequest3 = NSFetchRequest(entityName: "Move_animal")
        let predicate3 = NSPredicate(format: "offline = 'YES'", argumentArray: nil)
        fetchRequest3.predicate = predicate3
        fetchRequest3.returnsObjectsAsFaults = false
        fetchRequest3.fetchBatchSize = 20
        fetchRequest3.resultType = NSFetchRequestResultType.DictionaryResultType
        do {
            let results = try self.appDel.managedObjectContext.executeFetchRequest(fetchRequest3)
            if results.count > 0 {
                arrayMoveSection = results
                self.appDel.managedObjectContext.persistentStoreCoordinator!.performBlock {
                    autoreleasepool {
                        for i in 0 ..< self.arrayMoveSection.count
                        {
                            self.killIndex = i
                            self.MovePenService(self.arrayMoveSection[i])
                        }
                        self.methodSingleAddToDie()
                        
                    }
                }
                
                
            }
            else
            {
                self.methodSingleAddToDie()
            }
            
        } catch {
            // Do something in response to error condition
        }
    }
    
    func methodSingleAddToDie()
    {
        let fetchRequest4 = NSFetchRequest(entityName: "SingleAddToDie")
        fetchRequest4.returnsObjectsAsFaults = false
        fetchRequest4.fetchBatchSize = 20
        fetchRequest4.resultType = NSFetchRequestResultType.DictionaryResultType
        do {
            let results = try self.appDel.managedObjectContext.executeFetchRequest(fetchRequest4)
            if results.count > 0 {
                arraySingleSection = results
                self.appDel.managedObjectContext.persistentStoreCoordinator!.performBlock {
                    autoreleasepool {
                        for i in 0 ..< self.arraySingleSection.count
                        {
                            self.killIndex = i
                            self.SingleDieService(self.arraySingleSection[i])
                        }
                        self.methodGpToDie()
                    }
                }
                
                
            }
            else
            {
                self.methodGpToDie()
            }
            
        } catch {
            // Do something in response to error condition
        }
        
    }
    
    func  methodGpToDie()
    {
        let fetchRequest5 = NSFetchRequest(entityName: "Animalgroupdie")
        fetchRequest5.returnsObjectsAsFaults = false
        fetchRequest5.fetchBatchSize = 20
        fetchRequest5.resultType = NSFetchRequestResultType.DictionaryResultType
        do {
            let results = try self.appDel.managedObjectContext.executeFetchRequest(fetchRequest5)
            if results.count > 0 {
                arrayGroupSection = results
                self.appDel.managedObjectContext.persistentStoreCoordinator!.performBlock {
                    autoreleasepool {
                        for i in 0 ..< self.arrayGroupSection.count
                        {
                            self.killIndex = i
                            self.GroupDieService(self.arrayGroupSection[i])
                        }
                        self.methodGpToKill()
                    }
                }
                
                
            }
            else
            {
                self.methodGpToKill()
            }
            
        } catch {
            // Do something in response to error condition
        }
    }
    
    func  methodGpToKill()
    {
        let fetchRequest5 = NSFetchRequest(entityName: "Animalgroupkill")
        fetchRequest5.returnsObjectsAsFaults = false
        fetchRequest5.fetchBatchSize = 20
        fetchRequest5.resultType = NSFetchRequestResultType.DictionaryResultType
        do {
            let results = try self.appDel.managedObjectContext.executeFetchRequest(fetchRequest5)
            if results.count > 0 {
                arrayGroupKillSection = results
                self.appDel.managedObjectContext.persistentStoreCoordinator!.performBlock {
                    autoreleasepool {
                        for i in 0 ..< self.arrayGroupKillSection.count
                        {
                            self.killIndex = i
                            self.GroupKillService(self.arrayGroupKillSection[i])
                        }
                         self.methodAddToKill()
                    }
                }
                
                
                
            }
            else
            {
                self.methodAddToKill()
            }
            
        } catch {
            // Do something in response to error condition
        }
    }
    
    func  methodAddToKill()
    {
        let fetchRequest = NSFetchRequest(entityName: "KillTable")
        let predicate = NSPredicate(format: "offline = 'YES' AND killedFrom = 'Inspection'", argumentArray: nil)
        fetchRequest.predicate = predicate
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.fetchBatchSize = 20
        fetchRequest.resultType = NSFetchRequestResultType.DictionaryResultType
        do {
            let results = try appDel.managedObjectContext.executeFetchRequest(fetchRequest)
            if results.count > 0 {
                
                arrayAddToKillSection = results
                self.appDel.managedObjectContext.persistentStoreCoordinator!.performBlock {
                    autoreleasepool {
                        for i in 0 ..< self.arrayAddToKillSection.count
                        {
                            self.killIndex = i
                            self.AddToKillListService(self.arrayAddToKillSection[i])
                        }
                        self.methodRecheckCount()
                    }
                }
            }
            else
            {
                self.methodRecheckCount()
            }
            
        } catch {
            // Do something in response to error condition
        }
    }
    
    func methodRecheckCount()
    {
        let fetchRequest = NSFetchRequest(entityName: "RecheckTable")
        let predicate = NSPredicate(format: "offline = 'YES'", argumentArray: nil)
        fetchRequest.predicate = predicate
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.fetchBatchSize = 20
        fetchRequest.resultType = NSFetchRequestResultType.DictionaryResultType
        do {
            let results = try appDel.managedObjectContext.executeFetchRequest(fetchRequest)
            if results.count > 0 {
                
                arrayRecheck = results
                self.appDel.managedObjectContext.persistentStoreCoordinator!.performBlock {
                    autoreleasepool {
                        for i in 0 ..< self.arrayRecheck.count
                        {
                            self.killIndex = i
                            self.RecheckService(self.arrayRecheck[i] as AnyObject)
                        }
                        self.methodRevertkill()
                    }
                }
            }
            else
            {
                self.methodRevertkill()
            }
            
        } catch {
            // Do something in response to error condition
        }
    }
    
    func methodRevertkill()
    {
        let fetchRequest = NSFetchRequest(entityName: "KillRevertTable")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.fetchBatchSize = 20
        fetchRequest.resultType = NSFetchRequestResultType.DictionaryResultType
        do {
            let results = try appDel.managedObjectContext.executeFetchRequest(fetchRequest)
            if results.count > 0 {
                
                arrayRevert = results
                self.appDel.managedObjectContext.persistentStoreCoordinator!.performBlock {
                    autoreleasepool {
                        for i in 0 ..< self.arrayRevert.count
                        {
                            self.killIndex = i
                            self.RevertService(self.arrayRevert[i] as AnyObject)
                        }
                        self.methodPinkMark()
                    }
                }
            }
            else
            {
                self.methodPinkMark()
            }
            
        } catch {
            // Do something in response to error condition
        }
    }
    
    func methodPinkMark()
    {
        let fetchRequest = NSFetchRequest(entityName: "PinkMarkTable")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.fetchBatchSize = 20
        fetchRequest.resultType = NSFetchRequestResultType.DictionaryResultType
        do {
            let results = try appDel.managedObjectContext.executeFetchRequest(fetchRequest)
            if results.count > 0 {
                
                arrayPink = results
                self.appDel.managedObjectContext.persistentStoreCoordinator!.performBlock {
                    autoreleasepool {
                        for i in 0 ..< self.arrayPink.count
                        {
                            self.killIndex = i
                            self.PinkMarkService(self.arrayPink[i] as AnyObject)
                        }
                        self.methodSkinSizeCount()
                    }
                }
            }
            else
            {
                self.methodSkinSizeCount()
            }
            
        } catch {
            // Do something in response to error condition
        }
    }
    
    
    func methodSkinSizeCount()
    {
        let fetchRequest = NSFetchRequest(entityName: "SkinSizeTable")
        let predicate = NSPredicate(format: "offline = 'YES'", argumentArray: nil)
        fetchRequest.predicate = predicate
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.fetchBatchSize = 20
        fetchRequest.resultType = NSFetchRequestResultType.DictionaryResultType
        do {
            let results = try appDel.managedObjectContext.executeFetchRequest(fetchRequest)
            if results.count > 0 {
                
                arraySkinSize = results
                self.appDel.managedObjectContext.persistentStoreCoordinator!.performBlock {
                    autoreleasepool {
                        for i in 0 ..< self.arraySkinSize.count
                        {
                            self.killIndex = i
                            self.SkinSizeService(self.arraySkinSize[i] as AnyObject)
                        }
                        if NSUserDefaults.standardUserDefaults().objectForKey("str_HomeScreen") as! String == "" {
                            self.AllDataWebservice()
                            let userDefaults = NSUserDefaults.standardUserDefaults()
                            userDefaults.setValue("Filled", forKey: "str_HomeScreen")
                        }
                        else
                        {
                            self.appDel.remove_HUD()
                        }
                    }
                }
            }
            else
            {
                if NSUserDefaults.standardUserDefaults().objectForKey("str_HomeScreen") as! String == "" {
                    self.AllDataWebservice()
                    let userDefaults = NSUserDefaults.standardUserDefaults()
                    userDefaults.setValue("Filled", forKey: "str_HomeScreen")
                }
                else
                {
                    self.appDel.remove_HUD()
                }
            }
            
        } catch {
            // Do something in response to error condition
        }
        
    }
    
    //MARK: - GetKillList
    func  GetKillList(killid: String!)
    {
        if self.appDel.checkInternetConnection() {
            
            self.str_webservice = "confirmkill"
            let request = NSMutableURLRequest(URL: NSURL(string: "\(Server.local_server)/api/kill_list/confirmkill.php?")!)
            let postString = "killid=\(killid)&app_id=\(NSUserDefaults.standardUserDefaults().objectForKey("ApplicationIdentifier") as! String)"
            objwebservice.callServiceCommon(request, postString: postString)
            
            
            let predicate = NSPredicate(format: "killid == %@", (self.arrayKill[self.killIndex]["killid"] as! NSString))
            let fetchRequest = NSFetchRequest(entityName: "KillTable")
            fetchRequest.predicate = predicate
            
            do {
                let fetchedEntities = try self.appDel.managedObjectContext.executeFetchRequest(fetchRequest) as! [KillTable]
                for managedObject in fetchedEntities
                {
                    let managedObjectData:NSManagedObject = managedObject as NSManagedObject
                    self.appDel.managedObjectContext.deleteObject(managedObjectData)
                }
                do
                {
                    try self.appDel.managedObjectContext.save()
//                    if self.killIndex == self.arrayKill.count
//                    {
//                        self.methodAddingSinglePenTable()
//                    }
                }
                catch{}
            } catch {}
        }
        
    }

    
    func  AddingToSinglePenService(toPass_array: AnyObject)
    {
        if self.appDel.checkInternetConnection() {
            
            print(toPass_array)
            str_webservice = "sp_add";
            let request = NSMutableURLRequest(URL: NSURL(string: "\(Server.local_server)/api/singlepen/sp_add.php?")!)
            let postString = "penid=\(toPass_array["penid"] as! String)&graderid=\(toPass_array["graderid"] as! String)&condition=\(toPass_array["condition"] as! String)&inspectionperiod=\(toPass_array["inspectionperiod"] as! String)&movedgrp=\(toPass_array["movedgrp"] as! String)&movednamexx=\(toPass_array["movednamexx"] as! String)&movednameyy=\(toPass_array["movednameyy"] as! String)&comment=\(toPass_array["comment"] as! String)&animalsize=\(toPass_array["skinsize"] as! String)&app_id=\(NSUserDefaults.standardUserDefaults().objectForKey("ApplicationIdentifier") as! String)"
            objwebservice.callServiceCommon(request, postString: postString)
            
            let predicate = NSPredicate(format: "penid == %@", (self.arraySinglePen[self.killIndex]["penid"] as! NSString))
            let fetchRequest = NSFetchRequest(entityName: "AddingSinglePenTable")
            fetchRequest.predicate = predicate
            
            do {
                let fetchedEntities = try self.appDel.managedObjectContext.executeFetchRequest(fetchRequest) as! [AddingSinglePenTable]
                for managedObject in fetchedEntities
                {
                    let managedObjectData:NSManagedObject = managedObject as NSManagedObject
                    self.appDel.managedObjectContext.deleteObject(managedObjectData)
                }
                do
                {
                    try self.appDel.managedObjectContext.save()
                }
                catch{}
            } catch {}
        }
        
    }
    
    
    func  MovePenToEmptyService(toPass_array: AnyObject)
    {
        if self.appDel.checkInternetConnection() {
            print(toPass_array)
            str_webservice = "empty_move_sub"
            
            let request = NSMutableURLRequest(URL: NSURL(string: "\(Server.local_server)/api/animals/empty_move_sub.php?")!)
            let postString = "fromnamexx=\(toPass_array["namexx"] as! String)&group=\(toPass_array["groupname"] as! String)&fromnameyy=\(toPass_array["nameyy"] as! String)&movedby=\(toPass_array["userid"] as! String)&app_id=\(NSUserDefaults.standardUserDefaults().objectForKey("ApplicationIdentifier") as! String)"
            objwebservice.callServiceCommon(request, postString: postString)

            
            
            let fetch = NSFetchRequest(entityName: "AnimalgroupEmpty")
            let predicate1 = NSPredicate(format: "namexx = '\(toPass_array["namexx"] as! String)' and nameyy = '\(toPass_array["nameyy"] as! String)' and groupname = '\(toPass_array["groupname"] as! String)'")
            fetch.predicate = predicate1
            
            do {
                let fetchedEntities = try self.appDel.managedObjectContext.executeFetchRequest(fetch) as! [AnimalgroupEmpty]
                for managedObject in fetchedEntities
                {
                    let managedObjectData:NSManagedObject = managedObject as NSManagedObject
                    self.appDel.managedObjectContext.deleteObject(managedObjectData)
                }
                do
                {
                    try self.appDel.managedObjectContext.save()
                }
                catch{}
            } catch {}
        }
    }
    
        
    
    
    
    func  MoveAddAnimaltoPen(toPass_array: AnyObject)
    {
        if self.appDel.checkInternetConnection() {
            print(toPass_array)
            str_webservice = "empty_move_add"
            let request = NSMutableURLRequest(URL: NSURL(string: "\(Server.local_server)/api/animals/empty_move_add.php?")!)
            let postString = "noofanimals=\(toPass_array["totalanimal"] as! String)&group=\(toPass_array["groupname"] as! String)&tonamexx=\(toPass_array["namexx"] as! String)&tonameyy=\(toPass_array["nameyy"] as! String)&movedby=\(toPass_array["moved_by"] as! String)&app_id=\(NSUserDefaults.standardUserDefaults().objectForKey("ApplicationIdentifier") as! String)"
            objwebservice.callServiceCommon(request, postString: postString)
            
            print("andar aaya \(request)\(postString)")
            
            let fetch = NSFetchRequest(entityName: "MoveAddAnimal")
            let predicate1 = NSPredicate(format: "namexx = '\(toPass_array["namexx"] as! String)' and nameyy = '\(toPass_array["nameyy"] as! String)' and groupname = '\(toPass_array["groupname"] as! String)'")
            fetch.predicate = predicate1
            
            do {
                let fetchedEntities = try self.appDel.managedObjectContext.executeFetchRequest(fetch) as! [MoveAddAnimal]
                for managedObject in fetchedEntities
                {
                    let managedObjectData:NSManagedObject = managedObject as NSManagedObject
                    self.appDel.managedObjectContext.deleteObject(managedObjectData)
                }
                do
                {
                    try self.appDel.managedObjectContext.save()
                }
                catch{}
            } catch {}
        }
    }
    
    func  MoveFromIncubatorToPenService(toPass_array: AnyObject)
    {
        if self.appDel.checkInternetConnection() {
            print(toPass_array)
            str_webservice = "move_hatchlings"
            let request = NSMutableURLRequest(URL: NSURL(string: "\(Server.local_server)/api/incubator/move_hatchlings.php?")!)
            let postString = "noofanimals=\(toPass_array["totalanimal"] as! String)&group=\(toPass_array["groupname"] as! String)&namexx=\(toPass_array["namexx"] as! String)&nameyy=\(toPass_array["nameyy"] as! String)&movedby=\(toPass_array["moved_by"] as! String)&app_id=\(NSUserDefaults.standardUserDefaults().objectForKey("ApplicationIdentifier") as! String)"
            objwebservice.callServiceCommon(request, postString: postString)
            
            
            
            let fetch = NSFetchRequest(entityName: "MoveHatchlings")
            let predicate1 = NSPredicate(format: "namexx = '\(toPass_array["namexx"] as! String)' and nameyy = '\(toPass_array["nameyy"] as! String)' and groupname = '\(toPass_array["groupname"] as! String)'")
            fetch.predicate = predicate1
            
            do {
                let fetchedEntities = try self.appDel.managedObjectContext.executeFetchRequest(fetch) as! [MoveHatchlings]
                for managedObject in fetchedEntities
                {
                    let managedObjectData:NSManagedObject = managedObject as NSManagedObject
                    self.appDel.managedObjectContext.deleteObject(managedObjectData)
                }
                do
                {
                    try self.appDel.managedObjectContext.save()
                    
                }
                catch{}
            } catch {}
            
            
            
            
            
            
        }
    }
    
    func  MovePenService(toPass_array: AnyObject)
    {
        if self.appDel.checkInternetConnection() {
            print(toPass_array)
            str_webservice = "move_animals";
            let request = NSMutableURLRequest(URL: NSURL(string: "\(Server.local_server)/api/animals/move_animals.php?")!)
            let postString = "noofanimals=\(toPass_array["no_animals"] as! String)&from_group=\(toPass_array["from_groupname"] as! String)&fromnamexx=\(toPass_array["from_namexx"] as! String)&fromnameyy=\(toPass_array["from_nameyy"] as! String)&to_group=\(toPass_array["to_groupname"] as! String)&tonamexx=\(toPass_array["to_namexx"] as! String)&tonameyy=\(toPass_array["to_nameyy"] as! String)&movedby=\(toPass_array["moved_by"] as! String)&app_id=\(NSUserDefaults.standardUserDefaults().objectForKey("ApplicationIdentifier") as! String)"
            objwebservice.callServiceCommon(request, postString: postString)
            
            
            let fetchRequest = NSFetchRequest(entityName: "Move_animal")
            let predicate = NSPredicate(format: "id = '\(self.arrayMoveSection[self.killIndex]["id"] as! NSNumber)'")
            fetchRequest.predicate = predicate
            
            do {
                let fetchedEntities = try self.appDel.managedObjectContext.executeFetchRequest(fetchRequest) as! [Move_animal]
                for managedObject in fetchedEntities
                {
                    let managedObjectData:NSManagedObject = managedObject as NSManagedObject
                    self.appDel.managedObjectContext.deleteObject(managedObjectData)
                }
                do
                {
                    try self.appDel.managedObjectContext.save()
                }
                catch{}
            } catch {}
        }
        
    }
    
    
    func  SingleDieService(toPass_array: AnyObject)
    {
        if self.appDel.checkInternetConnection() {
            print(toPass_array)
            str_webservice = "die_animals";
            let request = NSMutableURLRequest(URL: NSURL(string: "\(Server.local_server)/api/animals/die_animals.php?")!)
            let postString = "pen_type=Single&noofanimals=1&groupcode=\(toPass_array["group"] as! String)&namexx=\(toPass_array["namexx"] as! String)&nameyy=\(toPass_array["nameyy"] as! String)&dateadded=\(toPass_array["date"] as! String)&movedby=\(toPass_array["userid"] as! String)&app_id=\(NSUserDefaults.standardUserDefaults().objectForKey("ApplicationIdentifier") as! String)"
            objwebservice.callServiceCommon(request, postString: postString)
            
            let fetchRequest = NSFetchRequest(entityName: "SingleAddToDie")
            let predicate = NSPredicate(format: "namexx = '\(self.arraySingleSection[self.killIndex]["namexx"] as! String)' AND nameyy = '\(self.arraySingleSection[self.killIndex]["nameyy"] as! String)'")
            fetchRequest.predicate = predicate
            do {
                let fetchedEntities = try self.appDel.managedObjectContext.executeFetchRequest(fetchRequest) as! [SingleAddToDie]
                for managedObject in fetchedEntities
                {
                    let managedObjectData:NSManagedObject = managedObject as NSManagedObject
                    self.appDel.managedObjectContext.deleteObject(managedObjectData)
                }
                do
                {
                    try self.appDel.managedObjectContext.save()
                }
                catch{}
            } catch {}
        }
        
    }
    
    
    func  GroupDieService(toPass_array: AnyObject)
    {
        if self.appDel.checkInternetConnection() {
            print(toPass_array)
            str_webservice = "Group_die_animals";
            let request = NSMutableURLRequest(URL: NSURL(string: "\(Server.local_server)/api/animals/die_animals.php?")!)
            let postString = "pen_type=Grouped&noofanimals=\(toPass_array["totalanimal"] as! String)&groupcode=\(toPass_array["groupname"] as! String)&namexx=\(toPass_array["namexx"] as! String)&nameyy=\(toPass_array["nameyy"] as! String)&dateadded=\(toPass_array["date"] as! String)&movedby=\(toPass_array["userid"] as! String)&app_id=\(NSUserDefaults.standardUserDefaults().objectForKey("ApplicationIdentifier") as! String)"
            objwebservice.callServiceCommon(request, postString: postString)
            
            let fetchRequest = NSFetchRequest(entityName: "Animalgroupdie")
            let predicate = NSPredicate(format: "namexx = '\(self.arrayGroupSection[self.killIndex]["namexx"] as! String)' AND nameyy = '\(self.arrayGroupSection[self.killIndex]["nameyy"] as! String)' AND groupname = '\(self.arrayGroupSection[self.killIndex]["groupname"] as! String)'")
            fetchRequest.predicate = predicate
            do{
                let fetchedEntities = try self.appDel.managedObjectContext.executeFetchRequest(fetchRequest) as! [Animalgroupdie]
                for managedObject in fetchedEntities
                {
                    let managedObjectData:NSManagedObject = managedObject as NSManagedObject
                    self.appDel.managedObjectContext.deleteObject(managedObjectData)
                }
                do
                {
                    try self.appDel.managedObjectContext.save()
                }
                catch{}
            }
            catch {
                
            }
        }
        
    }
    
    func  GroupKillService(toPass_array: AnyObject)
    {
        if self.appDel.checkInternetConnection() {
            
            print(toPass_array)
            str_webservice = "Group_Kill_animals";
            let request = NSMutableURLRequest(URL: NSURL(string: "\(Server.local_server)/api/animals/kill_animals_group.php?")!)
            let postString = "noofanimals=\(toPass_array["totalanimal"] as! String)&group=\(toPass_array["groupname"] as! String)&namexx=\(toPass_array["namexx"] as! String)&nameyy=\(toPass_array["nameyy"] as! String)&movedby=\(toPass_array["userid"] as! String)&dateadded=\(toPass_array["date"] as! String)&app_id=\(NSUserDefaults.standardUserDefaults().objectForKey("ApplicationIdentifier") as! String)"
            objwebservice.callServiceCommon(request, postString: postString)
            
            let fetchRequest = NSFetchRequest(entityName: "Animalgroupkill")
            let predicate = NSPredicate(format: "namexx = '\(self.arrayGroupKillSection[self.killIndex]["namexx"] as! String)' AND nameyy = '\(self.arrayGroupKillSection[self.killIndex]["nameyy"] as! String)' AND groupname = '\(self.arrayGroupKillSection[self.killIndex]["groupname"] as! String)'")
            fetchRequest.predicate = predicate
            do {
                let fetchedEntities = try self.appDel.managedObjectContext.executeFetchRequest(fetchRequest) as! [Animalgroupkill]
                for managedObject in fetchedEntities
                {
                    let managedObjectData:NSManagedObject = managedObject as NSManagedObject
                    self.appDel.managedObjectContext.deleteObject(managedObjectData)
                }
                do
                {
                    try self.appDel.managedObjectContext.save()
                }
                catch{}
            } catch {
                
            }
        }
    }
    
    
    func  AddToKillListService(toPass_array: AnyObject)
    {
        if self.appDel.checkInternetConnection() {
            
            print(toPass_array)
            str_webservice = "movetokill_list";
            let request = NSMutableURLRequest(URL: NSURL(string: "\(Server.local_server)/api/sp_inspection/movetokill_list.php?")!)
            let postString = "penid=\(toPass_array["killid"] as! String)&addedby=\(NSUserDefaults.standardUserDefaults().objectForKey("email_username") as! String)&app_id=\(NSUserDefaults.standardUserDefaults().objectForKey("ApplicationIdentifier") as! String)"
            objwebservice.callServiceCommon(request, postString: postString)
            
            
            let predicate = NSPredicate(format: "killid == %@", (self.arrayAddToKillSection[self.killIndex]["killid"] as! NSString))
            let fetchRequest = NSFetchRequest(entityName: "KillTable")
            fetchRequest.predicate = predicate
            fetchRequest.returnsObjectsAsFaults = false
            fetchRequest.fetchBatchSize = 20
            do {
                let fetchedResults = try self.appDel.managedObjectContext.executeFetchRequest(fetchRequest)
                if fetchedResults.count != 0 {
                    for i in 0 ..< fetchedResults.count {
                        if let objTable: KillTable = fetchedResults[i] as? KillTable {
                            objTable.offline = "NO"
                            objTable.killedFrom = "Kill"
                            do {
                                try self.appDel.managedObjectContext.save()
                            } catch {
                            }
                        }
                    }
                }
            } catch {
                // Do something in response to error condition
            }
        }
    }
    
    
    func RecheckService(toPass_array: AnyObject)
    {
        if self.appDel.checkInternetConnection() {
            print(toPass_array)
            str_webservice = "updaterecheck"
            let request = NSMutableURLRequest(URL: NSURL(string: "\(Server.local_server)/api/sp_update/updaterecheck.php?")!)
            let postString = "penid=\(toPass_array["penid"] as! String)&recheck=\(toPass_array["recheck"] as! String)&app_id=\(NSUserDefaults.standardUserDefaults().objectForKey("ApplicationIdentifier") as! String)"
            objwebservice.callServiceCommon(request, postString: postString)

            let predicate = NSPredicate(format: "penid == %@", (self.arrayRecheck[self.killIndex]["penid"] as! NSString))
            let fetchRequest = NSFetchRequest(entityName: "RecheckTable")
            fetchRequest.predicate = predicate
            fetchRequest.returnsObjectsAsFaults = false
            fetchRequest.fetchBatchSize = 20
            do {
                let fetchedEntities = try self.appDel.managedObjectContext.executeFetchRequest(fetchRequest) as! [RecheckTable]
                for managedObject in fetchedEntities
                {
                    let managedObjectData:NSManagedObject = managedObject as NSManagedObject
                    self.appDel.managedObjectContext.deleteObject(managedObjectData)
                }
                do
                {
                    try self.appDel.managedObjectContext.save()
//                    if self.killIndex == self.arrayRecheck.count
//                    {
//                        self.methodSkinSizeCount()
//                    }
                }
                catch{}
            } catch {
                // Do something in response to error condition
            }
        }
    }
    
    
    func RevertService(toPass_array: AnyObject)
    {
        if self.appDel.checkInternetConnection() {
            print("revert")
            print(toPass_array)
            
            
            self.str_webservice = "revert"
            let request = NSMutableURLRequest(URL: NSURL(string: "\(Server.local_server)/api/kill_list/revertkill.php?")!)
            let postString = "killid=\(toPass_array["killid"] as! String)&app_id=\(NSUserDefaults.standardUserDefaults().objectForKey("ApplicationIdentifier") as! String)"
            objwebservice.callServiceCommon(request, postString: postString)
            
            
            let predicate = NSPredicate(format: "killid == %@", (toPass_array["killid"] as! String))
            let fetchRequest = NSFetchRequest(entityName: "KillRevertTable")
            fetchRequest.predicate = predicate
            fetchRequest.returnsObjectsAsFaults = false
            fetchRequest.fetchBatchSize = 20
            do {
                let fetchedEntities = try self.appDel.managedObjectContext.executeFetchRequest(fetchRequest) as! [KillRevertTable]
                for managedObject in fetchedEntities
                {
                    let managedObjectData:NSManagedObject = managedObject as NSManagedObject
                    self.appDel.managedObjectContext.deleteObject(managedObjectData)
                }
                do
                {
                    try self.appDel.managedObjectContext.save()
                }
                catch{}
            } catch {
                // Do something in response to error condition
            }
        }
    }
    
    func PinkMarkService(toPass_array: AnyObject)
    {
        if self.appDel.checkInternetConnection() {
            print(toPass_array)
            
            str_webservice = "updatepinkvalue"
            let request = NSMutableURLRequest(URL: NSURL(string: "\(Server.local_server)/api/sp_update/updatepinkvalue.php?")!)
            let postString = "penid=\(toPass_array["penid"] as! String)&markvalue=\(toPass_array["ispink"] as! String)&app_id=\(NSUserDefaults.standardUserDefaults().objectForKey("ApplicationIdentifier") as! String)"
            objwebservice.callServiceCommon(request, postString: postString)
            
            
            let predicate = NSPredicate(format: "penid == %@", (toPass_array["penid"] as! String))
            let fetchRequest = NSFetchRequest(entityName: "PinkMarkTable")
            fetchRequest.predicate = predicate
            fetchRequest.returnsObjectsAsFaults = false
            fetchRequest.fetchBatchSize = 20
            do {
                let fetchedEntities = try self.appDel.managedObjectContext.executeFetchRequest(fetchRequest) as! [PinkMarkTable]
                for managedObject in fetchedEntities
                {
                    let managedObjectData:NSManagedObject = managedObject as NSManagedObject
                    self.appDel.managedObjectContext.deleteObject(managedObjectData)
                }
                do
                {
                    try self.appDel.managedObjectContext.save()
                }
                catch{}
            } catch {
                // Do something in response to error condition
            }
        }
    }

    func SkinSizeService(toPass_array: AnyObject)
    {
        if self.appDel.checkInternetConnection() {
            print(toPass_array)
            str_webservice = "updatedataskin"
            let request = NSMutableURLRequest(URL: NSURL(string: "\(Server.local_server)/api/sp_update/updatedataskin.php?")!)
            let postString = "penid=\(toPass_array["penid"] as! String)&skinsize=\(toPass_array["skinsize"] as! String)&app_id=\(NSUserDefaults.standardUserDefaults().objectForKey("ApplicationIdentifier") as! String)"
            objwebservice.callServiceCommon(request, postString: postString)
            
            let predicate = NSPredicate(format: "penid == %@", (self.arraySkinSize[self.killIndex]["penid"] as! NSString))
            let fetchRequest = NSFetchRequest(entityName: "SkinSizeTable")
            fetchRequest.predicate = predicate
            fetchRequest.returnsObjectsAsFaults = false
            fetchRequest.fetchBatchSize = 20
            do {
                let fetchedEntities = try self.appDel.managedObjectContext.executeFetchRequest(fetchRequest) as! [SkinSizeTable]
                for managedObject in fetchedEntities
                {
                    let managedObjectData:NSManagedObject = managedObject as NSManagedObject
                    self.appDel.managedObjectContext.deleteObject(managedObjectData)
                }
                do
                {
                    try self.appDel.managedObjectContext.save()
                }
                catch{}
            } catch {}
        }
    }
 
    
    //MARK: - ALL DATA Home Screen
    func AllDataWebservice()
    {
        if self.appDel.checkInternetConnection() {
            
            str_webservice = "alldata"
            let request = NSMutableURLRequest(URL: NSURL(string: "\(Server.local_server)/api/singlepen/alldata.php?")!)
            var postString = ""
           
                if NSUserDefaults.standardUserDefaults().objectForKey("AllData") != nil
                {
                    if NSUserDefaults.standardUserDefaults().objectForKey("AllData") as! String == "AllDataSaved"
                    {
                        let fetchRequest = NSFetchRequest(entityName: "TimeStrampTable")
                        fetchRequest.returnsObjectsAsFaults = false
                        fetchRequest.fetchBatchSize = 20
                        fetchRequest.resultType = NSFetchRequestResultType.DictionaryResultType
                        do {
                            let results = try self.appDel.managedObjectContext.executeFetchRequest(fetchRequest)
                            if (results.count > 0)
                            {
                                print(results)
                                for i in 0 ..< results.count {
                                    
                                    if let val = results[i]["allocatedPenTym"] {
                                        if let x = val {
                                            print(x)
                                            postString = "last_animalcount=\(results[0]["animalCountTym"] as! String)&last_allocated=\(results[0]["allocatedPenTym"] as! String)&last_allgrp=\(results[0]["emptyPenTym"] as! String)&app_id=\(NSUserDefaults.standardUserDefaults().objectForKey("ApplicationIdentifier") as! String)"
                                            objwebservice.callServiceCommon_Delta(request, postString: postString)
                                        } else {
                                            print("value is nil")
                                            postString = "last_animalcount=\(results[0]["animalCountTym"] as! String)&last_allgrp=\(results[0]["emptyPenTym"] as! String)&app_id=\(NSUserDefaults.standardUserDefaults().objectForKey("ApplicationIdentifier") as! String)"
                                            objwebservice.callServiceCommon_Delta(request, postString: postString)
                                        }
                                    } else {
                                        print("key is not present in dict")
                                        postString = "last_animalcount=\(results[0]["animalCountTym"] as! String)&last_allgrp=\(results[0]["emptyPenTym"] as! String)&app_id=\(NSUserDefaults.standardUserDefaults().objectForKey("ApplicationIdentifier") as! String)"
                                        objwebservice.callServiceCommon_Delta(request, postString: postString)
                                    }
                                }
                                //crashed here
//                                postString = "last_animalcount=\(results[0]["animalCountTym"] as! String)&last_allocated=\(results[0]["allocatedPenTym"] as! String)&last_allgrp=\(results[0]["emptyPenTym"] as! String)&app_id=\(NSUserDefaults.standardUserDefaults().objectForKey("ApplicationIdentifier") as! String)"
//                                print("\(request)\(postString)")
//                                objwebservice.callServiceCommon_Delta(request, postString: postString)
                                
                            }
                        } catch{}
                    }
                }
            
            else if NSUserDefaults.standardUserDefaults().objectForKey("AllData") == nil
            {
                objwebservice.callServiceCommon_Delta(request, postString: postString)
            }
            
            else
            {
                self.appDel.remove_HUD()
            }
            
        }
    }
    
    
    // MARK: - Webservice NetLost delegate
    func NetworkLost(str: String!)
    {
        if str == "netLost" {
            
            
            self.appDel.remove_HUD()
            
        }
        else if (str == "noResponse")
        {
            
            self.appDel.remove_HUD()
        }
    }
    
    
    //MARK:- Webservice delegate
    func  responseDictionary(dic: NSMutableDictionary) {
        print(dic)
        if self.str_webservice .isEqualToString("confirmkill") {
            
        }
            //ADDING SINGLE PENS
        else if self.str_webservice == "sp_add" {
        }
            // MOVE TO EMPTY
        else if self.str_webservice == "empty_move_sub" {}
            //MOVE HTCHLINGS
        else if (self.str_webservice == "move_hatchlings")
        {
        }
            //move_animals
        else if (self.str_webservice == "move_animals")
        {
        }
            //die_animals
        else if (self.str_webservice == "die_animals")
        {
            
        }
        else if (self.str_webservice == "Group_die_animals")
        {
            
        }
        else if (self.str_webservice == "Group_Kill_animals")
        {
        }
        else if (self.str_webservice == "movetokill_list")
        {
        }
            
        else if (self.str_webservice == "updaterecheck")
        {
        }
        else if (self.str_webPacket == "Inserted")
        {
            autoreleasepool{
                if arrayKill.count > 0
                {
                    for i in 0 ..< self.arrayKill.count
                    {
                        let predicate = NSPredicate(format: "killid == %@", (self.arrayKill[i]["killid"] as! NSString))
                        let fetchRequest = NSFetchRequest(entityName: "KillTable")
                        fetchRequest.predicate = predicate
                        
                        do {
                            let fetchedEntities = try self.appDel.managedObjectContext.executeFetchRequest(fetchRequest) as! [KillTable]
                            for managedObject in fetchedEntities
                            {
                                let managedObjectData:NSManagedObject = managedObject as NSManagedObject
                                self.appDel.managedObjectContext.deleteObject(managedObjectData)
                            }
                            do
                            {
                                try self.appDel.managedObjectContext.save()
                            }
                            catch{}
                        } catch {}
                        
                    }
                    
                }
                ///
                if arraySinglePen.count > 0
                {
                    let fetchRequest = NSFetchRequest(entityName: "AddingSinglePenTable")
                    // delete records
                    let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                    
                    do {
                        try self.appDel.persistentStoreCoordinator.executeRequest(deleteRequest, withContext: self.appDel.managedObjectContext)
                        do
                        {
                            try self.appDel.managedObjectContext.save()
                        }
                        catch{}
                    } catch{}
//                    for i in 0 ..< self.arraySinglePen.count
//                    {
//                        let predicate = NSPredicate(format: "penid == %@", (self.arraySinglePen[i]["penid"] as! NSString))
//                        let fetchRequest = NSFetchRequest(entityName: "AddingSinglePenTable")
//                        fetchRequest.predicate = predicate
//                        
//                        do {
//                            let fetchedEntities = try self.appDel.managedObjectContext.executeFetchRequest(fetchRequest) as! [AddingSinglePenTable]
//                            for managedObject in fetchedEntities
//                            {
//                                let managedObjectData:NSManagedObject = managedObject as NSManagedObject
//                                self.appDel.managedObjectContext.deleteObject(managedObjectData)
//                            }
//                            do
//                            {
//                                try self.appDel.managedObjectContext.save()
//                            }
//                            catch{}
//                        } catch {}
//                    }
                }
                //
                if arrayEmptyMove.count > 0
                {
                    let fetchRequest = NSFetchRequest(entityName: "AnimalgroupEmpty")
                    // delete records
                    let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                    
                    do {
                        try self.appDel.persistentStoreCoordinator.executeRequest(deleteRequest, withContext: self.appDel.managedObjectContext)
                        do
                        {
                            try self.appDel.managedObjectContext.save()
                        }
                        catch{}
                    } catch{}
//                    for i in 0 ..< self.arrayEmptyMove.count
//                    {
//                        let fetch = NSFetchRequest(entityName: "AnimalgroupEmpty")
//                        let predicate1 = NSPredicate(format: "namexx = '\(self.arrayEmptyMove[i]["namexx"] as! String)' and nameyy = '\(self.arrayEmptyMove[i]["nameyy"] as! String)' and groupname = '\(self.arrayEmptyMove[i]["groupname"] as! String)'")
//                        fetch.predicate = predicate1
//                        
//                        do {
//                            let fetchedEntities = try self.appDel.managedObjectContext.executeFetchRequest(fetch) as! [AnimalgroupEmpty]
//                            for managedObject in fetchedEntities
//                            {
//                                let managedObjectData:NSManagedObject = managedObject as NSManagedObject
//                                self.appDel.managedObjectContext.deleteObject(managedObjectData)
//                            }
//                            do
//                            {
//                                try self.appDel.managedObjectContext.save()
//                            }
//                            catch{}
//                        } catch {}
//                    }
                }
                //--------
                if arrayMoveHatchling.count > 0
                {
                    let fetchRequest = NSFetchRequest(entityName: "MoveHatchlings")
                    // delete records
                    let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                    
                    do {
                        try self.appDel.persistentStoreCoordinator.executeRequest(deleteRequest, withContext: self.appDel.managedObjectContext)
                        do
                        {
                            try self.appDel.managedObjectContext.save()
                        }
                        catch{}
                    } catch{}
//                    for i in 0 ..< self.arrayMoveHatchling.count
//                    {
//                        let fetch = NSFetchRequest(entityName: "MoveHatchlings")
//                        let predicate1 = NSPredicate(format: "namexx = '\(self.arrayMoveHatchling[i]["namexx"] as! String)' and nameyy = '\(self.arrayMoveHatchling[i]["nameyy"] as! String)' and groupname = '\(self.arrayMoveHatchling[i]["groupname"] as! String)'")
//                        fetch.predicate = predicate1
//                        
//                        do {
//                            let fetchedEntities = try self.appDel.managedObjectContext.executeFetchRequest(fetch) as! [MoveHatchlings]
//                            for managedObject in fetchedEntities
//                            {
//                                let managedObjectData:NSManagedObject = managedObject as NSManagedObject
//                                self.appDel.managedObjectContext.deleteObject(managedObjectData)
//                            }
//                            do
//                            {
//                                try self.appDel.managedObjectContext.save()
//                                
//                            }
//                            catch{}
//                        } catch {}
//                    }
                }
                //--------
                if arrayMoveAddAnimal.count > 0
                {
                    let fetchRequest = NSFetchRequest(entityName: "MoveAddAnimal")
                    // delete records
                    let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                    
                    do {
                        try self.appDel.persistentStoreCoordinator.executeRequest(deleteRequest, withContext: self.appDel.managedObjectContext)
                        do
                        {
                            try self.appDel.managedObjectContext.save()
                        }
                        catch{}
                    } catch{}
//                    for i in 0 ..< self.arrayMoveAddAnimal.count
//                    {
//                        let fetch = NSFetchRequest(entityName: "MoveAddAnimal")
//                        let predicate1 = NSPredicate(format: "namexx = '\(self.arrayMoveAddAnimal[i]["namexx"] as! String)' and nameyy = '\(self.arrayMoveAddAnimal[i]["nameyy"] as! String)' and groupname = '\(self.arrayMoveAddAnimal[i]["groupname"] as! String)'")
//                        fetch.predicate = predicate1
//                        
//                        do {
//                            let fetchedEntities = try self.appDel.managedObjectContext.executeFetchRequest(fetch) as! [MoveAddAnimal]
//                            for managedObject in fetchedEntities
//                            {
//                                let managedObjectData:NSManagedObject = managedObject as NSManagedObject
//                                self.appDel.managedObjectContext.deleteObject(managedObjectData)
//                            }
//                            do
//                            {
//                                try self.appDel.managedObjectContext.save()
//                            }
//                            catch{}
//                        } catch {}
//                    }
                }
                //--------
                if arrayMoveSection.count > 0
                {
                    let fetchRequest = NSFetchRequest(entityName: "Move_animal")
                    // delete records
                    let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                    
                    do {
                        try self.appDel.persistentStoreCoordinator.executeRequest(deleteRequest, withContext: self.appDel.managedObjectContext)
                        do
                        {
                            try self.appDel.managedObjectContext.save()
                        }
                        catch{}
                    } catch{}

//                    for i in 0 ..< self.arrayMoveSection.count
//                    {
//                        let fetchRequest = NSFetchRequest(entityName: "Move_animal")
//                        let predicate = NSPredicate(format: "id = '\(self.arrayMoveSection[i]["id"] as! NSNumber)'")
//                        fetchRequest.predicate = predicate
//                        
//                        do {
//                            let fetchedEntities = try self.appDel.managedObjectContext.executeFetchRequest(fetchRequest) as! [Move_animal]
//                            for managedObject in fetchedEntities
//                            {
//                                let managedObjectData:NSManagedObject = managedObject as NSManagedObject
//                                self.appDel.managedObjectContext.deleteObject(managedObjectData)
//                            }
//                            do
//                            {
//                                try self.appDel.managedObjectContext.save()
//                            }
//                            catch{}
//                        } catch {}
//
//                    }
                }
                //--------
                if arraySingleSection.count > 0
                {
                    let fetchRequest = NSFetchRequest(entityName: "SingleAddToDie")
                    // delete records
                    let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                    
                    do {
                        try self.appDel.persistentStoreCoordinator.executeRequest(deleteRequest, withContext: self.appDel.managedObjectContext)
                        do
                        {
                            try self.appDel.managedObjectContext.save()
                        }
                        catch{}
                    } catch{}
//                    for i in 0 ..< self.arraySingleSection.count
//                    {
//                        let fetchRequest = NSFetchRequest(entityName: "SingleAddToDie")
//                        let predicate = NSPredicate(format: "namexx = '\(self.arraySingleSection[i]["namexx"] as! String)' AND nameyy = '\(self.arraySingleSection[i]["nameyy"] as! String)'")
//                        fetchRequest.predicate = predicate
//                        do {
//                            let fetchedEntities = try self.appDel.managedObjectContext.executeFetchRequest(fetchRequest) as! [SingleAddToDie]
//                            for managedObject in fetchedEntities
//                            {
//                                let managedObjectData:NSManagedObject = managedObject as NSManagedObject
//                                self.appDel.managedObjectContext.deleteObject(managedObjectData)
//                            }
//                            do
//                            {
//                                try self.appDel.managedObjectContext.save()
//                            }
//                            catch{}
//                        } catch {}
//                    }
                }
                //--------
                if arrayGroupSection.count > 0
                {
                    let fetchRequest = NSFetchRequest(entityName: "Animalgroupdie")
                    // delete records
                    let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                    
                    do {
                        try self.appDel.persistentStoreCoordinator.executeRequest(deleteRequest, withContext: self.appDel.managedObjectContext)
                        do
                        {
                            try self.appDel.managedObjectContext.save()
                        }
                        catch{}
                    } catch{}
//                    for i in 0 ..< self.arrayGroupSection.count
//                    {
//                        let fetchRequest = NSFetchRequest(entityName: "Animalgroupdie")
//                        let predicate = NSPredicate(format: "namexx = '\(self.arrayGroupSection[i]["namexx"] as! String)' AND nameyy = '\(self.arrayGroupSection[i]["nameyy"] as! String)' AND groupname = '\(self.arrayGroupSection[i]["groupname"] as! String)'")
//                        fetchRequest.predicate = predicate
//                        do{
//                            let fetchedEntities = try self.appDel.managedObjectContext.executeFetchRequest(fetchRequest) as! [Animalgroupdie]
//                            for managedObject in fetchedEntities
//                            {
//                                let managedObjectData:NSManagedObject = managedObject as NSManagedObject
//                                self.appDel.managedObjectContext.deleteObject(managedObjectData)
//                            }
//                            do
//                            {
//                                try self.appDel.managedObjectContext.save()
//                            }
//                            catch{}
//                        }
//                        catch {
//                            
//                        }
//                    }
                }
                //--------
                if arrayGroupKillSection.count > 0
                {
                    let fetchRequest = NSFetchRequest(entityName: "Animalgroupkill")
                    // delete records
                    let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                    
                    do {
                        try self.appDel.persistentStoreCoordinator.executeRequest(deleteRequest, withContext: self.appDel.managedObjectContext)
                        do
                        {
                            try self.appDel.managedObjectContext.save()
                        }
                        catch{}
                    } catch{}
                    
//                    for i in 0 ..< self.arrayGroupKillSection.count
//                    {
//                        let fetchRequest = NSFetchRequest(entityName: "Animalgroupkill")
//                        let predicate = NSPredicate(format: "namexx = '\(self.arrayGroupKillSection[i]["namexx"] as! String)' AND nameyy = '\(self.arrayGroupKillSection[i]["nameyy"] as! String)' AND groupname = '\(self.arrayGroupKillSection[i]["groupname"] as! String)'")
//                        fetchRequest.predicate = predicate
//                        do {
//                            let fetchedEntities = try self.appDel.managedObjectContext.executeFetchRequest(fetchRequest) as! [Animalgroupkill]
//                            for managedObject in fetchedEntities
//                            {
//                                let managedObjectData:NSManagedObject = managedObject as NSManagedObject
//                                self.appDel.managedObjectContext.deleteObject(managedObjectData)
//                            }
//                            do
//                            {
//                                try self.appDel.managedObjectContext.save()
//                            }
//                            catch{}
//                        } catch {
//                            
//                        }
//                    }
                }
                //--------
                if arrayAddToKillSection.count > 0
                {
                    for i in 0 ..< self.arrayAddToKillSection.count
                    {
                        let predicate = NSPredicate(format: "killid == %@", (self.arrayAddToKillSection[i]["killid"] as! NSString))
                        let fetchRequest = NSFetchRequest(entityName: "KillTable")
                        fetchRequest.predicate = predicate
                        fetchRequest.returnsObjectsAsFaults = false
                        fetchRequest.fetchBatchSize = 20
                        do {
                            let fetchedResults = try self.appDel.managedObjectContext.executeFetchRequest(fetchRequest)
                            if fetchedResults.count != 0 {
                                for i in 0 ..< fetchedResults.count {
                                    if let objTable: KillTable = fetchedResults[i] as? KillTable {
                                        objTable.offline = "NO"
                                        objTable.killedFrom = "Kill"
                                        do {
                                            try self.appDel.managedObjectContext.save()
                                        } catch {
                                        }
                                    }
                                }
                            }
                        } catch {
                            // Do something in response to error condition
                        }
                    }
                }
                //--------
                if arrayRecheck.count > 0
                {
                    let fetchRequest = NSFetchRequest(entityName: "RecheckTable")
                    // delete records
                    let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                    
                    do {
                        try self.appDel.persistentStoreCoordinator.executeRequest(deleteRequest, withContext: self.appDel.managedObjectContext)
                        do
                        {
                            try self.appDel.managedObjectContext.save()
                        }
                        catch{}
                    } catch{}
//                    for i in 0 ..< self.arrayRecheck.count
//                    {
//                        let predicate = NSPredicate(format: "penid == %@", (self.arrayRecheck[i]["penid"] as! NSString))
//                        let fetchRequest = NSFetchRequest(entityName: "RecheckTable")
//                        fetchRequest.predicate = predicate
//                        fetchRequest.returnsObjectsAsFaults = false
//                        fetchRequest.fetchBatchSize = 20
//                        do {
//                            let fetchedEntities = try self.appDel.managedObjectContext.executeFetchRequest(fetchRequest) as! [RecheckTable]
//                            for managedObject in fetchedEntities
//                            {
//                                let managedObjectData:NSManagedObject = managedObject as NSManagedObject
//                                self.appDel.managedObjectContext.deleteObject(managedObjectData)
//                            }
//                            do
//                            {
//                                try self.appDel.managedObjectContext.save()
//                            }
//                            catch{}
//                        } catch {}
//                    }
                }
                //--------
                if arrayRevert.count > 0
                {
                    let fetchRequest = NSFetchRequest(entityName: "KillRevertTable")
                    // delete records
                    let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                    
                    do {
                        try self.appDel.persistentStoreCoordinator.executeRequest(deleteRequest, withContext: self.appDel.managedObjectContext)
                        do
                        {
                            try self.appDel.managedObjectContext.save()
                        }
                        catch{}
                    } catch{}
//                    for i in 0 ..< self.arrayRevert.count
//                    {
//                        let predicate = NSPredicate(format: "killid == %@", (self.arrayRevert[i]["killid"] as! String))
//                        let fetchRequest = NSFetchRequest(entityName: "KillRevertTable")
//                        fetchRequest.predicate = predicate
//                        fetchRequest.returnsObjectsAsFaults = false
//                        fetchRequest.fetchBatchSize = 20
//                        do {
//                            let fetchedEntities = try self.appDel.managedObjectContext.executeFetchRequest(fetchRequest) as! [KillRevertTable]
//                            for managedObject in fetchedEntities
//                            {
//                                let managedObjectData:NSManagedObject = managedObject as NSManagedObject
//                                self.appDel.managedObjectContext.deleteObject(managedObjectData)
//                            }
//                            do
//                            {
//                                try self.appDel.managedObjectContext.save()
//                            }
//                            catch{}
//                        } catch {
//                            // Do something in response to error condition
//                        }
//                    }
                }
                //--------
                if arrayPink.count > 0
                {
                    let fetchRequest = NSFetchRequest(entityName: "PinkMarkTable")
                    // delete records
                    let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                    
                    do {
                        try self.appDel.persistentStoreCoordinator.executeRequest(deleteRequest, withContext: self.appDel.managedObjectContext)
                        do
                        {
                            try self.appDel.managedObjectContext.save()
                        }
                        catch{}
                    } catch{}
//                    for i in 0 ..< self.arrayPink.count
//                    {
//                        let predicate = NSPredicate(format: "penid == %@", (self.arrayPink[i]["penid"] as! String))
//                        let fetchRequest = NSFetchRequest(entityName: "PinkMarkTable")
//                        fetchRequest.predicate = predicate
//                        fetchRequest.returnsObjectsAsFaults = false
//                        fetchRequest.fetchBatchSize = 20
//                        do {
//                            let fetchedEntities = try self.appDel.managedObjectContext.executeFetchRequest(fetchRequest) as! [PinkMarkTable]
//                            for managedObject in fetchedEntities
//                            {
//                                let managedObjectData:NSManagedObject = managedObject as NSManagedObject
//                                self.appDel.managedObjectContext.deleteObject(managedObjectData)
//                            }
//                            do
//                            {
//                                try self.appDel.managedObjectContext.save()
//                            }
//                            catch{}
//                        } catch {
//                            // Do something in response to error condition
//                        }
//                    }
                    
                }
                //--------
                if arraySkinSize.count > 0
                {
                    let fetchRequest = NSFetchRequest(entityName: "SkinSizeTable")
                    // delete records
                    let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                    
                    do {
                        try self.appDel.persistentStoreCoordinator.executeRequest(deleteRequest, withContext: self.appDel.managedObjectContext)
                        do
                        {
                            try self.appDel.managedObjectContext.save()
                        }
                        catch{}
                    } catch{}

//                    for i in 0 ..< self.arraySkinSize.count
//                    {
//                        let predicate = NSPredicate(format: "penid == %@", (self.arraySkinSize[i]["penid"] as! NSString))
//                        let fetchRequest = NSFetchRequest(entityName: "SkinSizeTable")
//                        fetchRequest.predicate = predicate
//                        fetchRequest.returnsObjectsAsFaults = false
//                        fetchRequest.fetchBatchSize = 20
//                        do {
//                            let fetchedEntities = try self.appDel.managedObjectContext.executeFetchRequest(fetchRequest) as! [SkinSizeTable]
//                            for managedObject in fetchedEntities
//                            {
//                                let managedObjectData:NSManagedObject = managedObject as NSManagedObject
//                                self.appDel.managedObjectContext.deleteObject(managedObjectData)
//                            }
//                            do
//                            {
//                                try self.appDel.managedObjectContext.save()
//                            }
//                            catch{}
//                        } catch {}
//                    }
                }
                
                //--------
                if arrayUpdateMove.count > 0
                {
                    let fetchRequest = NSFetchRequest(entityName: "UpdateMoveToAnother")
                    // delete records
                    let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                    
                    do {
                        try self.appDel.persistentStoreCoordinator.executeRequest(deleteRequest, withContext: self.appDel.managedObjectContext)
                        do
                        {
                            try self.appDel.managedObjectContext.save()
                        }
                        catch{}
                    } catch{}
                }
            }
        }
        
        self.appDel.remove_HUD()
        
        if let currentDelegate = self.delegate {
            self.delegate.responsedataOffline("Complete")
        }
        
    }
    
    
    func responseDictionaryDelta(dic: NSMutableDictionary) {
        if (str_webservice == "alldata")
        {
            if NSUserDefaults.standardUserDefaults().objectForKey("AllData") != nil
            {
                if NSUserDefaults.standardUserDefaults().objectForKey("AllData") as! String == "AllDataSaved"
                {
                    
                    var arrayAllData : NSMutableArray! = []
                    arrayAllData = dic["all_details"] as! NSMutableArray
                    print(arrayAllData)
                    //Update Table
                    
                
                    
                    let fetchRequest1 = NSFetchRequest(entityName: "TimeStrampTable")
                    fetchRequest1.returnsObjectsAsFaults = false
                    do
                    {
                        let results = try self.appDel.managedObjectContext.executeFetchRequest(fetchRequest1)
                        if results.count > 0 {
                            if let objTable: TimeStrampTable = results[0] as? TimeStrampTable {
                                objTable.availableTym = arrayAllData[0]["last_update"] as? String
                                objTable.animalCountTym = arrayAllData[1]["lastupdate"] as? String
                                objTable.allocatedPenTym = arrayAllData[4]["last_update"] as? String
                                objTable.emptyPenTym = arrayAllData[5]["last_update"] as? String
                                print(objTable.allocatedPenTym)
                                do
                                {
                                    try self.appDel.managedObjectContext.save()
                                    self.appDel.remove_HUD()
                                }
                                catch{}
                            }
                        }
                    }
                    catch {}
                    
                    
                    //First delete AddSectionTable
                    let fetchRequest = NSFetchRequest(entityName: "AddSectionTable")
                    fetchRequest.returnsObjectsAsFaults = false
                    let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                    do {
                        try self.appDel.persistentStoreCoordinator.executeRequest(deleteRequest, withContext: self.appDel.managedObjectContext)
                        do
                        {
                            try self.appDel.managedObjectContext.save()
                            print("inside")
                            
                        }
                        catch{}
                    } catch{}
                    
                    
                    
                    autoreleasepool
                        {
                        //Insert Into Table AddSectionTable
                        for i in 0 ..< (arrayAllData[0]["AllGroups"]!!.count){
                            var objAddSectionTable: AddSectionTable!
                            
                            objAddSectionTable = (NSEntityDescription.insertNewObjectForEntityForName("AddSectionTable", inManagedObjectContext: self.appDel.managedObjectContext) as! AddSectionTable)
                            objAddSectionTable.id = i
                            objAddSectionTable.groupcode = arrayAllData[0]["AllGroups"]!![i]["groupcode"] as? String
                            objAddSectionTable.groupname = arrayAllData[0]["AllGroups"]!![i]["groupname"] as? String
                            objAddSectionTable.available = arrayAllData[0]["AllGroups"]!![i]["available"] as? String
                            objAddSectionTable.total = arrayAllData[0]["AllGroups"]!![i]["total"] as? String
                            do {
                                try self.appDel.managedObjectContext.save()
                            } catch {}
                            
                        }
                    }
                    
                    
                    
                    autoreleasepool{
                        //Delete Which are in the AnimalsCountTable
                        for j in 0 ..< arrayAllData[1]["Animals_count_Data"]!!.count {
                            let fetchRequest = NSFetchRequest(entityName: "AnimalsCountTable")
                            let predicate = NSPredicate(format: "count_namexx == %@ AND count_nameyy == %@ AND groupname == %@", arrayAllData[1]["Animals_count_Data"]!![j]["namexx"] as! String, arrayAllData[1]["Animals_count_Data"]!![j]["nameyy"] as! String, arrayAllData[1]["Animals_count_Data"]!![j]["groupname"] as! String)
                            fetchRequest.predicate = predicate
                            fetchRequest.returnsObjectsAsFaults = false
                            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                            
                            do {
                                try self.appDel.persistentStoreCoordinator.executeRequest(deleteRequest, withContext: self.appDel.managedObjectContext)
                                do
                                {
                                    try self.appDel.managedObjectContext.save()
                                    print("inside")
                                    
                                }
                                catch{}
                            } catch{}
                        }
                    }

                    
                    //Insert which are not in the AnimalsCountTable
                    autoreleasepool
                    {
                        var objCoreTable: AnimalsCountTable!
                        for i in 0 ..< (arrayAllData[1]["Animals_count_Data"]!!.count)!{
                            objCoreTable = (NSEntityDescription.insertNewObjectForEntityForName("AnimalsCountTable", inManagedObjectContext: self.appDel.managedObjectContext) as! AnimalsCountTable)
                            objCoreTable.count_id = i
                            objCoreTable.count_namexx = arrayAllData[1]["Animals_count_Data"]!![i]["namexx"] as? String
                            objCoreTable.count_nameyy = arrayAllData[1]["Animals_count_Data"]!![i]["nameyy"] as? String
                            objCoreTable.groupname = arrayAllData[1]["Animals_count_Data"]!![i]["groupname"] as? String
                            objCoreTable.movedby = NSUserDefaults.standardUserDefaults().objectForKey("email_username") as? String
                            objCoreTable.total_animals = arrayAllData[1]["Animals_count_Data"]!![i]["total_animals"] as? String
                            objCoreTable.total_animals = objCoreTable.total_animals!
                            print(objCoreTable.total_animals)
                            objCoreTable.offline = "NO"
                        }
                        do {
                            try self.appDel.managedObjectContext.save()
                        } catch {
                        }
                        
                    }
                    
                    
                    
                    //Delete All GraderTable
                    if true {
                        let fetchRequest = NSFetchRequest(entityName: "GraderTable")
                        fetchRequest.returnsObjectsAsFaults = false
                        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                        do {
                            
                            try self.appDel.persistentStoreCoordinator.executeRequest(deleteRequest, withContext: self.appDel.managedObjectContext)
                            do
                            {
                                try self.appDel.managedObjectContext.save()
                                print("inside")
                                
                            }
                            catch{}
                        } catch{}
                    }
                    
                    //                        }
                    
                    
                    //Insert Into GraderTable
                    autoreleasepool {
                        var objCoreTable: GraderTable!
                        for i in 0 ..< (arrayAllData[2]["general_details"]!![2]["grader_data"]!!.count)!{
                            objCoreTable = (NSEntityDescription.insertNewObjectForEntityForName("GraderTable", inManagedObjectContext: self.appDel.managedObjectContext) as! GraderTable)
                            objCoreTable.id = i
                            objCoreTable.grader_id = arrayAllData[2]["general_details"]!![2]["grader_data"]!![i]["grader_id"] as? String
                            objCoreTable.fname = arrayAllData[2]["general_details"]!![2]["grader_data"]!![i]["fname"] as? String
                            objCoreTable.lname = arrayAllData[2]["general_details"]!![2]["grader_data"]!![i]["lname"] as? String
                            do {
                                try self.appDel.managedObjectContext.save()
                            } catch {}
                            
                        }
                    }
                    
                    //Delete Kill Table
                    autoreleasepool {
                        let fetchRequest = NSFetchRequest(entityName: "KillTable")
                        fetchRequest.returnsObjectsAsFaults = false
                        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                        do {
                            try self.appDel.persistentStoreCoordinator.executeRequest(deleteRequest, withContext: self.appDel.managedObjectContext)
                            do
                            {
                                try self.appDel.managedObjectContext.save()
                                print("inside")
                            }
                            catch{}
                        } catch{}
                    }
                    
                    
                    //Insert Kill Table
                    autoreleasepool {
                        if arrayAllData[3]["kill_list"] is NSString {
                            print("It's a string")
                        } else if arrayAllData[3]["kill_list"] is NSArray {
                            var objKillTable: KillTable!
                            for i in 0 ..< (arrayAllData[3]["kill_list"]!!.count)!{
                                objKillTable = (NSEntityDescription.insertNewObjectForEntityForName("KillTable", inManagedObjectContext: self.appDel.managedObjectContext) as! KillTable)
                                objKillTable.id = i
                                objKillTable.groupcode = arrayAllData[3]["kill_list"]!![i]["groupcode"] as? String
                                objKillTable.groupcodedisp = arrayAllData[3]["kill_list"]!![i]["groupcodedisp"] as? String
                                objKillTable.killdate = arrayAllData[3]["kill_list"]!![i]["killdate"] as? String
                                objKillTable.killid = arrayAllData[3]["kill_list"]!![i]["killid"] as? String
                                objKillTable.pennodisp = arrayAllData[3]["kill_list"]!![i]["pennodisp"] as? String
                                objKillTable.offline = "NO"
                                objKillTable.recheck_count = arrayAllData[3]["kill_list"]!![i]["recheck_count"] as? String
                                objKillTable.sp_size = arrayAllData[3]["kill_list"]!![i]["sp_size"] as? String
                                objKillTable.inspect_date = arrayAllData[3]["kill_list"]!![i]["inspect_date"] as? String
                                objKillTable.entry_date = arrayAllData[3]["kill_list"]!![i]["entry_date"] as? String
                                objKillTable.ispink = arrayAllData[3]["kill_list"]!![i]["ispink"] as? String
                                objKillTable.killedFrom = "Kill"
                                objKillTable.comment = arrayAllData[3]["kill_list"]!![i]["comment"] as? String
                                do {
                                    try self.appDel.managedObjectContext.save()
                                } catch {}
                            }
                        }
                        
                    }
                    
                    autoreleasepool{
                        //Delete from SingleAllocatedPen and EmptyPensGRP1-3
                        for j in 0 ..< arrayAllData[4]["AllocatedPens"]!!.count {
                            let fetchRequest = NSFetchRequest(entityName: "SingleAllocatedPen")
                            fetchRequest.returnsObjectsAsFaults = false
                            let predicate = NSPredicate(format: "penid == %@", arrayAllData[4]["AllocatedPens"]!![j]["penid"] as! String)
                            fetchRequest.predicate = predicate
                            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                            do {
                                try self.appDel.persistentStoreCoordinator.executeRequest(deleteRequest, withContext: self.appDel.managedObjectContext)
                                do
                                {
                                    try self.appDel.managedObjectContext.save()
                                    print("inside")
                                }
                                catch{}
                            } catch{}
                            
                            
                            autoreleasepool {
                                let fetchRequest = NSFetchRequest(entityName: "EmptyPensTable")
                                fetchRequest.returnsObjectsAsFaults = false
                                let predicate = NSPredicate(format: "penid == %@", arrayAllData[4]["AllocatedPens"]!![j]["penid"] as! String)
                                fetchRequest.predicate = predicate
                                let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                                
                                do {
                                    try self.appDel.persistentStoreCoordinator.executeRequest(deleteRequest, withContext: self.appDel.managedObjectContext)
                                    do
                                    {
                                        try self.appDel.managedObjectContext.save()
                                        print("inside")
                                    }
                                    catch{}
                                } catch{}
                            }
                            
                        }
                    }
                    
                    
                    //Insert into SingleAllocatedPen
                    autoreleasepool {
                        var objCoreTable: SingleAllocatedPen!
                        let newArray = arrayAllData[4]["AllocatedPens"]!! as! NSArray
                        for i in 0 ..< newArray.count {
                            objCoreTable = (NSEntityDescription.insertNewObjectForEntityForName("SingleAllocatedPen", inManagedObjectContext: self.appDel.managedObjectContext) as! SingleAllocatedPen)
                            objCoreTable.groupcode = newArray[i]["group_code"] as? String
                            objCoreTable.namexx = newArray[i]["sp_namexx"] as? String
                            objCoreTable.nameyy = newArray[i]["sp_nameyy"] as? String
                            objCoreTable.colorcode = newArray[i]["colorcode"] as? String
                            objCoreTable.dateadded = newArray[i]["dateadded"] as? String
                            objCoreTable.entryConvert = self.Databse_dateconvertor(newArray[i]["entrydate"] as? String)
                            objCoreTable.addedConvert = self.Databse_dateconvertor(newArray[i]["dateadded"] as? String)
                            objCoreTable.entrydate = newArray[i]["entrydate"] as? String
                            objCoreTable.groupcodedisp = newArray[i]["groupcodedisp"] as? String
                            objCoreTable.penid = newArray[i]["penid"] as? String
                            objCoreTable.pennodisp = newArray[i]["pennodisp"] as? String
                            objCoreTable.skin_size = newArray[i]["skin_size"] as? String
                            objCoreTable.recheckcount = newArray[i]["recheckcount"] as? String
                            objCoreTable.state = "NO"
                            objCoreTable.ispink = newArray[i]["ispink"] as? String
                            objCoreTable.comment = newArray[i]["comment"] as? String  //
                            print(objCoreTable.comment)
                            do {
                                try self.appDel.managedObjectContext.save()
                                
                            } catch {
                            }
                        }
                        
                        
                        appDel.remove_HUD()
                    }
                    
                    
                    //EmptyPensAllGRP
                    autoreleasepool{
                        //Delete Which are in the  EmptyPensAllGRP
                        for j in 0 ..< (arrayAllData[5]["EmptyPensAllGRP"]!!.count)! {
                            let fetchRequest = NSFetchRequest(entityName: "EmptyPensTable")
                            fetchRequest.returnsObjectsAsFaults = false
                            print(arrayAllData[5]["EmptyPensAllGRP"]!![j]["penid"] as! String)
                            let predicate = NSPredicate(format: "penid = %@", arrayAllData[5]["EmptyPensAllGRP"]!![j]["penid"] as! String)
                            fetchRequest.predicate = predicate
                            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                            do {
                                try self.appDel.persistentStoreCoordinator.executeRequest(deleteRequest, withContext: self.appDel.managedObjectContext)
                                do
                                {
                                    try self.appDel.managedObjectContext.save()
                                    print("inside")
                                }
                                catch{}
                            } catch{}
                        }
                    }
                    
                    
                    //Insert Into EmptyPensAllGRP
                    autoreleasepool
                        {
                            for i in 0 ..< (arrayAllData[5]["EmptyPensAllGRP"]!!.count)!{
                                var objCoreTable: EmptyPensTable!
                                
                                objCoreTable = (NSEntityDescription.insertNewObjectForEntityForName("EmptyPensTable", inManagedObjectContext: self.appDel.managedObjectContext) as! EmptyPensTable)
                                objCoreTable.id = i
                                objCoreTable.groupcode = arrayAllData[5]["EmptyPensAllGRP"]!![i]["groupcode"] as? String
                                objCoreTable.grpnamedisp = arrayAllData[5]["EmptyPensAllGRP"]!![i]["grpnamedisp"] as? String
                                objCoreTable.namexx = arrayAllData[5]["EmptyPensAllGRP"]!![i]["namexx"] as? String
                                objCoreTable.nameyy = arrayAllData[5]["EmptyPensAllGRP"]!![i]["nameyy"] as? String
                                objCoreTable.pennodisp = arrayAllData[5]["EmptyPensAllGRP"]!![i]["pennodisp"] as? String
                                objCoreTable.penid = arrayAllData[5]["EmptyPensAllGRP"]!![i]["penid"] as? String
                                do {
                                    try self.appDel.managedObjectContext.save()
                                    
                                } catch {}
                                
                            }
                            
                    }
                }
            }
            else
            {
                var arrayAllData : NSMutableArray! = []
                arrayAllData = dic["all_details"] as! NSMutableArray
                /*
                 all groups
                 animalcount
                 general details
                 kill list
                 allocated pens
                 emptypen list
                 */
//                print(arrayAllData[7]["last_update"] as! String)
//                print(arrayAllData[1]["last_update"] as! String)
                //----Saving to databse//
                if (true) {
                    var objTable: TimeStrampTable!
                    objTable = (NSEntityDescription.insertNewObjectForEntityForName("TimeStrampTable", inManagedObjectContext: self.appDel.managedObjectContext) as! TimeStrampTable)
                    objTable.availableTym = arrayAllData[0]["last_update"] as? String
                    objTable.animalCountTym = arrayAllData[1]["lastupdate"] as? String
                    objTable.allocatedPenTym = arrayAllData[4]["last_update"] as? String
                    objTable.emptyPenTym = arrayAllData[5]["last_update"] as? String
                    
                    do {
                        try self.appDel.managedObjectContext.save()
                    } catch {}
                }
                
                autoreleasepool{
                    for i in 0 ..< (arrayAllData[0]["AllGroups"]!!.count){
                        var objAddSectionTable: AddSectionTable!
                        
                        objAddSectionTable = (NSEntityDescription.insertNewObjectForEntityForName("AddSectionTable", inManagedObjectContext: self.appDel.managedObjectContext) as! AddSectionTable)
                        objAddSectionTable.id = i
                        objAddSectionTable.groupcode = arrayAllData[0]["AllGroups"]!![i]["groupcode"] as? String
                        objAddSectionTable.groupname = arrayAllData[0]["AllGroups"]!![i]["groupname"] as? String
                        objAddSectionTable.available = arrayAllData[0]["AllGroups"]!![i]["available"] as? String
                        objAddSectionTable.total = arrayAllData[0]["AllGroups"]!![i]["total"] as? String
                        do {
                            try self.appDel.managedObjectContext.save()
                        } catch {}
                        
                    }
                }
                
                
                //-----//
                //----Saving to databse//
                
                autoreleasepool
                {
                    for i in 0 ..< (arrayAllData[5]["EmptyPensAllGRP"]!!.count)!{
                        var objCoreTable: EmptyPensTable!
                        
                        objCoreTable = (NSEntityDescription.insertNewObjectForEntityForName("EmptyPensTable", inManagedObjectContext: self.appDel.managedObjectContext) as! EmptyPensTable)
                        objCoreTable.id = i
                        objCoreTable.groupcode = arrayAllData[5]["EmptyPensAllGRP"]!![i]["groupcode"] as? String
                        objCoreTable.grpnamedisp = arrayAllData[5]["EmptyPensAllGRP"]!![i]["grpnamedisp"] as? String
                        objCoreTable.namexx = arrayAllData[5]["EmptyPensAllGRP"]!![i]["namexx"] as? String
                        objCoreTable.nameyy = arrayAllData[5]["EmptyPensAllGRP"]!![i]["nameyy"] as? String
                        objCoreTable.pennodisp = arrayAllData[5]["EmptyPensAllGRP"]!![i]["pennodisp"] as? String
                        objCoreTable.penid = arrayAllData[5]["EmptyPensAllGRP"]!![i]["penid"] as? String
                        
                        do {
                            try self.appDel.managedObjectContext.save()
                        } catch {}
                        
                    }
                    
                }
                
                autoreleasepool
                {
                    var objCoreTable: AnimalsCountTable!
                    for i in 0 ..< (arrayAllData[1]["Animals_count_Data"]!!.count)!{
                        objCoreTable = (NSEntityDescription.insertNewObjectForEntityForName("AnimalsCountTable", inManagedObjectContext: self.appDel.managedObjectContext) as! AnimalsCountTable)
                        objCoreTable.count_id = i
                        objCoreTable.count_namexx = arrayAllData[1]["Animals_count_Data"]!![i]["namexx"] as? String
                        objCoreTable.count_nameyy = arrayAllData[1]["Animals_count_Data"]!![i]["nameyy"] as? String
                        objCoreTable.groupname = arrayAllData[1]["Animals_count_Data"]!![i]["groupname"] as? String
                        objCoreTable.movedby = NSUserDefaults.standardUserDefaults().objectForKey("email_username") as? String
                        objCoreTable.total_animals = arrayAllData[1]["Animals_count_Data"]!![i]["total_animals"] as? String
                        objCoreTable.total_animals = objCoreTable.total_animals!
                        print(objCoreTable)
                        objCoreTable.offline = "NO"
                        
                    }
                    do {
                        try self.appDel.managedObjectContext.save()
                    } catch {
                    }
                    
                }
                
                
                autoreleasepool {
                    var objCoreTable: ConditionTable!
                    for i in 0 ..< (arrayAllData[2]["general_details"]!![0]["Condition_data"]!!.count)!{
                        objCoreTable = (NSEntityDescription.insertNewObjectForEntityForName("ConditionTable", inManagedObjectContext: self.appDel.managedObjectContext) as! ConditionTable)
                        objCoreTable.id = i
                        objCoreTable.conditionid = arrayAllData[2]["general_details"]!![0]["Condition_data"]!![i]["conditionid"] as? String
                        objCoreTable.conditionname = arrayAllData[2]["general_details"]!![0]["Condition_data"]!![i]["conditionname"] as? String
                        do {
                            try self.appDel.managedObjectContext.save()
                        } catch {}
                        
                    }
                }
                
                
               autoreleasepool {
                    var objCoreTable: InspectionPeriodTable!
                    for i in 0 ..< (arrayAllData[2]["general_details"]!![1]["inspection_data"]!!.count)!{
                        objCoreTable = (NSEntityDescription.insertNewObjectForEntityForName("InspectionPeriodTable", inManagedObjectContext: self.appDel.managedObjectContext) as! InspectionPeriodTable)
                        objCoreTable.id = i
                        objCoreTable.inspect_id = arrayAllData[2]["general_details"]!![1]["inspection_data"]!![i]["inspect_id"] as? String
                        objCoreTable.inspect_period = arrayAllData[2]["general_details"]!![1]["inspection_data"]!![i]["inspect_period"] as? String
                        do {
                            try self.appDel.managedObjectContext.save()
                        } catch {}
                        
                    }
                }
                
                autoreleasepool {
                    var objCoreTable: GraderTable!
                    for i in 0 ..< (arrayAllData[2]["general_details"]!![2]["grader_data"]!!.count)!{
                        objCoreTable = (NSEntityDescription.insertNewObjectForEntityForName("GraderTable", inManagedObjectContext: self.appDel.managedObjectContext) as! GraderTable)
                        objCoreTable.id = i
                        objCoreTable.grader_id = arrayAllData[2]["general_details"]!![2]["grader_data"]!![i]["grader_id"] as? String
                        objCoreTable.fname = arrayAllData[2]["general_details"]!![2]["grader_data"]!![i]["fname"] as? String
                        objCoreTable.lname = arrayAllData[2]["general_details"]!![2]["grader_data"]!![i]["lname"] as? String
                        do {
                            try self.appDel.managedObjectContext.save()
                        } catch {}
                        
                    }
                }
                
                
                
                autoreleasepool {
                    if arrayAllData[3]["kill_list"] is NSString {
                        print("It's a string")
                    } else if arrayAllData[3]["kill_list"] is NSArray {
                        var objKillTable: KillTable!
                        for i in 0 ..< (arrayAllData[3]["kill_list"]!!.count)!{
                            objKillTable = (NSEntityDescription.insertNewObjectForEntityForName("KillTable", inManagedObjectContext: self.appDel.managedObjectContext) as! KillTable)
                            objKillTable.id = i
                            objKillTable.groupcode = arrayAllData[3]["kill_list"]!![i]["groupcode"] as? String
                            objKillTable.groupcodedisp = arrayAllData[3]["kill_list"]!![i]["groupcodedisp"] as? String
                            objKillTable.killdate = arrayAllData[3]["kill_list"]!![i]["killdate"] as? String
                            objKillTable.killid = arrayAllData[3]["kill_list"]!![i]["killid"] as? String
                            objKillTable.pennodisp = arrayAllData[3]["kill_list"]!![i]["pennodisp"] as? String
                            objKillTable.offline = "NO"
                            objKillTable.recheck_count = arrayAllData[3]["kill_list"]!![i]["recheck_count"] as? String
                            objKillTable.sp_size = arrayAllData[3]["kill_list"]!![i]["sp_size"] as? String
                            objKillTable.inspect_date = arrayAllData[3]["kill_list"]!![i]["inspect_date"] as? String
                            objKillTable.entry_date = arrayAllData[3]["kill_list"]!![i]["entry_date"] as? String
                            objKillTable.ispink = arrayAllData[3]["kill_list"]!![i]["ispink"] as? String
                            objKillTable.killedFrom = "Kill"
                            objKillTable.comment = arrayAllData[3]["kill_list"]!![i]["comment"] as? String
                            do {
                                try self.appDel.managedObjectContext.save()
                            } catch {}
                        }
                    }
                    
                }
                
                
                autoreleasepool {
                    var objCoreTable: SingleAllocatedPen!
                    let newArray = arrayAllData[4]["AllocatedPens"]!! as! NSArray
                    for i in 0 ..< newArray.count {
                        objCoreTable = (NSEntityDescription.insertNewObjectForEntityForName("SingleAllocatedPen", inManagedObjectContext: self.appDel.managedObjectContext) as! SingleAllocatedPen)
                        objCoreTable.groupcode = newArray[i]["group_code"] as? String
                        objCoreTable.namexx = newArray[i]["sp_namexx"] as? String
                        objCoreTable.nameyy = newArray[i]["sp_nameyy"] as? String
                        objCoreTable.colorcode = newArray[i]["colorcode"] as? String
                        objCoreTable.dateadded = newArray[i]["dateadded"] as? String
                        objCoreTable.entryConvert = self.Databse_dateconvertor(newArray[i]["entrydate"] as? String)
                        objCoreTable.addedConvert = self.Databse_dateconvertor(newArray[i]["dateadded"] as? String)
                        objCoreTable.entrydate = newArray[i]["entrydate"] as? String
                        objCoreTable.groupcodedisp = newArray[i]["groupcodedisp"] as? String
                        objCoreTable.penid = newArray[i]["penid"] as? String
                        objCoreTable.pennodisp = newArray[i]["pennodisp"] as? String
                        objCoreTable.skin_size = newArray[i]["skin_size"] as? String
                        objCoreTable.recheckcount = newArray[i]["recheckcount"] as? String
                        objCoreTable.state = "NO"
                        objCoreTable.ispink = newArray[i]["ispink"] as? String
                        objCoreTable.comment = newArray[i]["comment"] as? String  //
                        print(objCoreTable.comment)
                    }
                    do {
                        try self.appDel.managedObjectContext.save()
                        
                    } catch {
                    }
                    
                    
//                    let userDefaults = NSUserDefaults.standardUserDefaults()
//                    userDefaults.setValue("AllDataSaved", forKey: "AllData")
//                    
//                    appDel.remove_HUD()
                }
                
                autoreleasepool {
                    var objCoreTable: FirstLetterTable!
                    let newArray = arrayAllData[6]["FirstLetter"]!! as! NSArray
                    for i in 0 ..< newArray.count {
                        objCoreTable = (NSEntityDescription.insertNewObjectForEntityForName("FirstLetterTable", inManagedObjectContext: self.appDel.managedObjectContext) as! FirstLetterTable)
                        objCoreTable.first_letter = newArray[i]["first_letter"] as? String
                        objCoreTable.group_code = newArray[i]["group_code"] as? String
                        
                    }
                    do {
                        try self.appDel.managedObjectContext.save()
                        
                    } catch {
                    }
                    
                    let userDefaults = NSUserDefaults.standardUserDefaults()
                    userDefaults.setValue("AllDataSaved", forKey: "AllData")
                    
                    appDel.remove_HUD()
                }
                
            }
            
        }
    }
    

    //MARK: -
    func Databse_dateconvertor(datestr: String!) -> NSDate
    {
        //        let dateFormatter: NSDateFormatter = NSDateFormatter()
        let twelveHourLocale: NSLocale = NSLocale(localeIdentifier: "en_US_POSIX")
        dateFormatter.locale = twelveHourLocale
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC")
        let gotDate: NSDate = dateFormatter.dateFromString(datestr)!
        return gotDate
    }
    
    
    
    //MARK: - BackGroung Methods dummy
    func methodKillTable_d()
    {
        if arrayForPacket.count > 0 {
            arrayForPacket.removeAllObjects()
        }
        
        let fetchRequest = NSFetchRequest(entityName: "KillTable")
        let predicate = NSPredicate(format: "offline = 'YES' AND killedFrom = 'Kill'", argumentArray: nil)
        fetchRequest.predicate = predicate
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.fetchBatchSize = 20
        fetchRequest.resultType = NSFetchRequestResultType.DictionaryResultType
        do {
            let results = try appDel.managedObjectContext.executeFetchRequest(fetchRequest)
            if results.count > 0 {
                
                arrayKill = results
                
                let temp : NSMutableDictionary! = NSMutableDictionary()
                temp.setValue(results, forKey: "confirmkill")
                arrayForPacket.addObject(temp)
                
                self.methodAddingSinglePenTable_d()
            }
            else
            {
                
                let temp : NSMutableDictionary! = NSMutableDictionary()
                temp.setValue(results, forKey: "confirmkill")
                arrayForPacket.addObject(temp)
                self.methodAddingSinglePenTable_d()
            }
            
        } catch {}
    }
    
    func  methodAddingSinglePenTable_d()
    {
        let fetchRequest1 = NSFetchRequest(entityName: "AddingSinglePenTable")
        let predicate1 = NSPredicate(format: "offline = 'YES'", argumentArray: nil)
        fetchRequest1.predicate = predicate1
        fetchRequest1.returnsObjectsAsFaults = false
        fetchRequest1.fetchBatchSize = 20
        fetchRequest1.resultType = NSFetchRequestResultType.DictionaryResultType
        do {
            let results = try self.appDel.managedObjectContext.executeFetchRequest(fetchRequest1)
            if results.count > 0 {
                arraySinglePen = results
                let temp : NSMutableDictionary! = NSMutableDictionary()
                temp.setValue(results, forKey: "sp_add")
                arrayForPacket.addObject(temp)
                
                print("2 \(arrayForPacket)")
                self.methodEmptyMove_d()
            }
            else
            {
                let temp : NSMutableDictionary! = NSMutableDictionary()
                temp.setValue(results, forKey: "sp_add")
                arrayForPacket.addObject(temp)
                self.methodEmptyMove_d()
            }
            
        } catch {
            // Do something in response to error condition
        }
    }
    
    func  methodEmptyMove_d()
    {
        let fetchRequest2 = NSFetchRequest(entityName: "AnimalgroupEmpty")
        fetchRequest2.returnsObjectsAsFaults = false
        fetchRequest2.fetchBatchSize = 20
        fetchRequest2.resultType = NSFetchRequestResultType.DictionaryResultType
        do {
            let results = try self.appDel.managedObjectContext.executeFetchRequest(fetchRequest2)
            if results.count > 0 {
                arrayEmptyMove = results
                
                let temp : NSMutableDictionary! = NSMutableDictionary()
                temp.setValue(results, forKey: "empty_move_sub")
                arrayForPacket.addObject(temp)
                print("3 \(arrayForPacket)")
                
                self.methodMoveAddAnimal_d()
            }
            else
            {
                let temp : NSMutableDictionary! = NSMutableDictionary()
                temp.setValue(results, forKey: "empty_move_sub")
                arrayForPacket.addObject(temp)
                self.methodMoveAddAnimal_d()
            }
            
        } catch {
            // Do something in response to error condition
        }
    }
    
    func  methodMoveAddAnimal_d()
    {
        let fetchRequest2 = NSFetchRequest(entityName: "MoveAddAnimal")
        fetchRequest2.returnsObjectsAsFaults = false
        fetchRequest2.fetchBatchSize = 20
        fetchRequest2.resultType = NSFetchRequestResultType.DictionaryResultType
        do {
            let results = try self.appDel.managedObjectContext.executeFetchRequest(fetchRequest2)
            if results.count > 0 {
                arrayMoveAddAnimal = results
                
                let temp : NSMutableDictionary! = NSMutableDictionary()
                temp.setValue(results, forKey: "empty_move_add")
                arrayForPacket.addObject(temp)
                print("4 \(arrayForPacket)")
                self.methodMoveHatchling_d()
            }
            else
            {
                let temp : NSMutableDictionary! = NSMutableDictionary()
                temp.setValue(results, forKey: "empty_move_add")
                arrayForPacket.addObject(temp)
                self.methodMoveHatchling_d()
            }
            
        } catch {
            // Do something in response to error condition
        }
    }
    
    
    func  methodMoveHatchling_d()
    {
        let fetchRequest2 = NSFetchRequest(entityName: "MoveHatchlings")
        fetchRequest2.returnsObjectsAsFaults = false
        fetchRequest2.fetchBatchSize = 20
        fetchRequest2.resultType = NSFetchRequestResultType.DictionaryResultType
        do {
            let results = try self.appDel.managedObjectContext.executeFetchRequest(fetchRequest2)
            if results.count > 0 {
                arrayMoveHatchling = results
                
                let temp : NSMutableDictionary! = NSMutableDictionary()
                temp.setValue(results, forKey: "move_hatchlings")
                arrayForPacket.addObject(temp)
                print("5 \(arrayForPacket)")
                self.methodMoveSection_d()
            }
            else
            {
                let temp : NSMutableDictionary! = NSMutableDictionary()
                temp.setValue(results, forKey: "move_hatchlings")
                arrayForPacket.addObject(temp)
                self.methodMoveSection_d()
            }
            
        } catch {
            // Do something in response to error condition
        }
    }
    
    func  methodMoveSection_d()
    {
        let fetchRequest3 = NSFetchRequest(entityName: "Move_animal")
        let predicate3 = NSPredicate(format: "offline = 'YES'", argumentArray: nil)
        fetchRequest3.predicate = predicate3
        fetchRequest3.returnsObjectsAsFaults = false
        fetchRequest3.fetchBatchSize = 20
        fetchRequest3.resultType = NSFetchRequestResultType.DictionaryResultType
        do {
            let results = try self.appDel.managedObjectContext.executeFetchRequest(fetchRequest3)
            if results.count > 0 {
                arrayMoveSection = results
                
                let temp : NSMutableDictionary! = NSMutableDictionary()
                temp.setValue(results, forKey: "move_animals")
                arrayForPacket.addObject(temp)
                print("6 \(arrayForPacket)")
                self.methodSingleAddToDie_d()
            }
            else
            {
                let temp : NSMutableDictionary! = NSMutableDictionary()
                temp.setValue(results, forKey: "move_animals")
                arrayForPacket.addObject(temp)
                self.methodSingleAddToDie_d()
            }
            
        } catch {
            // Do something in response to error condition
        }
    }
    
    func methodSingleAddToDie_d()
    {
        let fetchRequest4 = NSFetchRequest(entityName: "SingleAddToDie")
        fetchRequest4.returnsObjectsAsFaults = false
        fetchRequest4.fetchBatchSize = 20
        fetchRequest4.resultType = NSFetchRequestResultType.DictionaryResultType
        do {
            let results = try self.appDel.managedObjectContext.executeFetchRequest(fetchRequest4)
            if results.count > 0 {
                
                arraySingleSection = results
                
                let temp : NSMutableDictionary! = NSMutableDictionary()
                temp.setValue(results, forKey: "Single_die_animals")
                arrayForPacket.addObject(temp)
                print("7 \(arrayForPacket)")
                self.methodGpToDie_d()
            }
            else
            {
                let temp : NSMutableDictionary! = NSMutableDictionary()
                temp.setValue(results, forKey: "Single_die_animals")
                arrayForPacket.addObject(temp)
                self.methodGpToDie_d()
            }
            
        } catch {
            // Do something in response to error condition
        }
        
    }
    
    func  methodGpToDie_d()
    {
        let fetchRequest5 = NSFetchRequest(entityName: "Animalgroupdie")
        fetchRequest5.returnsObjectsAsFaults = false
        fetchRequest5.fetchBatchSize = 20
        fetchRequest5.resultType = NSFetchRequestResultType.DictionaryResultType
        do {
            let results = try self.appDel.managedObjectContext.executeFetchRequest(fetchRequest5)
            if results.count > 0 {
                
                arrayGroupSection = results
                let temp : NSMutableDictionary! = NSMutableDictionary()
                temp.setValue(results, forKey: "Group_die_animals")
                arrayForPacket.addObject(temp)
                print("8 \(arrayForPacket)")
                self.methodGpToKill_d()
            }
            else
            {
                let temp : NSMutableDictionary! = NSMutableDictionary()
                temp.setValue(results, forKey: "Group_die_animals")
                arrayForPacket.addObject(temp)
                self.methodGpToKill_d()
            }
            
        } catch {
            // Do something in response to error condition
        }
    }
    
    func  methodGpToKill_d()
    {
        let fetchRequest5 = NSFetchRequest(entityName: "Animalgroupkill")
        fetchRequest5.returnsObjectsAsFaults = false
        fetchRequest5.fetchBatchSize = 20
        fetchRequest5.resultType = NSFetchRequestResultType.DictionaryResultType
        do {
            let results = try self.appDel.managedObjectContext.executeFetchRequest(fetchRequest5)
            if results.count > 0 {
                
                arrayGroupKillSection = results
                
                let temp : NSMutableDictionary! = NSMutableDictionary()
                temp.setValue(results, forKey: "kill_animals_group")
                arrayForPacket.addObject(temp)
                print("9 \(arrayForPacket)")
                self.methodAddToKill_d()
            }
            else
            {
                let temp : NSMutableDictionary! = NSMutableDictionary()
                temp.setValue(results, forKey: "kill_animals_group")
                arrayForPacket.addObject(temp)
                self.methodAddToKill_d()
            }
            
        } catch {
            // Do something in response to error condition
        }
    }
    
    func  methodAddToKill_d()
    {
        let fetchRequest = NSFetchRequest(entityName: "KillTable")
        let predicate = NSPredicate(format: "offline = 'YES' OR killedFrom = 'Inspection'", argumentArray: nil)
        fetchRequest.predicate = predicate
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.fetchBatchSize = 20
        fetchRequest.resultType = NSFetchRequestResultType.DictionaryResultType
        do {
            let results = try appDel.managedObjectContext.executeFetchRequest(fetchRequest)
            if results.count > 0 {
                
                arrayAddToKillSection = results
                
                let temp : NSMutableDictionary! = NSMutableDictionary()
                temp.setValue(results, forKey: "movetokill_list")
                temp.setValue("\(NSUserDefaults.standardUserDefaults().objectForKey("email_username") as! String)", forKey: "addedby")
                arrayForPacket.addObject(temp)
                print("10 \(arrayForPacket)")
                self.methodRecheckCount_d()
            }
            else
            {
                let temp : NSMutableDictionary! = NSMutableDictionary()
                temp.setValue(results, forKey: "movetokill_list")
                arrayForPacket.addObject(temp)
                self.methodRecheckCount_d()
            }
            
        } catch {
            // Do something in response to error condition
        }
    }
    
    func methodRecheckCount_d()
    {
        let fetchRequest = NSFetchRequest(entityName: "RecheckTable")
        let predicate = NSPredicate(format: "offline = 'YES'", argumentArray: nil)
        fetchRequest.predicate = predicate
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.fetchBatchSize = 20
        fetchRequest.resultType = NSFetchRequestResultType.DictionaryResultType
        do {
            let results = try appDel.managedObjectContext.executeFetchRequest(fetchRequest)
            if results.count > 0 {
                arrayRecheck = results
                
                let temp : NSMutableDictionary! = NSMutableDictionary()
                temp.setValue(results, forKey: "updaterecheck")
                arrayForPacket.addObject(temp)
                print("11 \(arrayForPacket)")
                self.methodRevertkill_d()
            }
            else
            {
                let temp : NSMutableDictionary! = NSMutableDictionary()
                temp.setValue(results, forKey: "updaterecheck")
                arrayForPacket.addObject(temp)
                self.methodRevertkill_d()
            }
            
        } catch {
            // Do something in response to error condition
        }
    }
    
    func methodRevertkill_d()
    {
        let fetchRequest = NSFetchRequest(entityName: "KillRevertTable")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.fetchBatchSize = 20
        fetchRequest.resultType = NSFetchRequestResultType.DictionaryResultType
        do {
            let results = try appDel.managedObjectContext.executeFetchRequest(fetchRequest)
            if results.count > 0 {
                arrayRevert = results
                
                let temp : NSMutableDictionary! = NSMutableDictionary()
                temp.setValue(results, forKey: "revertkill")
                arrayForPacket.addObject(temp)
                print("12 \(arrayForPacket)")
                self.methodPinkMark_d()
            }
            else
            {
                let temp : NSMutableDictionary! = NSMutableDictionary()
                temp.setValue(results, forKey: "revertkill")
                arrayForPacket.addObject(temp)
                self.methodPinkMark_d()
            }
            
        } catch {
            // Do something in response to error condition
        }
    }
    
    func methodPinkMark_d()
    {
        let fetchRequest = NSFetchRequest(entityName: "PinkMarkTable")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.fetchBatchSize = 20
        fetchRequest.resultType = NSFetchRequestResultType.DictionaryResultType
        do {
            let results = try appDel.managedObjectContext.executeFetchRequest(fetchRequest)
            if results.count > 0 {
                arrayPink = results
                
                let temp : NSMutableDictionary! = NSMutableDictionary()
                temp.setValue(results, forKey: "updatepinkvalue")
                arrayForPacket.addObject(temp)
                self.methodSkinSizeCount_d()
            }
            else
            {
                let temp : NSMutableDictionary! = NSMutableDictionary()
                temp.setValue(results, forKey: "updatepinkvalue")
                arrayForPacket.addObject(temp)
                self.methodSkinSizeCount_d()
            }
            
        } catch {
            // Do something in response to error condition
        }
    }
    
    
    func methodSkinSizeCount_d()
    {
        let fetchRequest = NSFetchRequest(entityName: "SkinSizeTable")
        let predicate = NSPredicate(format: "offline = 'YES'", argumentArray: nil)
        fetchRequest.predicate = predicate
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.fetchBatchSize = 20
        fetchRequest.resultType = NSFetchRequestResultType.DictionaryResultType
        do {
            let results = try appDel.managedObjectContext.executeFetchRequest(fetchRequest)
            if results.count > 0 {
                arraySkinSize = results
                
                let temp : NSMutableDictionary! = NSMutableDictionary()
                temp.setValue(results, forKey: "updatedataskin")
                arrayForPacket.addObject(temp)
                
                self.methodUpdateMove_d()
            }
            else
            {
                let temp : NSMutableDictionary! = NSMutableDictionary()
                temp.setValue(results, forKey: "updatedataskin")
                arrayForPacket.addObject(temp)
                
                self.methodUpdateMove_d()
            }
            
        } catch {
            // Do something in response to error condition
        }
        
    }
    
    func methodUpdateMove_d()
    {
        let fetchRequest = NSFetchRequest(entityName: "UpdateMoveToAnother")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.fetchBatchSize = 20
        fetchRequest.resultType = NSFetchRequestResultType.DictionaryResultType
        do {
            let results = try appDel.managedObjectContext.executeFetchRequest(fetchRequest)
            if results.count > 0 {
                arrayUpdateMove = results
                
                let temp : NSMutableDictionary! = NSMutableDictionary()
                temp.setValue(results, forKey: "updateMoveanimal")
                arrayForPacket.addObject(temp)
                
                
                let arrayPacket: [AnyObject] = arrayForPacket.mutableCopy() as! [AnyObject]
                dictForPacket.setValue(arrayPacket, forKey: "OfflinePacket")
                dictForPacket.setValue("\(NSUserDefaults.standardUserDefaults().objectForKey("ApplicationIdentifier") as! String)", forKey: "app_id")
                self.objwebservice.post(self.dictForPacket, url: "\(Server.local_server)/api/Offline2Online/toserver.php")
                print("dictForPacket inside \(dictForPacket)")
                str_webPacket = "Inserted"
                
                if NSUserDefaults.standardUserDefaults().objectForKey("str_HomeScreen") as! String == "" {
                    self.AllDataWebservice()
                    let userDefaults = NSUserDefaults.standardUserDefaults()
                    userDefaults.setValue("Filled", forKey: "str_HomeScreen")
                }
                else
                {
                    self.appDel.remove_HUD()
                }
                
                
            }
            else
            {
                let temp : NSMutableDictionary! = NSMutableDictionary()
                temp.setValue(results, forKey: "updateMoveanimal")
                arrayForPacket.addObject(temp)
                
                let arrayPacket: [AnyObject] = arrayForPacket.mutableCopy() as! [AnyObject]
                dictForPacket.setValue(arrayPacket, forKey: "OfflinePacket")
                dictForPacket.setValue("\(NSUserDefaults.standardUserDefaults().objectForKey("ApplicationIdentifier") as! String)", forKey: "app_id")
                str_webPacket = "Inserted"
                
                self.objwebservice.post(self.dictForPacket, url: "\(Server.local_server)/api/Offline2Online/toserver.php")
                
                if NSUserDefaults.standardUserDefaults().objectForKey("str_HomeScreen") as! String == "" {
                    self.AllDataWebservice()
                    let userDefaults = NSUserDefaults.standardUserDefaults()
                    userDefaults.setValue("Filled", forKey: "str_HomeScreen")
                }
                else
                {
                    self.appDel.remove_HUD()
                }
                
            }
            
        } catch {
            // Do something in response to error condition
        }
        
    }
    
}