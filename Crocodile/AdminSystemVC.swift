//
//  AdminSystemVC.swift
//  Crocodile
//
//  Created by Nibha Aggarwal on 5/10/16.
//  Copyright © 2016 Nibha Aggarwal. All rights reserved.
//

import UIKit

class AdminSystemVC: UIViewController, responseProtocol {
    var objwebservice : webservice! = webservice()
    var array_killdaysmonth: NSMutableArray = []
    var array_killday: NSMutableArray = []
    var array_backup: NSMutableArray = []
    var pickerLabel: UILabel!
    var int1: Int=0
    var int2: Int=0
    var int3: Int=0
    var str_webservice: String!
    var appDel : AppDelegate!
   
    
    @IBOutlet weak var pickerview_killsDaysMonth: UIPickerView!
    @IBOutlet weak var pickerview_backupKills: UIPickerView!
    @IBOutlet weak var pickerview_killsPerDay: UIPickerView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        appDel = (UIApplication.sharedApplication().delegate as! AppDelegate)
        guard let controller = self.storyboard!.instantiateViewControllerWithIdentifier("CommonClassVC") as? CommonClassVC
            else {
                fatalError();
        }
        addChildViewController(controller)
        controller.view.frame = CGRectMake(0, 0, 1024, 768)
        
        controller.array_tableSection = ["admin"]
        controller.array_sectionRow = [["system", "adduser", "manageuser"]]
        
        view.addSubview(controller.view)
        view.sendSubviewToBack(controller.view)
        controller.IIndexPath = NSIndexPath(forRow: 0, inSection: 0)
        controller.label_header.text = "SP SYSTEM SETUP"
        controller.btn_BackPop.hidden = true
        
        controller.array_temp_section.replaceObjectAtIndex(0, withObject: "Yes")
        controller.tableMenu.reloadData()
        let arrt = controller.array_temp_row[0]
        arrt.replaceObjectAtIndex(0, withObject: "Yes")
        
        objwebservice?.delegate = self
        
        for i in 10 ..< 31{
            array_killdaysmonth.addObject("\(i)")
        }
        for i in 20 ..< 101
        {
            array_killday.addObject("\(i)")
        }
        for i in 1 ..< 31
        {
            array_backup.addObject("\(i)")
        }
        print(array_killdaysmonth)
        
        pickerview_killsDaysMonth.reloadAllComponents()
        pickerview_killsDaysMonth.selectRow(10, inComponent: 0, animated: true)
        
        pickerview_killsPerDay.reloadAllComponents()
        pickerview_killsPerDay.selectRow(20, inComponent: 0, animated: true)
        
        pickerview_backupKills.reloadAllComponents()
        pickerview_backupKills.selectRow(14, inComponent: 0, animated: true)
        
        int1 = array_killdaysmonth[10].integerValue
        int2 = array_killday[20].integerValue
        int3 = array_backup[14].integerValue
    }
    
    override func viewWillAppear(animated: Bool) {
          self.GetAllSystemDetails()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - GetSystem Details
    func GetAllSystemDetails() {
        str_webservice = "apigetkills"
        let request = NSMutableURLRequest(URL: NSURL(string: "\(Server.local_server)/api/setup/apigetkills.php")!)
        let postString = ""
        objwebservice.callServiceCommon(request, postString: postString)
    }
    
    // MARK: - PickerView Delegates
    func numberOfComponentsInPickerView(pickerView: UIPickerView!) -> Int{
        return 1
    }
    
    // returns the # of rows in each component..
    func pickerView(pickerView: UIPickerView!, numberOfRowsInComponent component: Int) -> Int{
        if pickerView == pickerview_killsDaysMonth {
            return array_killdaysmonth.count
        }
        if pickerView == pickerview_killsPerDay {
            return array_killday.count
        }
        if pickerView == pickerview_backupKills {
            return array_backup.count
        }
        return 30
    }
    
    func pickerView(pickerView: UIPickerView!, titleForRow row: Int, forComponent component: Int) -> String! {
        if pickerView == pickerview_killsDaysMonth {
            return array_killdaysmonth[row] as! String
        }
        if pickerView == pickerview_killsPerDay {
            return array_killday[row] as! String
        }
        if pickerView == pickerview_backupKills {
            return array_backup[row] as! String
        }
        return array_killdaysmonth[row] as! String
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
        if pickerView == pickerview_killsDaysMonth {
            pickerLabel.text = array_killdaysmonth[row] as? String
        }
        if pickerView == pickerview_killsPerDay {
            pickerLabel.text = array_killday[row] as? String
        }
        if pickerView == pickerview_backupKills {
            pickerLabel.text = array_backup[row] as? String
        }
        return pickerLabel
    }
    
    func pickerView(pickerView: UIPickerView!, didSelectRow row: Int, inComponent component: Int)
    {
        if pickerView == pickerview_killsDaysMonth {
            int1 = array_killdaysmonth[row].integerValue
        }
        else if pickerView == pickerview_killsPerDay {
            int2 = array_killday[row].integerValue
        }
        else if pickerView == pickerview_backupKills {
            int3 = array_backup[row].integerValue
        }
    }
    
    
    // MARK: - Save
    @IBAction func Save_btnAction(sender: AnyObject) {
        if self.appDel.checkInternetConnection() {
            killdayspermonth(int1, killsperday: int2, backupkills: int3)
        }
          else
        {
            HelperClass.MessageAletOnly(Server.noInternet, selfView: self)
       }
    }
    
    func killdayspermonth(killdayspermonth: Int, killsperday: Int, backupkills: Int) {
        appDel.Show_HUD()
        str_webservice = "apisetkills"
        let request = NSMutableURLRequest(URL: NSURL(string: "\(Server.local_server)/api/setup/apisetkills.php?")!)
        let postString = "killdayspermonth=\(int1)&killsperday=\(int2)&backupkills=\(int3)"
        objwebservice.callServiceCommon(request, postString: postString)
        
    }
    
    // MARK: - Webservice NetLost delegate
    func NetworkLost(str: String!)
    {
        HelperClass.NetworkLost(str, view1: self)
    }
    
    
    func responseDictionary(dic: NSMutableDictionary) {
        
        if (self.str_webservice == "apisetkills") {
            let msg: String!
            if (dic["success"] as! String == "False") {
                msg = "SP System Details Have Not Been Saved/n Please Try Again."
                
            }
            else
            {
                msg = "SP System Details Have Been Saved."
            }
//            dispatch_async(dispatch_get_main_queue()) {
            let alertController = UIAlertController(title: nil, message:
                msg, preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
            self.appDel.remove_HUD()
//            }
        }
        else if (self.str_webservice == "apigetkills") {
            print("ssss \(dic)")
//            dispatch_async(dispatch_get_main_queue()) {
                if dic.count != 0
                {
                      let i1:Int = abs((dic["killdayspermonth"]!.integerValue)-10)
                    let i2:Int = abs((dic["killsperday"]!.integerValue)-20)
                    let i3:Int = abs((dic["backupkills"]!.integerValue)-1)
                    
                    self.pickerview_killsDaysMonth.reloadAllComponents()
                    self.pickerview_killsDaysMonth.selectRow(i1, inComponent: 0, animated: true)
                    
                    self.pickerview_killsPerDay.reloadAllComponents()
                    self.pickerview_killsPerDay.selectRow(i2, inComponent: 0, animated: true)
                    
                    self.pickerview_backupKills.reloadAllComponents()
                    self.pickerview_backupKills.selectRow(i3, inComponent: 0, animated: true)
                    
                    self.int1 = self.array_killdaysmonth[i1].integerValue
                    self.int2 = self.array_killday[i2].integerValue
                    self.int3 = self.array_backup[i3].integerValue
                    
                }
               self.appDel.remove_HUD()
//            }
        
            
        }
//         dispatch_async(dispatch_get_main_queue()) {
            self.appDel.remove_HUD()
//        }
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
