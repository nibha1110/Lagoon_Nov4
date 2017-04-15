//
//  DieReportVC.swift
//  Crocodile
//
//  Created by Nibha Aggarwal on 5/19/16.
//  Copyright © 2016 Nibha Aggarwal. All rights reserved.
//

import UIKit
import Charts

class DieReportVC: UIViewController,responseProtocol, userlistProtocol, CalendarProtocol, CommonClassProtocol {
    @IBOutlet weak var textfield_StartDate: UITextField!
    @IBOutlet weak var textfield_StopDate: UITextField!
    var str_webservice: String!
    
    var objwebservice : webservice! = webservice()
    var objuserList : UserListView! = UserListView()
    var objDatePicker : CalendarView! = CalendarView()
    var Bool_viewUsers: Bool = false
    var Bool_viewcalendar: Bool = false
    var appDel : AppDelegate!

    //For Chart
    @IBOutlet weak var barChartView: BarChartView!
    var monthstemp: [AnyObject] = []
    var unitTemp: [AnyObject] = []
    
    //MARK: -
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
        controller.label_header.text = "ADD TO DIE REPORT"
        controller.IIndexPath = NSIndexPath(forRow: 6, inSection: 6)
        controller.array_temp_section.replaceObjectAtIndex(6, withObject: "Yes")
        controller.tableMenu.reloadData()
        controller.tableMenu.contentOffset = CGPointMake(0, 76*3) // to show Die Report tab
        controller.btn_Sync.hidden = false
        controller.img_Sync.hidden = false
        controller.btn_BackPop.hidden = true
        let arrt = controller.array_temp_row[6]
        arrt.replaceObjectAtIndex(6, withObject: "Yes")
        
        controller.array_userList = NSUserDefaults.standardUserDefaults().objectForKey("UserList")?.mutableCopy() as! NSMutableArray
        objwebservice?.delegate = self
        objuserList = UserListView.instanceFromNib() as! UserListView
        objuserList?.delegate = self
        
        objDatePicker = CalendarView.instanceFromNib() as! CalendarView
        objDatePicker?.delegate = self
        
        
        controller.delegate = self
        
        appDel = (UIApplication.sharedApplication().delegate as! AppDelegate)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewWillAppear(animated: Bool) {
        textfield_StopDate.text = "\(objDatePicker.todaydate())"
        textfield_StartDate.text = "  \(objDatePicker.daysBetweenDate(objDatePicker.todaydate()))"
    }
    
    override func viewDidAppear(animated: Bool) {
        if self.appDel.checkInternetConnection() {
            self.getDieReportService()
        }
        else
        {
            let alertView = UIAlertController(title: nil, message: Server.noInternet, preferredStyle: .Alert)
            alertView.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(alertView, animated: true, completion: nil)
        }
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
                let alertView = UIAlertController(title: nil, message: "Please Select User.", preferredStyle: .Alert)
                alertView.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
                self.presentViewController(alertView, animated: true, completion: nil)
        }
        else
        {
            Bool_viewUsers = false
            objuserList.removeView(self.view)
            if self.appDel.checkInternetConnection() {
                appDel.Show_HUD()
                str_webservice = "report_die"
                var start: String! = textfield_StartDate.text!.stringByReplacingOccurrencesOfString(" ", withString: "")
                start = start.stringByReplacingOccurrencesOfString("/", withString: "-")
                var stop: String! = textfield_StopDate.text!.stringByReplacingOccurrencesOfString(" ", withString: "")
                stop = stop.stringByReplacingOccurrencesOfString("/", withString: "-")
                
                let request = NSMutableURLRequest(URL: NSURL(string: "\(Server.local_server)/api/file/report_die.php?")!)
                let postString = "datefrom=\(start)&dateto=\(stop)&tomail=\(EmailUsers)"
                objwebservice.callServiceCommon_inspection(request, postString: postString)
            }
            else
            {
                    let alertView = UIAlertController(title: nil, message: Server.noInternet, preferredStyle: .Alert)
                    alertView.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
                    self.presentViewController(alertView, animated: true, completion: nil)
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
    
    //MARK: - Webservice Delegate
    func responseDictionary(dic: NSMutableDictionary) {
        if str_webservice == "die_report" {
            print(dic)
            
            monthstemp.removeAll()
            unitTemp.removeAll()
            
            if dic["DieReportData"] != nil {
                if dic["DieReportData"]?.count != 0 {
                    
                    autoreleasepool{
                        for i in 0 ..< dic["DieReportData"]!.count {
                            var month: String = dic["DieReportData"]![i]["monthname"] as! String
                            if (month == "January") {
                                month = "JAN"
                            }
                            else if (month == "February") {
                                month = "FEB"
                            }
                            else if (month == "March") {
                                month = "MAR"
                            }
                            else if (month == "April") {
                                month = "APR"
                            }
                            else if (month == "May") {
                                month = "MAY"
                            }
                            else if (month == "June") {
                                month = "JUN"
                            }
                            else if (month == "July") {
                                month = "JUL"
                            }
                            else if (month == "August") {
                                month = "AUG"
                            }
                            else if (month == "September") {
                                month = "SEP"
                            }
                            else if (month == "October") {
                                month = "OCT"
                            }
                            else if (month == "November") {
                                month = "NOV"
                            }
                            else if (month == "December") {
                                month = "DEC"
                            }
                            
                            let year: String = dic["DieReportData"]![i]["yearno"] as! String
                            month = "\(month)-\(year)"
                            //                        month = "\(month)"
                            
                            ////////////
                            monthstemp.append(month)
                            let myDouble = Double(dic["DieReportData"]![i]["value"] as! String)
                            unitTemp.append(myDouble!)
                            
                        }
                    }
                    
                    setChart(monthstemp as! [String], values: unitTemp as! [Double])
                    
                }
                else
                {
                    monthstemp.append("NO DATA")
                    let myDouble = Double("0")
                    unitTemp.append(myDouble!)
                    setChart1(monthstemp as! [String], values: unitTemp as! [Double])
                }
                
            }
            else
            {
                monthstemp.append("NO DATA")
                let myDouble = Double("0")
                unitTemp.append(myDouble!)
                setChart1(monthstemp as! [String], values: unitTemp as! [Double])
            }
        }
            
            //
        else if (str_webservice == "report_die")
        {
            var msg: String!
            if dic["success"] as! String == "True" {
                msg = "Mail Sent."
            }
            else
            {
                msg = "Mail Not Sent."
            }
                let alertView = UIAlertController(title: nil, message: msg, preferredStyle: .Alert)
                alertView.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
                self.presentViewController(alertView, animated: true, completion: nil)
//            }
        }
//        dispatch_async(dispatch_get_main_queue()) {
            self.appDel.remove_HUD()
//        }
    }
    
    //MARK: - getAddReportService
    func getDieReportService()
    {
        appDel.Show_HUD()
        str_webservice = "die_report"
        var start: String! = textfield_StartDate.text!.stringByReplacingOccurrencesOfString(" ", withString: "")
        start = start.stringByReplacingOccurrencesOfString("/", withString: "-")
        var stop: String! = textfield_StopDate.text!.stringByReplacingOccurrencesOfString(" ", withString: "")
        stop = stop.stringByReplacingOccurrencesOfString("/", withString: "-")
        let request = NSMutableURLRequest(URL: NSURL(string: "\(Server.local_server)/api/sp_reports/die_report.php?")!)
        let postString = "datefrom=\(start)&dateto=\(stop)"
        objwebservice.callServiceCommon(request, postString: postString)
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
        self.getDieReportService()
    }

    //MARK: - CHART
    func setChart(dataPoints: [String], values: [Double]) {
        barChartView.noDataText = "No Data For Related Period."
        var dataEntries: [BarChartDataEntry] = []
        
        autoreleasepool{
            for i in 0..<dataPoints.count {
                let dataEntry = BarChartDataEntry(value: values[i], xIndex: i)
                dataEntries.append(dataEntry)
            }
        }
        
        let chartDataSet = BarChartDataSet(yVals: dataEntries, label: "Animals Die")
        let chartData = BarChartData(xVals: monthstemp as? [NSObject], dataSet: chartDataSet)
        if dataPoints.count < 5 {
            chartDataSet.barSpace = 0.8
        }
        barChartView.data = chartData
        barChartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
        barChartView.xAxis.labelHeight = 80
        barChartView.descriptionText = ""
        barChartView.xAxis.labelFont = UIFont(descriptor: UIFontDescriptor(name: "HelveticaNeue", size: 13), size: 13.0)
        chartDataSet.valueFont = UIFont(descriptor: UIFontDescriptor(name: "HelveticaNeue", size: 18), size: 18.0)
        chartDataSet.colors = [UIColor(red: 6/255, green: 92/255, blue: 142/255, alpha: 1)]
        
    }
    
    func setChart1(dataPoints: [String], values: [Double]) {
        barChartView.noDataText = "No Data For Related Period."
        var dataEntries: [BarChartDataEntry] = []
        
        autoreleasepool{
            for i in 0..<dataPoints.count {
                let dataEntry = BarChartDataEntry(value: values[i], xIndex: i)
                dataEntries.append(dataEntry)
            }
        }
        
        let chartDataSet = BarChartDataSet(yVals: dataEntries, label: "Animals Die")
        let chartData = BarChartData(xVals: monthstemp as? [NSObject], dataSet: chartDataSet)
        barChartView.data = chartData
        barChartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
        barChartView.xAxis.labelHeight = 80
        barChartView.descriptionText = ""
        barChartView.xAxis.labelFont = UIFont(descriptor: UIFontDescriptor(name: "HelveticaNeue", size: 13), size: 13.0)
        chartDataSet.valueFont = UIFont(descriptor: UIFontDescriptor(name: "HelveticaNeue", size: 18), size: 18.0)
        chartDataSet.colors = [UIColor(red: 6/255, green: 92/255, blue: 142/255, alpha: 1)]
        chartData.setDrawValues(false)
    }
}