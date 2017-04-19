//
//  AddReport.swift
//  Crocodile
//
//  Created by Nibha Aggarwal on 5/19/16.
//  Copyright © 2016 Nibha Aggarwal. All rights reserved.
//

import UIKit
import Charts

class AddReportVC: UIViewController, responseProtocol, userlistProtocol, CalendarProtocol, CommonClassProtocol {
    @IBOutlet weak var textfield_StartDate: UITextField!
    @IBOutlet weak var textfield_StopDate: UITextField!
    @IBOutlet weak var SegCtrl: UISegmentedControl!
    var str_webservice: String!
    
    var objwebservice : webservice! = webservice()
    var objuserList : UserListView! = UserListView()
    var objDatePicker : CalendarView! = CalendarView()
    
    var str_segCtrlSel: String! = "Month"
    var Bool_viewUsers: Bool = false
    var Bool_viewcalendar: Bool = false
    var appDel : AppDelegate!
    
    @IBOutlet weak var barChartView: BarChartView!
    var monthstemp: [AnyObject] = []
    var unitTemp: [AnyObject] = []
    
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
        controller.IIndexPath = NSIndexPath(forRow: 0, inSection: 6)
        controller.tableMenu.reloadData()
        controller.label_header.text = "ADD REPORT"
        controller.array_temp_section.replaceObjectAtIndex(6, withObject: "Yes")
        controller.btn_Sync.hidden = false
        controller.img_Sync.hidden = false
        controller.btn_BackPop.hidden = true
        let arrt = controller.array_temp_row[6]
        arrt.replaceObjectAtIndex(0, withObject: "Yes")
        controller.array_userList = NSUserDefaults.standardUserDefaults().objectForKey("UserList")?.mutableCopy() as! NSMutableArray
        
        
        
        objwebservice?.delegate = self
        objuserList = UserListView.instanceFromNib() as! UserListView
        objuserList?.delegate = self
        
        objDatePicker = CalendarView.instanceFromNib() as! CalendarView
        objDatePicker?.delegate = self
        
        controller.delegate = self
        
        appDel = (UIApplication.sharedApplication().delegate as! AppDelegate)
    }
    
    override func viewWillAppear(animated: Bool) {
        textfield_StopDate.text = "\(objDatePicker.todaydate())"
        textfield_StartDate.text = "  \(objDatePicker.daysBetweenDate(objDatePicker.todaydate()))"
        
        SegCtrl.setDividerImage(UIImage(named: "filter"), forLeftSegmentState: .Selected, rightSegmentState: .Normal, barMetrics:UIBarMetrics.Default)
    }
    
    override func viewDidAppear(animated: Bool) {
        if self.appDel.checkInternetConnection() {
         self.getAddReportService()
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
    
    
    //MARK: - Export Btn_Action/ UserList Delegate
    @IBAction func Export_BtnAction(sender: AnyObject) {
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
            HelperClass.MessageAletOnly("Please Select User.", selfView: self)
        }
        else
        {
            Bool_viewUsers = false
            objuserList.removeView(self.view)
            if self.appDel.checkInternetConnection() {
                appDel.Show_HUD()
                str_webservice = "report_add"
                var start: String! = textfield_StartDate.text!.stringByReplacingOccurrencesOfString(" ", withString: "")
                start = start.stringByReplacingOccurrencesOfString("/", withString: "-")
                var stop: String! = textfield_StopDate.text!.stringByReplacingOccurrencesOfString(" ", withString: "")
                stop = stop.stringByReplacingOccurrencesOfString("/", withString: "-")
                
                let request = NSMutableURLRequest(URL: NSURL(string: "\(Server.local_server)/api/file/report_add.php?")!)
                let postString = "datefrom=\(start)&dateto=\(stop)&reporttype=\(str_segCtrlSel)&tomail=\(EmailUsers)"
                objwebservice.callServiceCommon_inspection(request, postString: postString)
            }
            else
            {
                HelperClass.MessageAletOnly(Server.noInternet, selfView: self)
            }
        }
        
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
        if str_webservice == "add_report" {
            
            monthstemp.removeAll()
            unitTemp.removeAll()
            

            
            if dic["AddReportData"] != nil {
                if dic["AddReportData"]?.count != 0 {
                    if str_segCtrlSel == "Week" {
                        autoreleasepool
                            {
                                for i in 0 ..< dic["AddReportData"]!.count {
                                    var week: String = dic["AddReportData"]![i]["weekno"] as! String
                                    let year: String = dic["AddReportData"]![i]["yearno"] as! String
                                    week = "\(week)-\(year)"
                                    
                                    ////////////
                                    
                                    monthstemp.append(week)
                                    let myDouble = Double(dic["AddReportData"]![i]["value"] as! String)
                                    unitTemp.append(myDouble!)
                                    
                                }
                        }
                        setChart(monthstemp as! [String], values: unitTemp as! [Double])
                    }
                    else
                    {
                        // The output below is limited by 1 KB.
                        // Please Sign Up (Free!) to remove this limitation.
                        autoreleasepool{
                            for i in 0 ..< dic["AddReportData"]!.count {
                                var month: String = dic["AddReportData"]![i]["monthname"] as! String
                                
                                let range = month.startIndex.advancedBy(0) ..< month.startIndex.advancedBy(3)
                                let save: String = month.substringWithRange(range)
                                month = save.uppercaseString
                                
                                let year: String = dic["AddReportData"]![i]["yearno"] as! String
                                print(month)
                                month = "\(month)-\(year)"
                                //                            month = "\(month)"
                                ////////////
                                monthstemp.append(month)
                                let myDouble = Double(dic["AddReportData"]![i]["value"] as! String)
                                unitTemp.append(myDouble!)
                                
                            }
                        }
                        
                        setChart(monthstemp as! [String], values: unitTemp as! [Double])
                    }
                }
                else
                {
                    
                    monthstemp.append("NO DATA")
                    let myDouble = Double("0")
                    unitTemp.append(myDouble!)
                    setChart(monthstemp as! [String], values: unitTemp as! [Double])
                    
                }
                
            }
            else
            {
                monthstemp.append("NO DATA")
                let myDouble = Double("0")
                unitTemp.append(myDouble!)
                setChart(monthstemp as! [String], values: unitTemp as! [Double])
            }
        }
        
        //
        else if (str_webservice == "report_add")
        {
            var msg: String!
            if dic["success"] as! String == "True" {
                msg = "Mail Sent."
            }
            else
            {
                msg = "Mail Not Sent."
            }
            HelperClass.MessageAletOnly(msg!, selfView: self)
                self.appDel.remove_HUD()
        }
            self.appDel.remove_HUD()
    }
    
    //MARK: - getAddReportService
    func getAddReportService()
    {
        appDel.Show_HUD()
        str_webservice = "add_report"
        var start: String! = textfield_StartDate.text!.stringByReplacingOccurrencesOfString(" ", withString: "")
        start = start.stringByReplacingOccurrencesOfString("/", withString: "-")
        var stop: String! = textfield_StopDate.text!.stringByReplacingOccurrencesOfString(" ", withString: "")
        stop = stop.stringByReplacingOccurrencesOfString("/", withString: "-")
        let request = NSMutableURLRequest(URL: NSURL(string: "\(Server.local_server)/api/sp_reports/add_report.php?")!)
        let postString = "datefrom=\(start)&dateto=\(stop)&reporttype=\(str_segCtrlSel)"
        
        objwebservice.callServiceCommon(request, postString: postString)
    }
    
  
    
    //MARK: - Segment Control Value Changed
    @IBAction func SegmentToogle(sender: UISegmentedControl) {
//        appDel.removeDirect(self.view)
        Bool_viewUsers = false
        if sender.selectedSegmentIndex == 0 {
            str_segCtrlSel = "Month"
            sender.setDividerImage(UIImage(named: "filter"), forLeftSegmentState: .Selected, rightSegmentState: .Normal, barMetrics:UIBarMetrics.Default)
        }
        else if sender.selectedSegmentIndex == 1 {
            str_segCtrlSel = "Week"
            sender.setDividerImage(UIImage(named: "filter2"), forLeftSegmentState: .Normal, rightSegmentState: .Normal, barMetrics: UIBarMetrics.Default)
        }
        self.getAddReportService()
    }
    
    
    //MARK: - calendar Btn_Action/ Calendar Delegate
    @IBAction func Calendar_BtnAction(sender: AnyObject) {
        objuserList.removeView(self.view)
        Bool_viewUsers = false
        
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
        textfield_StartDate.text = "\(objDatePicker.daysBetweenDate(dateSelected))"
        self.getAddReportService()
    }
    
    
    //MARK: - CHART
    func setChart(dataPoints: [String], values: [Double]) {
        
        HelperClass.setBarChartHelper(dataPoints, valuesss: values, barcart: self.barChartView, monthssstemp: monthstemp, labelMessage: "Animals Added", compareMsg: "NO DATA", nodataStr: "There Is No Data For Related Period.")


    }
}
