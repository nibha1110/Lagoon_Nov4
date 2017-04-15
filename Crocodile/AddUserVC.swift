//
//  AddUserVC.swift
//  Crocodile
//
//  Created by Nibha Aggarwal on 5/12/16.
//  Copyright © 2016 Nibha Aggarwal. All rights reserved.
//

import UIKit

class AddUserVC: UIViewController, responseProtocol {
    var objwebservice : webservice! = webservice()
    @IBOutlet weak var textfield_firstName: UITextField!
    @IBOutlet weak var textfield_lastName: UITextField!
    @IBOutlet weak var textfield_password: UITextField!
    @IBOutlet weak var textfield_email: UITextField!
    var _keyboardWillHide : Bool? = false
    var bool_textfield : Bool? = false
    var appDel : AppDelegate!
    var str_admin: String!
    var str_move: String!
    var str_add: String!
    var str_inspection: String!
    var str_kill: String!
    var str_update: String!
    var str_report: String!
    var str_webservice: String!

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
        controller.IIndexPath = NSIndexPath(forRow: 1, inSection: 0)
        controller.label_header.text = "USER SETUP"
        controller.btn_BackPop.hidden = true
        controller.array_temp_section.replaceObjectAtIndex(0, withObject: "Yes")
        controller.tableMenu.reloadData()
        let arrt = controller.array_temp_row[0]
        arrt.replaceObjectAtIndex(1, withObject: "Yes")
        
        objwebservice?.delegate = self
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
        str_admin = "1"
        str_move = "1"
        str_inspection = "1"
        str_add = "1"
        str_update = "1"
        str_report = "1"
        str_kill = "1"
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - toogle Button
    @IBAction func button_toggles(sender: AnyObject) {
        let btn: UIButton = (sender as! UIButton)
        if sender.tag == 1 {
            btn.selected = !btn.selected
            if btn.selected {
                str_admin = "0"
            }
            else {
                str_admin = "1"
            }
        }
        else if sender.tag == 2 {
            btn.selected = !btn.selected
            if btn.selected {
                str_move = "0"
            }
            else {
                str_move = "1"
            }
        }
        else if sender.tag == 3 {
            btn.selected = !btn.selected
            if btn.selected {
                str_add = "0"
            }
            else {
                str_add = "1"
            }
        }
        else if sender.tag == 4 {
            btn.selected = !btn.selected
            if btn.selected {
                str_inspection = "0"
            }
            else {
                str_inspection = "1"
            }
        }
        else if sender.tag == 5 {
            btn.selected = !btn.selected
            if btn.selected {
                str_kill = "0"
            }
            else {
                str_kill = "1"
            }
        }
        else if sender.tag == 6 {
            btn.selected = !btn.selected
            if btn.selected {
                str_update = "0"
            }
            else {
                str_update = "1"
            }
        }
        else if sender.tag == 7 {
            btn.selected = !btn.selected
            if btn.selected {
                str_report = "0"
            }
            else {
                str_report = "1"
            }
        }
        
    }
    
    // MARK: - Save_btnAction

    @IBAction func Save_btnAction(sender: AnyObject) {
        self.TextfieldBtnAction(sender)
        if self.appDel.checkInternetConnection() {
            if (textfield_email.text! == "") || (textfield_firstName.text! == "") || (textfield_lastName.text! == "") || (textfield_password.text! == "") {
                let alertView = UIAlertController(title: nil, message: "All Fields Are Required.", preferredStyle: .Alert)
                alertView.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                presentViewController(alertView, animated: true, completion: nil)
                
            }
            else if textfield_email.text!.characters.count != 0 && textfield_firstName.text!.characters.count != 0 && textfield_lastName.text!.characters.count != 0 && textfield_password.text!.characters.count != 0
            {
                let alertView = UIAlertController(title: nil, message: "Are You Sure You Want To Save It In The System.", preferredStyle: .Alert)
                alertView.addAction(UIAlertAction(title: "NO", style: .Cancel, handler: nil))
                alertView.addAction(UIAlertAction(title: "YES", style: UIAlertActionStyle.Default, handler: {(action:UIAlertAction) in
                    print(self.textfield_email.text!)
                    print(Int(self.str_add)!)
                    self.AddUserService(self.textfield_email.text!, password: self.textfield_password.text!, firstN: self.textfield_firstName.text!, LName: self.textfield_lastName.text!, admin: Int(self.str_admin)!, incubator: 0, move: Int(self.str_move)!, add: Int(self.str_add)!, inspect: Int(self.str_inspection)!, kill: Int(self.str_kill)!, update: Int(self.str_update)!, report: Int(self.str_report)!)
                }));
                presentViewController(alertView, animated: true, completion: nil)
            }

        }
        else
        {
            let alertView = UIAlertController(title: nil, message: Server.noInternet, preferredStyle: .Alert)
            alertView.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(alertView, animated: true, completion: nil)
        }
        
        
       
    }
    
    
    func AddUserService(User_id: String, password: String, firstN: String, LName: String, admin: Int, incubator: Int, move: Int, add: Int, inspect: Int, kill: Int, update: Int, report: Int)
    {
        str_webservice = "apiregisteruser"
        appDel.Show_HUD()
        let request = NSMutableURLRequest(URL: NSURL(string: "\(Server.local_server)/api/users/apiregisteruser.php?")!)
        let postString = "email=\(User_id)&password=\(password)&fname=\(firstN)&lname=\(LName)&peradmin=\(admin)&peradd=\(add)&perinspect=\(inspect)&perkill=\(kill)&perupdate=\(update)&perreports=\(report)&perincubator=\(incubator)&permove=\(move)"
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
    
    func responseDictionary(dic: NSMutableDictionary) {
        if str_webservice == "apiregisteruser" {
            let msg: String!
            if (dic["success"] as! String == "False") {
                if (dic["Message"] as! String == "Email already registered") {
                    msg = "UserName Already Exists."
                    
                }
                else {
                    msg = "Entered Details Are Invalid Or Incorrect."
                }
            }
            else
            {
                self.usersList()
                msg = "User Has Been Added Successfully."
                
                
            }
//            dispatch_async(dispatch_get_main_queue()) {
                let alertView = UIAlertController(title: nil, message: msg, preferredStyle: .Alert)
                alertView.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                self.presentViewController(alertView, animated: true, completion: nil)
                self.appDel.remove_HUD()
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
    }
    
    
    func usersList()
    {
        
        str_webservice = "apigetallusers"
        let request = NSMutableURLRequest(URL: NSURL(string: "\(Server.local_server)/api/users/apigetallusers.php")!)
        let postString = ""
        objwebservice.callServiceCommon(request, postString: postString)
    }
    

    
    // MARK:textfield Delegates
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.becomeFirstResponder()
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        textField.resignFirstResponder()
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {   //delegate method
        
        textField.resignFirstResponder()
        return true
    }
 
    func textField(textFieldToChange: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
      
        if(textFieldToChange==textfield_firstName)
        {
         // limit to 1 characters
        let characterCountLimit = 1
        
        // We need to figure out how many characters would be in the string after the change happens
        let startingLength = textFieldToChange.text?.characters.count ?? 0
        let lengthToAdd = string.characters.count
        let lengthToReplace = range.length
        
        let newLength = startingLength + lengthToAdd - lengthToReplace
        
        return newLength <= characterCountLimit
       }
        if (string == " ") {
            return false
        }
        
              return true
      }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view!.endEditing(true)
        // this will do the trick
    }
//    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
//        view.endEditing(true)
//        super.touchesBegan(touches, withEvent: event)
//       
//    }
     // MARK: TextField btn Action to go down keypad
    @IBAction func TextfieldBtnAction(sender: AnyObject)
    {
        bool_textfield = true
        self.view.endEditing(true)
        _keyboardWillHide = true
    }
    
  
    
    // MARK: - Keyboard hide
    func keyboardWillHide(notification: NSNotification)
    {
        if (_keyboardWillHide == true) {
            UIView.animateWithDuration(0.5, animations: {
                self.view.frame = CGRectMake(0, 0, 1024, 768)
                }, completion: {(value: Bool) in
                    
            })
        }
        _keyboardWillHide = false
    }
    
    func validate(YourEMailAddress: String) -> Bool {
        let REGEX: String
        REGEX = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", REGEX).evaluateWithObject(YourEMailAddress)
    }

}
