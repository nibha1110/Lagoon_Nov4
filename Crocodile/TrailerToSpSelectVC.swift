//
//  TrailerToSpSelectVC.swift
//  Crocodile
//
//  Created by Nibha Aggarwal on 10/17/16.
//  Copyright © 2016 Nibha Aggarwal. All rights reserved.
//

import UIKit

class TrailerToSpSelectVC: UIViewController {
    var array_Group: NSMutableArray = ["IFP", "IFTP", "OFP", "RTF"]
    var array_username: NSMutableArray! = []
    var toPass : NSMutableDictionary! = NSMutableDictionary()
    
    var str_group: String!
    var str_grader: String!
    var pickerLabel: UILabel!
    
    var appDel : AppDelegate!
    var objwebservice : webservice! = webservice()
    
    @IBOutlet weak var Label_showPens: UILabel!
    @IBOutlet weak var picker_group: UIPickerView!
    @IBOutlet weak var pickerview_UserName: UIPickerView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appDel = (UIApplication.sharedApplication().delegate as! AppDelegate)
        guard let controller = self.storyboard!.instantiateViewControllerWithIdentifier("CommonClassVC") as? CommonClassVC
            else {
                fatalError();
        }
        addChildViewController(controller)
        controller.view.frame = CGRectMake(0, 0, 1024, 768)
        controller.array_tableSection = ["add"]
        controller.array_sectionRow = [["SP_ADD_unselected", "Load_to_trailer", "Trailer_to SP_unselected", "All_empty_pens", "Add_animal_unselected"]]
        view.addSubview(controller.view)
        view.sendSubviewToBack(controller.view)
        controller.IIndexPath = NSIndexPath(forRow: 2, inSection: 2)
       
        controller.label_header.text = "TRAILER TO SP"
        controller.array_temp_section.replaceObjectAtIndex(2, withObject: "Yes")
        controller.tableMenu.reloadData()
        let arrt = controller.array_temp_row[2]
        arrt.replaceObjectAtIndex(2, withObject: "Yes")
        
//        objwebservice?.delegate = self
        
        
        
        picker_group.reloadAllComponents()
        picker_group.selectRow(0, inComponent: 0, animated: true)  //1
        str_group = array_Group[0] as! String
        
        array_username = NSUserDefaults.standardUserDefaults().objectForKey("UserList")?.mutableCopy() as! NSMutableArray
        
        Label_showPens.text = "\(toPass["namexx"] as! String)-\(toPass["nameyy"] as! String)"
        
        if array_username.count != 0 {
            str_grader = array_username[0]["userid"] as? String
        }
        
        
        print(array_username)
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
        if pickerView == picker_group {
                return array_Group.count
        }
        
        else if pickerView == pickerview_UserName {
            if array_username.count != 0 {
                return array_username.count
            }
            
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
            pickerLabel.font = UIFont(descriptor: UIFontDescriptor(name: "HelveticaNeue", size: 32), size: 32.0)
        }
        if pickerView == picker_group {
            pickerLabel.text = array_Group[row] as? String
        }
        else if pickerView == pickerview_UserName {
            
            pickerLabel.text = array_username[row]["name"] as? String
        }
        return pickerLabel
        
        
    }
    
    
    
    func pickerView(pickerView: UIPickerView!, didSelectRow row: Int, inComponent component: Int)
    {
        if pickerView == picker_group
        {
            str_group = array_Group[row] as? String
        }
        else if pickerView == pickerview_UserName
        {
            str_grader = array_username[row]["userid"] as? String
        }
    }
    
    @IBAction func Select_btnAction(sender: AnyObject) {
        
        toPass["group"] = str_group
        toPass["grader"] = str_grader
        
        print(toPass)
        
        let objVC = self.storyboard?.instantiateViewControllerWithIdentifier("TrailerToSpAvailableVC") as! TrailerToSpAvailableVC
        objVC.toPass = toPass
        self.navigationController?.pushViewController(objVC, animated: false)
        
//        self.performSegueWithIdentifier("toTrailerEmpty", sender: self)
    }

    
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "toTrailerEmpty") {
            let objVC = segue.destinationViewController as! TrailerToSpAvailableVC;
            
            print(toPass)
            objVC.toPass = toPass
        }
    }
}
