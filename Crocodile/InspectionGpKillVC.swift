//
//  InspectionGpKillVC.swift
//  Crocodile
//
//  Created by Nibha Aggarwal on 6/2/16.
//  Copyright © 2016 Nibha Aggarwal. All rights reserved.
//

import UIKit
import CoreData

class InspectionGpKillVC: UIViewController, responseProtocol

{
    var toPassDic: NSMutableDictionary! = NSMutableDictionary()
    var objwebservice : webservice! = webservice()
    var objDatePicker : CalendarView! = CalendarView()
    var str_webservice: String!
    var pickerLabel: UILabel!
    var int_recheckValue: Int!
    var appDel : AppDelegate!
    let dateFormatter: NSDateFormatter = NSDateFormatter()
//    var imageVar: UIImage = UIImage(named: "Checkbox_NoTick")
    
    var array_condition: NSArray = ["P(Pits)", "W(Wrinkle)", "PIX(Pix)", "S(Scar)", "BS(Brown Spot)", "IS(Infected Sensor)", "Select All", "None"]
    var selecteditems: NSMutableArray! = []
    
    @IBOutlet var label_penDetail: UILabel!
    @IBOutlet var picker_recheck: UIPickerView!
    @IBOutlet var tabelview_Condition: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let controller = self.storyboard!.instantiateViewControllerWithIdentifier("CommonClassVC") as? CommonClassVC
            else {
                fatalError();
        }
        addChildViewController(controller)
        controller.view.frame = CGRectMake(0, 0, 1024, 768)
        controller.array_tableSection = ["inspection"]
        controller.array_sectionRow = [[]]
        view.addSubview(controller.view)
        view.sendSubviewToBack(controller.view)
        controller.label_header.text = "SP INSPECTION LIST"
        controller.IIndexPath = NSIndexPath(forRow: 0, inSection: 3)
        controller.array_temp_section.replaceObjectAtIndex(3, withObject: "Yes")
        controller.tableMenu.reloadData()

        objwebservice?.delegate = self
        objDatePicker = CalendarView.instanceFromNib() as! CalendarView
        
        appDel = (UIApplication.sharedApplication().delegate as! AppDelegate)
        
        label_penDetail.text = "\(toPassDic["groupcodedisp"] as! String) \(toPassDic["pennodisp"] as! String)"
        int_recheckValue = 1
        picker_recheck.reloadAllComponents()
        appDel.ForInspectionComes = "Back"
        
//        //////////
//        let fetchRequest = NSFetchRequest(entityName: "ConditionTable")
//        fetchRequest.returnsObjectsAsFaults = false
//        fetchRequest.fetchBatchSize = 20
//        fetchRequest.resultType = NSFetchRequestResultType.DictionaryResultType
//        do {
//            let results = try appDel.managedObjectContext.executeFetchRequest(fetchRequest)
//            array_condition = results
//        } catch{}
        
        print(array_condition)
        tabelview_Condition.reloadData()
        if array_condition.count != 0 {
            for _ in 0 ..< array_condition.count {
                selecteditems.addObject("NO")
            }
        }
        print(selecteditems)
        
        let str = "\(toPassDic["comment"] as! String)".stringByReplacingOccurrencesOfString("%20", withString: " ")
        let arraytemp = str.componentsSeparatedByString(", ")
        if arraytemp[0] == "" {
            selecteditems[array_condition.count-1] = "YES"
        }
        else
        {
            if (arraytemp.count == 6)
            {
                selecteditems[array_condition.count-2] = "YES"
            }
            for k in 0 ..< array_condition.count
            {
                
                for i in 0 ..< arraytemp.count
                {
                    if arraytemp[i] as String == array_condition[k] as! String {
                        let index1: Int = array_condition.indexOfObject(arraytemp[i] as String)
                        selecteditems[index1] = "YES"
                    }
                }
            }
        }
        
        tabelview_Condition.backgroundColor = UIColor.clearColor()
        tabelview_Condition.layer.cornerRadius = 2.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Webservice NetLost delegate
    func NetworkLost(str: String!)
    {
        if str == "netLost" {
            
            let alertView = UIAlertController(title: nil, message: Server.netLost, preferredStyle: .Alert)
            alertView.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
            self.presentViewController(alertView, animated: true, completion: nil)
            
            self.appDel.remove_HUD()
            self.view.userInteractionEnabled = true
        }
        else if (str == "noResponse")
        {
            let alertView = UIAlertController(title: nil, message: Server.ErrorMsg, preferredStyle: .Alert)
            alertView.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
            self.presentViewController(alertView, animated: true, completion: nil)
            
            self.appDel.remove_HUD()
            self.view.userInteractionEnabled = true
        }
    }
    
    //MARK: - Webservice Delegate
    func responseDictionary(dic: NSMutableDictionary) {
//        dispatch_async(dispatch_get_main_queue()) {
            if self.str_webservice == "movetokill_list" {
                print(dic)
                if dic["Message"] as! String == "Successfully added to kill list" {
                    
                    /*
                    //----Saving to databse//
                    var objKillTable: KillTable!
                    
                    let fetchRequest = NSFetchRequest(entityName: "KillTable")
                    fetchRequest.returnsObjectsAsFaults = false
                    
                    do
                    {
                        var start: String! = self.objDatePicker.todaydate().stringByReplacingOccurrencesOfString(" ", withString: "")
                        start = start.stringByReplacingOccurrencesOfString("/", withString: "-")
                        
                        let results = try self.appDel.managedObjectContext.executeFetchRequest(fetchRequest)
                        objKillTable = (NSEntityDescription.insertNewObjectForEntityForName("KillTable", inManagedObjectContext: self.appDel.managedObjectContext) as! KillTable)
                        objKillTable.id = results.count+1
                        objKillTable.groupcode = self.toPassDic["groupcode"] as? String
                        objKillTable.groupcodedisp = self.toPassDic["groupcodedisp"] as? String
                        objKillTable.killdate = start
//                        var intvaa : Int = Int(results[results.count]["killid"] as! String)!//objKillTable.killid! as String)!
//                        intvaa = intvaa + 1
//                        objKillTable.killid = String(intvaa)
                        objKillTable.killid = self.toPassDic["penid"] as? String
                        objKillTable.pennodisp = self.toPassDic["pennodisp"] as? String
                        objKillTable.offline = "NO"
                        do {
                            try self.appDel.managedObjectContext.save()
                        } catch {
                            // Replace this implementation with code to handle the error appropriately.
                            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                            //print("Unresolved error \(error), \(error.userInfo)")
                        }
                        
                        
                        
                    } catch {
                        
                    }
                    
                    
                    
                        
                    
                    //-----//
                    
                    */
                    let alertView = UIAlertController(title: nil, message: "Successfully Added To Kill List.", preferredStyle: .Alert)
                    let OKAction = UIAlertAction(title: "OK", style: .Cancel) { (action: UIAlertAction) in
                        // pop here
                        self.appDel.ForInspectionComes = "Killed"
                        self.navigationController?.popViewControllerAnimated(false)
                    }
                    alertView.addAction(OKAction)
                    self.presentViewController(alertView, animated: true, completion: nil)
                }
            }
            else if (self.str_webservice == "updateinspect")
            {
                var msg:String!
                if (dic["Message"] as! String == "Successfully Updated values for PEN")
                {
                    msg = "Successfully Updated Inspection Period."
                }
                else
                {
                    msg = "Invalid Pen Id\n Please Try Other."
                }
                let alertView = UIAlertController(title: nil, message: msg, preferredStyle: .Alert)
                let OKAction = UIAlertAction(title: "OK", style: .Cancel) { (action: UIAlertAction) in
                    // pop here
                    if msg == "Successfully Updated Inspection Period."
                    {
                        self.appDel.str_recheckPenId = "\(self.toPassDic["penid"] as! String)"
                        self.appDel.str_recheckCount = "\(self.int_recheckValue)"
                        self.appDel.ForInspectionComes = "Saved"
                        
                        self.navigationController?.popViewControllerAnimated(false)
                    }
                }
                alertView.addAction(OKAction)
                self.presentViewController(alertView, animated: true, completion: nil)
            }
//        }
//        dispatch_async(dispatch_get_main_queue()) {
            self.appDel.remove_HUD()
//        }
    }
    
    //MARK: - AddToKill Bn Action
    @IBAction func AddToKill(sender: AnyObject) {
//        dispatch_async(dispatch_get_main_queue()) {
            let alertView = UIAlertController(title: nil, message: "Are You Sure You Want To Add To Kill List?", preferredStyle: .Alert)
            alertView.addAction(UIAlertAction(title: "NO", style: .Cancel, handler: nil))
            alertView.addAction(UIAlertAction(title: "YES", style: .Default, handler: {(action:UIAlertAction) in
                if self.appDel.checkInternetConnection() {
                    self.DeleteFromSingleAllocatedPen(self.toPassDic["penid"] as! String, Offline: "NO", killedFrom: "Kill")
                    
                    self.AddToKillListService()
                }
                else
                {
                    self.DeleteFromSingleAllocatedPen(self.toPassDic["penid"] as! String, Offline: "YES", killedFrom: "Inspection")
                    
                    
                }
            }));
            self.presentViewController(alertView, animated: true, completion: nil)
            
//        }
    }
    
    
    
    func AddToKillListService()
    {
        appDel.Show_HUD()
        str_webservice = "movetokill_list";
        let request = NSMutableURLRequest(URL: NSURL(string: "\(Server.local_server)/api/sp_inspection/movetokill_list.php?")!)
        let postString = "penid=\(toPassDic["penid"] as! String)&addedby=\(NSUserDefaults.standardUserDefaults().objectForKey("email_username") as! String)&app_id=\(NSUserDefaults.standardUserDefaults().objectForKey("ApplicationIdentifier") as! String)"
        objwebservice.callServiceCommon(request, postString: postString)

    }
    
    
    //MARK: - Save Btn Action
    @IBAction func Save_btnAction(sender: AnyObject) {
        
        let temparray: NSMutableArray! = []
        for i in 0 ..< selecteditems.count {
            if !(selecteditems[i] as! String == "NO") {
                if array_condition[i] as! String == "None" {
                    temparray.addObject("")
                }
                else if array_condition[i] as! String == "Select All" {
                }
                else
                {
                    temparray.addObject(array_condition[i] as! String)
                }
                
            }
        }
        
        var comma: String!
        if temparray.count > 0 {
            comma = temparray.componentsJoinedByString(", ")
        }
        if comma == nil {
            let alertView = UIAlertController(title: nil, message: "Please Select Comment.", preferredStyle: .Alert)
            alertView.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
            self.presentViewController(alertView, animated: true, completion: nil)
            //            }
        }
        else
        {
            let alertView = UIAlertController(title: nil, message: "Are You Sure To Save?", preferredStyle: .Alert)
            alertView.addAction(UIAlertAction(title: "NO", style: .Cancel, handler: nil))
            alertView.addAction(UIAlertAction(title: "YES", style: .Default, handler: {(action:UIAlertAction) in
                if self.appDel.checkInternetConnection() {
                    self.SaveService(comma)
                }
                else
                {
                    var objCoreTable: RecheckTable!
                    self.appDel.managedObjectContext.persistentStoreCoordinator!.performBlock {
                        autoreleasepool {
                            objCoreTable = (NSEntityDescription.insertNewObjectForEntityForName("RecheckTable", inManagedObjectContext: self.appDel.managedObjectContext) as! RecheckTable)
                            objCoreTable.penid = self.toPassDic["penid"] as? String
                            objCoreTable.recheck = "\(self.int_recheckValue as Int)"
                            objCoreTable.recheck = objCoreTable.recheck!
                            if comma == ""
                            {
                                objCoreTable.commentCondition = ""
                            }
                            else
                            {
                                objCoreTable.commentCondition = comma
                            }
                            
                            print(objCoreTable.recheck!)
                            objCoreTable.offline = "YES"
                        }
                        do
                        {
                            try self.appDel.managedObjectContext.save()
                            NSOperationQueue.mainQueue().addOperationWithBlock({
                                //////////
                                self.recheckoffline(comma)
                            })
                        } catch {
                        }
                    }
                }
            }));
            self.presentViewController(alertView, animated: true, completion: nil)
        }
        
    }
    
    
    
    
    func SaveService(comma: String!)
    {
        appDel.str_recheckPenId = ""
        appDel.str_recheckCount = ""
        
        appDel.Show_HUD()
        str_webservice = "updateinspect";
        
      
        self.recheckoffline(comma)
        
        let request = NSMutableURLRequest(URL: NSURL(string: "\(Server.local_server)/api/sp_update/updaterecheckcomment.php?")!)
        let postString = "penid=\(toPassDic["penid"] as! String)&recheck=\(int_recheckValue)&comment=\(comma)&app_id=\(NSUserDefaults.standardUserDefaults().objectForKey("ApplicationIdentifier") as! String)"
        objwebservice.callServiceCommon(request, postString: postString)
    }
    
    // MARK: -  tableview Delegates
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(array_condition.count)
        return array_condition.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 40.0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        
        cell.backgroundColor = UIColor.clearColor()
        cell.contentView.backgroundColor = UIColor.clearColor()
        
        //view Backgd
        let view_bg: UIView = UIView(frame: CGRectMake(0, 0, 250, 75))
        if indexPath.row % 2 == 0 {
            view_bg.backgroundColor = UIColor.redColor()
        }
        else {
            view_bg.backgroundColor = UIColor(red: 233.0 / 255.0, green: 102 / 255.0, blue: 119 / 255.0, alpha: 1.0)
        }
        
        
//        //label_Grp
        let label_Grp: UILabel = UILabel(frame: CGRectMake(20, 5, 200, 100))
        label_Grp.textAlignment = .Center
        label_Grp.font = UIFont(name: "HelveticaNeue", size: 22)
        label_Grp.text = array_condition.objectAtIndex(indexPath.row) as? String
        
        cell.textLabel?.text = array_condition.objectAtIndex(indexPath.row) as? String
        cell.textLabel!.font = UIFont(name: "HelveticaNeue", size: 22)

        if (selecteditems[indexPath.row] as! String == "NO") {
            cell.accessoryType = .None
        }
        else {
            cell.accessoryType = .Checkmark
        }
        
        
        
        
//        let img_check: UIImageView = UIImageView(frame: CGRectMake(210, 5, 25, 25))
//        if (selecteditems[indexPath.row] as! String == "NO") {
////            btn_check.setImage(UIImage(named: "Checkbox_NoTick"), forState: .Normal)
//            img_check.image = UIImage(named: "Checkbox_NoTick")
//        }
//        else {
////            btn_check.setImage(UIImage(named: "Checkbox_tick"), forState: .Normal)
//            img_check.image = UIImage(named: "Checkbox_tick")
//        }
//       
//        view_bg.addSubview(label_Grp)
//        cell.contentView.addSubview(view_bg)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        print(tableView.subviews.)
        let cell:UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        print(cell.subviews.description)
        
        
        if tableView.cellForRowAtIndexPath(indexPath)!.accessoryType == .Checkmark {
            tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = .None
            selecteditems[indexPath.row] = "NO"
            
            if indexPath.row != array_condition.count-1 {
                //for unselected last row
                let indexPath1 = NSIndexPath(forRow: array_condition.count-2, inSection: 0)
                tableView.cellForRowAtIndexPath(indexPath1)?.accessoryType = .None
                selecteditems[array_condition.count-2] = "NO"
            }
        }
        else {
            // for Select All
            if indexPath.row == array_condition.count-2 {
                for i in 0 ..< array_condition.count-1
                {
                    let indexPath = NSIndexPath(forRow: i, inSection: 0)
                    tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = .Checkmark
                    if i == array_condition.count - 2 {
                        selecteditems[i] = "YES"
                    }
                    else
                    {
                        selecteditems[i] = array_condition[i]
                    }
                    
                    print(selecteditems)
                }
                //for unselected last row
                let indexPath1 = NSIndexPath(forRow: array_condition.count-1, inSection: 0)
                tableView.cellForRowAtIndexPath(indexPath1)?.accessoryType = .None
                selecteditems[array_condition.count-1] = "NO"
            }
                //None
            else if indexPath.row == array_condition.count-1
            {
                for i in 0 ..< array_condition.count-1
                {
                    let indexPath = NSIndexPath(forRow: i, inSection: 0)
                    tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = .None
                    selecteditems[i] = "NO"
                }
                //select last row
                tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = .Checkmark
                selecteditems[indexPath.row] = "" //array_condition[indexPath.row]
            }
            else  // Other selections
            {
                tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = .Checkmark
                selecteditems[indexPath.row] = array_condition[indexPath.row]
                
//                //for unselected last row
                let indexPath1 = NSIndexPath(forRow: array_condition.count-1, inSection: 0)
                tableView.cellForRowAtIndexPath(indexPath1)?.accessoryType = .None
                selecteditems[array_condition.count-1] = "NO"
                
                /*
                //if selected all rows then select "All Select"
                var count: Int! = 0
                for i in 0 ..< selecteditems.count-2 {
                    if selecteditems[i] as! String != "NO" {
                        count = count+1
                    }
                }
                if count == 6 {
                    let indexPath = NSIndexPath(forRow: array_condition.count-2, inSection: 0)
                    tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = .Checkmark
                    selecteditems[array_condition.count-2] = "YES"
                }
                */
            }
            
        }
    }

    
    
    // MARK: - PickerView Delegates
    func numberOfComponentsInPickerView(pickerView: UIPickerView!) -> Int{
        return 1
    }
    
    // returns the # of rows in each component..
    func pickerView(pickerView: UIPickerView!, numberOfRowsInComponent component: Int) -> Int{
        return 12
    }
    
    
    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 57
    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView) -> UIView {
        pickerLabel = (view as! UILabel)
        if pickerLabel == nil {
            let frame: CGRect = CGRectMake(10, 0, 250, 65)
            pickerLabel = UILabel(frame: frame)
            pickerLabel.textAlignment = .Center
            pickerLabel.backgroundColor = UIColor.clearColor()
            pickerLabel.textColor = UIColor.whiteColor()
            pickerLabel.font = UIFont(name: "HelveticaNeue", size: 35)
        }
        
        pickerLabel.text = "\(row+1)"
        return pickerLabel
    }
    
    func pickerView(pickerView: UIPickerView!, didSelectRow row: Int, inComponent component: Int)
    {
        int_recheckValue = row+1
    }
    
    
    //MARK: - Offline Methods
    func recheckoffline(comma: String!)
    {
        let fetchRequest1 = NSFetchRequest(entityName: "SingleAllocatedPen")
        let predicate1 = NSPredicate(format: "penid = '\(self.toPassDic["penid"] as! String)'")
        fetchRequest1.predicate = predicate1
        fetchRequest1.returnsObjectsAsFaults = false
        fetchRequest1.fetchBatchSize = 20
        do {
            let results = try self.appDel.managedObjectContext.executeFetchRequest(fetchRequest1)
            if results.count > 0 {
                for i in 0 ..< results.count {
                    if let objTable: SingleAllocatedPen = results[i] as? SingleAllocatedPen {
                        objTable.recheckcount = "\(self.int_recheckValue)"
                        objTable.comment = "\(comma)"
                        if comma == "" {
                            objTable.ispink = "0"
                        }
                        else
                        {
                            objTable.ispink = "1"
                        }
                        do
                        {
                            try self.appDel.managedObjectContext.save()
                            if comma == "" {
                                self.appDel.str_conditioncomment = ""
                            }
                            else
                            {
                                self.appDel.str_conditioncomment = comma
                            }
                            if self.appDel.checkInternetConnection()
                            {}
                            else
                            {
                                let alertView = UIAlertController(title: nil, message: "Successfully Updated Inspection Period.", preferredStyle: .Alert)
                                let OKAction = UIAlertAction(title: "OK", style: .Cancel) { (action: UIAlertAction) in
                                    // pop here
                                    self.appDel.str_recheckPenId = "\(self.toPassDic["penid"] as! String)"
                                    self.appDel.str_recheckCount = "\(self.int_recheckValue)"
                                    
                                    
                                    self.appDel.ForInspectionComes = "Saved"
                                    self.navigationController?.popViewControllerAnimated(false)
                                }
                                alertView.addAction(OKAction)
                                self.presentViewController(alertView, animated: true, completion: nil)
                            }
                            
                        }
                        catch{}
                    }
                }
                
                
            }
            
        } catch {
            
        }
    }

    
    func DeleteFromSingleAllocatedPen(strPenIds: String!, Offline: String!, killedFrom: String!)
    {
        let arraytemp = strPenIds.componentsSeparatedByString(",")
        print(arraytemp)
        let fetchRequest = NSFetchRequest(entityName: "SingleAllocatedPen")
        let predicate = NSPredicate(format: "penid = '\(strPenIds)'")
        fetchRequest.predicate = predicate
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.fetchBatchSize = 20
        do
        {
            let results = try self.appDel.managedObjectContext.executeFetchRequest(fetchRequest)
            if results.count > 0 {
                self.InsertToKill(self.toPassDic as NSMutableDictionary, Offline: Offline, killedFrom: killedFrom)
                
            }
            
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            do {
                try self.appDel.persistentStoreCoordinator.executeRequest(deleteRequest, withContext: self.appDel.managedObjectContext)
                do
                {
                    try self.appDel.managedObjectContext.save()
                    
                    
                }
                catch{}
            } catch{}
            
//            for managedObject in results
//            {
//                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
//                self.appDel.managedObjectContext.deleteObject(managedObjectData)
//            }
//            do {
//                try self.appDel.managedObjectContext.save()
//            } catch {}
        } catch {
            
        }
        //        dispatch_async(dispatch_get_main_queue()) {
                //        }
        
        
    }

    
    func InsertToKill(arrayTemp: NSMutableDictionary!, Offline: String!, killedFrom: String!)
    {
        var objKillTable: KillTable!
        
        let fetchRequest = NSFetchRequest(entityName: "KillTable")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.fetchBatchSize = 20
        do
        {
            print(arrayTemp)
            
            let results = try self.appDel.managedObjectContext.executeFetchRequest(fetchRequest)
            objKillTable = (NSEntityDescription.insertNewObjectForEntityForName("KillTable", inManagedObjectContext: self.appDel.managedObjectContext) as! KillTable)
            objKillTable.id = results.count+1
            objKillTable.groupcode = "\(arrayTemp["groupcode"] as! String)"
            objKillTable.groupcodedisp = "\(arrayTemp["groupcodedisp"] as! String)"
            objKillTable.killdate = self.todaydate().stringByReplacingOccurrencesOfString(" ", withString: "") as String
            objKillTable.killid = "\(arrayTemp["penid"] as! String)"
            objKillTable.pennodisp = "\(arrayTemp["pennodisp"] as! String)"
            objKillTable.offline = Offline
            objKillTable.killedFrom = killedFrom
            objKillTable.recheck_count = "\(arrayTemp["recheckcount"] as! String)"
            objKillTable.sp_size = "\(arrayTemp["skin_size"] as! String)"
            objKillTable.inspect_date = "\(arrayTemp["entrydate"] as! String)"
            objKillTable.entry_date = "\(arrayTemp["dateadded"] as! String)"
            objKillTable.ispink = "\(arrayTemp["ispink"] as! String)"
            objKillTable.comment = "\(arrayTemp["comment"] as! String)"
            do {
                try self.appDel.managedObjectContext.save()
                let alertView = UIAlertController(title: nil, message: "Successfully Added To Kill List.", preferredStyle: .Alert)
                let OKAction = UIAlertAction(title: "OK", style: .Cancel) { (action: UIAlertAction) in
                    // pop here
                    self.appDel.ForInspectionComes = "Killed"
                    self.navigationController?.popViewControllerAnimated(false)
                }
                alertView.addAction(OKAction)
                self.presentViewController(alertView, animated: true, completion: nil)
            } catch {}
        }catch {
            
        }
        
        
    }
    
    
    func todaydate() -> NSString
    {
        
        let twelveHourLocale: NSLocale = NSLocale(localeIdentifier: "en_US_POSIX")
        dateFormatter.locale = twelveHourLocale
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let todayDate: String = "  \(dateFormatter.stringFromDate(NSDate()))"
        return todayDate
    }
}
