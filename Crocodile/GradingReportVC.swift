//
//  GradingReport.swift
//  Crocodile
//
//  Created by Nibha Aggarwal on 5/19/16.
//  Copyright © 2016 Nibha Aggarwal. All rights reserved.
//

import UIKit
import Charts

class GradingReportVC: UIViewController, responseProtocol, userlistProtocol, CalendarProtocol, CommonClassProtocol {
    var objwebservice : webservice! = webservice()
    var objuserList : UserListView! = UserListView()
    var objDatePicker : CalendarView! = CalendarView()
    
    @IBOutlet weak var picker_Date: UIDatePicker!
    @IBOutlet weak var picker_Users: UIPickerView!
    @IBOutlet weak var textfield_StopDate: UITextField!
    @IBOutlet weak var view_Graders: UIView!
    @IBOutlet weak var label_userSelected: UILabel!
    
    var array_ylable: NSMutableArray! = ["0"]
    var array_List: NSMutableArray! = []
    var str_webservice: String!
    var pickerLabel: UILabel!
    var Bool_viewUsers: Bool = false
    var Bool_viewGraders: Bool = false
    var Bool_viewcalendar: Bool = false
    var rowUserSelected: Int! = 0
    var appDel : AppDelegate!
    
    //For Chart
    @IBOutlet weak var barChartView: BarChartView!
    var monthstemp: [AnyObject] = []
    var unitTemp: [AnyObject] = []
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let controller = self.storyboard!.instantiateViewControllerWithIdentifier("CommonClassVC") as? CommonClassVC
            else {
                fatalError();
        }
        addChildViewController(controller)
        controller.view.frame = CGRectMake(0, 0, 1024, 768)
        controller.array_tableSection = ["report"]
        controller.array_sectionRow = [["sddreport", "killreport", "gradingreport", "aging", "spinuserepoert",  "Community_Pens_Report_Unsel", "Diereport_unselect", "Readyreport_unselect", "AverageReport_unselect"]]
        view.addSubview(controller.view)
        view.sendSubviewToBack(controller.view)
        controller.label_header.text = "GRADING REPORT"
        controller.IIndexPath = NSIndexPath(forRow: 2, inSection: 6)
        controller.array_temp_section.replaceObjectAtIndex(6, withObject: "Yes")
        controller.tableMenu.reloadData()
        let arrt = controller.array_temp_row[6]
        arrt.replaceObjectAtIndex(2, withObject: "Yes")
        
        controller.btn_Sync.hidden = false
        controller.img_Sync.hidden = false
        controller.btn_BackPop.hidden = true
        
        controller.delegate = self
        
        objwebservice?.delegate = self
        objuserList = UserListView.instanceFromNib() as! UserListView
        objuserList?.delegate = self
        
        objDatePicker = CalendarView.instanceFromNib() as! CalendarView
        objDatePicker?.delegate = self
        
        
        array_List = NSUserDefaults.standardUserDefaults().valueForKey("UserList")?.mutableCopy() as! NSMutableArray
        appDel = (UIApplication.sharedApplication().delegate as! AppDelegate)
    }

    override func viewWillAppear(animated: Bool) {
        textfield_StopDate.text = "\(objDatePicker.todaydate())"
        
        
        rowUserSelected = picker_Users.selectedRowInComponent(0)
        label_userSelected.text = "  \(array_List.objectAtIndex(rowUserSelected).valueForKey("name") as! String)"
        picker_Users.reloadAllComponents()
    }
    
    
    override func viewDidAppear(animated: Bool) {
        if self.appDel.checkInternetConnection() {
         self.getGradingReportService()
        }
        else
        {
            HelperClass.MessageAletOnly(Server.noInternet, selfView: self)
        }
    }
     override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - getGradingReportService
    func getGradingReportService()
    {
        appDel.Show_HUD()
        str_webservice = "grading_report"
        var stop: String! = textfield_StopDate.text!.stringByReplacingOccurrencesOfString(" ", withString: "")
        stop = stop.stringByReplacingOccurrencesOfString("/", withString: "-")
        let request = NSMutableURLRequest(URL: NSURL(string: "\(Server.local_server)/api/sp_reports/grading_report.php?")!)
        let postString = "datefrom=\(stop)&graderid=\(array_List.objectAtIndex(rowUserSelected).valueForKey("userid") as! String)"
        
        objwebservice.callServiceCommon(request, postString: postString)
    }
    
    //MARK: - CommonClass Delegate
    func responseCommonClassOffline() {
        self.viewDidAppear(false)
    }
    
    
    // MARK: - Webservice NetLost delegate
    func NetworkLost(str: String!)
    {
        HelperClass.NetworkLost(str, view1: self)
    }
    
    //MARK: - Webservice Delegate
    func responseDictionary(dic: NSMutableDictionary) {
        if str_webservice == "grading_report" {
            print(dic)
            array_ylable.removeAllObjects()
            
            
            monthstemp.removeAll()
            unitTemp.removeAll()
            
            if dic["GraderReport"] != nil {
                if dic["GraderReport"]?.count != 0 {
                    autoreleasepool{
                        for i in 0 ..< dic["GraderReport"]!.count {
                            array_ylable.addObject("\(dic["GraderReport"]![i]["count"] as! NSNumber)")
                            
                            monthstemp.append(dic["GraderReport"]![i]["months"] as! String)
                            let myDouble = Double("\(dic["GraderReport"]![i]["count"] as! NSNumber)")
                            unitTemp.append(myDouble!)
                        }
                    }
                    
                    
                    
                    
                
                
                    var valueNotZero: String! = "YES"
                    for j in 0 ..< array_ylable.count {
                        if !(array_ylable[j] as! String == "0") {
                            valueNotZero = "NO"
                        }
                    }
                    
                    
                    if valueNotZero == "YES" {
                        monthstemp.removeAll()
                        unitTemp.removeAll()
                        monthstemp.append("There Is No Data For Related Grader")
                        let myDouble = Double("0")
                        unitTemp.append(myDouble!)
                        setChart(monthstemp as! [String], values: unitTemp as! [Double])
                        
                    }
                    else
                    {
                        setChart(monthstemp as! [String], values: unitTemp as! [Double])
                    }
                }
                else
                {
                    array_ylable.addObject("0")
                    
                    monthstemp.append("There Is No Data For Related Grader")
                    let myDouble = Double("0")
                    unitTemp.append(myDouble!)
                    setChart(monthstemp as! [String], values: unitTemp as! [Double])
                }
            }
        }
            //
        else if (str_webservice == "report_grader")
        {
            var msg: String!
            if dic["success"] as! String == "True" {
                msg = "Mail Sent."
            }
            else
            {
                msg = "Mail Not Sent."
            }
                HelperClass.MessageAletOnly(msg, selfView: self)
        }
            self.appDel.remove_HUD()
    }
    
    
    // MARK: - PickerView Delegates
    func numberOfComponentsInPickerView(pickerView: UIPickerView!) -> Int{
        return 1
    }
    
    // returns the # of rows in each component..
    func pickerView(pickerView: UIPickerView!, numberOfRowsInComponent component: Int) -> Int{
        if pickerView == picker_Users {
            print(array_List.count)
            return array_List.count
        }
        else if pickerView == picker_Date {
            
        }
        
        return 0
    }
    
    
    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 45.0
    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView) -> UIView {
        pickerLabel = (view as! UILabel)
        if pickerLabel == nil {
            let frame: CGRect = CGRectMake(10, 0, 250, 65)
            pickerLabel = UILabel(frame: frame)
            pickerLabel.textAlignment = .Center
            pickerLabel.textColor = UIColor.blackColor()
            pickerLabel.font = UIFont(descriptor: UIFontDescriptor(name: "HelveticaNeue", size: 20), size: 20.0)
        }
        if pickerView == picker_Users {
            pickerLabel.text = array_List.objectAtIndex(row).valueForKey("name") as? String
        }
        else if pickerView == picker_Date {
            
        }
        
        return pickerLabel
    }
    
    
    
    func pickerView(pickerView: UIPickerView!, didSelectRow row: Int, inComponent component: Int)
    {
        
    }
    
    //MARK: - Grader Picker View/ User View Done/Cancel
    @IBAction func GraderShowList(sender: AnyObject)
    {
        objuserList.removeView(self.view)
        Bool_viewUsers = false
        
        objDatePicker.removeDateView(self.view)
        Bool_viewcalendar = false
        
        if !Bool_viewGraders {
            view_Graders.hidden = true
            let transitionOptions = UIViewAnimationOptions.TransitionCurlDown
            UIView.transitionWithView(self.view_Graders, duration: 0.6, options: transitionOptions, animations: {
                self.view_Graders.hidden = false
                
                }, completion: { finished in
                    
                    self.Bool_viewGraders = true
            })
            
        }
        else {
            let transitionOptions = UIViewAnimationOptions.TransitionCurlUp
            UIView.transitionWithView(self.view_Graders, duration: 0.6, options: transitionOptions, animations: {
                self.view_Graders.hidden = true
                
                }, completion: { finished in
                    
                    self.Bool_viewGraders = false
            })
            
        }
        
    }
    
    @IBAction func CancelBtn_Users(sender: AnyObject)
    {
        let transitionOptions = UIViewAnimationOptions.TransitionCurlUp
        UIView.transitionWithView(self.view_Graders, duration: 0.6, options: transitionOptions, animations: {
            self.view_Graders.hidden = true
            
            }, completion: { finished in
                
                self.Bool_viewGraders = false
        })
        
    }
    
    
    @IBAction func DoneBtn_Users(sender: AnyObject)
    {
        rowUserSelected = picker_Users.selectedRowInComponent(0)
        label_userSelected.text = "  \(array_List.objectAtIndex(rowUserSelected).valueForKey("name") as! String)"
        let transitionOptions = UIViewAnimationOptions.TransitionCurlUp
        UIView.transitionWithView(self.view_Graders, duration: 0.75, options: transitionOptions, animations: {
            self.view_Graders.hidden = true
            
            }, completion: { finished in
                
                self.Bool_viewGraders = false
        })
        self.getGradingReportService()
    }
    
    //MARK: - calendar Btn_Action/ Calendar Delegate
    @IBAction func Calendar_BtnAction(sender: AnyObject) {
        objuserList.removeView(self.view)
        Bool_viewUsers = false
        
        self.view_Graders.hidden = true
        self.Bool_viewGraders = false
        
        if !Bool_viewcalendar {
            objDatePicker.showDateView(self.view, frame1: CGRectMake(373+315, 58+75, 320, 238))
            Bool_viewcalendar = true
        }
        else {
            objDatePicker.removeDateView(self.view)
            Bool_viewcalendar = false
        }
    }
    
    
    func cancelCalendar() {
        objDatePicker.removeDateView(self.view)
        Bool_viewcalendar = false
    }
    
    func DoneCalendar(dateSelected: String!) {
        textfield_StopDate.text = dateSelected
        objDatePicker.removeDateView(self.view)
        Bool_viewcalendar = false
        
        self.getGradingReportService()
    }

    //MARK: - Export Btn_Action/ UserList Delegate
    @IBAction func Export_BtnAction(sender: AnyObject) {
        self.view_Graders.hidden = true
        self.Bool_viewGraders = false
        
        objDatePicker.removeDateView(self.view)
        Bool_viewcalendar = false
        
        if !Bool_viewUsers {
            objuserList.showView(self.view, frame1: CGRectMake(677, 205, 318, 231))
            Bool_viewUsers = true
        }
        else {
            objuserList.removeView(self.view)
            Bool_viewUsers = false
        }
    }
    
    
    func cancelMethod() {
        Bool_viewUsers = false
        objuserList.removeView(self.view)
    }
    
    
    func DoneMethod(EmailUsers: String!) {
        
        if EmailUsers == nil {
//            dispatch_async(dispatch_get_main_queue())
//            {
                HelperClass.MessageAletOnly("Please Select User.", selfView: self)
//            }
        }
        else
        {
            Bool_viewUsers = false
            objuserList.removeView(self.view)
            if self.appDel.checkInternetConnection() {
                appDel.Show_HUD()
                str_webservice = "report_grader"
                var stop: String! = textfield_StopDate.text!.stringByReplacingOccurrencesOfString(" ", withString: "")
                stop = stop.stringByReplacingOccurrencesOfString("/", withString: "-")
                
                let request = NSMutableURLRequest(URL: NSURL(string: "\(Server.local_server)/api/file/report_grader.php?")!)
                let postString = "dateto=\(stop)&tomail=\(EmailUsers)"
                objwebservice.callServiceCommon_inspection(request, postString: postString)
            }
            else
            {
                HelperClass.MessageAletOnly(Server.noInternet, selfView: self)
            }
        }
        
    }
    
    //MARK: - CHART
    func setChart(dataPoints: [String], values: [Double]) {
        HelperClass.setBarChartHelper(dataPoints, valuesss: values, barcart: self.barChartView, monthssstemp: monthstemp, labelMessage: "Grader Added", compareMsg: "There Is No Data For Related Grader", nodataStr: "There Is No Data For Related Grader.")
        
    }

}
