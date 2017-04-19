//
//  AddToKillVC.swift
//  Crocodile
//
//  Created by Nibha Aggarwal on 8/8/16.
//  Copyright © 2016 Nibha Aggarwal. All rights reserved.
//

import UIKit
import CoreData

class AddToKillVC: UIViewController, responseProtocol, CommonClassProtocol {
    
    var objwebservice : webservice! = webservice()
    var objDatePicker : CalendarView! = CalendarView()
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
    var str_TotalAnimal: String!
    var str_todatDate: String!
    
    var pickerLabel: UILabel!
    var array_Group: NSMutableArray = []
    var array_SinglePens: NSMutableArray = []
    var array_X : NSMutableArray = []
    var array_AnimalCount: NSMutableArray = []
    
    
    //MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        appDel = (UIApplication.sharedApplication().delegate as! AppDelegate)
        
        guard let controller = self.storyboard!.instantiateViewControllerWithIdentifier("CommonClassVC") as? CommonClassVC
            else {
                fatalError();
        }
        addChildViewController(controller)
        controller.view.frame = CGRectMake(0, 0, 1024, 768)
        controller.btn_Sync.hidden = false
        controller.img_Sync.hidden = false
        controller.btn_BackPop.hidden = true
        controller.array_tableSection = ["move_left"]
        controller.array_sectionRow = [["Move_Hatchlings_UnSel", "move_left", "add_to_dieBLUE", "add_to_killBLUE", "Sp_move_blue", "GroupAverage_blue"]]
        view.addSubview(controller.view)
        view.sendSubviewToBack(controller.view)
        controller.IIndexPath = NSIndexPath(forRow: 3, inSection: 1)
        controller.tableMenu.reloadData()
        controller.label_header.text = "ADD TO KILL"
        controller.array_temp_section.replaceObjectAtIndex(1, withObject: "Yes")
        let arrt = controller.array_temp_row[1]
        arrt.replaceObjectAtIndex(3, withObject: "Yes")
        
        controller.delegate = self
        
        objwebservice?.delegate = self
        appDel = (UIApplication.sharedApplication().delegate as! AppDelegate)
        
        objDatePicker = CalendarView.instanceFromNib() as! CalendarView
        str_todatDate = "\(objDatePicker.todaydate())"
        
        self.callInViewDidLoad()
    }
    
    
    func callInViewDidLoad()
    {
        str_todatDate = str_todatDate!.stringByReplacingOccurrencesOfString(" ", withString: "")
        str_todatDate = str_todatDate.stringByReplacingOccurrencesOfString("/", withString: "-")
        
        for i in 1 ..< 5{
            array_Group.addObject("Y\(i)")
        }
        
        for char in "ABCDEFGHIJKLMNOP".characters {
            array_X.addObject("\(char)")
        }
        
        for i in 0 ..< 10{
            array_AnimalCount.addObject("\(i)")
        }
        
        for i in 1 ..< 11{
            array_SinglePens.addObject("\(i)")
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
        }
        else
        {
            
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    }
    
    //MARK: - AddToKill Button
    @IBAction func AddToDie_btnAction(sender: AnyObject) {
        str_TotalAnimal = "\(str_Animal1)\(str_Animal2)\(str_Animal3)"
        
            let alertView = UIAlertController(title: nil, message: "Are You Sure You Want To Kill #\(str_TotalAnimal) Animal From #\(str_MovePen1)-\(str_MovePen2)\(str_MovePen3)?", preferredStyle: .Alert)
            alertView.addAction(UIAlertAction(title: "NO", style: .Cancel, handler: nil))
            alertView.addAction(UIAlertAction(title: "YES", style: .Default, handler: {(action:UIAlertAction) in
                if (self.str_TotalAnimal == "000")
                {
                    HelperClass.MessageAletOnly("Animal Quantity Should Be Greater Than Zero", selfView: self)
                }
                else
                {
                    if self.appDel.checkInternetConnection() {
                        self.GroupedPenService()
                    }
                    else
                    {
                        self.GetOfflineGroupAllocatedPen()
                    }
                    
                }
            }));
            self.presentViewController(alertView, animated: true, completion: nil)
        
    }
    
    
    //MARK: - GroupedPenService
    func GroupedPenService()
    {
        appDel.Show_HUD()
        str_webservice = "kill_animals";
        
        let request = NSMutableURLRequest(URL: NSURL(string: "\(Server.local_server)/api/animals/kill_animals_group.php?")!)
        let postString = "noofanimals=\(str_TotalAnimal)&group=\(str_MovePen1)&namexx=\(str_MovePen2)&nameyy=\(str_MovePen3)&movedby=\(NSUserDefaults.standardUserDefaults().objectForKey("email_username") as! String)&dateadded=\(str_todatDate)&app_id=\(NSUserDefaults.standardUserDefaults().objectForKey("ApplicationIdentifier") as! String)"
        objwebservice.callServiceCommon(request, postString: postString)
    }
    
    //MARK: -  CommonClass Delegate
    func responseCommonClassOffline() {
        self.viewDidAppear(false)
    }
    
    // MARK: - Webservice NetLost delegate
    func NetworkLost(str: String!)
    {
        HelperClass.NetworkLost(str, view1: self)
    }
    
    
    //MARK: - Webservice Protocol
    func responseDictionary(dic: NSMutableDictionary) {
            if self.str_webservice == "kill_animals" {
                var msg: String!
                if dic["success"] as! String == "True" {
                    self.DeleteFromGroupAllocatedPen()
                    msg = "Successfully Killed."
                }
                else
                {
                    msg = dic["Message"] as! String
                }
                HelperClass.MessageAletOnly(msg!, selfView: self)
                self.appDel.remove_HUD()
            }
        
            self.appDel.remove_HUD()
    }
    
    
    //MARK: - Offline Methods
    func DeleteFromGroupAllocatedPen()
    {
        let fetchRequest = NSFetchRequest(entityName: "AnimalsCountTable")
        let predicate = NSPredicate(format: "count_namexx = '\(str_MovePen2)' and count_namexx = '\(str_MovePen3)' and groupname = '\(str_MovePen1)'")
        fetchRequest.predicate = predicate
        fetchRequest.returnsObjectsAsFaults = false
        do
        {
            let results = try self.appDel.managedObjectContext.executeFetchRequest(fetchRequest)
            
            if results.count > 0
            {
                if let objTable: AnimalsCountTable = results[results.count-1] as? AnimalsCountTable {
                    let totalVal = objTable.total_animals?.toInteger()
                    let animal = Int(str_TotalAnimal as String)!
                    if totalVal >= animal
                    {
                        let totalanimal: Int = totalVal! - animal
                        objTable.total_animals = String(totalanimal)
                    }
                    
                    do {
                        try self.appDel.managedObjectContext.save()
                        
                    } catch {
                    }
                }
            }
        } catch {
            
        }
    }
    
    func GetOfflineGroupAllocatedPen()
    {
        let fetchRequest = NSFetchRequest(entityName: "AnimalsCountTable")
        let predicate = NSPredicate(format: "count_namexx = '\(str_MovePen2)' and count_nameyy = '\(str_MovePen3)' and groupname = '\(str_MovePen1)'")
        fetchRequest.predicate = predicate
        fetchRequest.returnsObjectsAsFaults = false
        //        fetchRequest.fetchBatchSize = 20
        fetchRequest.resultType = NSFetchRequestResultType.DictionaryResultType
        do
        {
            let results = try self.appDel.managedObjectContext.executeFetchRequest(fetchRequest)
            if results.count > 0 {
                
                var totalanimal : Int = Int(results[results.count-1]["total_animals"] as! String)!
                
                if totalanimal == 0 {
                    HelperClass.MessageAletOnly("Pen is Empty.", selfView: self)
                }
                else if (totalanimal >= Int(str_TotalAnimal as String)!)
                {
                    totalanimal = totalanimal - Int(str_TotalAnimal as String)!
                    self.UpdateGroupAllocatedPen(String(totalanimal))
                    HelperClass.MessageAletOnly("Successfully Killed.", selfView: self)
                }
                else
                {
                    HelperClass.MessageAletOnly("Animals Moved Are Greater Than Total Animals.", selfView: self)
                }
                
            }
            else
            {
                
                HelperClass.MessageAletOnly("Entered Pen Does not Exist.", selfView: self)
            }
        } catch {
            
        }
    }
    
    
    func InsertToAnimalgroupKill()
    {

        let fetchRequest = NSFetchRequest(entityName: "Animalgroupkill")
        let predicate = NSPredicate(format: "namexx = '\(str_MovePen2)' AND nameyy = '\(str_MovePen3)' AND groupname = '\(str_MovePen1)'")
        fetchRequest.predicate = predicate
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.fetchBatchSize = 20
        do {
            let fetchedResults = try appDel.managedObjectContext.executeFetchRequest(fetchRequest)
            if fetchedResults.count != 0 {
                if let objTable: Animalgroupkill = fetchedResults[0] as? Animalgroupkill {
                    let totalVal = objTable.totalanimal?.toInteger()
                    //
                    let totalanimal: Int = totalVal! + str_TotalAnimal.toInteger()!
                    objTable.totalanimal = String(totalanimal)
                    print(objTable.totalanimal)
                    do {
                        try self.appDel.managedObjectContext.save()
                        
                    } catch {
                    }
                }
            }
            else
            {
                
                var objCoreTable: Animalgroupkill!
                objCoreTable = (NSEntityDescription.insertNewObjectForEntityForName("Animalgroupkill", inManagedObjectContext: self.appDel.managedObjectContext) as! Animalgroupkill)
                objCoreTable.totalanimal = "\(str_TotalAnimal)"
                objCoreTable.groupname = "\(str_MovePen1)"
                objCoreTable.namexx = "\(str_MovePen2)"
                objCoreTable.nameyy = "\(str_MovePen3)"
                objCoreTable.date = "\(str_todatDate)"
                objCoreTable.userid = "\(NSUserDefaults.standardUserDefaults().objectForKey("email_username") as! String)"
                do {
                    try self.appDel.managedObjectContext.save()
                    
                } catch {
                }
            }
        }
        catch {
            
        }
    }

    
    
    func UpdateGroupAllocatedPen(totalAnimal: String!)
    {
        // Define fetch request/predicate/sort descriptors
        let fetchRequest = NSFetchRequest(entityName: "AnimalsCountTable")
        let predicate = NSPredicate(format: "count_namexx = '\(str_MovePen2)' and count_nameyy = '\(str_MovePen3)' and groupname = '\(str_MovePen1)'")
        fetchRequest.predicate = predicate
        fetchRequest.returnsObjectsAsFaults = false
        //        fetchRequest.fetchBatchSize = 20
        do {
            let fetchedResults = try appDel.managedObjectContext.executeFetchRequest(fetchRequest)
            if fetchedResults.count != 0 {
                for i in 0 ..< fetchedResults.count {
                    if let objTable: AnimalsCountTable = fetchedResults[i] as? AnimalsCountTable {
                        objTable.total_animals = totalAnimal
                        do {
                            try self.appDel.managedObjectContext.save()
                            self.InsertToAnimalgroupKill()
                        } catch {
                        }}}}
        }catch  {
            
        }
    }
    
    
    
}
