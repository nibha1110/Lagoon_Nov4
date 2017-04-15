//
//  SPinUseReport.swift
//  Crocodile
//
//  Created by Nibha Aggarwal on 5/19/16.
//  Copyright © 2016 Nibha Aggarwal. All rights reserved.
//

import UIKit
import Charts

class SPinUseReportVC: UIViewController , responseProtocol, userlistProtocol, CalendarProtocol, CommonClassProtocol {
    var objwebservice : webservice! = webservice()
    var objuserList : UserListView! = UserListView()
    var objDatePicker : CalendarView! = CalendarView()
    
    @IBOutlet weak var picker_Date: UIDatePicker!
    @IBOutlet weak var textfield_StopDate: UITextField!
    @IBOutlet weak var img_noPenAllocated: UIImageView!
    @IBOutlet weak var img_noPenAvailable: UIImageView!
    @IBOutlet weak var webviewObj: UIWebView!
    @IBOutlet weak var label_spUse: UILabel!
    @IBOutlet weak var label_spEmpty: UILabel!
    
    var str_webservice: String!
    var Bool_viewUsers: Bool = false
    var Bool_viewcalendar: Bool = false
    var appDel : AppDelegate!
    
    //For Chart
    @IBOutlet weak var pieChartView_Available: PieChartView!
    @IBOutlet weak var pieChartView_used: PieChartView!
    var monthstemp: [AnyObject] = []
    var unitTemp: [AnyObject] = []
    
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
        controller.array_tableSection = ["report"]
        controller.array_sectionRow = [["sddreport", "killreport", "gradingreport", "aging", "spinuserepoert",  "Community_Pens_Report_Unsel", "Diereport_unselect", "Readyreport_unselect", "AverageReport_unselect"]]
        view.addSubview(controller.view)
        view.sendSubviewToBack(controller.view)
        controller.label_header.text = "SP IN USE REPORT"
        controller.IIndexPath = NSIndexPath(forRow: 4, inSection: 6)
        controller.array_temp_section.replaceObjectAtIndex(6, withObject: "Yes")
        controller.tableMenu.reloadData()
        let arrt = controller.array_temp_row[6]
        arrt.replaceObjectAtIndex(4, withObject: "Yes")
        
        controller.btn_Sync.hidden = false
        controller.img_Sync.hidden = false
        controller.btn_BackPop.hidden = true
        objwebservice?.delegate = self
        
        objuserList = UserListView.instanceFromNib() as! UserListView
        objuserList?.delegate = self
    
        controller.delegate = self
        
        objDatePicker = CalendarView.instanceFromNib() as! CalendarView
        objDatePicker?.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        print(objDatePicker.todaydate())
        textfield_StopDate.text = "\(objDatePicker.todaydate())"
//        textfield_StopDate.text = "  16/06/2016"  // for testing
        
    }
    
    override func viewDidAppear(animated: Bool) {
        if self.appDel.checkInternetConnection() {
           self.getSpUseReportService()
        }
        else
        {
            let alertView = UIAlertController(title: nil, message: Server.noInternet, preferredStyle: .Alert)
            alertView.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(alertView, animated: true, completion: nil)
        }
     }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - getSpUseReportService
    
    func getSpUseReportService()
    {
        appDel.Show_HUD()
        str_webservice = "sp_use_report"
        
        var stop: String! = textfield_StopDate.text!.stringByReplacingOccurrencesOfString(" ", withString: "")
        stop = stop.stringByReplacingOccurrencesOfString("/", withString: "-")
        
        let request = NSMutableURLRequest(URL: NSURL(string: "\(Server.local_server)/api/sp_reports/sp_use_report.php?")!)
        let postString = "datetill=\(stop)"
        objwebservice.callServiceCommon(request, postString: postString)
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
    
    func forTailingZero(temp: Double) -> String{
        let tempVar = String(format: "%g", temp)
        return tempVar
    }
    
    //MARK: - webservice delegate
    func responseDictionary(dic: NSMutableDictionary) {
        print(dic)
        if str_webservice == "sp_use_report" {
            //            dispatch_async(dispatch_get_main_queue()) {
            self.monthstemp.removeAll()
            self.unitTemp.removeAll()
            
            //
            let int_penUse: Int = (dic["UsedPensData"]![0]["IFP"])!!.integerValue + (dic["UsedPensData"]![0]["IFTP"])!!.integerValue + (dic["UsedPensData"]![0]["OFP"])!!.integerValue + (dic["UsedPensData"]![0]["RTF"])!!.integerValue
            print("\(int_penUse)")
            self.label_spUse.text = "\(int_penUse)"
            //
            let int_penEmpty: Int = (dic["AvailablePens"]![0]["IFP"])!!.integerValue + (dic["AvailablePens"]![0]["IFTP"])!!.integerValue + (dic["AvailablePens"]![0]["OFP"])!!.integerValue + (dic["AvailablePens"]![0]["RTF"])!!.integerValue
            self.label_spEmpty.text = "\(int_penEmpty)"
            
            self.monthstemp.append("")
            self.monthstemp.append("")
            self.monthstemp.append("")
            self.monthstemp.append("")
            var myDouble = Double(forTailingZero(Double((dic["UsedPensData"]![0]["IFP"])!!.integerValue)))
            self.unitTemp.append((myDouble)!)
            myDouble = Double(forTailingZero(Double((dic["UsedPensData"]![0]["IFTP"])!!.integerValue)))
            self.unitTemp.append((myDouble)!)
            myDouble = Double(forTailingZero(Double((dic["UsedPensData"]![0]["OFP"])!!.integerValue)))
            self.unitTemp.append((myDouble)!)
            myDouble = Double(forTailingZero(Double((dic["UsedPensData"]![0]["RTF"])!!.integerValue)))
            self.unitTemp.append((myDouble)!)
            self.setChart(self.monthstemp as! [String], values: self.unitTemp as! [Double])
            
            
            self.unitTemp.removeAll()
            myDouble = Double(forTailingZero(Double((dic["AvailablePens"]![0]["IFP"])!!.integerValue)))
            self.unitTemp.append((myDouble)!)
            myDouble = Double(forTailingZero(Double((dic["AvailablePens"]![0]["IFTP"])!!.integerValue)))
            self.unitTemp.append((myDouble)!)
            myDouble = Double(forTailingZero(Double((dic["AvailablePens"]![0]["OFP"])!!.integerValue)))
            self.unitTemp.append((myDouble)!)
            myDouble = Double(forTailingZero(Double((dic["AvailablePens"]![0]["RTF"])!!.integerValue)))
            self.unitTemp.append((myDouble)!)
            
            self.setChart1(self.monthstemp as! [String], values: self.unitTemp as! [Double])
            
            //////
            if int_penUse <= 0 {
                self.img_noPenAllocated.hidden = false
            }
            else {
                self.img_noPenAllocated.hidden = true
            }
            if int_penEmpty <= 0 {
                self.img_noPenAvailable.hidden = false
            }
            else {
                self.img_noPenAvailable.hidden = true
            }
            
            
            
            
            //if network
            /*
             str_webservice = "sp_pie_chart_display"
             dispatch_async(dispatch_get_main_queue()) {
             var stop: String! = self.textfield_StopDate.text!.stringByReplacingOccurrencesOfString(" ", withString: "")
             stop = stop.stringByReplacingOccurrencesOfString("/", withString: "-")
             
             let postString = "\(Server.local_server)/api/sp_reports/sp_pie_chart_display.php?datetill=\(stop)"
             let url: NSURL = NSURL(string: postString)!
             let requestObj: NSURLRequest = NSURLRequest(URL: url)
             
             
             self.webviewObj.loadRequest(requestObj)
             }
             */
            //else no network
            
            //            }
        }
        else if (str_webservice == "report_sp_use")
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
                self.appDel.remove_HUD()
        }
            self.appDel.remove_HUD()
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
                str_webservice = "report_sp_use"
                appDel.Show_HUD()
                var stop: String! = textfield_StopDate.text!.stringByReplacingOccurrencesOfString(" ", withString: "")
                stop = stop.stringByReplacingOccurrencesOfString("/", withString: "-")
                
                let request = NSMutableURLRequest(URL: NSURL(string: "\(Server.local_server)/api/file/report_sp_use.php?")!)
                let postString = "datetill=\(stop)&tomail=\(EmailUsers)"
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
        
        self.getSpUseReportService()
    }
    
    //MARK: - CHART
    func setChart(dataPoints: [String], values: [Double]) {
        
        var dataEntries: [ChartDataEntry] = []
        
        var colors: [UIColor] = []
        let color_0 = UIColor(red: 226.0/255.0, green: 98.0/255.0, blue: 15.0/255.0, alpha: 1) //blue
        let color_1 = UIColor(red: 36.0/255.0, green: 99.0/255.0, blue: 17.0/255.0, alpha: 1) // green
        let color_2 = UIColor(red: 26.0/255.0, green: 65.0/255.0, blue: 110.0/255.0, alpha: 1) // orange
        let color_3 = UIColor(red: 255.0/255.0, green: 179.0/255.0, blue: 0.0/255.0, alpha: 1) // yellow
        
        autoreleasepool{
            for i in 0..<dataPoints.count {

                let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
                if values[i] == 0
                {
                    
                }
                else
                {
                    dataEntries.append(dataEntry)
                    if i == 0
                    {
                        colors.append(color_0)
                    }
                    else if i == 1
                    {
                        colors.append(color_1)
                    }
                    else if i == 2
                    {
                        colors.append(color_2)
                    }
                    else if i == 3
                    {
                        colors.append(color_3)
                    }
                }
                
            }
        }
        
//        let chartDataSet = BarChartDataSet(yVals: dataEntries, label: "Animals Aging")
//        let chartData = BarChartData(xVals: monthstemp as? [NSObject], dataSet: chartDataSet)
//        barChartView.data = chartData
//        barChartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
//        barChartView.xAxis.labelHeight = 80
//        barChartView.descriptionText = ""
//        chartDataSet.colors = [UIColor(red: 6/255, green: 92/255, blue: 142/255, alpha: 1)]
        //        barChartView.xAxis.labelRotationAngle = 135
        
        
        let pieChartDataSet = PieChartDataSet(yVals: dataEntries, label: "")
        let pieChartData = PieChartData(xVals: monthstemp as? [NSObject], dataSet: pieChartDataSet)
        pieChartView_Available.data = pieChartData
        pieChartView_Available.animate(xAxisDuration: 0.8)
        
        
//        for i in 0..<dataPoints.count {
//            let red = (UIColor(red: 26.0/255.0, green: 130.0, blue: 230.0, alpha: 1.0))
//            let green = Double(arc4random_uniform(256))
//            let blue = Double(arc4random_uniform(256))
//            
//            let color = UIColor(red: 26.0/255.0, green: 65.0/255.0, blue: 110.0/255.0, alpha: 1)
//            colors.append(UIColor(red: 26.0/255.0, green: 65.0/255.0, blue: 110.0/255.0, alpha: 1))
//            colors.append(UIColor(red: 226.0/255.0, green: 98.0/255.0, blue: 15.0/255.0, alpha: 1))
//            colors.append(UIColor(red: 36.0/255.0, green: 99.0/255.0, blue: 17.0/255.0, alpha: 1))
//            colors.append(UIColor(red: 255.0/255.0, green: 179.0/255.0, blue: 0.0/255.0, alpha: 1))
//            
//        }

        

        pieChartDataSet.colors = colors
        pieChartView_Available.legend.enabled = false
        pieChartView_Available.descriptionText = ""
    }
    
    func setChart1(dataPoints: [String], values: [Double]) {
        
        var dataEntries: [ChartDataEntry] = []
        
        var colors: [UIColor] = []
        let color_0 = UIColor(red: 226.0/255.0, green: 98.0/255.0, blue: 15.0/255.0, alpha: 1) //blue
        let color_1 = UIColor(red: 36.0/255.0, green: 99.0/255.0, blue: 17.0/255.0, alpha: 1) // green
        let color_2 = UIColor(red: 26.0/255.0, green: 65.0/255.0, blue: 110.0/255.0, alpha: 1) // orange
        let color_3 = UIColor(red: 255.0/255.0, green: 179.0/255.0, blue: 0.0/255.0, alpha: 1) // yellow
        
        autoreleasepool{
           
            for i in 0..<dataPoints.count {
                let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
                if values[i] == 0
                {
                    
                }
                else
                {
                    dataEntries.append(dataEntry)
                    if i == 0
                    {
                        colors.append(color_0)
                    }
                    else if i == 1
                    {
                        colors.append(color_1)
                    }
                    else if i == 2
                    {
                        colors.append(color_2)
                    }
                    else if i == 3
                    {
                        colors.append(color_3)
                    }
                }
                
            }
        }
        

        let pieChartDataSet = PieChartDataSet(yVals: dataEntries, label: "")
        let pieChartData = PieChartData(xVals: monthstemp as? [NSObject], dataSet: pieChartDataSet)
        pieChartView_used.data = pieChartData
        
        pieChartView_used.animate(xAxisDuration: 0.8)
        
        
        pieChartDataSet.colors = colors
        pieChartView_used.legend.enabled = false
        pieChartView_used.descriptionText = ""
    }
    
    
    
    //MARK: - CHART
    func setChart2(dataPoints: [String], values: [Double]) {
        
        var dataEntries: [ChartDataEntry] = []
        
        autoreleasepool{
            for i in 0..<dataPoints.count {
                let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
                if values[i] == 0
                {
                    
                }
                else
                {
                    dataEntries.append(dataEntry)
                }
            }
        }
        
        let pieChartDataSet = PieChartDataSet(yVals: dataEntries, label: "")
        let pieChartData = PieChartData(xVals: monthstemp as? [NSObject], dataSet: pieChartDataSet)
        pieChartView_used.data = pieChartData
        pieChartView_used.animate(xAxisDuration: 0.8)
        
        var colors: [UIColor] = []
        var color = UIColor(red: 226.0/255.0, green: 98.0/255.0, blue: 15.0/255.0, alpha: 1) //blue
        colors.append(color)
        
        color = UIColor(red: 36.0/255.0, green: 99.0/255.0, blue: 17.0/255.0, alpha: 1) // green
        colors.append(color)
        
        color = UIColor(red: 26.0/255.0, green: 65.0/255.0, blue: 110.0/255.0, alpha: 1) // orange
        colors.append(color)
        
        color = UIColor(red: 255.0/255.0, green: 179.0/255.0, blue: 0.0/255.0, alpha: 1) // yellow
        colors.append(color)
        
        pieChartDataSet.colors = colors
        pieChartView_used.legend.enabled = false
        pieChartView_used.descriptionText = ""
    }
    
}
