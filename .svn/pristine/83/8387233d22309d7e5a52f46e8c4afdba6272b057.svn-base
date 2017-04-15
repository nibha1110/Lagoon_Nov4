//
//  GroupAverageVC.swift
//  Crocodile
//
//  Created by Nibha Aggarwal on 27/03/17.
//  Copyright © 2017 Nibha Aggarwal. All rights reserved.
//

import UIKit

class GroupAverageVC: UIViewController, responseProtocol, CommonClassProtocol {
    
    var objwebservice : webservice! = webservice()
    var objDatePicker : CalendarView! = CalendarView()
    var appDel : AppDelegate!
    
    @IBOutlet weak var pickerview1_movePen: UIPickerView!
    @IBOutlet weak var pickerview2_movePen: UIPickerView!
    @IBOutlet weak var pickerview3_movePen: UIPickerView!

    @IBOutlet weak var pickerview_Avg: UIPickerView!
    
    var str_MovePen1: NSString!
    var str_MovePen2: NSString!
    var str_MovePen3: NSString!
    
    var str_webservice: NSString!
    var str_TotalPen: NSString!
    var str_todatDate: String!
    var str_Avg: NSString!
    
    var pickerLabel: UILabel!
    
    var array_Group: NSMutableArray = []
    var array_SinglePens: NSMutableArray = []
    var array_X : NSMutableArray = []
    var array_Avg: NSMutableArray = []
    
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
//        controller.btn_Sync.hidden = false
//        controller.img_Sync.hidden = false
        controller.btn_BackPop.hidden = true
        controller.array_tableSection = ["move_left"]
        controller.array_sectionRow = [["Move_Hatchlings_UnSel", "move_left", "add_to_dieBLUE", "add_to_killBLUE", "Sp_move_blue", "GroupAverage_blue"]]
        view.addSubview(controller.view)
        view.sendSubviewToBack(controller.view)
        controller.IIndexPath = NSIndexPath(forRow: 5, inSection: 1)
        controller.tableMenu.reloadData()
        controller.label_header.text = "GROUPED PEN SIZE"
        controller.array_temp_section.replaceObjectAtIndex(1, withObject: "Yes")
        let arrt = controller.array_temp_row[1]
        arrt.replaceObjectAtIndex(5, withObject: "Yes")
        array_Avg = controller.array_average
        controller.delegate = self
        
        objwebservice?.delegate = self
        appDel = (UIApplication.sharedApplication().delegate as! AppDelegate)
        
        objDatePicker = CalendarView.instanceFromNib() as! CalendarView
        str_todatDate = "\(objDatePicker.todaydate())"
        str_todatDate = str_todatDate!.stringByReplacingOccurrencesOfString(" ", withString: "")
        str_todatDate = str_todatDate.stringByReplacingOccurrencesOfString("/", withString: "-")
        
        for i in 1 ..< 5{
            array_Group.addObject("Y\(i)")
        }
        
        for char in "ABCDEFGHIJKLMNOP".characters {
            array_X.addObject("\(char)")
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
        
        
        pickerview_Avg.reloadAllComponents()
        pickerview_Avg.selectRow(0, inComponent: 0, animated: true)  //0
        
        print(array_Avg)
        
        str_MovePen1 = "Y1"
        str_MovePen2 = "A"
        str_MovePen3 = "1"
        
        str_Avg = array_Avg[0] as! String
    }
    
    override func viewDidAppear(animated: Bool) {
        if self.appDel.checkInternetConnection() {
            //            appDel.Show_HUD()
            //            self.GetGroupAllocatedService()
        }
        else
        {
            
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
        else if pickerView == pickerview_Avg
        {
            return array_Avg.count
        }
        return array_SinglePens.count
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
        else if pickerView == pickerview_Avg
        {
            return array_Avg[row] as! String
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
        else if pickerView == pickerview_Avg
        {
            pickerLabel.text = array_Avg[row] as? String
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
        
        else if pickerView == pickerview_Avg
        {
            str_Avg = array_Avg[row] as! NSString
        }
        
    }
    
    
    //MARK: - AddToKill Button
    @IBAction func Save_btnAction(sender: AnyObject) {
        str_TotalPen = "\(str_MovePen2)\(str_MovePen3)"
        
        if str_TotalPen == "000" {
            let alertView = UIAlertController(title: nil, message: "Invalid Pen", preferredStyle: .Alert)
            alertView.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
            self.presentViewController(alertView, animated: true, completion: nil)
        }
        else
        {
            let alertView = UIAlertController(title: nil, message: "Are You Sure To Update \(str_MovePen1)-\(str_TotalPen) Pen?", preferredStyle: .Alert)
            alertView.addAction(UIAlertAction(title: "NO", style: .Cancel, handler: nil))
            alertView.addAction(UIAlertAction(title: "YES", style: .Default, handler: {(action:UIAlertAction) in
                
                if self.appDel.checkInternetConnection() {
                    self.saveService()
                }
                else
                {
                }
                
                
            }));
            self.presentViewController(alertView, animated: true, completion: nil)
        }
    }
    
    func saveService()
    {
        self.appDel.Show_HUD()
        self.str_webservice = "add_grouped_size";
        
        let request = NSMutableURLRequest(URL: NSURL(string: "\(Server.local_server)/api/animals/add_grouped_size.php?")!)
        let postString = "groupcode=\(self.str_MovePen1)&namexx=\(self.str_MovePen2)&nameyy=\(str_MovePen3)&avgsize=\(self.str_Avg)&appid=\(NSUserDefaults.standardUserDefaults().objectForKey("ApplicationIdentifier") as! String)"
        self.objwebservice.callServiceCommon(request, postString: postString)
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
    
    
    //MARK: - Webservice Protocol
    func responseDictionary(dic: NSMutableDictionary) {
        //        dispatch_async(dispatch_get_main_queue()) {
        if self.str_webservice == "add_grouped_size" {
            
            let alertView = UIAlertController(title: nil, message: dic["Message"] as? String, preferredStyle: .Alert)
            alertView.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
            self.presentViewController(alertView, animated: true, completion: nil)
            self.appDel.remove_HUD()
        }
    
        
        self.appDel.remove_HUD()
    }

}
