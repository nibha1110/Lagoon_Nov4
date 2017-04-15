//
//  UpdateSectionVC.swift
//  Crocodile
//
//  Created by Nibha Aggarwal on 5/19/16.
//  Copyright © 2016 Nibha Aggarwal. All rights reserved.
//

import UIKit
import CoreData

class UpdateSectionVC: UIViewController, responseProtocol
{
    
    @IBOutlet weak var picker_group: UIPickerView!
    @IBOutlet weak var picker_penXX: UIPickerView!
    @IBOutlet weak var picker_pen1: UIPickerView!
    @IBOutlet weak var picker_pen2: UIPickerView!
    @IBOutlet weak var picker_pen3: UIPickerView!
    @IBOutlet weak var picker_pen4: UIPickerView!
    var objwebservice : webservice! = webservice()
    
    var array_Group: NSMutableArray = ["IFP", "IFTP", "OFP", "RTF"]
    var array_SinglePens: NSMutableArray = []
    var array_XX: NSMutableArray = []
    
    var str_group: String!
    var str_name_XX: String!
    var str_name_1: String!
    var str_name_2: String!
    var str_name_3: String!
    var str_name_4: String!
    var str_webservice: String!
    var appDel : AppDelegate!
    var pickerLabel: UILabel!
    var dic_Select: NSMutableDictionary! = NSMutableDictionary()
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let controller = self.storyboard!.instantiateViewControllerWithIdentifier("CommonClassVC") as? CommonClassVC
            else {
                fatalError();
        }
        appDel = (UIApplication.sharedApplication().delegate as! AppDelegate)
        addChildViewController(controller)
        controller.view.frame = CGRectMake(0, 0, 1024, 768)
        controller.array_tableSection = ["update"]
        controller.array_sectionRow = [[]]
        controller.btn_BackPop.hidden = true
        view.addSubview(controller.view)
        view.sendSubviewToBack(controller.view)
        controller.label_header.text = "SP UPDATE"
        controller.IIndexPath = NSIndexPath(forRow: 0, inSection: 5)
        controller.array_temp_section.replaceObjectAtIndex(5, withObject: "Yes")
        controller.tableMenu.reloadData()

        
        
        objwebservice?.delegate = self
        
        
        for i in 0 ..< 10{
            array_SinglePens.addObject("\(i)")
        }
        
//        for i in 1 ..< 18{
//            array_XX.addObject("IF\(i)")
//        }
//        array_XX.addObject("OF")
//        array_XX.addObject("RT")

        
        
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
        if NSUserDefaults.standardUserDefaults().objectForKey("array_saveUpdate") != nil {
            if (NSUserDefaults.standardUserDefaults().objectForKey("array_saveUpdate")?.mutableCopy() as! NSMutableArray).count > 0 {
                array_temp = NSUserDefaults.standardUserDefaults().objectForKey("array_saveUpdate")?.mutableCopy() as! NSMutableArray
                print(array_temp)
                
                let index1: Int = array_Group.indexOfObject(array_temp[0] as! String)
                let index2: Int = array_SinglePens.indexOfObject(array_temp[1] as! String)
                let index3: Int = array_SinglePens.indexOfObject(array_temp[2] as! String)
                let index4: Int = array_SinglePens.indexOfObject(array_temp[3] as! String)
                let index5: Int = array_SinglePens.indexOfObject(array_temp[4] as! String)
                let index6: Int = array_XX.indexOfObject(array_temp[5] as! String)
                
                str_group = array_Group[index1] as! String
                str_name_XX = array_XX[index6] as! String
                str_name_1 = array_SinglePens[index2] as! String
                str_name_2 = array_SinglePens[index3] as! String
                str_name_3 = array_SinglePens[index4] as! String
                str_name_4 = array_SinglePens[index5] as! String
                
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
    
    //MARK: - webservice Delegate
    func responseDictionary(dic: NSMutableDictionary) {
//        dispatch_async(dispatch_get_main_queue()) {
            if self.str_webservice == "checkpen" {
                if (dic["success"] != nil)
                {
                    if dic["success"] as! String == "False"
                    {
                        let alertView = UIAlertController(title: nil, message: "No Pens Present For Matching Criteria.", preferredStyle: .Alert)
                        alertView.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
                        self.presentViewController(alertView, animated: true, completion: nil)
                    }
                }
                
                else
                {
                    self.dic_Select = dic.mutableCopy() as! NSMutableDictionary
                    let array_saveValue:NSMutableArray = []
                    /*
                    array_saveValue.addObject("\(Int(self.picker_group.selectedRowInComponent(0)))")
                    array_saveValue.addObject("\(Int(self.picker_pen1.selectedRowInComponent(0)))")
                    array_saveValue.addObject("\(Int(self.picker_pen2.selectedRowInComponent(0)))")
                    array_saveValue.addObject("\(Int(self.picker_pen3.selectedRowInComponent(0)))")
                    array_saveValue.addObject("\(Int(self.picker_pen4.selectedRowInComponent(0)))")
                    */
                    array_saveValue.addObject(self.str_group)
                    array_saveValue.addObject(self.str_name_1)
                    array_saveValue.addObject(self.str_name_2)
                    array_saveValue.addObject(self.str_name_3)
                    array_saveValue.addObject(self.str_name_4)
                    array_saveValue.addObject(self.str_name_XX)
                    
                    let userDefaults = NSUserDefaults.standardUserDefaults()
                    userDefaults.setValue(array_saveValue, forKey: "array_saveUpdate")
                    userDefaults.synchronize()
                    
                    self.performSegueWithIdentifier("toUpdateRecheck", sender: self)
                }
            }
            self.appDel.remove_HUD()
    }
    
    
    //MARK: - Select Btn Action
    @IBAction func SelectSave_btnAction(sender: AnyObject) {
        
        if self.appDel.checkInternetConnection() {
            appDel.Show_HUD()
            str_webservice = "checkpen"
            let request = NSMutableURLRequest(URL: NSURL(string: "\(Server.local_server)/api/sp_update/checkpen.php?")!)
            let postString = "groupcode=\(str_group)&namexx=\(str_name_XX)&nameyy=\(str_name_1+str_name_2)\(str_name_3+str_name_4)"
            objwebservice.callServiceCommon(request, postString: postString)
        }
        else
        {
            self.GetOfflineSingleAllocatedPen()
        }
    }

    
    func GetOfflineSingleAllocatedPen()
    {
        let fetchRequest = NSFetchRequest(entityName: "SingleAllocatedPen")
        let predicate = NSPredicate(format: "groupcode = '\(str_group)' AND namexx = '\(str_name_XX)' AND nameyy = '\(str_name_1)\(str_name_2)\(str_name_3)\(str_name_4)'")
        fetchRequest.predicate = predicate
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.fetchBatchSize = 20
        fetchRequest.resultType = NSFetchRequestResultType.DictionaryResultType
        do
        {
            let results = try self.appDel.managedObjectContext.executeFetchRequest(fetchRequest)
            print(results)
            if results.count > 0 {
                let temparray : NSMutableArray! = []
                temparray.addObject(results[0] as AnyObject)
                self.dic_Select .setValue(temparray , forKey: "PenDetails")
                let array_saveValue:NSMutableArray = []
                
                array_saveValue.addObject(self.str_group)
                array_saveValue.addObject(self.str_name_1)
                array_saveValue.addObject(self.str_name_2)
                array_saveValue.addObject(self.str_name_3)
                array_saveValue.addObject(self.str_name_4)
                array_saveValue.addObject(self.str_name_XX)
                
                let userDefaults = NSUserDefaults.standardUserDefaults()
                userDefaults.setValue(array_saveValue, forKey: "array_saveUpdate")
                userDefaults.synchronize()
                
                self.performSegueWithIdentifier("toUpdateRecheck", sender: self)
            }
            else
            {
                let alertView = UIAlertController(title: nil, message: "No Pens Present For Matching Criteria." , preferredStyle: .Alert)
                alertView.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                self.presentViewController(alertView, animated: true, completion: nil)
                
            }
        } catch {
            
        }
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
        else if (pickerView == picker_penXX){
            return array_XX.count
        }
        else if (pickerView == picker_pen1){
            return array_SinglePens.count
        }
        else if (pickerView == picker_pen2){
            return array_SinglePens.count
        }
        else if (pickerView == picker_pen3){
            return array_SinglePens.count
        }
        else if (pickerView == picker_pen4){
            return array_SinglePens.count
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
            pickerLabel.font = UIFont(descriptor: UIFontDescriptor(name: "HelveticaNeue", size: 35), size: 35.0)
        }
        if pickerView == picker_group {
            pickerLabel.text = array_Group[row] as? String
        }
        else if (pickerView == picker_penXX){
            pickerLabel.text = array_XX[row] as? String
        }
        else if (pickerView == picker_pen1){
            pickerLabel.text = array_SinglePens[row] as? String
        }
        else if (pickerView == picker_pen2){
            pickerLabel.text = array_SinglePens[row] as? String
        }
        else if (pickerView == picker_pen3){
            pickerLabel.text = array_SinglePens[row] as? String
        }
        else if (pickerView == picker_pen4){
            pickerLabel.text = array_SinglePens[row] as? String
        }
        
        return pickerLabel
    }
    
    func pickerView(pickerView: UIPickerView!, didSelectRow row: Int, inComponent component: Int)
    {
//        let max1: Int = 5
//        let max2: Int = 0
//        var rowIndex: Int = row
        
        if pickerView == picker_group {
            str_group = array_Group[row] as! String
        }
        else if (pickerView == picker_penXX){
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
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "toUpdateRecheck") {
            
            let objVC = segue.destinationViewController as! UpdateRecheckVC;
            objVC.toPass_dic = dic_Select
            print(objVC.toPass_dic)
        }
    }
}
