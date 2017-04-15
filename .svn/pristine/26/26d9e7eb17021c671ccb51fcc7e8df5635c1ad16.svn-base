//
//  ForgotVC.swift
//  Crocodile
//
//  Created by Rashmi Deshwal on 22/06/16.
//  Copyright © 2016 Nibha Aggarwal. All rights reserved.
//

import UIKit
import Foundation

class ForgotVC: UIViewController, UITextFieldDelegate, responseProtocol {
    var bool_textfield : Bool? = false
    var _keyboardWillHide : Bool? = false
    var objwebservice : webservice! = webservice()
    var DicResponse = Dictionary<String, String>()
    var DictionaryGet: NSMutableDictionary! = NSMutableDictionary()
    var str_webservice: String!
    var appDel : AppDelegate!
    
    @IBOutlet weak var txtFld_email: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        objwebservice?.delegate = self
        appDel = (UIApplication.sharedApplication().delegate as! AppDelegate)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK:textfield Delegates
    func textFieldDidBeginEditing(textField: UITextField) {
        _keyboardWillHide = true
        
        if textField == txtFld_email
        {
            UIView.animateWithDuration(0.6, animations: {
                self.view.frame = CGRectMake(0, -200, 1024, 768)
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
    

  //Mark : Back Button
    @IBAction func btn_back(sender: AnyObject) {
     navigationController?.popViewControllerAnimated(true)
    }
    
    //Mark : Submit Button
    @IBAction func btn_submit(sender: AnyObject) {
        if txtFld_email.text!.isEqual("")
        {
            let alertView = UIAlertController(title: nil, message: "Please Enter E-Mail.", preferredStyle: .Alert)
            alertView.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            presentViewController(alertView, animated: true, completion: nil)
        }
        else
        {
            if !txtFld_email.text!.isEmpty
            {
                let emailReg = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
                let emailTest = NSPredicate(format: "SELF MATCHES %@", emailReg)
                
                if emailTest .evaluateWithObject(txtFld_email.text).boolValue == true
                {
                    txtFld_email.resignFirstResponder()
                    if self.appDel.checkInternetConnection() {
                        self.ForgotService(txtFld_email.text!)
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
//                    dispatch_async(dispatch_get_main_queue()) {
                        let alertView = UIAlertController(title: nil, message: "Please Enter Valid E-mail Address.", preferredStyle: .Alert)
                        alertView.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                        self.presentViewController(alertView, animated: true, completion: nil)
                        self.txtFld_email.text = "";
                     
//                    }
                }
               }
            else
            {
                txtFld_email.text = "";
            }
        }
    }

    //MARk :- Forgot Service
    func ForgotService(User_id:String?)
    {
        appDel.Show_HUD()
        str_webservice = "apiForgot"
        let request = NSMutableURLRequest(URL: NSURL(string: "\(Server.local_server)/api/users/apiforgotpass.php?")!)
        let postString = "email=\(txtFld_email.text!)"
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

    
    func responseDictionary(dic: NSMutableDictionary){
        if (str_webservice == "apiForgot")
        {
//            dispatch_async(dispatch_get_main_queue()) {
                if (dic["success"]!.isEqual("False"))
                {
                    let alertView = UIAlertController(title: nil, message: "Entered Details Are Invalid or Incorrect\n Please Try Again.", preferredStyle: .Alert)
                    alertView.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
                    self.presentViewController(alertView, animated: true, completion: nil)
                }
                    
                else if(dic["success"]!.isEqual("True"))
                {
                    let alertView = UIAlertController(title: nil, message: "Password Has Been Sent To Your E-mail Id.", preferredStyle: .Alert)
                    alertView.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
                    self.presentViewController(alertView, animated: true, completion: nil)
                    
                }
                self.txtFld_email.resignFirstResponder()
//            }
        }
//        dispatch_async(dispatch_get_main_queue()) {
            self.appDel.remove_HUD()
//        }
    }

//    func textField(textField: UITextField,
//                   shouldChangeCharactersInRange range: NSRange,
//                                                 replacementString string: String) -> Bool {
//        
//        // Create an `NSCharacterSet` set which includes everything *but* the digits
//        let inverseSet = NSCharacterSet(charactersInString:"0123456789").invertedSet
//        
//        // At every character in this "inverseSet" contained in the string,
//        // split the string up into components which exclude the characters
//        // in this inverse set
//        let components = string.componentsSeparatedByCharactersInSet(inverseSet)
//        
//        // Rejoin these components
//        let filtered = components.joinWithSeparator("")  // use join("", components) if you are using Swift 1.2
//        
//        // If the original string is equal to the filtered string, i.e. if no
//        // inverse characters were present to be eliminated, the input is valid
//        // and the statement returns true; else it returns false
//        return string == filtered
//        
//    }
    
}
