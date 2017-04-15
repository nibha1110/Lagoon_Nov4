//
//  ViewController.swift
//  Crocodile
//
//  Created by Nibha Aggarwal on 4/15/16.
//  Copyright © 2016 Nibha Aggarwal. All rights reserved.
//

import UIKit
import Foundation

import Crashlytics


class ViewController: UIViewController, UITextFieldDelegate, responseProtocol {
    var objwebservice : webservice! = webservice()
    var bool_textfield : Bool? = false
    var _keyboardWillHide : Bool? = false
    var DicResponse = Dictionary<String, String>()
    var str_webservice: String!
    var appDel : AppDelegate!
    
    @IBOutlet weak var textFld_email: UITextField!
    @IBOutlet weak var textFld_password:UITextField!
    
    func didFinishTask(sender: webservice) {
        // do stuff like updating the UI
        print("abc")
    }
    
    // MARK: Forgot Btn Action
    @IBAction func button_forgotPassword(sender: AnyObject) {
//        ForgotPasswordVC *forgotVC = [[ForgotPasswordVC alloc]initWithNibName:@"ForgotPasswordVC" bundle:nil];
//        [self.navigationController pushViewController:forgotVC animated:YES];
//        forgotVC = nil;
        
    }
    
    
    
    // MARK: TextField btn Action to go down keypad
    @IBAction func TextfieldBtnAction(sender: AnyObject)
    {
        bool_textfield = true
        self.view.endEditing(true)
        
        UIView.animateWithDuration(0.6, animations: {
            self.view.frame = CGRectMake(0, 0, 1024, 768)
            }, completion: {(value: Bool) in
                
        })
    }
    

    // MARK:textfield Delegates
    func textFieldDidBeginEditing(textField: UITextField) {
        _keyboardWillHide = true
        
        if textField == textFld_email
        {
            UIView.animateWithDuration(0.6, animations: {
                self.view.frame = CGRectMake(0, -200, 1024, 768)
                }, completion: {(value: Bool) in
                    self.bool_textfield = true;
            })
            
        }
        else if textField == textFld_password {
            
            UIView.animateWithDuration(0.6, animations: {
                self.view.frame = CGRectMake(0, -250, 1024, 768)
                }, completion: {(value: Bool) in
                    self.bool_textfield = true;
            })
            
        }
        textField.becomeFirstResponder()
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        textField.resignFirstResponder()
        UIView.animateWithDuration(0.6, animations: {
            self.view.frame = CGRectMake(0, 0, 1024, 768)
            }, completion: {(value: Bool) in
                self.bool_textfield = false;
        })
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {   //delegate method
        
        self.TextfieldBtnAction(self)
        textField.resignFirstResponder()
        return true
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

    func textField(textFieldToChange: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if (string == " ") {
            return false
        }
        
        return true
    }
    
    
    // MARK:Login Btn Action
    
    @IBAction func Login_btnAction(sender: AnyObject) {
        self.TextfieldBtnAction(self)   // to go keypad down
        
        if textFld_email.text!.isEqual("")
        {
            let alertView = UIAlertController(title: nil, message: "Please Enter E-Mail.", preferredStyle: .Alert)
            alertView.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            presentViewController(alertView, animated: true, completion: nil)
        }
        else if textFld_password.text!.isEqual("")
        {
            let alertView = UIAlertController(title: nil, message: "Please Enter Password.", preferredStyle: .Alert)
            alertView.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            presentViewController(alertView, animated: true, completion: nil)
        }
        else
        {
            if !textFld_email.text!.isEmpty && !textFld_password.text!.isEmpty
            {
                let emailReg = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
                let emailTest = NSPredicate(format: "SELF MATCHES %@", emailReg)
               
                if emailTest .evaluateWithObject(textFld_email.text).boolValue == true
                {
                    if self.appDel.checkInternetConnection() {
                        self.LoginService(textFld_email.text!, password: textFld_password.text!)
                    }
                    else
                    {
                        let alertView = UIAlertController(title: nil, message: Server.noInternet, preferredStyle: .Alert)
                        alertView.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                        self.presentViewController(alertView, animated: true, completion: nil)
                    }
                }
                else
                {
                    let alertView = UIAlertController(title: nil, message: "Please Enter Valid E-mail Address.", preferredStyle: .Alert)
                    alertView.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                    self.presentViewController(alertView, animated: true, completion: nil)
                    self.textFld_email.text = "";
                    self.textFld_password.text = "";
                }
                
            }
            else
            {
                textFld_email.text = "";
                textFld_password.text = "";
                
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
    
    
    func responseDictionary(dic: NSMutableDictionary){
        if (str_webservice == "apilogin")
        {
//            dispatch_async(dispatch_get_main_queue()) {
                self .ReponseGot(dic)
//            }
        }
        else if (str_webservice == "apigetallusers")
        {
//            dispatch_async(dispatch_get_main_queue()) {
                print(dic)
                let userDefaults = NSUserDefaults.standardUserDefaults()
                userDefaults.setValue(dic["AllUsers"] as! NSArray, forKey: "UserList")
                userDefaults.synchronize()
               /* if self.appDel.checkInternetConnection() {
                    self.str_webservice = "confirmkill"
                    let arraytemp: NSMutableArray! = []
                    var dictee =  [String:AnyObject]()
                    for i in 0 ..< dic["AllUsers"]!.count
                    {
                        var tempDic  = [String : AnyObject]()
                        tempDic["Email"] = dic["AllUsers"]![i]["Email"] as? String
                        tempDic["name"] = dic["AllUsers"]![i]["name"] as? String
                        tempDic["userid"] = dic["AllUsers"]![i]["userid"] as? String
                        arraytemp.addObject(tempDic)
                    }
                    dictee["userdata"] = arraytemp
                    print(dictee)
                    self.objwebservice.post(dictee, url: "http://172.20.20.72/APITEST/getdata.php") { (succeeded: Bool, msg: String) -> () in
                        
                        
                        // Move to the UI thread
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            // Show the alert
                            if(succeeded) {
                                let alertView = UIAlertController(title: nil, message: "Sucess", preferredStyle: .Alert)
                                alertView.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
                                self.presentViewController(alertView, animated: true, completion: nil)
                            }
                            else {
                                let alertView = UIAlertController(title: nil, message: "Fail", preferredStyle: .Alert)
                                alertView.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
                                self.presentViewController(alertView, animated: true, completion: nil)
                            }
                        })
                    }
                }*/
//            }
            
//                
//                let searchResults = userListArray.filter {
//                    let components = $0.componentsSeparatedByString(" ")
//                    return components[0].containsString(attributeValue)
//                }
        }
//        else if (str_webservice == "confirmkill")
//        {
//            
//        }
       
    }
     func LoginService(User_id:String, password:String?)
    {
        appDel.Show_HUD()
        str_webservice = "apilogin"
        let request = NSMutableURLRequest(URL: NSURL(string: "\(Server.local_server)/api/users/apilogin.php?")!)
        let postString = "email=\(textFld_email.text!)&pwd=\(textFld_password.text!)"
        objwebservice.callServiceCommon(request, postString: postString)
    }
    
    func ReponseGot(dic_temp: NSMutableDictionary!)
    {
        if (dic_temp["success"]! .isEqual("False"))
        {
            
                let alertController = UIAlertController(title: nil, message:
                    "Entered Details Are Invalid or Incorrect\n Please Try Again.", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
            
        }
        else
        {
            self.usersList()
            
            print("else")
            let FName:String  = dic_temp["Fname"] as! String
            let LName:String = dic_temp["Lname"] as! String
            let fullName:String = FName + " " + LName

            
            
            let userDefaults = NSUserDefaults.standardUserDefaults()
            userDefaults.setValue(fullName, forKey: "username")
            userDefaults.setValue(dic_temp["username"] as! String, forKey: "email_username")
            userDefaults.synchronize()
        
            if (appDel.arrayState.count > 0){
                appDel.arrayState.removeAllObjects()
            }
            appDel.arrayState.addObject(Int(dic_temp["peradmin"] as! String)!)
            appDel.arrayState.addObject(Int(dic_temp["perincubator"] as! String)!)
            appDel.arrayState.addObject(Int(dic_temp["permove"] as! String)!)
            appDel.arrayState.addObject(Int(dic_temp["peradd"] as! String)!)
            appDel.arrayState.addObject(Int(dic_temp["perinspect"] as! String)!)
            appDel.arrayState.addObject(Int(dic_temp["perkill"] as! String)!)
            appDel.arrayState.addObject(Int(dic_temp["perupdate"] as! String)!)
            appDel.arrayState.addObject(Int(dic_temp["perreports"] as! String)!)
            
            
            self.navigationController!.pushViewController(self.storyboard!.instantiateViewControllerWithIdentifier("HomeVC") as UIViewController, animated: true)
            
        }
        appDel.remove_HUD()
    }
    
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textFld_email.delegate = self
        self.textFld_password.delegate = self
        objwebservice?.delegate = self
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        appDel = (UIApplication.sharedApplication().delegate as! AppDelegate)
       
        
//        let button = UIButton(type: UIButtonType.RoundedRect)
//        button.frame = CGRectMake(20, 50, 100, 30)
//        button.setTitle("Crash", forState: UIControlState.Normal)
//        button.addTarget(self, action: #selector(self.crashButtonTapped(_:)), forControlEvents: UIControlEvents.TouchUpInside)
//        view.addSubview(button)

    }
    
//    @IBAction func crashButtonTapped(sender: AnyObject) {
//        Crashlytics.sharedInstance().crash()
//    }
    


    //
    override func viewWillAppear(animated: Bool) {
        textFld_email.text = "crocapp@gmail.com"
        textFld_password.text = "welcomeca"
    }
    
    override func viewDidDisappear(animated: Bool) {
        bool_textfield = true
        self.view.endEditing(true)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func usersList()
    {
        str_webservice = "apigetallusers"
        let request = NSMutableURLRequest(URL: NSURL(string: "\(Server.local_server)/api/users/apigetallusers.php")!)
        let postString = ""
        objwebservice.callServiceCommon(request, postString: postString)
    }
    

}

