

//
//  SelectPensVC.swift
//  Crocodile
//
//  Created by Nibha Aggarwal on 5/26/16.
//  Copyright © 2016 Nibha Aggarwal. All rights reserved.
//

import UIKit
import CoreData

class SelectPensVC: UIViewController, responseProtocol{
    var objwebservice : webservice! = webservice()
    var appDel : AppDelegate!
    var array_Group: NSMutableArray = []
    var array_X : NSMutableArray = []
    var array_SinglePens: NSMutableArray = []
    var toPass: NSMutableDictionary! = NSMutableDictionary()
    var str_webservice: String!
    var graderID: String!
    var inspection_period: String!
    var str_group: String!
    var str_name_y1: String!
    var str_name_y2: String!
    var pickerLabel: UILabel!
    
    @IBOutlet weak var pickerview_Groups: UIPickerView!
    @IBOutlet weak var picker_pen1: UIPickerView!
    @IBOutlet weak var picker_pen2: UIPickerView!
    
    
    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        objwebservice?.delegate = self
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
        controller.label_header.text = "ADD TO SINGLE PEN"
        
        controller.IIndexPath = NSIndexPath(forRow: 0, inSection: 2)
        controller.array_temp_section.replaceObjectAtIndex(2, withObject: "Yes")
        controller.tableMenu.reloadData()
        
        let arrt = controller.array_temp_row[2]
        arrt.replaceObjectAtIndex(0, withObject: "Yes")
        
        appDel = (UIApplication.sharedApplication().delegate as! AppDelegate)
        
        for i in 1 ..< 5{
            array_Group.addObject("Y\(i)")
        }
        
        for char in "ABCDEFGHIJKLMNOP".characters {
            array_X.addObject("\(char)")
        }
        
        for i in 1 ..< 11{
            array_SinglePens.addObject("\(i)")
        }
        
        pickerview_Groups.reloadAllComponents()
        pickerview_Groups.selectRow(0, inComponent: 0, animated: true)  //Y1
        
        picker_pen1.reloadAllComponents()
        picker_pen1.selectRow(0, inComponent: 0, animated: true)  //0

        picker_pen2.reloadAllComponents()
        picker_pen2.selectRow(0, inComponent: 0, animated: true)  //0


        str_group = "Y1";
        str_name_y1 = "A";
        str_name_y2 = "1";
        graderID = "0"
        inspection_period = "1"
        
        appDel.ForSPAddComes = "Back"
    }
    
    override func viewWillAppear(animated: Bool) {
        var array_temp : NSMutableArray = []
        if NSUserDefaults.standardUserDefaults().objectForKey("array_saveValue") != nil {
            if (NSUserDefaults.standardUserDefaults().objectForKey("array_saveValue")?.mutableCopy() as! NSMutableArray).count > 0 {
                array_temp = NSUserDefaults.standardUserDefaults().objectForKey("array_saveValue")?.mutableCopy() as! NSMutableArray
                str_group = array_temp[0] as! String
                str_name_y1 = array_temp[1] as! String
                str_name_y2 = array_temp[2] as! String
                if array_temp.count == 3
                {
                    graderID = "0"
                }
                else{
                    graderID = array_temp[3] as! String
                }
                
                if array_temp.count <= 4 {
                    inspection_period = "1"
                }
                else
                {
                    inspection_period = array_temp[4] as! String
                }
                
                //
                let index1: Int = array_Group.indexOfObject(array_temp[0] as! String)
                let index2: Int = array_X.indexOfObject(array_temp[1] as! String)
                let index3: Int = array_SinglePens.indexOfObject(array_temp[2] as! String)
                
                pickerview_Groups.reloadAllComponents()
                pickerview_Groups.selectRow(index1, inComponent: 0, animated: true)
                
                picker_pen1.reloadAllComponents()
                picker_pen1.selectRow(index2, inComponent: 0, animated: true)
                
                picker_pen2.reloadAllComponents()
                picker_pen2.selectRow(index3, inComponent: 0, animated: true)
                
            }

        }
                //
        else
        {
            if self.appDel.checkInternetConnection() {
                self.GetAllSystemDetails()
            }
            
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //MARK: - GetAnimalCountService
    func GetAnimalCountService()
    {
        
        appDel.ForSelectPenVCComes = "Come"
        appDel.Show_HUD()
        str_webservice = "api_animals_count"
        let request = NSMutableURLRequest(URL: NSURL(string: "\(Server.local_server)/api/animals/api_animals_count.php?")!)
        var postString = ""
        if NSUserDefaults.standardUserDefaults().objectForKey("AllData") != nil
        {
            if NSUserDefaults.standardUserDefaults().objectForKey("AllData") as! String == "AllDataSaved"
            {
                
                let fetchRequest = NSFetchRequest(entityName: "TimeStrampTable")
                fetchRequest.returnsObjectsAsFaults = false
                fetchRequest.fetchBatchSize = 20
                fetchRequest.resultType = NSFetchRequestResultType.DictionaryResultType
                var str: String!
                do {
                    let results = try self.appDel.managedObjectContext.executeFetchRequest(fetchRequest)
                    if (results.count > 0)
                    {
                        print(results)
                        for i in 0 ..< results.count {
                            
                            if let val = results[i]["animalCountTym"] {
                                if let x = val {
                                    print(x)
                                    str = "\(results[i]["animalCountTym"] as! String)"
                                    str = str.stringByReplacingOccurrencesOfString(" ", withString: "%20")
                                    postString = "last_update=\(str)&app_id=\(NSUserDefaults.standardUserDefaults().objectForKey("ApplicationIdentifier") as! String)"
                                } else {
                                    print("value is nil")
                                }
                            } else {
                                print("key is not present in dict")
                            }
                        }
                        
                        
                    }
                } catch{}
                
                
            }
            
        }
        objwebservice.callServiceCommon(request, postString: postString)
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

    
    //MARK:- Webservice delegate
    func responseDictionary(dic: NSMutableDictionary) {
            print(dic)
            if self.str_webservice == "sp_last_record" {
//                self.graderID = dic["Last_Inserted_From"]![0]["graderid"] as! String
//                self.inspection_period = dic["Last_Inserted_From"]![0]["inspection_period"] as! String
                
                if dic["Last_Inserted_From"]?.count != 0 {
                    self.pickerview_Groups.reloadAllComponents()
                    
                    if dic["Last_Inserted_From"]![0]["namexx"] is NSString {
                        print("It's a string")
                        for i in 0 ..< 3
                        {
                            if dic["Last_Inserted_From"]![0]["groupname"] as! String == self.array_Group[i] as! String {
                                self.pickerview_Groups.selectRow(i, inComponent: 0, animated: true)
                                self.str_group = "Y\(i+2)"
                                self.pickerview_Groups.reloadAllComponents()
                            }
                            else
                            {
                                
                                self.pickerview_Groups.selectRow(0, inComponent: 0, animated: true)
                                self.str_group = "Y\(0+2)"
                                self.pickerview_Groups.reloadAllComponents()
                            }
                        }
                        
                        
                        let str1 : String! = (dic["Last_Inserted_From"]![0]["namexx"] as! String)
                        let str2 : String! = (dic["Last_Inserted_From"]![0]["nameyy"] as! String)
                        
                        
                        let index2: Int = array_SinglePens.indexOfObject(str2)
                        self.picker_pen2.selectRow(index2, inComponent: 0, animated: true)
                        picker_pen2.reloadAllComponents()
                        self.str_name_y2 = "\(str2)"
                        
                        
                        let index1: Int = array_X.indexOfObject(str1)
                        self.picker_pen1.selectRow(index1, inComponent: 0, animated: true)
                        picker_pen1.reloadAllComponents()
                        self.str_name_y1 = "\(str1)"
                        

                    } else if dic["Last_Inserted_From"]![0]["namexx"] is NSNull {
                        print("It's a NSNull")
                        self.pickerview_Groups.selectRow(0, inComponent: 0, animated: true)
                        self.str_group = "Y1"
                        self.pickerview_Groups.reloadAllComponents()
                        
                        self.picker_pen1.selectRow(0, inComponent: 0, animated: true)
                        self.str_name_y1 = "A"
                        self.picker_pen1.reloadAllComponents()
                        
                        self.picker_pen2.selectRow(0, inComponent: 0, animated: true)
                        self.str_name_y2 = "1"
                        self.picker_pen2.reloadAllComponents()
                        
                        
                        self.graderID = "0"
                        self.inspection_period = "1"
                        
                    }
                    
                    
                    
                    
                }
                if self.appDel.checkInternetConnection() {
                    if (self.appDel.ForSelectPenVCComes == "")
                    {
                        self.view.userInteractionEnabled = false
                        self.GetAnimalCountService()
                    }
                    else
                    {
                        self.view.userInteractionEnabled = true
                        self.appDel.remove_HUD()
                    }
                }
            }
            else if (self.str_webservice == "check_movement_sp_add")
            {
                if (dic["success"] as! String == "True")
                {
                    
                        let array_saveValue:NSMutableArray = []
                        array_saveValue.addObject(self.str_group)
                        array_saveValue.addObject(self.str_name_y1)
                        array_saveValue.addObject(self.str_name_y2)
                        print(self.inspection_period)
                        array_saveValue.addObject(self.graderID)
                        array_saveValue.addObject(self.inspection_period)
                        
                        
                        let userDefaults = NSUserDefaults.standardUserDefaults()
                        userDefaults.setValue(array_saveValue, forKey: "array_saveValue")
                        userDefaults.synchronize()
                    
                        array_saveValue.removeAllObjects()
                        print(userDefaults.valueForKey("array_saveValue")?.mutableCopy() as! NSMutableArray)
                    
                        let objVC = self.storyboard?.instantiateViewControllerWithIdentifier("AddSinglePensVC") as! AddSinglePensVC
                        array_saveValue.addObject(self.toPass["penid"]  as! String)
                        array_saveValue.addObject(self.toPass["pennodisp"]  as! String)
                        array_saveValue.addObject(self.toPass["grpnamedisp"]  as! String)
                        array_saveValue.addObject(self.graderID)
                        array_saveValue.addObject(self.str_group)
                        array_saveValue.addObject(self.str_name_y1)
                        array_saveValue.addObject(self.inspection_period)
                        array_saveValue.addObject(self.str_name_y2)
                        array_saveValue.addObject(self.toPass["groupcode"]  as! String)
                        objVC.toPass_array = array_saveValue.mutableCopy() as! NSMutableArray
                        self.navigationController?.pushViewController(objVC, animated: false)
//                        self.performSegueWithIdentifier("toAddSinglePen", sender: self)
                }
                else
                {
                    
                    let alertView = UIAlertController(title: nil, message: "Pen Is Empty.", preferredStyle: .Alert)
                    alertView.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
                    self.presentViewController(alertView, animated: true, completion: nil)
                  }
            }
            else if (self.str_webservice == "api_animals_count")
            {
                if NSUserDefaults.standardUserDefaults().objectForKey("AllData") != nil
                {
                    if NSUserDefaults.standardUserDefaults().objectForKey("AllData") as! String == "AllDataSaved"
                    {
                        appDel.Show_HUD()
                        
                        for j in 0 ..< dic["Animals_count_Data"]!.count {
                            let fetchRequest = NSFetchRequest(entityName: "AnimalsCountTable")
                            let predicate = NSPredicate(format: "namexx = %@ AND nameyy = %@ AND groupname = %@", dic["Animals_count_Data"]![j]["namexx"] as! String, dic["Animals_count_Data"]![j]["nameyy"] as! String, dic["Animals_count_Data"]![j]["groupname"] as! String)
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
                        
                        
                        autoreleasepool {
                            var objCoreTable: AnimalsCountTable!
                            for i in 0 ..< (dic["Animals_count_Data"]?.count)!{
                                objCoreTable = (NSEntityDescription.insertNewObjectForEntityForName("AnimalsCountTable", inManagedObjectContext: self.appDel.managedObjectContext) as! AnimalsCountTable)
                                objCoreTable.count_id = i
                                objCoreTable.count_namexx = dic["Animals_count_Data"]![i]["namexx"] as? String
                                objCoreTable.count_nameyy = dic["Animals_count_Data"]![i]["nameyy"] as? String
                                objCoreTable.groupname = dic["Animals_count_Data"]![i]["groupname"] as? String
                                objCoreTable.movedby = NSUserDefaults.standardUserDefaults().objectForKey("email_username") as? String
                                objCoreTable.total_animals = dic["Animals_count_Data"]![i]["total_animals"] as? String
                                objCoreTable.offline = "NO"
                                
                            }
                            do {
                                try self.appDel.managedObjectContext.save()
                            } catch {
                            }
                        }
                        
                        
                        
                        
                        let fetchRequest1 = NSFetchRequest(entityName: "TimeStrampTable")
                        fetchRequest1.returnsObjectsAsFaults = false
                        do
                        {
                            let results = try self.appDel.managedObjectContext.executeFetchRequest(fetchRequest1)
                            if results.count > 0 {
                                if let objTable: TimeStrampTable = results[0] as? TimeStrampTable {
                                    objTable.animalCountTym = dic["last_update"] as? String
                                    objTable.animalCountTym = objTable.animalCountTym!
                                    print(objTable.animalCountTym)
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
                        
                    }
//                    self.appDel.str_api_animals_count = "Filled"
                }
                else
                {
                    //----Saving to databse//
                    
                    
                    let fetchRequest = NSFetchRequest(entityName: "AnimalsCountTable")
                    fetchRequest.returnsObjectsAsFaults = false
                    let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                    do {
                        try self.appDel.persistentStoreCoordinator.executeRequest(deleteRequest, withContext: self.appDel.managedObjectContext)
                        do
                        {
                            try self.appDel.managedObjectContext.save()
                            
                            
                        }
                        catch{}
                    } catch{}
                    
                    
                    
                    // for Animals count table, data is same for both table
                    autoreleasepool {
                        var objCoreTable: AnimalsCountTable!
//                        var objCoreTable1: GroupAllocatedPen!
                        for i in 0 ..< (dic["Animals_count_Data"]?.count)!{
                            objCoreTable = (NSEntityDescription.insertNewObjectForEntityForName("AnimalsCountTable", inManagedObjectContext: self.appDel.managedObjectContext) as! AnimalsCountTable)
                            objCoreTable.count_id = i
                            objCoreTable.count_namexx = dic["Animals_count_Data"]![i]["namexx"] as? String
                            objCoreTable.count_nameyy = dic["Animals_count_Data"]![i]["nameyy"] as? String
                            objCoreTable.groupname = dic["Animals_count_Data"]![i]["groupname"] as? String
                            objCoreTable.movedby = NSUserDefaults.standardUserDefaults().objectForKey("email_username") as? String
                            objCoreTable.total_animals = dic["Animals_count_Data"]![i]["total_animals"] as? String
                            objCoreTable.offline = "NO"
                            
                        }
                        do {
                            try self.appDel.managedObjectContext.save()
                        } catch {
                        }
                    }
                    
                    
                    //-----//
                    
                    var objTable: TimeStrampTable!
                    objTable = (NSEntityDescription.insertNewObjectForEntityForName("TimeStrampTable", inManagedObjectContext: self.appDel.managedObjectContext) as! TimeStrampTable)
                    
                    print(dic["last_update"] as! String)
                    
                    objTable.animalCountTym = dic["last_update"] as? String
                    objTable.animalCountTym = objTable.animalCountTym!
                    print(objTable.animalCountTym)
                    do {
                        try self.appDel.managedObjectContext.save()
                        self.appDel.remove_HUD()
                    } catch {}
                }
                
        }
        self.view.userInteractionEnabled = true
        self.appDel.remove_HUD()
    }
    
    // MARK: - GetSystem Details
    func GetAllSystemDetails() {
        appDel.Show_HUD()
        str_webservice = "sp_last_record"
        let request = NSMutableURLRequest(URL: NSURL(string: "\(Server.local_server)/api/singlepen/sp_last_record.php")!)
        let postString = ""
        objwebservice.callServiceCommon(request, postString: postString)
    }
    
    // MARK: - PickerView Delegates
    func numberOfComponentsInPickerView(pickerView: UIPickerView!) -> Int{
        return 1
    }
    
    // returns the # of rows in each component..
    func pickerView(pickerView: UIPickerView!, numberOfRowsInComponent component: Int) -> Int{

        if pickerView == pickerview_Groups
        {
            return array_Group.count
        }
        else if (pickerView == picker_pen1){
            return array_X.count
        }
        return array_SinglePens.count
    }
    
    func pickerView(pickerView: UIPickerView!, titleForRow row: Int, forComponent component: Int) -> String! {
        if pickerView == pickerview_Groups {
            return array_Group[row] as! String
        }
        else if (pickerView == picker_pen1){
            return array_X[row] as! String
        }
        return array_SinglePens[row] as! String
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
        if pickerView == pickerview_Groups {
            pickerLabel.text = array_Group[row] as? String
        }
        else if (pickerView == picker_pen1){
            pickerLabel.text = array_X[row] as? String
        }
        else
        {
            pickerLabel.text = array_SinglePens[row] as? String
        }
        
        return pickerLabel
    }
    
    func pickerView(pickerView: UIPickerView!, didSelectRow row: Int, inComponent component: Int)
    {
        if pickerView == pickerview_Groups {
            str_group = array_Group[row] as! String
        }
        else if pickerView == picker_pen1 {
            str_name_y1 = array_X[row] as! String
        }
        else if pickerView == picker_pen2 {
            str_name_y2 = array_SinglePens[row] as! String
        }
    }
    
    
    //MARK: - Select Button
    @IBAction func Select_btnAction(sender: AnyObject) {
        
        if self.appDel.checkInternetConnection() {
            appDel.Show_HUD()
            str_webservice = "check_movement_sp_add"
            let request = NSMutableURLRequest(URL: NSURL(string: "\(Server.local_server)/api/animals/check_movement_sp_add.php?")!)
            let postString = "noofanimals=1&fromgroup=\(str_group)&fromnamexx=\(str_name_y1)&fromnameyy=\(str_name_y2)"
            objwebservice.callServiceCommon(request, postString: postString)
        }
        else
        {
            getFromAnimalsCountTableOffline()
        }
        
        
    }
    
    func getFromAnimalsCountTableOffline()
    {
        if true {
            let fetchRequest = NSFetchRequest(entityName: "AnimalsCountTable")
            let predicate = NSPredicate(format: "count_namexx = '\(str_name_y1)' and count_nameyy = '\(str_name_y2)' and groupname = '\(str_group)'")
            fetchRequest.predicate = predicate
            fetchRequest.returnsObjectsAsFaults = false
            fetchRequest.fetchBatchSize = 20
            //        fetchRequest.resultType = NSFetchRequestResultType.DictionaryResultType
            do {
                let fetchedResults = try self.appDel.managedObjectContext.executeFetchRequest(fetchRequest)
                if fetchedResults.count != 0 {
                    for i in 0 ..< fetchedResults.count {
                        if let objTable: AnimalsCountTable = fetchedResults[i] as? AnimalsCountTable {
                            let intvaa : Int = Int(objTable.total_animals! as String)!
                            if intvaa <= 0 {
                                let alertView = UIAlertController(title: nil, message: "Pen Is Empty.", preferredStyle: .Alert)
                                alertView.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
                                self.presentViewController(alertView, animated: true, completion: nil)
                            }
                            else
                            {
                                let array_saveValue:NSMutableArray = []
                                array_saveValue.addObject(self.str_group)
                                array_saveValue.addObject(self.str_name_y1)
                                array_saveValue.addObject(self.str_name_y2)
                                
                                if NSUserDefaults.standardUserDefaults().objectForKey("array_saveValue") == nil {
                                    graderID = "0"
                                    inspection_period = "1"
                                }
                                
                                array_saveValue.addObject(self.graderID)
                                array_saveValue.addObject(self.inspection_period)
                                
                                let userDefaults = NSUserDefaults.standardUserDefaults()
                                userDefaults.setValue(array_saveValue, forKey: "array_saveValue")
                                userDefaults.synchronize()
                                
                                let objVC = self.storyboard?.instantiateViewControllerWithIdentifier("AddSinglePensVC") as! AddSinglePensVC
                                objVC.toPass_array.addObject(self.toPass["penid"]  as! String)
                                objVC.toPass_array.addObject(self.toPass["pennodisp"]  as! String)
                                objVC.toPass_array.addObject(self.toPass["grpnamedisp"]  as! String)
                                objVC.toPass_array.addObject(self.graderID)
                                objVC.toPass_array.addObject(self.str_group)
                                objVC.toPass_array.addObject(self.str_name_y1)
                                objVC.toPass_array.addObject(self.inspection_period)
                                objVC.toPass_array.addObject(self.str_name_y2)
                                objVC.toPass_array.addObject(self.toPass["groupcode"]  as! String)
                                self.navigationController?.pushViewController(objVC, animated: false)
                                
//                                self.performSegueWithIdentifier("toAddSinglePen", sender: self)
                            }
                            
                            do {
                                try self.appDel.managedObjectContext.save()
                                
                                
                            } catch {
                            }
                        }
                    }
                }
                else
                {
                    let alertView = UIAlertController(title: nil, message: "Entered Pen Does not Exist.", preferredStyle: .Alert)
                    alertView.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
                    self.presentViewController(alertView, animated: true, completion: nil)
                }
                
            }catch let error as NSError {
                // failure
                print("Fetch failed: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "toAddSinglePen") {
            
            let objVC = segue.destinationViewController as! AddSinglePensVC;
            objVC.toPass_array.addObject(self.toPass["penid"]  as! String)
            objVC.toPass_array.addObject(self.toPass["pennodisp"]  as! String)
            objVC.toPass_array.addObject(self.toPass["grpnamedisp"]  as! String)
            objVC.toPass_array.addObject(self.graderID)
            objVC.toPass_array.addObject(self.str_group)
            objVC.toPass_array.addObject(self.str_name_y1)
            objVC.toPass_array.addObject(self.inspection_period)
            objVC.toPass_array.addObject(self.str_name_y2)
            print(objVC.toPass_array)
            
        }
    }

}
