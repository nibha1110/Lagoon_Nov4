//
//  InspectionVC.swift
//  Crocodile
//
//  Created by Nibha Aggarwal on 5/18/16.
//  Copyright © 2016 Nibha Aggarwal. All rights reserved.
//

import UIKit

class InspectionVC: UIViewController, responseProtocol, CommonClassProtocol {
    
    var objwebservice : webservice! = webservice()
    var str_webservice: String!
    var str_btnClicked: String!
    var int_animals: Int?
    var int_month: Int?
    var pickerLabel: UILabel!
    var DicResponse_animals:NSMutableDictionary! = NSMutableDictionary()
    var DicResponse_month:NSMutableDictionary! = NSMutableDictionary()
    var appDel : AppDelegate!
    @IBOutlet weak var pickerview_animals: UIPickerView!
    @IBOutlet weak var pickerview_month: UIPickerView!
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        appDel = (UIApplication.sharedApplication().delegate as! AppDelegate)
        guard let controller = self.storyboard!.instantiateViewControllerWithIdentifier("CommonClassVC") as? CommonClassVC
            else {
                fatalError();
        }
        addChildViewController(controller)
        controller.view.frame = CGRectMake(0, 0, 1024, 768)
        controller.array_tableSection = ["inspection"]
        controller.array_sectionRow = [[]]
        view.addSubview(controller.view)
        view.sendSubviewToBack(controller.view)
        controller.btn_Sync.hidden = false
        controller.img_Sync.hidden = false
        controller.btn_BackPop.hidden = true
        controller.label_header.text = "SP INSPECTION"
        controller.IIndexPath = NSIndexPath(forRow: 0, inSection: 3)
        controller.array_temp_section.replaceObjectAtIndex(3, withObject: "Yes")
        controller.tableMenu.reloadData()

        objwebservice?.delegate = self
        
        controller.delegate = self
        
        appDel.ForInspectionComes = "Notcome"
        
        
        let arrayTemp: NSMutableArray! = []
        autoreleasepool{
            for i in 20 ..< 101
            {
                let dicTemp: NSMutableDictionary! = NSMutableDictionary()
                dicTemp.setObject(i, forKey: "no")
                arrayTemp.addObject(dicTemp)
            }
        }
        
        DicResponse_animals.removeAllObjects()
        DicResponse_animals.setObject(arrayTemp, forKey: "animalnos")
        
        let arrayTemp1: NSMutableArray! = []
        for i in 1 ..< 13
        {
            let dicTemp: NSMutableDictionary! = NSMutableDictionary()
            dicTemp.setObject(i, forKey: "month")
            arrayTemp1.addObject(dicTemp)
        }
        autoreleasepool{
            arrayTemp1
        }
        DicResponse_month.removeAllObjects()
        DicResponse_month.setObject(arrayTemp1, forKey: "monthlist")
        
//        dispatch_async(dispatch_get_main_queue()) {
            //pickerview_animals
            self.pickerview_animals.reloadAllComponents()
            if (self.DicResponse_animals["animalnos"]?.count != 0)
            {
                if (self.DicResponse_animals["animalnos"]?.count > 20)
                {
                    self.int_animals = (self.DicResponse_animals["animalnos"]![60]["no"])!!.integerValue
                    self.pickerview_animals.selectRow(60, inComponent: 0, animated: true)
                }
                else
                {
                    self.int_animals = (self.DicResponse_animals["animalnos"]![0]["no"])!!.integerValue
                    self.pickerview_animals.selectRow(0, inComponent: 0, animated: true)
                }
            }
            
            //pickerview_month
            self.pickerview_month.reloadAllComponents()
            if (self.DicResponse_month["monthlist"]?.count != 0)
            {
                if (self.DicResponse_month["monthlist"]?.count > 7)
                {
                    self.int_month = (self.DicResponse_month["monthlist"]![7]["month"])!!.integerValue
                    self.pickerview_month.selectRow(7, inComponent: 0, animated: true)
                }
                else
                {
                    self.int_month = (self.DicResponse_month["monthlist"]![0]["month"])!!.integerValue
                    self.pickerview_month.selectRow(0, inComponent: 0, animated: true)
                }
            }
//        }
    }

    override func viewWillAppear(animated: Bool) {
        str_btnClicked = ""
        self.appDel.ForInspectionComes = ""
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: -  CommonClass Delegate
    func responseCommonClassOffline() {
        
    }
    
    // MARK: - Webservice NetLost delegate
    func NetworkLost(str: String!)
    {
        HelperClass.NetworkLost(str, view1: self)
    }
    
    //MARK: - Webservcie Delegate  Uncomment if want to use
    func responseDictionary(dic: NSMutableDictionary) {
    }
    
    
    // MARK: - PickerView Delegates
    func numberOfComponentsInPickerView(pickerView: UIPickerView!) -> Int{
        return 1
    }
    
    // returns the # of rows in each component..
    func pickerView(pickerView: UIPickerView!, numberOfRowsInComponent component: Int) -> Int{
        if pickerView == pickerview_animals {
            if DicResponse_animals.count != 0 {
                return (DicResponse_animals["animalnos"]?.count)!
            }
        }
        else if pickerView == pickerview_month {
            if DicResponse_month.count != 0 {
                return (DicResponse_month["monthlist"]?.count)!
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
            pickerLabel.font = UIFont(name: "HelveticaNeue", size: 40)
        }
        if pickerView == pickerview_animals {
            pickerLabel.text = "\((self.DicResponse_animals["animalnos"]![row]["no"])!!.integerValue)"
        }
        else if pickerView == pickerview_month {
            pickerLabel.text = "\((DicResponse_month["monthlist"]![row]["month"])!!.integerValue)"
        }
        return pickerLabel
    }
    
    func pickerView(pickerView: UIPickerView!, didSelectRow row: Int, inComponent component: Int)
    {
        if pickerView == pickerview_animals {
            int_animals = (DicResponse_animals["animalnos"]![row]["no"])!!.integerValue
        }
        else if pickerView == pickerview_month {
            int_month = (DicResponse_month["monthlist"]![row]["month"])!!.integerValue
        }
    }
    
    //MARK: - AutoInspection
    @IBAction func AutoInspection_btnAction(sender: AnyObject) {
        
            str_btnClicked = "autoInspection"
            self.performSegueWithIdentifier("toInspectionList", sender: self)
    }
    
    //MARK: - Create
    @IBAction func Create_btnAction(sender: AnyObject) {
        str_btnClicked = "create"
        self.performSegueWithIdentifier("toInspectionList", sender: self)
    }
    
    //MARK: - AllSizesList
    @IBAction func AllSizesList_btnAction(sender: AnyObject) {
        str_btnClicked = "AllSizesList"
        self.performSegueWithIdentifier("toInspectionList", sender: self)
        
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "toInspectionList") {
            let objVC = segue.destinationViewController as! InspectionListVC;
            objVC.toPassArray .addObject(int_animals!)
            objVC.toPassArray .addObject(int_month!)
            objVC.toPassArray .addObject(str_btnClicked)
        }
    }
    

}
