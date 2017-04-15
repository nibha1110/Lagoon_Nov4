//
//  AddOutsideSinglePenVC.swift
//  Crocodile
//
//  Created by Nibha Aggarwal on 16/11/16.
//  Copyright © 2016 Nibha Aggarwal. All rights reserved.
//

import UIKit
import CoreData

class AddOutsideSinglePenVC: UIViewController, responseProtocol, CommentConditionProtocol{
    var appDel : AppDelegate!
    var objwebservice : webservice! = webservice()
    var objCommentCondition : CommentConditionView! = CommentConditionView()
    var objCoreData: CoreDataQueryClass! = CoreDataQueryClass()
    var objDatePicker : CalendarView! = CalendarView()
    var toPass_array: NSMutableDictionary! = NSMutableDictionary()
    var str_condition: String!
    var str_inspection: String!
    var str_grader: String!
    var str_Skin: String!
    var str_webservice:String!
    var pickerLabel: UILabel!
    var str_comment: String!
    var str_grpUpdate: String!
    
    var Bool_comment: Bool = false
    
    var dic_condition:NSMutableDictionary! = NSMutableDictionary()
    var dic_inspect:NSMutableDictionary! = NSMutableDictionary()
    var dic_username:NSMutableDictionary! = NSMutableDictionary()
    var array_SkinSize: NSMutableArray! = []
    var array_temp : NSMutableArray = []
    var arrayCoredta: [AnyObject] = []
    
    let dateFormatter: NSDateFormatter = NSDateFormatter()
    
    @IBOutlet weak var pickerview_conditions: UIPickerView!
    @IBOutlet weak var pickerview_inspected: UIPickerView!
    @IBOutlet weak var pickerview_UserName: UIPickerView!
    @IBOutlet weak var pickerview_Skin: UIPickerView!
    @IBOutlet weak var Label_showPens: UILabel!
    @IBOutlet weak var textView_details: UITextView!
    @IBOutlet weak var view_details: UIView!
    @IBOutlet weak var img_details: UIImageView!
    var keyboardWillHide: Bool! = false
    var bool_textfield: Bool! = false
    
    
    
    
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print(toPass_array)
        
        str_comment = ""
        appDel = (UIApplication.sharedApplication().delegate as! AppDelegate)
        
        guard let controller = self.storyboard!.instantiateViewControllerWithIdentifier("CommonClassVC") as? CommonClassVC
            else {
                fatalError();
        }
        addChildViewController(controller)
        controller.view.frame = CGRectMake(0, 0, 1024, 768)
        controller.array_tableSection = ["add"]
        controller.array_sectionRow = [["SP_ADD_unselected", "Load_to_trailer", "Trailer_to SP_unselected", "All_empty_pens", "Add_animal_unselected"]]
        view.addSubview(controller.view)
        view.sendSubviewToBack(controller.view)
        controller.label_header.text = "ADD OUTSIDE ANIMAL"
        
        controller.IIndexPath = NSIndexPath(forRow: 4, inSection: 2)
        controller.array_temp_section.replaceObjectAtIndex(2, withObject: "Yes")
        controller.tableMenu.reloadData()
        
        let arrt = controller.array_temp_row[2]
        arrt.replaceObjectAtIndex(4, withObject: "Yes")
        
        array_SkinSize = controller.array_Skin
        array_SkinSize.replaceObjectAtIndex(0, withObject: "SelectSize")
        objwebservice?.delegate = self
        
        objCommentCondition = CommentConditionView.instanceFromNib() as! CommentConditionView
        objCommentCondition?.delegate = self
        objCommentCondition.selecteditems.removeAllObjects()
        objCommentCondition.drawRect(CGRectMake(640, 160, 318, 231))
        
        appDel.ForSPAddOutsideComes = "Back"
        // Keyboard Hide
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.keyboardWillShow), name: UIKeyboardWillHideNotification, object: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func viewDidAppear(animated: Bool) {
        Label_showPens.text = "\(toPass_array["grpnamedisp"] as! String) - \(toPass_array["pennodisp"] as! String)"
        
        self.str_Skin = array_SkinSize[0] as! String
        self.pickerview_Skin.selectRow(0, inComponent: 0, animated: true)
        self.pickerview_Skin.reloadAllComponents()
        
        
        if NSUserDefaults.standardUserDefaults().objectForKey("array_saveOutsideValue") != nil {
            if (NSUserDefaults.standardUserDefaults().objectForKey("array_saveOutsideValue")?.mutableCopy() as! NSMutableArray).count > 0 {
                array_temp = NSUserDefaults.standardUserDefaults().objectForKey("array_saveOutsideValue")?.mutableCopy() as! NSMutableArray
                if array_temp.count == 0
                {
                    str_grader = "0"
                    str_inspection = "1"
                }
                else{
                    
                    str_grader = array_temp[0] as! String
                    str_inspection = array_temp[1] as! String
                }
            }
        }
        else
        {
            str_grader = "0"
            str_inspection = "1"
            let array_saveValue:NSMutableArray = []
            array_saveValue.addObject("\(self.str_grader)")
            array_saveValue.addObject("\(self.str_inspection)")
            
            let userDefaults = NSUserDefaults.standardUserDefaults()
            userDefaults.setValue(array_saveValue, forKey: "array_saveOutsideValue")
            userDefaults.synchronize()
            array_temp = NSUserDefaults.standardUserDefaults().objectForKey("array_saveOutsideValue")?.mutableCopy() as! NSMutableArray
        }
        
        
        
        if self.appDel.checkInternetConnection()
        {
            self.GetAllGeneralDetailService()
        }
        else
        {
            var fetchRequest = NSFetchRequest(entityName: "ConditionTable")
            fetchRequest.returnsObjectsAsFaults = false
            //fetchRequest.includesPropertyValues = false
            fetchRequest.fetchBatchSize = 20
            fetchRequest.resultType = NSFetchRequestResultType.DictionaryResultType
            do {
                let results = try appDel.managedObjectContext.executeFetchRequest(fetchRequest)
                self.dic_condition.setValue(results, forKey: "Condition_data")
                self.str_condition = self.dic_condition["Condition_data"]![0]["conditionid"] as! String
                self.pickerview_conditions.selectRow(0, inComponent: 0, animated: true)
                self.pickerview_conditions.reloadAllComponents()
            } catch let error as NSError {
                print("Fetch failed: \(error.localizedDescription)")
            }
            
            //Inspection
            fetchRequest = NSFetchRequest(entityName: "InspectionPeriodTable")
            fetchRequest.returnsObjectsAsFaults = false
            //fetchRequest.includesPropertyValues = false
            fetchRequest.fetchBatchSize = 20
            fetchRequest.resultType = NSFetchRequestResultType.DictionaryResultType
            do {
                let results = try appDel.managedObjectContext.executeFetchRequest(fetchRequest)
                self.dic_inspect.setValue(results, forKey: "inspection_data")
                
                self.str_inspection = dic_inspect["inspection_data"]![0]["inspect_id"] as! String
                self.pickerview_inspected.selectRow(0, inComponent: 0, animated: true)
                self.pickerview_inspected.reloadAllComponents()
                
                autoreleasepool{
                    for i in 0 ..< 16 {
                        if str_inspection ==  dic_inspect["inspection_data"]![i]["inspect_id"] as! String{
                            self.str_inspection = dic_inspect["inspection_data"]![i]["inspect_id"] as! String
                            print(self.str_inspection)
                            self.pickerview_inspected.selectRow(i, inComponent: 0, animated: true)
                            self.pickerview_inspected.reloadAllComponents()
                            break
                        }
                    }
                }
            } catch let error as NSError {
                print("Fetch failed: \(error.localizedDescription)")
            }
            
            //grader
            fetchRequest = NSFetchRequest(entityName: "GraderTable")
            fetchRequest.returnsObjectsAsFaults = false
            //fetchRequest.includesPropertyValues = false
            fetchRequest.fetchBatchSize = 20
            fetchRequest.resultType = NSFetchRequestResultType.DictionaryResultType
            do {
                let results = try appDel.managedObjectContext.executeFetchRequest(fetchRequest)
                self.dic_username.setValue(results, forKey: "grader_data")
                if dic_username["grader_data"]?.count != 0 {
                    let count:Int = (dic_username["grader_data"]?.count)!
                    self.str_grader = dic_username["grader_data"]![0]["grader_id"] as! String
                    self.pickerview_UserName.selectRow(0, inComponent: 0, animated: true)
                    self.pickerview_UserName.reloadAllComponents()
                    
                    for i in 0 ..< count {
                        if str_grader ==  dic_username["grader_data"]![i]["grader_id"] as! String{
                            self.str_grader = dic_username["grader_data"]![i]["grader_id"] as! String
                            self.pickerview_UserName.selectRow(i, inComponent: 0, animated: true)
                            self.pickerview_UserName.reloadAllComponents()
                        }
                    }
                }
                
            } catch let error as NSError {
                print("Fetch failed: \(error.localizedDescription)")
            }
            
            //grader end
            
            self.appDel.remove_HUD()
        }
    }
    
    //MARK: - ALL Response
    func conditionResponse(dic: NSMutableDictionary)
    {
        //----Saving to databse//
        if (true) {
            var objCoreTable: ConditionTable!
            
            let fetchRequest = NSFetchRequest(entityName: "ConditionTable")
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
            
            ///
            
            for i in 0 ..< (dic["general_details"]![0]["Condition_data"]!!.count)!{
                objCoreTable = (NSEntityDescription.insertNewObjectForEntityForName("ConditionTable", inManagedObjectContext: self.appDel.managedObjectContext) as! ConditionTable)
                objCoreTable.id = i
                objCoreTable.conditionid = dic["general_details"]![0]["Condition_data"]!![i]["conditionid"] as? String
                objCoreTable.conditionname = dic["general_details"]![0]["Condition_data"]!![i]["conditionname"] as? String
                do {
                    try self.appDel.managedObjectContext.save()
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    //print("Unresolved error \(error), \(error.userInfo)")
                }
                
            }
        }
        //-----//
        
        
        
        self.dic_condition = dic["general_details"]![0] as AnyObject as! NSMutableDictionary
        self.str_condition = dic["general_details"]![0]["Condition_data"]!![0]["conditionid"] as! String
        self.pickerview_conditions.selectRow(0, inComponent: 0, animated: true)
        self.pickerview_conditions.reloadAllComponents()
    }
    
    func inspectionResponse(dic: NSMutableDictionary)
    {
        //----Saving to databse//
        if (true) {
            var objCoreTable: InspectionPeriodTable!
            
            let fetchRequest = NSFetchRequest(entityName: "InspectionPeriodTable")
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
            
            ///
            
            for i in 0 ..< (dic["general_details"]![1]["inspection_data"]!!.count)!{
                objCoreTable = (NSEntityDescription.insertNewObjectForEntityForName("InspectionPeriodTable", inManagedObjectContext: self.appDel.managedObjectContext) as! InspectionPeriodTable)
                objCoreTable.id = i
                objCoreTable.inspect_id = dic["general_details"]![1]["inspection_data"]!![i]["inspect_id"] as? String
                objCoreTable.inspect_period = dic["general_details"]![1]["inspection_data"]!![i]["inspect_period"] as? String
                do {
                    try self.appDel.managedObjectContext.save()
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    //print("Unresolved error \(error), \(error.userInfo)")
                }
                
            }
            
        }
        //-----//
        
        
        self.dic_inspect = dic["general_details"]![1] as AnyObject as! NSMutableDictionary
        if dic["general_details"]![1]["inspection_data"]!!.count > 7 {
            
            self.str_inspection = dic["general_details"]![1]["inspection_data"]!![0]["inspect_id"] as! String
            self.pickerview_inspected.selectRow(0, inComponent: 0, animated: true)
            self.pickerview_inspected.reloadAllComponents()
            print(array_temp)
            for i in 0 ..< 16 {
                if array_temp[1] as! String ==  dic["general_details"]![1]["inspection_data"]!![i]["inspect_id"] as! String{
                    self.str_inspection = dic["general_details"]![1]["inspection_data"]!![i]["inspect_id"] as! String
                    print(self.str_inspection)
                    self.pickerview_inspected.selectRow(i, inComponent: 0, animated: true)
                    self.pickerview_inspected.reloadAllComponents()
                    break
                }
            }
        }
        
    }
    
    func graderResponse(dic: NSMutableDictionary)
    {
        //----Saving to databse//
        if (true)
        {
            var objCoreTable: GraderTable!
            
            let fetchRequest = NSFetchRequest(entityName: "GraderTable")
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
            
            ///
            
            for i in 0 ..< (dic["general_details"]![2]["grader_data"]!!.count)!{
                objCoreTable = (NSEntityDescription.insertNewObjectForEntityForName("GraderTable", inManagedObjectContext: self.appDel.managedObjectContext) as! GraderTable)
                objCoreTable.id = i
                objCoreTable.grader_id = dic["general_details"]![2]["grader_data"]!![i]["grader_id"] as? String
                objCoreTable.fname = dic["general_details"]![2]["grader_data"]!![i]["fname"] as? String
                objCoreTable.lname = dic["general_details"]![2]["grader_data"]!![i]["lname"] as? String
                do {
                    try self.appDel.managedObjectContext.save()
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    //print("Unresolved error \(error), \(error.userInfo)")
                }
                
            }
            
        }
        //-----//
        
        
        
        self.dic_username = dic["general_details"]![2] as AnyObject as! NSMutableDictionary
        if dic["general_details"]![2]["grader_data"]!!.count != 0 {
            
            let count:Int = (dic["general_details"]![2]["grader_data"]!!.count)!
            self.str_grader = dic["general_details"]![2]["grader_data"]!![0]["grader_id"] as! String
            self.pickerview_UserName.selectRow(0, inComponent: 0, animated: true)
            self.pickerview_UserName.reloadAllComponents()
            
            for i in 0 ..< count {
                if array_temp[0] as! String ==  dic["general_details"]![2]["grader_data"]!![i]["grader_id"] as! String{
                    self.str_grader = dic["general_details"]![2]["grader_data"]!![i]["grader_id"] as! String
                    self.pickerview_UserName.selectRow(i, inComponent: 0, animated: true)
                    self.pickerview_UserName.reloadAllComponents()
                }
            }
        }
        else
        {
            self.str_grader = "No Grader"
            self.pickerview_UserName.selectRow(0, inComponent: 0, animated: true)
            self.pickerview_UserName.reloadAllComponents()
        }
        
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
        if (self.str_webservice == "getgeneraldetails")
        {
            self.conditionResponse(dic)
            self.inspectionResponse(dic)
            self.graderResponse(dic)
            
        }
            
        else if self.str_webservice == "sp_add_outside"
        {
            var msg:String!
            if (dic["success"] as! String == "False" || dic["Message"] as! String == "Pen already allocated. Select another pen")
            {
                msg = "Pen Already Allocated\n Please Select Another Pen."
                
            }
            else if (dic["success"] as! String == "True")
            {
                msg = "Record Has Been Saved Successfully."
            }
            
            let alertView = UIAlertController(title: nil, message: msg, preferredStyle: .Alert)
            let OKAction = UIAlertAction(title: "OK", style: .Cancel) { (action: UIAlertAction) in
                // pop here
                if msg == "Record Has Been Saved Successfully."
                {
                    // updating to databse
                    let fetchRequest = NSFetchRequest(entityName: "AnimalsCountTable")
                    let predicate = NSPredicate(format: "count_namexx = '\(self.toPass_array["namexx"] as! String)' and count_nameyy = '\(self.toPass_array["nameyy"] as! String)'")
                    fetchRequest.predicate = predicate
                    fetchRequest.returnsObjectsAsFaults = false
                    do {
                        let results = try self.appDel.managedObjectContext.executeFetchRequest(fetchRequest)
                        if results.count != 0 {
                            if let objTable: AnimalsCountTable = results[0] as? AnimalsCountTable {                                            objTable.offline = "NO"
                                var intvaa : Int = (objTable.total_animals?.toInteger())!
                                intvaa = intvaa - 1
                                objTable.total_animals = String(intvaa)
                                
                                do {
                                    try self.appDel.managedObjectContext.save()
                                    
                                    
                                } catch {
                                }
                            }
                        }
                    } catch{}
                    
                    
                    
                    //----Saving to databse//
//                    for i in 1 ..< 4
//                    {
//                        if (self.toPass_array["grpnamedisp"] as! String == "GRP\(i)-PEN# ")
//                        {
                            if (true) {
                                self.str_grpUpdate = "\(self.toPass_array["grpnamedisp"] as! String)"
                                let fetchRequest1 = NSFetchRequest(entityName: "EmptyPensTable")
                                let predicate = NSPredicate(format: "penid == '\(self.toPass_array["penid"] as! String)'", argumentArray: nil)
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
                            
//                        }
//                    }
                    
                    
                    
                    if (true)
                    {
                        var objCoreTable: SingleAllocatedPen!
                        objCoreTable = (NSEntityDescription.insertNewObjectForEntityForName("SingleAllocatedPen", inManagedObjectContext: self.appDel.managedObjectContext) as! SingleAllocatedPen)
                        print(self.toPass_array)
                        objCoreTable.pennodisp = self.toPass_array["pennodisp"] as? String
                        objCoreTable.namexx = self.toPass_array["namexx"] as? String
                        objCoreTable.nameyy = self.toPass_array["nameyy"] as? String
                        objCoreTable.pennodisp = "\(objCoreTable.namexx!)-\(objCoreTable.nameyy!)"
                        objCoreTable.penid = self.toPass_array["penid"] as? String
                        objCoreTable.skin_size = self.str_Skin
                        objCoreTable.recheckcount = "0"
                        objCoreTable.int_recheckcount = objCoreTable.recheckcount?.toInteger()
                        objCoreTable.state = "NO"
                        objCoreTable.groupcode = self.toPass_array["groupcode"] as? String
                        objCoreTable.groupcodedisp = "\(objCoreTable.groupcode!) -PEN#"
                        objCoreTable.comment = self.toPass_array["comment"] as? String
                        
                        print("\(self.todaydate())")
                        objCoreTable.dateadded = self.todaydate() as String
                        
                        
                        // to adding months in entry date
                        let monthsCount: Int! = Int(self.str_inspection)
                        objCoreTable.entrydate = self.months_BetweenDate(objCoreTable.dateadded, recheck: monthsCount) as String
                        objCoreTable.entryConvert = self.Databse_dateconvertor(objCoreTable.entrydate)
                        objCoreTable.addedConvert = self.Databse_dateconvertor(objCoreTable.dateadded)
                        objCoreTable.colorcode = "BLACK"
                        objCoreTable.ispink = "0"
                        print(objCoreTable)
                        do {
                            try self.appDel.managedObjectContext.save()
                            
                        } catch {}
                    }
                    
                    
                    self.UpDateTableEvent(self.str_grpUpdate)
                    
                    
                    //
                    let array_saveValue:NSMutableArray = []
                    array_saveValue.addObject("\(self.str_grader)")
                    array_saveValue.addObject("\(self.str_inspection)")
                    
                    let userDefaults = NSUserDefaults.standardUserDefaults()
                    userDefaults.setValue(array_saveValue, forKey: "array_saveOutsideValue")
                    userDefaults.synchronize()
                    
                    print(array_saveValue)
                    
                    for controller in self.navigationController!.viewControllers as Array {
                        if controller.isKindOfClass(AddOutsideGroupVC) {
                            self.appDel.ForSPAddOutsideComes = "Saved"
                            self.navigationController?.popToViewController(controller as UIViewController, animated: false)
                        }
                    }
                }
            }
            alertView.addAction(OKAction)
            self.presentViewController(alertView, animated: true, completion: nil)
        }
        self.appDel.remove_HUD()
        //        }
    }
    
    //MARK: - get All Data
    func GetAllGeneralDetailService()
    {
        if self.appDel.checkInternetConnection()
        {
            str_webservice = "getgeneraldetails"
            appDel.Show_HUD()
            let request = NSMutableURLRequest(URL: NSURL(string: "\(Server.local_server)/api/singlepen/getgeneraldetails.php")!)
            let postString = ""
            objwebservice.callServiceCommon(request, postString: postString)
        }
       
    }
    
    
    // MARK: - PickerView Delegates
    func numberOfComponentsInPickerView(pickerView: UIPickerView!) -> Int{
        return 1
    }
    
    // returns the # of rows in each component..
    func pickerView(pickerView: UIPickerView!, numberOfRowsInComponent component: Int) -> Int{
        if pickerView == pickerview_conditions {
            if dic_condition.count != 0 {
                return (dic_condition["Condition_data"]?.count)!
            }
        }
        else if pickerView == pickerview_inspected {
            if dic_inspect.count != 0 {
                return (dic_inspect["inspection_data"]?.count)!
            }
            
        }
        else if pickerView == pickerview_UserName {
            if dic_username.count != 0 {
                return (dic_username["grader_data"]?.count)!
            }
            
        }
        else if pickerView == pickerview_Skin {
            if array_SkinSize.count != 0 {
                return (array_SkinSize?.count)!
            }
            
        }
        return 0
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
            pickerLabel.font = UIFont(descriptor: UIFontDescriptor(name: "HelveticaNeue", size: 32), size: 32.0)
        }
        if pickerView == pickerview_conditions {
            pickerLabel.text = dic_condition["Condition_data"]![row]["conditionname"] as? String
            if row == 2 {
                pickerLabel.font = UIFont(descriptor: UIFontDescriptor(name: "HelveticaNeue", size: 27), size: 27)
            }
        }
        else if pickerView == pickerview_inspected {
            pickerLabel.text = dic_inspect["inspection_data"]![row]["inspect_period"] as? String
        }
        else if pickerView == pickerview_UserName {
            
            pickerLabel.text = (dic_username["grader_data"]![row]["fname"] as! String)+" "+(dic_username["grader_data"]![row]["lname"] as! String)
        }
            
        else if pickerView == pickerview_Skin {
            
            pickerLabel.text = (array_SkinSize[row] as! String)
            if pickerLabel.text == "SelectSize"
            {
                pickerLabel.font = UIFont(descriptor: UIFontDescriptor(name: "HelveticaNeue", size: 23), size: 23)
            }
        }
        return pickerLabel
        
        
    }
    
    
    
    func pickerView(pickerView: UIPickerView!, didSelectRow row: Int, inComponent component: Int)
    {
        if pickerView == pickerview_conditions {
            str_condition = dic_condition["Condition_data"]![row]["conditionid"] as! String
        }
        else if pickerView == pickerview_inspected {
            str_inspection = dic_inspect["inspection_data"]![row]["inspect_id"] as! String
        }
        else if pickerView == pickerview_UserName {
            
            str_grader = dic_username["grader_data"]![row]["grader_id"] as! String
        }
        else if pickerView == pickerview_Skin {
            
            str_Skin = array_SkinSize![row] as! String
        }
    }
    
    //MARK: - Save_btn
    @IBAction func Save_btnAction(sender: AnyObject) {
 
        let alertView = UIAlertController(title: nil, message: "Are You Sure You Want To Save It In The System?", preferredStyle: .Alert)
        alertView.addAction(UIAlertAction(title: "NO", style: .Cancel, handler: nil))
        alertView.addAction(UIAlertAction(title: "YES", style: .Default, handler: {(action:UIAlertAction) in
            self.AddingToSinglePenService()
        }));
        self.presentViewController(alertView, animated: true, completion: nil)
        //            }
        //        }
    }
    
    
    //MARK: -AddingToSinglePenService
    func AddingToSinglePenService()
    {
        
        str_webservice = "sp_add_outside";
        print(str_comment)
        let temp: String = str_comment.stringByReplacingOccurrencesOfString(" ", withString: "%20")
        if str_Skin == "SelectSize" {
            str_Skin = ""
        }
        if self.appDel.checkInternetConnection() {
            appDel.Show_HUD()
            let request = NSMutableURLRequest(URL: NSURL(string: "\(Server.local_server)/api/singlepen/sp_add_outside.php?")!)
            let postString = "penid=\(toPass_array["penid"] as! String)&graderid=\(str_grader)&condition=\(str_condition)&inspectionperiod=\(str_inspection)&comment=\(temp)&animalsize=\(str_Skin)&animaldetail=\(textView_details.text)&app_id=\(NSUserDefaults.standardUserDefaults().objectForKey("ApplicationIdentifier") as! String)"
            objwebservice.callServiceCommon(request, postString: postString)
        }
        else
        {
            
        }
    }
    
    //MARK: - update database
    func UpDateTableEvent(groupcode: String!) -> AddSectionTable? {
        
        if (true) {
            // Define fetch request/predicate/sort descriptors
            let fetchRequest = NSFetchRequest(entityName: "AddSectionTable")
            let predicate = NSPredicate(format: "groupcode = '\(groupcode)'", argumentArray: nil)
            fetchRequest.predicate = predicate
            
            // Handle results
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
                                //                                self.viewWillAppear(false)
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
    
    
    //MARK: - Comment Btn_Action/ EditComment Delegate
    @IBAction func Comment_BtnAction(sender: AnyObject) {
        if !Bool_comment {
            objCommentCondition.selecteditems.removeAllObjects()
            objCommentCondition.drawRect(CGRectMake(670, 150, 318, 231))
            
            objCommentCondition.showView(self.view, frame1:  CGRectMake(670, 150, 318, 231))
            Bool_comment = true
        }
        else {
            objCommentCondition.removeView(self.view)
            Bool_comment = false
        }
    }
    
    func cancelCommentMethod() {
        
        Bool_comment = false
        objCommentCondition.removeView(self.view)
    }
    
    
    func DoneCommentMethod(Comments: String!)
    {
        Bool_comment = false
        objCommentCondition.removeView(self.view)
        if Comments == nil {
            str_comment = ""
        }
        else
        {
            str_comment = Comments
        }
        print(str_comment)
    }
    
    //MARK: -
    func months_BetweenDate(currentstrDate: NSString!, recheck: Int!) -> NSString {
        let dateComponents: NSDateComponents = NSDateComponents()
        dateComponents.month = recheck
        let calendar: NSCalendar = NSCalendar.currentCalendar()
        
        var currentDate: NSDate! = NSDate()
        let twelveHourLocale: NSLocale = NSLocale(localeIdentifier: "en_US_POSIX")
        dateFormatter.locale = twelveHourLocale
        dateFormatter.dateFormat = "dd/MM/yyyy"
        currentDate = dateFormatter.dateFromString(currentstrDate as String)
        
        let newDate: NSDate = calendar.dateByAddingComponents(dateComponents, toDate: currentDate, options: NSCalendarOptions(rawValue: 0))!
        
        let SStr_date = "\(dateFormatter.stringFromDate(newDate))"
        return SStr_date
    }
    
    func Databse_dateconvertor(datestr: String!) -> NSDate
    {
        let twelveHourLocale: NSLocale = NSLocale(localeIdentifier: "en_US_POSIX")
        dateFormatter.locale = twelveHourLocale
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC")
        let gotDate: NSDate = dateFormatter.dateFromString(datestr)!
        return gotDate
    }
    
    func todaydate() -> NSString
    {
        //        let dateForm: NSDateFormatter = NSDateFormatter()
        let twelveHourLocale: NSLocale = NSLocale(localeIdentifier: "en_US_POSIX")
        dateFormatter.locale = twelveHourLocale
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let todayDate: String = "\(dateFormatter.stringFromDate(NSDate()))"
        return todayDate
    }
    
    //MARK :- textfield
    func textViewDidBeginEditing(textView: UITextView) {
        self.keyboardWillHide = true
        if textView == textView_details {
            UIView.animateWithDuration(0.6, animations: {() -> Void in
                self.view_details.frame = CGRectMake(0, 0, 1024, 768)
                self.img_details.frame = CGRectMake(353, 180, 610, 160)
                self.textView_details.frame = CGRectMake(356, 182, 610, 157)
                }, completion: {(finished: Bool) -> Void in
                    self.bool_textfield = true
            })
        }
        textView_details.becomeFirstResponder()
    }
    
    
    // MARK: - Keyboard hide
    
    
    func keyboardWillShow() {
        if keyboardWillHide == true{
            UIView.animateWithDuration(0.5, animations: {() -> Void in
                self.view_details.frame = CGRectMake(675, 478, 270, 145)
                self.img_details.frame = CGRectMake(0, 0, 270, 145)
                self.textView_details.frame = CGRectMake(3, 2, 270, 142)
                }, completion: {(finished: Bool) -> Void in
            })
        }
        self.keyboardWillHide = false
    }
}
