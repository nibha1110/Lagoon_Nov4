//
//  MoveHatchlingVC.swift
//  Crocodile
//
//  Created by Nibha Aggarwal on 22/06/16.
//  Copyright © 2016 Nibha Aggarwal. All rights reserved.
//

import UIKit
import CoreData

class MoveHatchlingVC: UIViewController, responseProtocol, CommonClassProtocol {
    
    var objwebservice : webservice! = webservice()
    var appDel : AppDelegate!
    
    
    
    @IBOutlet weak var pickerview1_movePen: UIPickerView!
    @IBOutlet weak var pickerview2_movePen: UIPickerView!
    @IBOutlet weak var pickerview3_movePen: UIPickerView!
    
    @IBOutlet weak var pickerview1_animalMoved: UIPickerView!
    @IBOutlet weak var pickerview2_animalMoved: UIPickerView!
    @IBOutlet weak var pickerview3_animalMoved: UIPickerView!
    
    var str_MovePen1: NSString!
    var str_MovePen2: NSString!
    var str_MovePen3: NSString!
    var str_Animal1: NSString!
    var str_Animal2: NSString!
    var str_Animal3: NSString!
    var str_webservice: NSString!
    var str_TotalAnimal: NSString!
    
    var pickerLabel: UILabel!
    var array_Group: NSMutableArray = []
    var array_X : NSMutableArray = []
    var array_SinglePens: NSMutableArray = []
    var array_AnimalCount: NSMutableArray = []
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let controller = self.storyboard!.instantiateViewControllerWithIdentifier("CommonClassVC") as? CommonClassVC
            else {
                fatalError();
        }
        addChildViewController(controller)
        controller.view.frame = CGRectMake(0, 0, 1024, 768)
        
        controller.array_tableSection = ["move_left"]
        controller.array_sectionRow = [["Move_Hatchlings_UnSel", "move_left", "add_to_dieBLUE", "add_to_killBLUE", "Sp_move_blue", "GroupAverage_blue"]]
        view.addSubview(controller.view)
        view.sendSubviewToBack(controller.view)
        controller.IIndexPath = NSIndexPath(forRow: 0, inSection: 1)
        controller.tableMenu.reloadData()
        controller.label_header.text = "ADD HATCHLINGS"
        controller.btn_Sync.hidden = false
        controller.img_Sync.hidden = false
        controller.btn_BackPop.hidden = true
        controller.array_temp_section.replaceObjectAtIndex(1, withObject: "Yes")
        let arrt = controller.array_temp_row[1]
        arrt.replaceObjectAtIndex(0, withObject: "Yes")
        
        controller.delegate = self
        
        appDel = (UIApplication.sharedApplication().delegate as! AppDelegate)
        objwebservice?.delegate = self
        
        for i in 1 ..< 5{
            array_Group.addObject("Y\(i)")
        }   
        
        for char in "ABCDEFGHIJKLMNOP".characters {
            array_X.addObject("\(char)")
        }
        
        for i in 1 ..< 11{
            array_SinglePens.addObject("\(i)")
        }
        for i in 0 ..< 10{
            array_AnimalCount.addObject("\(i)")
        }
        
        pickerview1_movePen.reloadAllComponents()
        pickerview1_movePen.selectRow(0, inComponent: 0, animated: true)  //Y1
        
        pickerview2_movePen.reloadAllComponents()
        pickerview2_movePen.selectRow(0, inComponent: 0, animated: true)  //0
        
        pickerview3_movePen.reloadAllComponents()
        pickerview3_movePen.selectRow(0, inComponent: 0, animated: true)  //0
        
        pickerview1_animalMoved.reloadAllComponents()
        pickerview1_animalMoved.selectRow(0, inComponent: 0, animated: true)  //0
        
        pickerview2_animalMoved.reloadAllComponents()
        pickerview2_animalMoved.selectRow(0, inComponent: 0, animated: true)  //0
        
        pickerview3_animalMoved.reloadAllComponents()
        pickerview3_animalMoved.selectRow(0, inComponent: 0, animated: true)  //0
        
        str_MovePen1 = "Y1";
        str_MovePen2 = "A";
        str_MovePen3 = "1";
        str_Animal1 = "0";
        str_Animal2 = "0";
        str_Animal3 = "0";
    }
    
    
    
    override func viewDidAppear(animated: Bool) {
        if self.appDel.checkInternetConnection() {
            self.GetAnimalCountService()
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - GetAnimalCountService
    func GetAnimalCountService()
    {
        
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
    
    
    // MARK: - PickerView Delegates
    func numberOfComponentsInPickerView(pickerView: UIPickerView!) -> Int{
        return 1
    }
    
    // returns the # of rows in each component..
    func pickerView(pickerView: UIPickerView!, numberOfRowsInComponent component: Int) -> Int{
        
        if pickerView == pickerview1_movePen
        {
            return array_Group.count
        }
        else if pickerView == pickerview2_movePen
        {
            return array_X.count
        }
        else if pickerView == pickerview3_movePen
        {
            return array_SinglePens.count
        }
        
        return array_AnimalCount.count
    }
    
    func pickerView(pickerView: UIPickerView!, titleForRow row: Int, forComponent component: Int) -> String! {
        if pickerView == pickerview1_movePen {
            return array_Group[row] as! String
        }
        else if pickerView == pickerview2_movePen
        {
            return array_X[row] as! String
        }
        else if pickerView == pickerview3_movePen
        {
            return array_SinglePens[row] as! String
        }
        return array_AnimalCount[row] as! String
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
            pickerLabel.font = UIFont(descriptor: UIFontDescriptor(name: "HelveticaNeue", size: 35), size: 35.0)
        }
        if pickerView == pickerview1_movePen {
            pickerLabel.text = array_Group[row] as? String
        }
        else if pickerView == pickerview2_movePen
        {
            pickerLabel.text = array_X[row] as? String
        }
        else if pickerView == pickerview3_movePen
        {
            pickerLabel.text = array_SinglePens[row] as? String
        }
        else
        {
            pickerLabel.text = array_AnimalCount[row] as? String
        }
        
        return pickerLabel
    }
    
    func pickerView(pickerView: UIPickerView!, didSelectRow row: Int, inComponent component: Int)
    {
//        var max1: Int = 0
//        var max2: Int = 0
//        var max3: Int = 0
//        
//        var rowIndex: Int = row
        
        if pickerView == pickerview1_movePen {
            str_MovePen1 = array_Group[row] as! String
        }
        else if pickerView == pickerview2_movePen
        {
            str_MovePen2 = array_X[row] as! String
        }
        else if pickerView == pickerview3_movePen
        {
            str_MovePen3 = array_SinglePens[row] as! String
        }
        
        
        
        else if pickerView == pickerview1_animalMoved {
            str_Animal1 = array_AnimalCount[row] as! String
        }
        else if pickerView == pickerview2_animalMoved {
            str_Animal2 = array_AnimalCount[row] as! String
        }
        else if pickerView == pickerview3_animalMoved {
            str_Animal3 = array_AnimalCount[row] as! String
        }
        /*
        if pickerView == pickerview1_movePen {
            str_MovePen1 = array_Group[row] as! NSString
            pickerview2_movePen.selectRow(0, inComponent: 0, animated: true)
            str_MovePen2 = array_SinglePens[0] as! NSString
            pickerview3_movePen.selectRow(0, inComponent: 0, animated: true)
            str_MovePen3 = array_SinglePens[0] as! NSString
        }
        
        //
        if str_MovePen1 == "Y1" {
            max1 = 2
            max2 = 0
            max3 = 9
            if pickerView == pickerview2_movePen {
                if row > max1 {
                    rowIndex = max1
                    pickerView.selectRow(max1, inComponent: 0, animated: true)
                    if pickerview3_movePen.selectedRowInComponent(0) > max2 {
                        pickerview3_movePen.selectRow(max2, inComponent: 0, animated: true)
                        str_MovePen3 = array_SinglePens[max2] as! NSString
                    }
                    
                }
                else if row == max1 {
                    pickerview3_movePen.selectRow(max2, inComponent: 0, animated: true)
                    
                }
                str_MovePen2 = array_SinglePens[rowIndex] as! NSString
            }
            else if pickerView == pickerview3_movePen {
                if pickerview2_movePen.selectedRowInComponent(0) == max1 {
                    if row > max2 {
                        rowIndex = max2
                        pickerView.selectRow(max2, inComponent: 0, animated: true)
                        
                    }
                }
                str_MovePen3 = array_SinglePens[rowIndex] as! NSString
            }
            
        }
        else if(str_MovePen1 == "Y2")
        {
            max1 = 0
            max2 = 8
            max3 = 5
            if pickerView == pickerview2_movePen {
                if row > max1 {
                    rowIndex = max1
                    pickerView.selectRow(max1, inComponent: 0, animated: true)
                    if pickerview3_movePen.selectedRowInComponent(0) > max2 {
                        pickerview3_movePen.selectRow(max2, inComponent: 0, animated: true)
                        str_MovePen3 = array_SinglePens[max2] as! NSString
                        
                    }
                }
                str_MovePen2 = array_SinglePens[rowIndex] as! NSString
            }
            else if pickerView == pickerview3_movePen {
                if pickerview2_movePen.selectedRowInComponent(0) == max1 {
                    if row > max2 {
                        rowIndex = max2
                        pickerView.selectRow(max2, inComponent: 0, animated: true)
                        
                    }
                }
                if row == max2 {
                    //[pickerview4_movePen selectRow:max3 inComponent:0 animated:YES];
                   
                }
                str_MovePen3 = array_SinglePens[rowIndex] as! NSString
            }
            
        }
        else if(str_MovePen1 == "Y3")
        {
            max1 = 0;
            max2 = 5;
            max3 = 8;
            if (pickerView == pickerview2_movePen)
            {
                if(row > max1){
                    rowIndex = max1
                    pickerView.selectRow(max1, inComponent: 0, animated: true)
                    if pickerview3_movePen.selectedRowInComponent(0) > max2 {
                        pickerview3_movePen.selectRow(max2, inComponent: 0, animated: true)
                        str_MovePen3 = array_SinglePens[max2] as! NSString
                        
                    }
                    
                }
                str_MovePen2 = array_SinglePens[rowIndex] as! NSString
                
                
                
            }
            else if (pickerView == pickerview3_movePen)
            {
                if pickerview2_movePen.selectedRowInComponent(0) == max1 {
                    if row > max2 {
                        rowIndex = max2
                        pickerView.selectRow(max2, inComponent: 0, animated: true)
                        
                    }
                }
                
                if row == max2 {
                    
                }
                
                str_MovePen3 = array_SinglePens[rowIndex] as! NSString
                
            }
            
        }
        else if(str_MovePen1 == "Y4")
        {
            max1 = 0;
            max2 = 7;
            max3 = 6;
            if pickerView == pickerview2_movePen {
                if row > max1 {
                    rowIndex = max1
                    pickerView.selectRow(max1, inComponent: 0, animated: true)
                    if pickerview3_movePen.selectedRowInComponent(0) > max2 {
                        pickerview3_movePen.selectRow(max2, inComponent: 0, animated: true)
                        str_MovePen3 = array_SinglePens[max2] as! NSString
                        
                    }
                }
                str_MovePen2 = array_SinglePens[rowIndex] as! NSString
            }
            else if pickerView == pickerview3_movePen {
                if pickerview2_movePen.selectedRowInComponent(0) == max1 {
                    if row > max2 {
                        rowIndex = max2
                        pickerView.selectRow(max2, inComponent: 0, animated: true)
                        
                    }
                }
                if row == max2 {
                    //[pickerview4_movePen selectRow:max3 inComponent:0 animated:YES];
                    
                }
                
                
                str_MovePen3 = array_SinglePens[rowIndex] as! NSString
                
            }

            
        }
 */
    }

    //MARK: - Move Button
    @IBAction func Move_btnAction(sender: AnyObject) {
        str_TotalAnimal = "\(str_Animal1)\(str_Animal2)\(str_Animal3)"
        
        
        let alertView = UIAlertController(title: nil, message: "Are You Sure You Want To Add #\(str_TotalAnimal) Hatchlings From Incubator To Pen #\(str_MovePen1)-\(str_MovePen2)\(str_MovePen3)?", preferredStyle: .Alert)
        alertView.addAction(UIAlertAction(title: "NO", style: .Cancel, handler: nil))
        alertView.addAction(UIAlertAction(title: "YES", style: .Default, handler: {(action:UIAlertAction) in
            if (self.str_TotalAnimal == "000")
            {
                let alertView = UIAlertController(title: nil, message: "Moving Animal Quantity Should Be Greater Than Zero", preferredStyle: .Alert)
                alertView.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
                self.presentViewController(alertView, animated: true, completion: nil)
            }
            else
            {
                if self.appDel.checkInternetConnection() {
                    self.MoveFromIncubatorToPenService()
                }
                else
                {
                    self.saveToMoveHatchlins()
                }
            }
        }));
        self.presentViewController(alertView, animated: true, completion: nil)
        
    }
 
    func saveToMoveHatchlins()
    {
        let fetchRequest1 = NSFetchRequest(entityName: "AnimalsCountTable")
        let predicate1 = NSPredicate(format: "count_namexx = '\(self.str_MovePen2)' and count_nameyy = '\(self.str_MovePen3)' and groupname = '\(self.str_MovePen1)'")
        fetchRequest1.predicate = predicate1
        fetchRequest1.returnsObjectsAsFaults = false
        fetchRequest1.fetchBatchSize = 20
        do {
            let results1 = try self.appDel.managedObjectContext.executeFetchRequest(fetchRequest1)
            if results1.count > 0 {
                let fetchRequest = NSFetchRequest(entityName: "MoveHatchlings")
                let predicate = NSPredicate(format: "namexx = '\(self.str_MovePen2)' and nameyy = '\(self.str_MovePen3)' and groupname = '\(self.str_MovePen1)'")
                fetchRequest.predicate = predicate
                fetchRequest.returnsObjectsAsFaults = false
                fetchRequest.fetchBatchSize = 20
                do {
                    do {
                        let results = try self.appDel.managedObjectContext.executeFetchRequest(fetchRequest)
                        if results.count == 0 {
                            var objCoreTable: MoveHatchlings!
                            objCoreTable = (NSEntityDescription.insertNewObjectForEntityForName("MoveHatchlings", inManagedObjectContext: self.appDel.managedObjectContext) as! MoveHatchlings)
                            objCoreTable.groupname = str_MovePen1 as String
                            objCoreTable.namexx = str_MovePen2 as String
                            objCoreTable.nameyy = str_MovePen3 as String
                            objCoreTable.moved_by = NSUserDefaults.standardUserDefaults().objectForKey("email_username") as? String
                            objCoreTable.totalanimal = str_TotalAnimal as String
                            do {
                                try self.appDel.managedObjectContext.save()
                                self.getAndInsertIntoAnimalsCount_offline()
                                
                            } catch {
                            }
                        }
                        else
                        {
                            if let objTable: MoveHatchlings = results[0] as? MoveHatchlings {
                                var intvaa : Int = Int(objTable.totalanimal! as String)!
                                intvaa = intvaa + Int(self.str_TotalAnimal as String)!
                                objTable.totalanimal = String(intvaa)
                                
                                do {
                                    try self.appDel.managedObjectContext.save()
                                    self.getAndInsertIntoAnimalsCount_offline()
                                } catch {
                                }
                            }
                        }
                        
                    }
                    catch{}
                    
                    
                }
            }
            else
            {
                let alertView = UIAlertController(title: nil, message: "Entered Pen Does not Exist.", preferredStyle: .Alert)
                alertView.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
                self.presentViewController(alertView, animated: true, completion: nil)
            }
        }
        catch{}
        
        
        
    }
    
    
    func getAndInsertIntoAnimalsCount_offline()
    {
        let fetchRequest = NSFetchRequest(entityName: "AnimalsCountTable")
        let predicate = NSPredicate(format: "count_namexx = '\(self.str_MovePen2)' and count_nameyy = '\(self.str_MovePen3)' and groupname = '\(self.str_MovePen1)'")
        fetchRequest.predicate = predicate
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.fetchBatchSize = 20
        do {
            let results = try self.appDel.managedObjectContext.executeFetchRequest(fetchRequest)
            if (results.count == 0)
            {
                var objCoreTable: AnimalsCountTable!
                objCoreTable = (NSEntityDescription.insertNewObjectForEntityForName("AnimalsCountTable", inManagedObjectContext: self.appDel.managedObjectContext) as! AnimalsCountTable)
                objCoreTable.count_id = results.count
                objCoreTable.groupname = self.str_MovePen1 as String
                objCoreTable.count_namexx = self.str_MovePen2 as String
                objCoreTable.count_nameyy = self.str_MovePen3 as String
                objCoreTable.movedby = NSUserDefaults.standardUserDefaults().objectForKey("email_username") as? String
                objCoreTable.total_animals = self.str_TotalAnimal as String
                objCoreTable.offline = "NO"
                do {
                    try self.appDel.managedObjectContext.save()
                    let alertView = UIAlertController(title: nil, message: "Hatchlings Have Been Moved Successfully.", preferredStyle: .Alert)
                    alertView.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
                    self.presentViewController(alertView, animated: true, completion: nil)
                } catch {
                }
            }
            else
            {
                for i in 0 ..< results.count {
                    if let objTable: AnimalsCountTable = results[i] as? AnimalsCountTable {                                            objTable.offline = "NO"
                        var intvaa : Int = Int(objTable.total_animals! as String)!
                        intvaa = intvaa + Int(self.str_TotalAnimal as String)!
                        objTable.total_animals = String(intvaa)
                        
                        do {
                            try self.appDel.managedObjectContext.save()
                            let alertView = UIAlertController(title: nil, message: "Hatchlings Have Been Moved Successfully.", preferredStyle: .Alert)
                            alertView.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
                            self.presentViewController(alertView, animated: true, completion: nil)
                        } catch {
                        }
                    }
                }
            }
            
            // success ...
        } catch {}
    }
    
    //MARK: - MoveFromIncubatorToPenService
    func MoveFromIncubatorToPenService()
    {
        str_webservice = "move_hatchlings"
        let request = NSMutableURLRequest(URL: NSURL(string: "\(Server.local_server)/api/incubator/move_hatchlings.php?")!)
        let postString = "noofanimals=\(str_TotalAnimal)&group=\(str_MovePen1)&namexx=\(str_MovePen2)&nameyy=\(str_MovePen3)&movedby=\(NSUserDefaults.standardUserDefaults().objectForKey("email_username") as! String)&app_id=\(NSUserDefaults.standardUserDefaults().objectForKey("ApplicationIdentifier") as! String)"
        objwebservice.callServiceCommon(request, postString: postString)
    }
    
    //MARK: -  CommonClass Delegate
    func responseCommonClassOffline() {
        self.viewDidAppear(false)
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
        print(dic)
        if self.str_webservice == "move_hatchlings" {
            var msg: String!
            if dic["success"] as! String == "True" {
                //fetch from AnimalCountTable
                let fetchRequest = NSFetchRequest(entityName: "AnimalsCountTable")
                let predicate = NSPredicate(format: "count_namexx = '\(self.str_MovePen2)' and count_nameyy = '\(self.str_MovePen3)' and groupname = '\(self.str_MovePen1)'")
                fetchRequest.predicate = predicate
                fetchRequest.returnsObjectsAsFaults = false
                fetchRequest.fetchBatchSize = 20
//                fetchRequest.resultType = NSFetchRequestResultType.DictionaryResultType
                do {
                    let results = try self.appDel.managedObjectContext.executeFetchRequest(fetchRequest)
                    
                    if (results.count == 0)
                    {
                        var objCoreTable: AnimalsCountTable!
                        objCoreTable = (NSEntityDescription.insertNewObjectForEntityForName("AnimalsCountTable", inManagedObjectContext: self.appDel.managedObjectContext) as! AnimalsCountTable)
                        objCoreTable.count_id = 1
                        objCoreTable.groupname = self.str_MovePen1 as String
                        objCoreTable.count_namexx = self.str_MovePen2 as String
                        objCoreTable.count_nameyy = self.str_MovePen3 as String
                        objCoreTable.movedby = NSUserDefaults.standardUserDefaults().objectForKey("email_username") as? String
                        objCoreTable.total_animals = self.str_TotalAnimal as String
                        objCoreTable.offline = "NO"
                        do {
                            try self.appDel.managedObjectContext.save()
                        } catch {
                        }
                    }
                    else
                    {
                        
                        if results.count != 0 {
                            for i in 0 ..< results.count {
                                if let objTable: AnimalsCountTable = results[i] as? AnimalsCountTable {                                            objTable.offline = "NO"
                                    print(results)
                                    print(results[i])
                                    var intvaa : Int = (objTable.total_animals?.toInteger())!
                                    intvaa = intvaa + Int(self.str_TotalAnimal as String)!
                                    objTable.total_animals = String(intvaa)
                                    
                                    do {
                                        try self.appDel.managedObjectContext.save()
                                        
                                        
                                    } catch {
                                    }
                                }
                            }
                        }
                        
                    }
                    
                    // success ...
                } catch{}
                //fetch from AnimalCountTable end
                
                msg = "Hatchlings Have Been Added Successfully."
                
                
            }
            else
            {
                msg = dic["Message"] as! String

            }
            
            let alertView = UIAlertController(title: nil, message: msg, preferredStyle: .Alert)
            alertView.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
            self.presentViewController(alertView, animated: true, completion: nil)
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
                        let predicate = NSPredicate(format: "count_namexx == %@ AND count_nameyy == %@ AND groupname = %@" , dic["Animals_count_Data"]![j]["namexx"] as! String, dic["Animals_count_Data"]![j]["nameyy"] as! String, dic["Animals_count_Data"]![j]["groupname"] as! String)
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
//                        var objCoreTable1: GroupAllocatedPen!
                        for i in 0 ..< (dic["Animals_count_Data"]?.count)!{
                            objCoreTable = (NSEntityDescription.insertNewObjectForEntityForName("AnimalsCountTable", inManagedObjectContext: self.appDel.managedObjectContext) as! AnimalsCountTable)
                            objCoreTable.count_id = i
                            objCoreTable.groupname = dic["Animals_count_Data"]![i]["groupname"] as? String
                            objCoreTable.count_namexx = dic["Animals_count_Data"]![i]["namexx"] as? String
                            objCoreTable.count_nameyy = dic["Animals_count_Data"]![i]["nameyy"] as? String
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
            
            
        
        self.appDel.remove_HUD()
    }
}
