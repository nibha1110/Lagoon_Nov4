//
//  ManageUserVC.swift
//  Crocodile
//
//  Created by Nibha Aggarwal on 5/18/16.
//  Copyright © 2016 Nibha Aggarwal. All rights reserved.
//

import UIKit

class ManageUserVC: UIViewController, responseProtocol {
    var appDel : AppDelegate!
    var objwebservice : webservice! = webservice()
    var str_webservice: String!
    var pickerLabel: UILabel!
    var array_users: NSMutableArray = []
    var _selectedRow:Int = 0
    var DictionaryGet: NSMutableDictionary! = NSMutableDictionary()
    var DictionaryUpdate: NSMutableDictionary! = NSMutableDictionary()
    
    @IBOutlet weak var pickerview_users: UIPickerView!
    //edit screen
    var str_admin: String!
    var str_move: String!
    var str_add: String!
    var str_inspection: String!
    var str_kill: String!
    var str_update: String!
    var str_report: String!
    

    @IBOutlet weak var admin_btn: UIButton!
    @IBOutlet weak var move_btn: UIButton!
    @IBOutlet weak var add_btn: UIButton!

    @IBOutlet weak var inspection_btn: UIButton!
    @IBOutlet weak var kill_btn: UIButton!
    @IBOutlet weak var update_btn: UIButton!
    @IBOutlet weak var report_btn: UIButton!
    
    @IBOutlet weak var view_editScreen: UIView!
    @IBOutlet weak var textfield_email: UITextField!
    @IBOutlet weak var textfield_password: UITextField!
    
    
    
    
    
    //MARK: - LifeCyle
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
        controller.IIndexPath = NSIndexPath(forRow: 2, inSection: 0)
        controller.btn_BackPop.hidden = true
        controller.label_header.text = "MANAGE USERS"
        controller.array_temp_section.replaceObjectAtIndex(0, withObject: "Yes")
        controller.tableMenu.reloadData()
        let arrt = controller.array_temp_row[0]
        arrt.replaceObjectAtIndex(2, withObject: "Yes")
        
        objwebservice?.delegate = self
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.GetAllUserService()
        admin_btn.selected = false
        move_btn.selected = false
        add_btn.selected = false
        inspection_btn.selected = false
        update_btn.selected = false
        kill_btn.selected = false
        report_btn.selected = false
        
        str_admin = "0";
        str_move = "0";
        str_add = "0";
        str_inspection = "0";
        str_kill = "0";
        str_update = "0";
        str_report = "0";
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - toogle btn
    @IBAction func tooogle_btnAction(sender: AnyObject) {
        let btn: UIButton = (sender as! UIButton)
        if sender.tag == 1 {
            btn.selected = !btn.selected
            if btn.selected {
                str_admin = "1"
            }
            else {
                str_admin = "0"
            }
        }
        else if sender.tag == 2 {
            btn.selected = !btn.selected
            if btn.selected {
                str_move = "1"
            }
            else {
                str_move = "0"
            }
        }
        else if sender.tag == 3 {
            btn.selected = !btn.selected
            if btn.selected {
                str_add = "1"
            }
            else {
                str_add = "0"
            }
        }
        else if sender.tag == 4 {
            btn.selected = !btn.selected
            if btn.selected {
                str_inspection = "1"
            }
            else {
                str_inspection = "0"
            }
        }
        else if sender.tag == 5 {
            btn.selected = !btn.selected
            if btn.selected {
                str_kill = "1"
            }
            else {
                str_kill = "0"
            }
        }
        else if sender.tag == 6 {
            btn.selected = !btn.selected
            if btn.selected {
                str_update = "1"
            }
            else {
                str_update = "0"
            }
        }
        else if sender.tag == 7 {
            btn.selected = !btn.selected
            if btn.selected {
                str_report = "1"
            }
            else {
                str_report = "0"
            }
        }
        
    }
    
    //MARK: - save btn
    @IBAction func save_btnAction(sender: AnyObject) {
        if (textfield_password.text! == ""){
            HelperClass.MessageAletOnly("Field cannot be blank.", selfView: self)
        }
        else if textfield_password.text!.characters.count != 0
        {
            let alertView = UIAlertController(title: nil, message: "Are You Sure You Want To Save It In The System.", preferredStyle: .Alert)
            alertView.addAction(UIAlertAction(title: "NO", style: .Cancel, handler: nil))
            alertView.addAction(UIAlertAction(title: "YES", style: UIAlertActionStyle.Default, handler: {(action:UIAlertAction) in
                print(self.textfield_email.text!)
                print(Int(self.str_add)!)

                self.UpdateUserDetailService(self.textfield_email.text!, password: self.textfield_password.text!, firstN: self.DictionaryUpdate["Fname"] as! String, LName: self.DictionaryUpdate["Lname"] as! String, admin: Int(self.str_admin)!, incubator: 0, move: Int(self.str_move)!, add: Int(self.str_add)!, inspect: Int(self.str_inspection)!, kill: Int(self.str_kill)!, update: Int(self.str_update)!, report: Int(self.str_report)!)
            }));
            presentViewController(alertView, animated: true, completion: nil)
        }
        
    }
    
    func UpdateUserDetailService(User_id: String, password pwd: String, firstN fname: String, LName lname: String, admin perAdmin: Int, incubator perIncubator: Int, move perMove: Int, add perAdd: Int, inspect perInspect: Int, kill perKill: Int, update perUpdate: Int, report perReport: Int) {
        appDel.Show_HUD()
        str_webservice = "apiupdateuser"
        let request = NSMutableURLRequest(URL: NSURL(string: "\(Server.local_server)/api/users/apiupdateuser.php?")!)
        let postString = "email=\(User_id)&password=\(pwd)&fname=\(fname)&lname=\(lname)&peradmin=\(perAdmin)&peradd=\(perAdd)&perinspect=\(perInspect)&perkill=\(perKill)&perupdate=\(perUpdate)&perreports=\(perReport)&perincubator=\(perIncubator)&permove=\(perMove)"
        objwebservice.callServiceCommon(request, postString: postString)
    }
    
    // MARK: - User List Getting
    func GetAllUserService()
    {
        if self.appDel.checkInternetConnection() {
            appDel.Show_HUD()
            self.str_webservice = "apigetallusers"
            let request = NSMutableURLRequest(URL: NSURL(string: "\(Server.local_server)/api/users/apigetallusers.php")!)
            let postString = ""
            objwebservice.callServiceCommon(request, postString: postString)
        }
        else
        {
            HelperClass.MessageAletOnly(Server.noInternet, selfView: self)
        }
    }
    
    // MARK: - Webservice NetLost delegate
    func NetworkLost(str: String!)
    {
        HelperClass.NetworkLost(str, view1: self)
    }

    // MARK: - Webservice Delegate
    func responseDictionary(dic: NSMutableDictionary)
    {
        // all user list response
        if self.str_webservice == "apigetallusers"
        {
            DictionaryGet = dic
            if (dic["AllUsers"]?.count == 0)
            {
                let alertController = UIAlertController(title: nil, message:
                    "There Is No User.", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
            }
            else
            {
                
                let count : Int = (dic["AllUsers"]?.count)!
                if array_users.count != 0 {
                    array_users.removeAllObjects()
                }
                for i in 0 ..< count
                {
                    array_users.addObject((dic["AllUsers"]![i]["name"] as? String)!)
                }
//                dispatch_async(dispatch_get_main_queue()) {
                    self.pickerview_users.reloadAllComponents()
                    let userDefaults = NSUserDefaults.standardUserDefaults()
                    userDefaults.setValue(dic["AllUsers"] as! NSMutableArray, forKey: "UserList")
//                }
            }
        }
            // delete user response
        else if self.str_webservice == "apideleteuser"
        {
            let msg:String!
            if dic["success"] as! String == "True" {
                
                msg = "User Has Been Deleted Successfully."
                
            }
            else
            {
                msg = Server.local_server
                
            }
//            dispatch_async(dispatch_get_main_queue()) {
                let alertController = UIAlertController(title: nil, message:
                    msg, preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel,handler: {(action:UIAlertAction) in
                    if msg == "User Has Been Deleted Successfully."
                    {
                        if (self.DictionaryGet["AllUsers"]![self._selectedRow]["Email"] as! String ==  NSUserDefaults.standardUserDefaults().objectForKey("email_username") as! String)
                        {
                            self.navigationController?.popToRootViewControllerAnimated(true)
                        }
                        else
                        {
                            if (self._selectedRow == 0) {
                                
                            }
                            else
                            {
                                self._selectedRow = self._selectedRow - 1
                            }
                            self.GetAllUserService()
                        }
                    }
                    
                }))
                self.presentViewController(alertController, animated: true, completion: nil)
//            }
        }
        //edit get user response
        else if (self.str_webservice == "apigetuser")
        {
            DictionaryUpdate = dic
            print(dic)
//            dispatch_async(dispatch_get_main_queue()) {
                self.textfield_password.text = dic["Password"] as? String
            
                if (dic["peradmin"]?.integerValue) == 1 {
                    self.admin_btn.selected = true
                    self.str_admin = "1"
                }
                if (dic["permove"]?.integerValue) == 1 {
                    self.move_btn.selected = true
                    self.str_move = "1"
                }
                if (dic["peradd"]?.integerValue) == 1 {
                    self.add_btn.selected = true
                    self.str_add = "1"
                }
                if (dic["perinspect"]?.integerValue) == 1 {
                    self.inspection_btn.selected = true
                    self.str_inspection = "1"
                }
                if (dic["perkill"]?.integerValue) == 1 {
                    self.kill_btn.selected = true
                    self.str_kill = "1"
                }
                if (dic["perupdate"]?.integerValue) == 1 {
                    self.update_btn.selected = true
                    self.str_update = "1"
                }
                if (dic["perreports"]?.integerValue) == 1 {
                    self.report_btn.selected = true
                    self.str_report = "1"
                }
//            }
        }
        else if (str_webservice == "apiupdateuser")
        {
            print(dic)
            let msg: String!
            if (dic["success"] as! String == "False") {
                msg = Server.ErrorMsg 
            }
            else
            {
                msg = "User Has Been Updated Successfully."
                if (NSUserDefaults.standardUserDefaults().objectForKey("email_username") as! String == textfield_email.text!) {
                    appDel.arrayState.replaceObjectAtIndex(0, withObject: Int(self.str_admin)!)
                    appDel.arrayState.replaceObjectAtIndex(1, withObject: 0)
                    appDel.arrayState.replaceObjectAtIndex(2, withObject: Int(self.str_move)!)
                    appDel.arrayState.replaceObjectAtIndex(3, withObject: Int(self.str_add)!)
                    appDel.arrayState.replaceObjectAtIndex(4, withObject: Int(self.str_inspection)!)
                    appDel.arrayState.replaceObjectAtIndex(5, withObject: Int(self.str_kill)!)
                    appDel.arrayState.replaceObjectAtIndex(6, withObject: Int(self.str_update)!)
                    appDel.arrayState.replaceObjectAtIndex(7, withObject: Int(self.str_report)!)
                }
                
            }
//            dispatch_async(dispatch_get_main_queue()) {
                let alertView = UIAlertController(title: nil, message: msg, preferredStyle: .Alert)
                alertView.addAction(UIAlertAction(title: "OK", style: .Default, handler: {(action:UIAlertAction) in
                    if (msg == "User Has Been Updated Successfully.")
                    {
                        self.view_editScreen.hidden = true
                    }
                }));
                self.presentViewController(alertView, animated: true, completion: nil)
                
//            }
            
        }
        else if (str_webservice == "apigetallusers")
        {
//            dispatch_async(dispatch_get_main_queue()) {
                let userDefaults = NSUserDefaults.standardUserDefaults()
                userDefaults.setValue(dic["AllUsers"] as! NSMutableArray, forKey: "UserList")
                self.appDel.remove_HUD()
//            }
        }
//         dispatch_async(dispatch_get_main_queue()) {
         self.appDel.remove_HUD()
//        }
    }
    
    // text Field Delegates
    func textFieldShouldReturn(textField: UITextField) -> Bool {   //delegate method
        
        textField.resignFirstResponder()
        return true
    }
    // MARK: - Edit Uder Details
    @IBAction func Edit_btnAction(sender: AnyObject) {
        if self.appDel.checkInternetConnection() {
            self.view_editScreen.hidden = false
            textfield_email.text = DictionaryGet["AllUsers"]![self._selectedRow]["Email"] as? String
            self.GetUserDetailService((DictionaryGet["AllUsers"]![self._selectedRow]["Email"] as? String)!)
        }
        else
        {
            HelperClass.MessageAletOnly(Server.noInternet, selfView: self)
        }
       
    }
    @IBAction func TextfieldBtnAction(sender: AnyObject)
    {
        self.view.endEditing(true)
    }
   
    func textField(textFieldToChange: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if (string == " ") {
            return false
        }
        
        return true
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view!.endEditing(true)
        // this will do the trick
    }
    func GetUserDetailService(email: String) {
        appDel.Show_HUD()
        self.str_webservice = "apigetuser"
        let request = NSMutableURLRequest(URL: NSURL(string: "\(Server.local_server)/api/users/apigetuser.php?")!)
        let postString = "email=\(email)"
        objwebservice.callServiceCommon(request, postString: postString)
    }
    
    @IBAction func delete_btnAction(sender: AnyObject) {
        if self.appDel.checkInternetConnection() {
            let msg:String!
            
            if ((DictionaryGet["AllUsers"]![_selectedRow]["Email"] as! String ==  NSUserDefaults.standardUserDefaults().objectForKey("email_username") as! String)){
                
                msg = "Are You Sure To Delete Yourself."
                
            }
            else
            {
                msg = "Are You Sure You Want To Delete User."
            }
            let alertController = UIAlertController(title: nil, message:
                msg, preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "NO", style: UIAlertActionStyle.Cancel,handler: nil))
            alertController.addAction(UIAlertAction(title: "YES", style: UIAlertActionStyle.Default, handler: {(action:UIAlertAction) in
                self.GetUserDeleteService()
            }))
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        else
        {
            HelperClass.MessageAletOnly(Server.noInternet, selfView: self)
        }
    }
    
    // MARK: - Delete User
    func GetUserDeleteService()
    {
        appDel.Show_HUD()
        self.str_webservice = "apideleteuser"
        let request = NSMutableURLRequest(URL: NSURL(string: "\(Server.local_server)/api/users/apideleteuser.php?")!)
        let postString = "email=\(DictionaryGet["AllUsers"]![_selectedRow]["Email"] as! String)"
        objwebservice.callServiceCommon(request, postString: postString)
        
    }
    
    // MARK: - PickerView Delegates
    func numberOfComponentsInPickerView(pickerView: UIPickerView!) -> Int{
        return 1
    }
    
    // returns the # of rows in each component..
    func pickerView(pickerView: UIPickerView!, numberOfRowsInComponent component: Int) -> Int{
        
        return array_users.count
    }
    
    func pickerView(pickerView: UIPickerView!, titleForRow row: Int, forComponent component: Int) -> String! {
        return array_users[row] as! String
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
        pickerLabel.text = array_users[row] as? String
        return pickerLabel
    }
    
    func pickerView(pickerView: UIPickerView!, didSelectRow row: Int, inComponent component: Int)
    {
        if array_users.count != 0 {
            _selectedRow = row
        }
        print(_selectedRow)
    }


}
