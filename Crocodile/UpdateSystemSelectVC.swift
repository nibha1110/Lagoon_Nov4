//
//  UpdateSystemSelectVC.swift
//  Crocodile
//
//  Created by Nibha Aggarwal on 6/10/16.
//  Copyright © 2016 Nibha Aggarwal. All rights reserved.
//

import UIKit
import CoreData

class UpdateSystemSelectVC: UIViewController, responseProtocol {
    var toPass: NSMutableDictionary! = NSMutableDictionary()
    var str_webservice: NSString!
    var objwebservice : webservice! = webservice()
    var dic_EmptyPens: NSMutableDictionary! = NSMutableDictionary()
    var totalRows: Int! = 0
    var MovedIndex: Int! = 0
    var appDel : AppDelegate!
    
    @IBOutlet weak var table_MoveList: UITableView!
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        appDel = (UIApplication.sharedApplication().delegate as! AppDelegate)
        guard let controller = self.storyboard!.instantiateViewControllerWithIdentifier("CommonClassVC") as? CommonClassVC
            else {
                fatalError();
        }
        addChildViewController(controller)
        controller.view.frame = CGRectMake(0, 0, 1024, 768)
        controller.array_tableSection = ["update"]
        controller.array_sectionRow = [[]]
        view.addSubview(controller.view)
        view.sendSubviewToBack(controller.view)
        controller.label_header.text = "SP UPDATE"
        controller.IIndexPath = NSIndexPath(forRow: 0, inSection: 5)
        controller.array_temp_section.replaceObjectAtIndex(5, withObject: "Yes")
        controller.tableMenu.reloadData()

        
        objwebservice?.delegate = self
        print(toPass)
    }
    
    
    
    override func viewDidAppear(animated: Bool) {
        if self.appDel.checkInternetConnection() {
            self.GetUpdateEmptyPens()
        }
        else
        {
            let fetchRequest = NSFetchRequest(entityName: "EmptyPensTable")
            let predicate = NSPredicate(format: "groupcode = '\(self.toPass["PenDetails"]![0]["groupcode"] as! String)'", argumentArray: nil)
            fetchRequest.predicate = predicate
            fetchRequest.returnsObjectsAsFaults = false
            fetchRequest.fetchBatchSize = 20
            fetchRequest.resultType = NSFetchRequestResultType.DictionaryResultType
            fetchRequest.fetchLimit = 5
            do {
                let results = try self.appDel.managedObjectContext.executeFetchRequest(fetchRequest)
                if results.count > 0
                {
                    self.totalRows = results.count
                    self.dic_EmptyPens.setValue(results, forKey: "FiveEmptyPens")
                    self.table_MoveList.reloadData()
                }
                else
                {
                    self.table_MoveList.reloadData()
                }
                
                // success ...
            } catch let error as NSError {
                // failure
                print("Fetch failed: \(error.localizedDescription)")
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Webservice NetLost delegate
    func NetworkLost(str: String!)
    {
        HelperClass.NetworkLost(str, view1: self)
    }
    
    //MARK: - Webservice Delegate
    func responseDictionary(dic: NSMutableDictionary) {
        
            if (self.str_webservice == "movetokill_list")
            {
//                dispatch_async(dispatch_get_main_queue()) {
                    if dic["FiveEmptyPens"] != nil {
                        self.totalRows = dic["FiveEmptyPens"]?.count
                        self.dic_EmptyPens = dic
                        self.table_MoveList.reloadData()
//                    }
                }
            }
            else if (self.str_webservice == "moveanimal")
            {
                var msg: String!
                if(dic["success"] as! String == "False")
                {
                    msg = "Pen Has Not Moved Successfully."
                }
                else if(dic["success"] as! String == "True")
                {
                    msg = dic["Message"] as! String
                }
//                dispatch_async(dispatch_get_main_queue()) {
                    let alertView = UIAlertController(title: nil, message: msg, preferredStyle: .Alert)
                alertView.addAction(UIAlertAction(title: "OK", style: .Cancel) { action -> Void in
                    
                    if (msg == dic["Message"] as! String)
                    {
                        self.OfflineMoveToAnother(self.MovedIndex)
                        print(self.toPass)
                        print("\(self.toPass["PenDetails"]![0]["groupcode"] as! String)")
                        
                        var array = "\(self.toPass["PenDetails"]![0]["pennodisp"] as! String)".componentsSeparatedByString("-")
                        
                         self.addToEmptyPen("\(self.toPass["PenDetails"]![0]["groupcode"] as! String)", grpnamedisp: "\(self.toPass["PenDetails"]![0]["groupcode"] as! String) - PEN#", namexx: "\(array[0])", nameyy: "\(array[1])", pennodisp: "\(self.toPass["PenDetails"]![0]["pennodisp"] as! String)", penid: "\(self.toPass["PenDetails"]![0]["penid"] as! String)")
                        
                        
                        let array_saveValue:NSMutableArray = []
                        array_saveValue.addObject("\(self.dic_EmptyPens["FiveEmptyPens"]![self.MovedIndex]["groupcode"] as! String)")
                        
                        //0
                        var range = ((self.dic_EmptyPens["FiveEmptyPens"]![self.MovedIndex]["nameyy"]) as! String).startIndex.advancedBy(0) ..< ((self.dic_EmptyPens["FiveEmptyPens"]![self.MovedIndex]["nameyy"]) as! String).startIndex.advancedBy(1)
                        var yy: String! = ((self.dic_EmptyPens["FiveEmptyPens"]![self.MovedIndex]["nameyy"]) as! String).substringWithRange(range)
                        array_saveValue.addObject("\(yy)")
                        
                        //1
                        range = ((self.dic_EmptyPens["FiveEmptyPens"]![self.MovedIndex]["nameyy"]) as! String).startIndex.advancedBy(1) ..< ((self.dic_EmptyPens["FiveEmptyPens"]![self.MovedIndex]["nameyy"]) as! String).startIndex.advancedBy(2)
                        yy = ((self.dic_EmptyPens["FiveEmptyPens"]![self.MovedIndex]["nameyy"]) as! String).substringWithRange(range)
                        array_saveValue.addObject("\(yy)")
                        
                        //2
                        range = ((self.dic_EmptyPens["FiveEmptyPens"]![self.MovedIndex]["nameyy"]) as! String).startIndex.advancedBy(2) ..< ((self.dic_EmptyPens["FiveEmptyPens"]![self.MovedIndex]["nameyy"]) as! String).startIndex.advancedBy(3)
                        yy = ((self.dic_EmptyPens["FiveEmptyPens"]![self.MovedIndex]["nameyy"]) as! String).substringWithRange(range)
                        array_saveValue.addObject("\(yy)")
                        
                        //3
                        range = ((self.dic_EmptyPens["FiveEmptyPens"]![self.MovedIndex]["nameyy"]) as! String).startIndex.advancedBy(3) ..< ((self.dic_EmptyPens["FiveEmptyPens"]![self.MovedIndex]["nameyy"]) as! String).startIndex.advancedBy(4)
                        yy = ((self.dic_EmptyPens["FiveEmptyPens"]![self.MovedIndex]["nameyy"]) as! String).substringWithRange(range)
                        array_saveValue.addObject("\(yy)")
                        
                        
                        array_saveValue.addObject("\(self.dic_EmptyPens["FiveEmptyPens"]![self.MovedIndex]["namexx"] as! String)")
                        
                        let userDefaults = NSUserDefaults.standardUserDefaults()
                        userDefaults.setValue(array_saveValue, forKey: "array_saveUpdate")
                        userDefaults.synchronize()
                        
                        print(self.navigationController!.viewControllers)
                        for controller in self.navigationController!.viewControllers as Array {
                            if controller.isKindOfClass(UpdateSectionVC) {
                                self.navigationController?.popToViewController(controller as UIViewController, animated: false)
                            }
                        }
                    }
                    })
                    self.presentViewController(alertView, animated: true, completion: nil)
            }
            self.appDel.remove_HUD()
    }

    
    func GetUpdateEmptyPens()
    {
        appDel.Show_HUD()
        str_webservice = "movetokill_list";
        let request = NSMutableURLRequest(URL: NSURL(string: "\(Server.local_server)/api/sp_update/getemptypens.php?")!)
        let postString = "groupcode=\(toPass["PenDetails"]![0]["groupcode"] as! String)"
        objwebservice.callServiceCommon(request, postString: postString)
    }

    // MARK: -  tableview Delegates
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.dic_EmptyPens["FiveEmptyPens"]?.count == 0)
        {
            return 1
        }
        return totalRows
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        
        let view_bg: UIView = UIView(frame: CGRectMake(0, 0, 709, 75))
        view_bg.tag = 50
        if indexPath.row % 2 == 0 {
            view_bg.backgroundColor = UIColor.whiteColor()
        }
        else {
            view_bg.backgroundColor = UIColor(red: 241.0 / 255.0, green: 241 / 255.0, blue: 241 / 255.0, alpha: 1.0)
        }
        
        //label_gpname
        let label_groupName: UILabel = UILabel(frame: CGRectMake(64, 13, 200, 50))
        label_groupName.font = UIFont(descriptor: UIFontDescriptor(name: "HelveticaNeue", size: 23), size: 23.0)
        
        if (self.dic_EmptyPens["FiveEmptyPens"]?.count == 0)
        {
            label_groupName.text = "No Empty Pen Available."
            return cell
        }
        
        label_groupName.text = "\((dic_EmptyPens["FiveEmptyPens"]![indexPath.row]["groupcode"] as! String)) - PEN#"
        
        //orange image
        let img_orange: UIImageView = UIImageView(frame: CGRectMake(275, 8, 192, 56))
        img_orange.image = UIImage(named: "xxyy")
        
        //label_pens
        let label_pens: UILabel = UILabel(frame: CGRectMake(275, 8, 192, 56))
        label_pens.textAlignment = .Center
        label_pens.textColor = UIColor.whiteColor()
        label_pens.font = UIFont(descriptor: UIFontDescriptor(name: "HelveticaNeue", size: 25), size: 25.0)
        label_pens.text = dic_EmptyPens["FiveEmptyPens"]![indexPath.row]["pennodisp"] as? String
        
        view_bg.addSubview(img_orange)
        view_bg.addSubview(label_pens)
        view_bg.addSubview(label_groupName)
        cell.contentView.addSubview(view_bg)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (self.dic_EmptyPens["FiveEmptyPens"]?.count == 0)
        {
            return
        }
        if self.appDel.checkInternetConnection() {
            self.SendMovePens_Service(indexPath.row)
        }
        else
        {
            appDel.Show_HUD()
            OfflineMoveToAnother(indexPath.row)
             self.addToEmptyPen(toPass["PenDetails"]![0]["groupcode"] as! String, grpnamedisp: "\(toPass["PenDetails"]![0]["groupcode"] as! String) - PEN#", namexx: toPass["PenDetails"]![0]["namexx"] as! String, nameyy: toPass["PenDetails"]![0]["nameyy"] as! String, pennodisp: "\(toPass["PenDetails"]![0]["namexx"] as! String)-\(toPass["PenDetails"]![0]["nameyy"] as! String)", penid: toPass["PenDetails"]![0]["penid"] as! String)
            
            self.saveToUpdateMoveTable()
            let alertView = UIAlertController(title: nil, message: "Successfully Moved animal to PEN# \(self.dic_EmptyPens["FiveEmptyPens"]![self.MovedIndex]["pennodisp"] as! String) in IFP", preferredStyle: .Alert)
            alertView.addAction(UIAlertAction(title: "OK", style: .Cancel) { action -> Void in
                
                
                let array_saveValue:NSMutableArray = []
                array_saveValue.addObject("\(self.dic_EmptyPens["FiveEmptyPens"]![self.MovedIndex]["groupcode"] as! String)")
                
                //0
                var range = ((self.dic_EmptyPens["FiveEmptyPens"]![self.MovedIndex]["nameyy"]) as! String).startIndex.advancedBy(0) ..< ((self.dic_EmptyPens["FiveEmptyPens"]![self.MovedIndex]["nameyy"]) as! String).startIndex.advancedBy(1)
                var yy: String! = ((self.dic_EmptyPens["FiveEmptyPens"]![self.MovedIndex]["nameyy"]) as! String).substringWithRange(range)
                array_saveValue.addObject("\(yy)")
                
                //1
                range = ((self.dic_EmptyPens["FiveEmptyPens"]![self.MovedIndex]["nameyy"]) as! String).startIndex.advancedBy(1) ..< ((self.dic_EmptyPens["FiveEmptyPens"]![self.MovedIndex]["nameyy"]) as! String).startIndex.advancedBy(2)
                yy = ((self.dic_EmptyPens["FiveEmptyPens"]![self.MovedIndex]["nameyy"]) as! String).substringWithRange(range)
                array_saveValue.addObject("\(yy)")
                
                //2
                range = ((self.dic_EmptyPens["FiveEmptyPens"]![self.MovedIndex]["nameyy"]) as! String).startIndex.advancedBy(2) ..< ((self.dic_EmptyPens["FiveEmptyPens"]![self.MovedIndex]["nameyy"]) as! String).startIndex.advancedBy(3)
                yy = ((self.dic_EmptyPens["FiveEmptyPens"]![self.MovedIndex]["nameyy"]) as! String).substringWithRange(range)
                array_saveValue.addObject("\(yy)")
                
                //3
                range = ((self.dic_EmptyPens["FiveEmptyPens"]![self.MovedIndex]["nameyy"]) as! String).startIndex.advancedBy(3) ..< ((self.dic_EmptyPens["FiveEmptyPens"]![self.MovedIndex]["nameyy"]) as! String).startIndex.advancedBy(4)
                yy = ((self.dic_EmptyPens["FiveEmptyPens"]![self.MovedIndex]["nameyy"]) as! String).substringWithRange(range)
                array_saveValue.addObject("\(yy)")
                
                
                array_saveValue.addObject("\(self.dic_EmptyPens["FiveEmptyPens"]![self.MovedIndex]["namexx"] as! String)")
                
                let userDefaults = NSUserDefaults.standardUserDefaults()
                userDefaults.setValue(array_saveValue, forKey: "array_saveUpdate")
                userDefaults.synchronize()
                
                print(self.navigationController!.viewControllers)
                for controller in self.navigationController!.viewControllers as Array {
                    if controller.isKindOfClass(UpdateSectionVC) {
                        self.navigationController?.popToViewController(controller as UIViewController, animated: false)
                    }
                }
                
                })
            self.presentViewController(alertView, animated: true, completion: nil)
            
            appDel.remove_HUD()
        }

    }
    
    //MARK: - Move to Another Pen
    func SendMovePens_Service(index: Int)
    {
        appDel.Show_HUD()
        MovedIndex = index
        str_webservice = "moveanimal";
        let gpCode: String = dic_EmptyPens["FiveEmptyPens"]![index]["groupcode"] as! String
        let namexx: String = dic_EmptyPens["FiveEmptyPens"]![index]["namexx"] as! String
        let nameyy: String = dic_EmptyPens["FiveEmptyPens"]![index]["nameyy"] as! String
        let penid: String  = toPass["PenDetails"]![0]["penid"] as! String
        let allocationid: String = toPass["PenDetails"]![0]["allocationid"] as! String
        
        let request = NSMutableURLRequest(URL: NSURL(string: "\(Server.local_server)/api/sp_update/moveanimal.php?")!)
        let postString = "groupcode=\(gpCode)&namexx=\(namexx)&nameyy=\(nameyy)&penid=\(penid)&allocationid=\(allocationid)&app_id=\(NSUserDefaults.standardUserDefaults().objectForKey("ApplicationIdentifier") as! String)"
        objwebservice.callServiceCommon(request, postString: postString)
    }
    
    func OfflineMoveToAnother(index: Int)
    {
        
        MovedIndex = index
        let penid: String! = toPass["PenDetails"]![0]["penid"] as! String
        let fetchRequest1 = NSFetchRequest(entityName: "SingleAllocatedPen")
        let predicate1 = NSPredicate(format: "penid = '\(penid)'")
        fetchRequest1.predicate = predicate1
        fetchRequest1.returnsObjectsAsFaults = false
        fetchRequest1.fetchBatchSize = 20
        do {
            let results = try self.appDel.managedObjectContext.executeFetchRequest(fetchRequest1)
            if results.count > 0 {
                for i in 0 ..< results.count {
                    if let objTable: SingleAllocatedPen = results[i] as? SingleAllocatedPen
                    {
                        objTable.penid = self.dic_EmptyPens["FiveEmptyPens"]![self.MovedIndex]["penid"] as? String
                        objTable.namexx = self.dic_EmptyPens["FiveEmptyPens"]![self.MovedIndex]["namexx"] as? String
                        objTable.nameyy = self.dic_EmptyPens["FiveEmptyPens"]![self.MovedIndex]["nameyy"] as? String
                        objTable.pennodisp = "\(objTable.namexx!)-\(objTable.nameyy!)"
                        do
                        {
                            try self.appDel.managedObjectContext.save()
                            
                           
                            
                            
                        }
                        catch
                        {
                        }
                    }
                }
            }
            
        } catch {
            
        }

    }
    
    

    func addToEmptyPen(groupcode: String, grpnamedisp: String, namexx: String, nameyy: String, pennodisp: String, penid: String)
    {
        let fetchRequest = NSFetchRequest(entityName: "EmptyPensTable")
        var resultscount : Int = 0
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try appDel.managedObjectContext.executeFetchRequest(fetchRequest)
            resultscount = results.count
        }catch  {
            
        }
        
        var objCoreTable : EmptyPensTable!
        objCoreTable = (NSEntityDescription.insertNewObjectForEntityForName("EmptyPensTable", inManagedObjectContext: self.appDel.managedObjectContext) as! EmptyPensTable)
        objCoreTable.id = resultscount+1
        objCoreTable.groupcode = groupcode
        objCoreTable.grpnamedisp = grpnamedisp
        objCoreTable.namexx = namexx
        objCoreTable.nameyy = nameyy
        objCoreTable.pennodisp = pennodisp
        objCoreTable.penid = penid
        do {
            try self.appDel.managedObjectContext.save()
            self.DeleteFromEmptyTable()
        } catch {}
    }
    
    func DeleteFromEmptyTable()
    {
        let fetchRequest1 = NSFetchRequest(entityName: "EmptyPensTable")
        let predicate = NSPredicate(format: "penid == '\(self.dic_EmptyPens["FiveEmptyPens"]![MovedIndex]["penid"] as! String)'", argumentArray: nil)
        fetchRequest1.predicate = predicate
        fetchRequest1.returnsObjectsAsFaults = false
        fetchRequest1.fetchBatchSize = 20
        // delete records
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest1)
        
        do {
            try self.appDel.persistentStoreCoordinator.executeRequest(deleteRequest, withContext: self.appDel.managedObjectContext)
            do
            {
                try self.appDel.managedObjectContext.save()
                
            }
            catch{}
        } catch{}
        
        ///
    }
    
    
    func saveToUpdateMoveTable()
    {
        var objCoreTable: UpdateMoveToAnother!
        objCoreTable = (NSEntityDescription.insertNewObjectForEntityForName("UpdateMoveToAnother", inManagedObjectContext: self.appDel.managedObjectContext) as! UpdateMoveToAnother)
        objCoreTable.from_xx = toPass["PenDetails"]![0]["namexx"] as? String
        objCoreTable.from_yy = toPass["PenDetails"]![0]["nameyy"] as? String
        objCoreTable.from_penid = toPass["PenDetails"]![0]["penid"] as? String
        objCoreTable.to_penid = self.dic_EmptyPens["FiveEmptyPens"]![self.MovedIndex]["penid"] as? String
        objCoreTable.to_xx = self.dic_EmptyPens["FiveEmptyPens"]![self.MovedIndex]["namexx"] as? String
        objCoreTable.to_yy = self.dic_EmptyPens["FiveEmptyPens"]![self.MovedIndex]["nameyy"] as? String
        do {
            try self.appDel.managedObjectContext.save()
            
        } catch {
        }
        
    }
}
