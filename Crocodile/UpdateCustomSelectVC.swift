//
//  UpdateCustomSelectVC.swift
//  Crocodile
//
//  Created by Nibha Aggarwal on 6/10/16.
//  Copyright © 2016 Nibha Aggarwal. All rights reserved.
//

import UIKit
import CoreData

class UpdateCustomSelectVC: UIViewController, responseProtocol {
    var toPass: NSMutableDictionary! = NSMutableDictionary()
    
    @IBOutlet var picker_group: UIPickerView!
    @IBOutlet weak var picker_penXX: UIPickerView!
    @IBOutlet var picker_pen1: UIPickerView!
    @IBOutlet var picker_pen2: UIPickerView!
    @IBOutlet var picker_pen3: UIPickerView!
    @IBOutlet var picker_pen4: UIPickerView!
    var objwebservice : webservice! = webservice()
    
    var array_SinglePens: NSMutableArray = []
    var array_Group: NSMutableArray = ["IFP", "IFTP", "OFP", "RTF"]
    var array_XX: NSMutableArray = []
    
    var str_group: String!
    var str_name_XX: String!
    var str_name_1: String!
    var str_name_2: String!
    var str_name_3: String!
    var str_name_4: String!
    var str_webservice: String!
    
    var pickerLabel: UILabel!
    var appDel: AppDelegate!
    
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

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

        print(toPass)
        
        objwebservice?.delegate = self
        appDel = (UIApplication.sharedApplication().delegate as! AppDelegate)
        
      
        for i in 0 ..< 10{
            array_SinglePens.addObject("\(i)")
        }
        
        
        array_XX.addObject("GO")
        for i in 1 ..< 17{
            array_XX.addObject("IF\(i)")
        }
        array_XX.addObject("OF")
        array_XX.addObject("WA")
        array_XX.addObject("WB")
        array_XX.addObject("XA")
        array_XX.addObject("XB")
        array_XX.addObject("YA")
        array_XX.addObject("YB")
        array_XX.addObject("ZA")
        array_XX.addObject("ZB")
        
        picker_group.reloadAllComponents()
        picker_group.selectRow(0, inComponent: 0, animated: true)  //1
        
        picker_penXX.reloadAllComponents()
        picker_penXX.selectRow(0, inComponent: 0, animated: true)  //1
        
        picker_pen1.reloadAllComponents()
        picker_pen1.selectRow(0, inComponent: 0, animated: true)  //0
        
        picker_pen2.reloadAllComponents()
        picker_pen2.selectRow(0, inComponent: 0, animated: true)  //0
        
        picker_pen3.reloadAllComponents()
        picker_pen3.selectRow(0, inComponent: 0, animated: true)  //0
        
        picker_pen4.reloadAllComponents()
        picker_pen4.selectRow(0, inComponent: 0, animated: true)  //0
        
        str_group = array_Group[0] as! String
        str_name_XX = array_XX[0] as! String
        str_name_1 = array_SinglePens[0] as! String
        str_name_2 = array_SinglePens[0] as! String
        str_name_3 = array_SinglePens[0] as! String
        str_name_4 = array_SinglePens[0] as! String
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        var array_temp : NSMutableArray = []
        
        if self.appDel.checkInternetConnection()
        {
            if (toPass["PenDetails"]![0]["lastgroup"] as! String != "" || toPass["PenDetails"]![0]["lastnamexx"] as! String != "" || toPass["PenDetails"]![0]["lastnameyy"] as! String != "")
            {
                array_temp.addObject("\(toPass["PenDetails"]![0]["lastgroup"] as! String)")  //0
                
                var range = (toPass["PenDetails"]![0]["lastnameyy"] as! String).startIndex.advancedBy(0) ..< (toPass["PenDetails"]![0]["lastnameyy"] as! String).startIndex.advancedBy(1)
                var save: String! = (toPass["PenDetails"]![0]["lastnameyy"] as! String).substringWithRange(range)
                array_temp.addObject("\(save)")  //1
                
                range = (toPass["PenDetails"]![0]["lastnameyy"] as! String).startIndex.advancedBy(1) ..< (toPass["PenDetails"]![0]["lastnameyy"] as! String).startIndex.advancedBy(2)
                save = (toPass["PenDetails"]![0]["lastnameyy"] as! String).substringWithRange(range)
                array_temp.addObject("\(save)")  //2
                
                range = (toPass["PenDetails"]![0]["lastnameyy"] as! String).startIndex.advancedBy(2) ..< (toPass["PenDetails"]![0]["lastnameyy"] as! String).startIndex.advancedBy(3)
                save = (toPass["PenDetails"]![0]["lastnameyy"] as! String).substringWithRange(range)
                array_temp.addObject("\(save)")  //3
                
                range = (toPass["PenDetails"]![0]["lastnameyy"] as! String).startIndex.advancedBy(3) ..< (toPass["PenDetails"]![0]["lastnameyy"] as! String).startIndex.advancedBy(4)
                save = (toPass["PenDetails"]![0]["lastnameyy"] as! String).substringWithRange(range)
                array_temp.addObject("\(save)")  //4
                
                array_temp.addObject("\(toPass["PenDetails"]![0]["lastnamexx"] as! String)")  //5
                
                
                let index1: Int = array_Group.indexOfObject(array_temp[0] as! String)
                let index2: Int = array_SinglePens.indexOfObject(array_temp[1] as! String)
                let index3: Int = array_SinglePens.indexOfObject(array_temp[2] as! String)
                let index4: Int = array_SinglePens.indexOfObject(array_temp[3] as! String)
                let index5: Int = array_SinglePens.indexOfObject(array_temp[4] as! String)
                let index6: Int = array_XX.indexOfObject(array_temp[5] as! String)
                
                str_group = array_Group[index1] as! String
                str_name_1 = array_SinglePens[index2] as! String
                str_name_2 = array_SinglePens[index3] as! String
                str_name_3 = array_SinglePens[index4] as! String
                str_name_4 = array_SinglePens[index5] as! String
                str_name_XX = array_XX[index6] as! String
                
                picker_group.reloadAllComponents()
                picker_group.selectRow(index1, inComponent: 0, animated: true)
                
                picker_pen1.reloadAllComponents()
                picker_pen1.selectRow(index2, inComponent: 0, animated: true)
                
                picker_pen2.reloadAllComponents()
                picker_pen2.selectRow(index3, inComponent: 0, animated: true)
                
                picker_pen3.reloadAllComponents()
                picker_pen3.selectRow(index4, inComponent: 0, animated: true)
                
                picker_pen4.reloadAllComponents()
                picker_pen4.selectRow(index5, inComponent: 0, animated: true)
                
                picker_penXX.reloadAllComponents()
                picker_penXX.selectRow(index6, inComponent: 0, animated: true)
                
            }
            else
            {
                if NSUserDefaults.standardUserDefaults().objectForKey("array_saveUpdate") != nil {
                    if (NSUserDefaults.standardUserDefaults().objectForKey("array_saveUpdate")?.mutableCopy() as! NSMutableArray).count > 0 {
                        array_temp = NSUserDefaults.standardUserDefaults().objectForKey("array_saveUpdate")?.mutableCopy() as! NSMutableArray
                        let index1: Int = array_Group.indexOfObject(array_temp[0] as! String)
                        let index2: Int = array_SinglePens.indexOfObject(array_temp[1] as! String)
                        let index3: Int = array_SinglePens.indexOfObject(array_temp[2] as! String)
                        let index4: Int = array_SinglePens.indexOfObject(array_temp[3] as! String)
                        let index5: Int = array_SinglePens.indexOfObject(array_temp[4] as! String)
                        let index6: Int = array_XX.indexOfObject(array_temp[5] as! String)
                        
                        str_group = array_Group[index1] as! String
                        str_name_1 = array_SinglePens[index2] as! String
                        str_name_2 = array_SinglePens[index3] as! String
                        str_name_3 = array_SinglePens[index4] as! String
                        str_name_4 = array_SinglePens[index5] as! String
                        str_name_XX = array_XX[index6] as! String
                        
                        /* for only one group to show
                         for i in 1 ..< 4 {
                         if (str_group == "\(i)")
                         {
                         array_Group.removeAllObjects()
                         array_Group.addObject("\(i)")
                         }
                         }
                         */
                        
                        
                        picker_group.reloadAllComponents()
                        picker_group.selectRow(index1, inComponent: 0, animated: true)
                        
                        picker_pen1.reloadAllComponents()
                        picker_pen1.selectRow(index2, inComponent: 0, animated: true)
                        
                        picker_pen2.reloadAllComponents()
                        picker_pen2.selectRow(index3, inComponent: 0, animated: true)
                        
                        picker_pen3.reloadAllComponents()
                        picker_pen3.selectRow(index4, inComponent: 0, animated: true)
                        
                        picker_pen4.reloadAllComponents()
                        picker_pen4.selectRow(index5, inComponent: 0, animated: true)
                        
                        picker_penXX.reloadAllComponents()
                        picker_penXX.selectRow(index6, inComponent: 0, animated: true)
                        
                    }
                }
            }

        }
        else
        {
            if NSUserDefaults.standardUserDefaults().objectForKey("array_saveUpdate") != nil {
                if (NSUserDefaults.standardUserDefaults().objectForKey("array_saveUpdate")?.mutableCopy() as! NSMutableArray).count > 0 {
                    array_temp = NSUserDefaults.standardUserDefaults().objectForKey("array_saveUpdate")?.mutableCopy() as! NSMutableArray
                    let index1: Int = array_Group.indexOfObject(array_temp[0] as! String)
                    let index2: Int = array_SinglePens.indexOfObject(array_temp[1] as! String)
                    let index3: Int = array_SinglePens.indexOfObject(array_temp[2] as! String)
                    let index4: Int = array_SinglePens.indexOfObject(array_temp[3] as! String)
                    let index5: Int = array_SinglePens.indexOfObject(array_temp[4] as! String)
                    let index6: Int = array_XX.indexOfObject(array_temp[5] as! String)
                    
                    str_group = array_Group[index1] as! String
                    str_name_1 = array_SinglePens[index2] as! String
                    str_name_2 = array_SinglePens[index3] as! String
                    str_name_3 = array_SinglePens[index4] as! String
                    str_name_4 = array_SinglePens[index5] as! String
                    str_name_XX = array_XX[index6] as! String
                    
                    /* for only one group to show
                     for i in 1 ..< 4 {
                     if (str_group == "\(i)")
                     {
                     array_Group.removeAllObjects()
                     array_Group.addObject("\(i)")
                     }
                     }
                     */
                    
                    
                    picker_group.reloadAllComponents()
                    picker_group.selectRow(index1, inComponent: 0, animated: true)
                    
                    picker_pen1.reloadAllComponents()
                    picker_pen1.selectRow(index2, inComponent: 0, animated: true)
                    
                    picker_pen2.reloadAllComponents()
                    picker_pen2.selectRow(index3, inComponent: 0, animated: true)
                    
                    picker_pen3.reloadAllComponents()
                    picker_pen3.selectRow(index4, inComponent: 0, animated: true)
                    
                    picker_pen4.reloadAllComponents()
                    picker_pen4.selectRow(index5, inComponent: 0, animated: true)
                    
                    picker_penXX.reloadAllComponents()
                    picker_penXX.selectRow(index6, inComponent: 0, animated: true)
                    
                }
            }
        }
    }
    
    // MARK: - Webservice NetLost delegate
    func NetworkLost(str: String!)
    {
        HelperClass.NetworkLost(str, view1: self)
    }
    
    //MARK: - webservice Delegate
    func responseDictionary(dic: NSMutableDictionary) {
        if self.str_webservice == "moveanimal" {
            var msg: String!
            if (dic["success"] != nil)
            {
                if dic["success"] as! String == "False"
                {
                    msg = "This Pen Is Already Allocated."
                }
                    
                    
                else
                {
                    msg = dic["Message"] as! String
                    
                    self.OfflineMoveToAnother()
                    
                }
//                dispatch_async(dispatch_get_main_queue()) {
                    let alertView = UIAlertController(title: nil, message: msg, preferredStyle: .Alert)
                    let OKAction = UIAlertAction(title: "OK", style: .Cancel) { (action: UIAlertAction) in
                        if (msg == dic["Message"] as! String)
                        {
                            let array_saveValue: NSMutableArray = []
                            array_saveValue.addObject(self.str_group)
                            array_saveValue.addObject(self.str_name_1)
                            array_saveValue.addObject(self.str_name_2)
                            array_saveValue.addObject(self.str_name_3)
                            array_saveValue.addObject(self.str_name_4)
                            array_saveValue.addObject(self.str_name_XX)
                            
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
                    }
                    alertView.addAction(OKAction)
                    self.presentViewController(alertView, animated: true, completion: nil)
//                }
            }
        }
        self.appDel.remove_HUD()
    }
    
    //MARK: - Save Btn Action
    @IBAction func SelectSave_btnAction(sender: AnyObject) {
        let alertView = UIAlertController(title: nil, message: "Are You Sure You Want To Update?", preferredStyle: .Alert)
        alertView.addAction(UIAlertAction(title: "NO", style: .Cancel, handler: nil))
        alertView.addAction(UIAlertAction(title: "YES", style: UIAlertActionStyle.Default, handler: {(action:UIAlertAction) in
            if self.appDel.checkInternetConnection() {
                self.appDel.Show_HUD()
                self.str_webservice = "moveanimal"
                let penid: String  = self.toPass["PenDetails"]![0]["penid"] as! String
                let allocationid: String = self.toPass["PenDetails"]![0]["allocationid"] as! String
                
                let request = NSMutableURLRequest(URL: NSURL(string: "\(Server.local_server)/api/sp_update/moveanimal.php?")!)
                let postString = "groupcode=\(self.str_group)&namexx=\(self.str_name_XX)&nameyy=\(self.str_name_1+self.str_name_2)\(self.str_name_3+self.str_name_4)&penid=\(penid)&allocationid=\(allocationid)&app_id=\(NSUserDefaults.standardUserDefaults().objectForKey("ApplicationIdentifier") as! String)"
                self.objwebservice.callServiceCommon(request, postString: postString)
            }
            else
            {
                self.OfflineMoveToAnother()
                
            }
        }));
        presentViewController(alertView, animated: true, completion: nil)
        
        
        
        
        
        
        
        
    }
    
    //MARK: - Back Btn Action
    @IBAction func Back_btnAction(sender: AnyObject) {
    }
    
    // MARK: - PickerView Delegates
    func numberOfComponentsInPickerView(pickerView: UIPickerView!) -> Int{
        return 1
    }
    
    // returns the # of rows in each component..
    func pickerView(pickerView: UIPickerView!, numberOfRowsInComponent component: Int) -> Int{
        
        if pickerView == picker_group{
            return array_Group.count
        }
        else if (pickerView == picker_penXX)
        {
            return array_XX.count
        }
        return array_SinglePens.count
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
            //            pickerLabel.font = UIFont(name: "HelveticaNeue", size: 35)
        }
        if pickerView == picker_group {
            pickerLabel.text = array_Group[row] as? String
        }
        else if (pickerView == picker_penXX)
        {
            pickerLabel.text = array_XX[row] as? String
        }
        else{
            pickerLabel.text = array_SinglePens[row] as? String
        }
        
        return pickerLabel
    }
    
    func pickerView(pickerView: UIPickerView!, didSelectRow row: Int, inComponent component: Int)
    {
        let max1: Int = 5
        let max2: Int = 0
        var rowIndex: Int = row
        
        if pickerView == picker_group {
            str_group = array_Group[row] as! String
        }
        else if (pickerView == picker_penXX)
        {
            str_name_XX = array_XX[row] as! String
        }
        else if (pickerView == picker_pen1){
            str_name_1 = array_SinglePens[row] as! String
        }
        else if (pickerView == picker_pen2){
            str_name_2 = array_SinglePens[row] as! String
        }
        else if (pickerView == picker_pen3){
            str_name_3 = array_SinglePens[row] as! String
            
//            if row >= 5 {
//                rowIndex = 5
//                picker_pen3.selectRow(max1, inComponent: 0, animated: true)
//                picker_pen4.selectRow(max2, inComponent: 0, animated: true)
//                str_name_4 = array_SinglePens[max2] as! String
//            }
//            str_name_3 = array_SinglePens[rowIndex] as! String
        }
        else if (pickerView == picker_pen4){
//            if picker_pen3.selectedRowInComponent(0) >= 5 {
//                rowIndex = 0
//                picker_pen4.selectRow(max2, inComponent: 0, animated: true)
//            }
            str_name_4 = array_SinglePens[row] as! String
            
        }
    }
    
    //MARK: - Offline Methods
    func OfflineMoveToAnother()
    {
        
        let penid: String! = toPass["PenDetails"]![0]["penid"] as! String
        
        let fetchRequest = NSFetchRequest(entityName: "EmptyPensTable")
        let predicate = NSPredicate(format: "groupcode = '\(str_group)' AND namexx = '\(str_name_XX)' AND nameyy = '\(str_name_1)\(str_name_2)\(str_name_3)\(str_name_4)'", argumentArray: nil)
        fetchRequest.predicate = predicate
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.fetchBatchSize = 20
        fetchRequest.resultType = NSFetchRequestResultType.DictionaryResultType
        do {
            let results = try self.appDel.managedObjectContext.executeFetchRequest(fetchRequest)
            if results.count > 0
            {
                let fetchRequest1 = NSFetchRequest(entityName: "SingleAllocatedPen")
                let predicate1 = NSPredicate(format: "penid = '\(penid)'")
                fetchRequest1.predicate = predicate1
                fetchRequest1.returnsObjectsAsFaults = false
                fetchRequest1.fetchBatchSize = 20
                do {
                    let results1 = try self.appDel.managedObjectContext.executeFetchRequest(fetchRequest1)
                    if results1.count > 0 {
                        for i in 0 ..< results1.count {
                            if let objTable: SingleAllocatedPen = results1[i] as? SingleAllocatedPen
                            {
                                objTable.penid = results[0]["penid"] as? String
                                objTable.namexx = results[0]["namexx"] as? String
                                objTable.nameyy = results[0]["nameyy"] as? String
                                objTable.pennodisp = "\(objTable.namexx!)-\(objTable.nameyy!)"
                                do
                                {
                                    try self.appDel.managedObjectContext.save()
                                    
                                    
                                    var arrayT = "\(toPass["PenDetails"]![0]["pennodisp"] as! String)".componentsSeparatedByString("-")
                                    
                                    self.addToEmptyPen(toPass["PenDetails"]![0]["groupcode"] as! String, grpnamedisp: "\(toPass["PenDetails"]![0]["groupcode"] as! String) - PEN#", namexx: "\(arrayT[0])", nameyy: "\(arrayT[1])", pennodisp: "\(toPass["PenDetails"]![0]["pennodisp"] as! String)", penid: toPass["PenDetails"]![0]["penid"] as! String, to_Penid: results[0]["penid"] as! String)
                                    if !self.appDel.checkInternetConnection() {
                                        self.saveToUpdateMoveTable(results[0]["penid"] as! String, to_namexx: results[0]["namexx"] as! String, to_nameyy: results[0]["nameyy"] as! String)
                                        
                                        let alertView = UIAlertController(title: nil, message: "Successfully Moved to \(str_name_XX)-\(str_name_1)\(str_name_2)\(str_name_3)\(str_name_4) in \(str_group)", preferredStyle: .Alert)
                                        let OKAction = UIAlertAction(title: "OK", style: .Cancel) { (action: UIAlertAction) in
                                            
                                                let array_saveValue: NSMutableArray = []
                                                array_saveValue.addObject(self.str_group)
                                                array_saveValue.addObject(self.str_name_1)
                                                array_saveValue.addObject(self.str_name_2)
                                                array_saveValue.addObject(self.str_name_3)
                                                array_saveValue.addObject(self.str_name_4)
                                                array_saveValue.addObject(self.str_name_XX)
                                                
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
                                        alertView.addAction(OKAction)
                                        self.presentViewController(alertView, animated: true, completion: nil)
                                    }
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
            else
            {
                HelperClass.MessageAletOnly("This Pen Is Already Allocated.", selfView: self)
            }
            
            // success ...
        } catch{}
        
    }
    
    
    func addToEmptyPen(groupcode: String, grpnamedisp: String, namexx: String, nameyy: String, pennodisp: String, penid: String, to_Penid: String)
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
            self.DeleteFromEmptyTable(to_Penid)
        } catch {}
    }
    
    func DeleteFromEmptyTable(to_Penid: String)
    {
        let fetchRequest1 = NSFetchRequest(entityName: "EmptyPensTable")
        let predicate = NSPredicate(format: "penid == '\(to_Penid)'", argumentArray: nil)
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
    
    
    func saveToUpdateMoveTable(topen_id: String, to_namexx: String, to_nameyy: String)
    {
        var objCoreTable: UpdateMoveToAnother!
        objCoreTable = (NSEntityDescription.insertNewObjectForEntityForName("UpdateMoveToAnother", inManagedObjectContext: self.appDel.managedObjectContext) as! UpdateMoveToAnother)
        objCoreTable.from_xx = toPass["PenDetails"]![0]["namexx"] as? String
        objCoreTable.from_yy = toPass["PenDetails"]![0]["nameyy"] as? String
        objCoreTable.from_penid = toPass["PenDetails"]![0]["penid"] as? String
        objCoreTable.to_penid = topen_id
        objCoreTable.to_xx = to_namexx
        objCoreTable.to_yy = to_nameyy
        do {
            try self.appDel.managedObjectContext.save()
            
        } catch {
        }
        
    }
    
}
