//
//  GroupAvgReportVC.swift
//  Crocodile
//
//  Created by Nibha Aggarwal on 28/03/17.
//  Copyright © 2017 Nibha Aggarwal. All rights reserved.
//

import UIKit
import Charts

class GroupAvgReportVC: UIViewController, responseProtocol, userlistProtocol, CommonClassProtocol {
    var objwebservice : webservice! = webservice()
    var objuserList : UserListView! = UserListView()
    
    @IBOutlet weak var picker_Users: UIPickerView!
    @IBOutlet weak var view_Graders: UIView!
    @IBOutlet weak var textField_GraderSel: UITextField!
    
    
    var array_List: NSMutableArray! = ["Y1", "Y2", "Y3", "Y4"]
    var str_webservice: String!
    var pickerLabel: UILabel!
    var Bool_viewUsers: Bool = false
    var Bool_viewGraders: Bool = false
    var rowGraderSelected: Int! = 0
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
        controller.label_header.text = "AGING REPORT"
        controller.IIndexPath = NSIndexPath(forRow: 8, inSection: 6)
        controller.array_temp_section.replaceObjectAtIndex(6, withObject: "Yes")
        controller.tableMenu.reloadData()
        controller.tableMenu.contentOffset = CGPointMake(0, 76*3) // to show Die Report tab
        let arrt = controller.array_temp_row[6]
        arrt.replaceObjectAtIndex(8, withObject: "Yes")
        controller.btn_Sync.hidden = false
        controller.img_Sync.hidden = false
        controller.btn_BackPop.hidden = true
        objwebservice?.delegate = self
        
        objuserList = UserListView.instanceFromNib() as! UserListView
        objuserList?.delegate = self
        
        controller.delegate = self
        
        appDel = (UIApplication.sharedApplication().delegate as! AppDelegate)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        rowGraderSelected = picker_Users.selectedRowInComponent(0)
        textField_GraderSel.text = array_List.objectAtIndex(rowGraderSelected) as? String
        picker_Users.reloadAllComponents()
    }
    
    
    override func viewDidAppear(animated: Bool) {
        if self.appDel.checkInternetConnection(){
            self.getAverageReportService()
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
    
    //MARK: - getGradingReportService
    func getAverageReportService()
    {
        appDel.Show_HUD()
        str_webservice = "getgroupedsize"
        
        var grpCode: String!
        for i in 0 ..< array_List.count
        {
            if rowGraderSelected == i {
                grpCode = array_List[i] as! String
            }
        }
        let request = NSMutableURLRequest(URL: NSURL(string: "\(Server.local_server)/api/animals/getgroupedsize.php?")!)
        let postString = "groupcode=\(grpCode)"
        
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
    
    //MARK: - Webservice Delegate
    func responseDictionary(dic: NSMutableDictionary) {
        if str_webservice == "getgroupedsize" {
            print(dic)
            
            monthstemp.removeAll()
            unitTemp.removeAll()
            
            if dic["Animals_count_Data"] != nil {
                if dic["Animals_count_Data"]?.count != 0 {
                    autoreleasepool
                        {
                            for i in 0 ..< dic["Animals_count_Data"]!.count {
                                ////////////
                                
                                monthstemp.append(dic["Animals_count_Data"]![i]["size"] as! String)
                                let myDouble = Double(dic["Animals_count_Data"]![i]["total_animals"] as! String)
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
        else if (str_webservice == "report_grouped_animal")
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
            pickerLabel.text = array_List.objectAtIndex(row) as? String
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
        
        if !Bool_viewGraders {
            view_Graders.hidden = true
            let transitionOptions = UIViewAnimationOptions.TransitionCurlDown
            UIView.transitionWithView(self.view_Graders, duration: 0.75, options: transitionOptions, animations: {
                self.view_Graders.hidden = false
                
                }, completion: { finished in
                    
                    self.Bool_viewGraders = true
            })
            
        }
        else {
            let transitionOptions = UIViewAnimationOptions.TransitionCurlUp
            UIView.transitionWithView(self.view_Graders, duration: 0.75, options: transitionOptions, animations: {
                self.view_Graders.hidden = true
                
                }, completion: { finished in
                    
                    self.Bool_viewGraders = false
            })
            
        }
        
    }
    
    @IBAction func CancelBtn_Users(sender: AnyObject)
    {
        let transitionOptions = UIViewAnimationOptions.TransitionCurlUp
        UIView.transitionWithView(self.view_Graders, duration: 0.75, options: transitionOptions, animations: {
            self.view_Graders.hidden = true
            
            }, completion: { finished in
                
                self.Bool_viewGraders = false
        })
        
    }
    
    
    @IBAction func DoneBtn_Users(sender: AnyObject)
    {
        rowGraderSelected = picker_Users.selectedRowInComponent(0)
        textField_GraderSel.text = array_List.objectAtIndex(rowGraderSelected) as? String
        
        let transitionOptions = UIViewAnimationOptions.TransitionCurlUp
        UIView.transitionWithView(self.view_Graders, duration: 0.75, options: transitionOptions, animations: {
            self.view_Graders.hidden = true
            
            }, completion: { finished in
                
                self.Bool_viewGraders = false
        })
        self.getAverageReportService()
    }
    
    //MARK: - Export Btn_Action/ UserList Delegate
    @IBAction func Export_BtnAction(sender: AnyObject) {
        self.view_Graders.hidden = true
        self.Bool_viewGraders = false
        
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
            let alertView = UIAlertController(title: nil, message: "Please Select User.", preferredStyle: .Alert)
            alertView.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
            self.presentViewController(alertView, animated: true, completion: nil)
            //            }
        }
        else
        {
            Bool_viewUsers = false
            objuserList.removeView(self.view)
            if self.appDel.checkInternetConnection() {
                appDel.Show_HUD()
                str_webservice = "report_grouped_animal"
                
                
                let request = NSMutableURLRequest(URL: NSURL(string: "\(Server.local_server)/api/file/report_grouped_animal_size.php?")!)
                let postString = "tomail=\(EmailUsers)"
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
    
    
    
    //MARK: - CHART
    func setChart(dataPoints: [String], values: [Double]) {
        barChartView.noDataText = "No Data For Related Period."
        var dataEntries: [BarChartDataEntry] = []
        
        autoreleasepool
            {
                for i in 0..<dataPoints.count {
                    let dataEntry = BarChartDataEntry(value: values[i], xIndex: i)
                    dataEntries.append(dataEntry)
                }
        }
        
        let chartDataSet = BarChartDataSet(yVals: dataEntries, label: "Group Average")
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
        
        let chartDataSet = BarChartDataSet(yVals: dataEntries, label: "Group Average")
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
        chartData.setDrawValues(false)
    }
    
}