//
//  GrpSingleMoveReportVC.swift
//  Crocodile
//
//  Created by Nibha Aggarwal on 8/9/16.
//  Copyright © 2016 Nibha Aggarwal. All rights reserved.
//

import UIKit

class GrpSingleMoveReportVC: UIViewController, responseProtocol, userlistProtocol, CalendarProtocol {
    @IBOutlet weak var textfield_StartDate: UITextField!
    @IBOutlet weak var textfield_StopDate: UITextField!

    @IBOutlet weak var tabelview_GrpList: UITableView!
    @IBOutlet weak var tabelview_UserList: UITableView!
    
    var objwebservice : webservice! = webservice()
    var objuserList : UserListView! = UserListView()
    var objDatePicker : CalendarView! = CalendarView()
    
    var appDel : AppDelegate!
    var array_List: [AnyObject] = []
    var str_webservice: NSString!
    var Bool_viewcalendar: Bool = false
    var Bool_viewUsers: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let controller = self.storyboard!.instantiateViewControllerWithIdentifier("CommonClassVC") as? CommonClassVC
            else {
                fatalError();
        }
        addChildViewController(controller)
        controller.view.frame = CGRectMake(0, 0, 1024, 768)
        controller.array_tableSection = ["report"]
        controller.array_sectionRow = [["sddreport", "killreport", "gradingreport", "aging", "spinuserepoert",  "Community_Pens_Report_Unsel", "Diereport_unselect", "killreport_unselect"]]
        view.addSubview(controller.view)
        view.sendSubviewToBack(controller.view)
        controller.label_header.text = "GROUP TO SINGLE MOVE REPORT"
        controller.IIndexPath = NSIndexPath(forRow: 8, inSection: 6)
        controller.array_temp_section.replaceObjectAtIndex(6, withObject: "Yes")
        controller.tableMenu.reloadData()
        controller.tableMenu.contentOffset = CGPointMake(0, 76*3) // to show Die Report tab
        controller.btn_Sync.hidden = false
        controller.img_Sync.hidden = false
        controller.btn_BackPop.hidden = true
        let arrt = controller.array_temp_row[6]
        arrt.replaceObjectAtIndex(8, withObject: "Yes")
        
        controller.array_userList = NSUserDefaults.standardUserDefaults().objectForKey("UserList") as! NSMutableArray
        objwebservice?.delegate = self
        objuserList = UserListView.instanceFromNib() as! UserListView
        objuserList?.delegate = self
        
        objDatePicker = CalendarView.instanceFromNib() as! CalendarView
        objDatePicker?.delegate = self
        
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
            self.GetGroupSingleService()
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
        
        if !Bool_viewUsers {
            objuserList.showView(self.view, frame1: CGRectMake(677, 195, 318, 231))
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
                str_webservice = "report_group_move_single"
                appDel.Show_HUD()
                var start: String! = textfield_StartDate.text!.stringByReplacingOccurrencesOfString(" ", withString: "")
                start = start.stringByReplacingOccurrencesOfString("/", withString: "-")
                var stop: String! = textfield_StopDate.text!.stringByReplacingOccurrencesOfString(" ", withString: "")
                stop = stop.stringByReplacingOccurrencesOfString("/", withString: "-")
                
                let request = NSMutableURLRequest(URL: NSURL(string: "\(Server.local_server)/api/file/report_group_move_single.php?")!)
                let postString = "datefrom=\(start)&dateto=\(stop)&tomail=\(EmailUsers)"
                objwebservice.callServiceCommon_inspection(request, postString: postString)
            }
            else
            {
//                dispatch_async(dispatch_get_main_queue()) {
                    let alertView = UIAlertController(title: nil, message: Server.noInternet, preferredStyle: .Alert)
                    alertView.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
                    self.presentViewController(alertView, animated: true, completion: nil)
//                }
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
    
    // MARK: - Webservice delegate
    func responseDictionary(dic: NSMutableDictionary) {
        if str_webservice == "group_move_single" {
//            dispatch_async(dispatch_get_main_queue()) {
                print(dic)
                self.array_List = dic["Group_animals_move_Data"] as! NSMutableArray as [AnyObject]
                self.tabelview_GrpList.reloadData()
                print(self.array_List)
//            }
        }
        else if (str_webservice == "report_group_move_single")
        {
            var msg: String!
            if dic["success"] as! String == "True" {
                msg = "Mail Sent."
            }
            else
            {
                msg = "Mail Not Sent."
            }
//            dispatch_async(dispatch_get_main_queue()) {
                let alertView = UIAlertController(title: nil, message: msg, preferredStyle: .Alert)
                alertView.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
                self.presentViewController(alertView, animated: true, completion: nil)
//            }
        }
//        dispatch_async(dispatch_get_main_queue()) {
            self.appDel.remove_HUD()
//        }
    }

    
    //MARK: - Get Group Single Moves
    func GetGroupSingleService()
    {
        appDel.Show_HUD()
        str_webservice = "group_move_single"
        var start: String! = textfield_StartDate.text!.stringByReplacingOccurrencesOfString(" ", withString: "")
        start = start.stringByReplacingOccurrencesOfString("/", withString: "-")
        var stop: String! = textfield_StopDate.text!.stringByReplacingOccurrencesOfString(" ", withString: "")
        stop = stop.stringByReplacingOccurrencesOfString("/", withString: "-")
        
        let request = NSMutableURLRequest(URL: NSURL(string: "\(Server.local_server)/api/animals/group_move_single.php?")!)
        let postString = "datefrom=\(start)&dateto=\(stop)"
        objwebservice.callServiceCommon(request, postString: postString)
    }
    
    // MARK: -  tableview Delegates
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(array_List.count)
        return array_List.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        /*
         if tableView == tabelview_GrpList {
         let cus_cell = tableView.dequeueReusableCellWithIdentifier("CustomTableViewCell", forIndexPath: indexPath) as! CustomTableViewCell
         
         if indexPath.row % 2 == 0 {
         cus_cell.customImageView.backgroundColor = UIColor.whiteColor()
         }
         else {
         cus_cell.customImageView.backgroundColor = UIColor(red: 241.0 / 255.0, green: 241 / 255.0, blue: 241 / 255.0, alpha: 1.0)
         }
         
         cus_cell.customlabel_left.text = array_List[indexPath.row]["grpnamedisp"] as? String
         
         cus_cell.customImg_orange.frame = CGRectMake(275, 8, 192, 56)
         cus_cell.customlbl_upperImge.frame = CGRectMake(275, 8, 192, 56)
         cus_cell.customlbl_upperImge.text = array_List[indexPath.row]["pennodisp"] as? String
         return cus_cell
         
         }
         let cell:UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
         return cell
         */
        let cell:UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        
        //view Backgd
        let view_bg: UIView = UIView(frame: CGRectMake(0, 0, 709, 75))
        if indexPath.row % 2 == 0 {
            view_bg.backgroundColor = UIColor.whiteColor()
        }
        else {
            view_bg.backgroundColor = UIColor(red: 241.0 / 255.0, green: 241 / 255.0, blue: 241 / 255.0, alpha: 1.0)
        }
        
        //Grp
        let label_GrpOnly: UILabel = UILabel(frame: CGRectMake(5, 13, 200, 50))
        label_GrpOnly.textAlignment = .Center
        label_GrpOnly.font = UIFont(name: "HelveticaNeue", size: 23)
        label_GrpOnly.text = "GRP-PEN#"
        
        //orange image
        let img_orange: UIImageView = UIImageView(frame: CGRectMake(220, 10, 192, 56))
        img_orange.image = UIImage(named: "xxyy")
        
        //group_pen
        let label_pens: UILabel = UILabel(frame: CGRectMake(220, 10, 192, 56))
        label_pens.textAlignment = .Center
        label_pens.textColor = UIColor.whiteColor()
        label_pens.font = UIFont(name: "HelveticaNeue", size: 23)
        label_pens.text = array_List[indexPath.row]["group_pen"] as? String
        
        //total_animals
        let label_Grp: UILabel = UILabel(frame: CGRectMake(400, 13, 200, 50))
        label_Grp.textAlignment = .Center
        label_Grp.font = UIFont(name: "HelveticaNeue", size: 23)
        label_Grp.text = array_List[indexPath.row]["total_animals"] as? String

        view_bg.addSubview(label_GrpOnly)
        view_bg.addSubview(img_orange)
        view_bg.addSubview(label_pens)
        view_bg.addSubview(label_Grp)
        
        cell.contentView .addSubview(view_bg)
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    //MARK: - calendar Btn_Action/ Calendar Delegate
    @IBAction func Calendar_BtnAction(sender: AnyObject) {
        objuserList.removeView(self.view)
        Bool_viewUsers = false
        
        if !Bool_viewcalendar {
            objDatePicker.showDateView(self.view, frame1: CGRectMake(373+315, 58+70, 320, 238))
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
        self.GetGroupSingleService()
    }
}
