//
//  CommonClassVC.swift
//  Crocodile
//
//  Created by Nibha Aggarwal on 4/28/16.
//  Copyright © 2016 Nibha Aggarwal. All rights reserved.
//

import UIKit


protocol CommonClassProtocol {
    func responseCommonClassOffline()
}

class CommonClassVC: UIViewController, UITableViewDelegate, UITableViewDataSource, dataOfflineProtocol {
    @IBOutlet var tableMenu: UITableView!
    @IBOutlet weak var btn_MainMenu: UIButton!
    @IBOutlet weak var btn_BackPop: UIButton!
    @IBOutlet weak var btn_LogOut: UIButton!
    @IBOutlet weak var label_header: UILabel!
    @IBOutlet weak var label_userName: UILabel!
    @IBOutlet weak var btn_Sync: UIButton!
    @IBOutlet weak var img_Sync: UIImageView!
    
    var objDataOffline: DataOffline! = DataOffline()
    
    var array_userList: NSMutableArray! = []
    var str_tableSection: NSString!
    var IIndexPath: NSIndexPath!
    var appDel : AppDelegate!
    
    var delegate: CommonClassProtocol!
    var array_average: NSMutableArray! = []
    
    var array_tableSection = ["admin", "move_left", "addnew", "inspection", "kill",  "update", "report"]
    //    var array_sectionRow = [["system", "adduser", "manageuser"], ["Move_Hatchlings_UnSel", "move_left", "add_to_dieBLUE", "add_to_killBLUE"], [], [], [], [], ["sddreport", "killreport", "gradingreport", "aging", "spinuserepoert",  "Community_Pens_Report_Unsel", "Diereport_unselect", "killreport_unselect", "killreport_unselect"]]
    var array_sectionRow = [["system", "adduser", "manageuser"], ["Move_Hatchlings_UnSel", "move_left", "add_to_dieBLUE", "add_to_killBLUE", "Sp_move_blue", "GroupAverage_blue"], ["SP_ADD_unselected", "Load_to_trailer", "Trailer_to SP_unselected", "All_empty_pens", "Add_animal_unselected"], [], [], [], ["sddreport", "killreport", "gradingreport", "aging", "spinuserepoert",  "Community_Pens_Report_Unsel", "Diereport_unselect", "Readyreport_unselect", "AverageReport_unselect"]]
    
    var array_tableSection_Sel = ["admin_sel", "Move_Hatchlings_Sel", "addnew_se", "inspection_sel", "kill_sel",  "update_sel", "report_sel"]
    //    var array_sectionRow_Sel = [["system_sel", "adduser_sel", "manageuser_sel"], ["Move_Hatchlings_Sel", "Move_Sel", "add_to_die_green", "add_to_kill_green"], [], [], [], [], ["sddreport_sel", "killreport_sel", "gradingreport_sel", "aging_sel", "spinuserepoert_sel", "Community_Pens_Report_Sel", "Diereport_select", "killreport_select", "killreport_select"]]
    var array_sectionRow_Sel = [["system_sel", "adduser_sel", "manageuser_sel"], ["Move_Hatchlings_Sel", "Move_Sel", "add_to_die_green", "add_to_kill_green", "Sp_move_green", "GroupAverage_green"], ["SP_ADD_selected", "Load_to_trailer_sel", "Trailer_to_SP_sel", "All_empty_pens_Sel", "Add_animal"], [], [], [], ["sddreport_sel", "killreport_sel", "gradingreport_sel", "aging_sel", "spinuserepoert_sel", "Community_Pens_Report_Sel", "Diereport_select", "Readyreport_sel", "AverageReport_sel"]]
    // array used to show selection images for section and rows and adding Yes and No
    var array_temp_section: NSMutableArray = []
    var array_temp_row: NSMutableArray = [[],[],[], [], [], [], []]
    
    
    var array_Skin: NSMutableArray! = ["Select Size"]
    
    // MARK: - Life Cyle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        objDataOffline.delegate = self
        
        label_userName.text = NSUserDefaults.standardUserDefaults().objectForKey("username") as? String
        
        //*****************
        array_Skin.addObject("20-24")
        array_Skin.addObject("25-29")
        array_Skin.addObject("30-34")
        array_Skin.addObject("35-39")
        array_Skin.addObject("40-44")
        array_Skin.addObject("45-49")
        array_Skin.addObject("50")
        //        for i in 20 ..< 51 {
        //            array_Skin.addObject("\(i)")
        //        }
        print(array_Skin)
        
        
        //*****************
        var j: Int = 0
        var k: Int = 0
        for i in 0 ..< 7 {
            k = k+4
            array_average.addObject("\(j)-\(k)")
            
            if i == 0
            {
                j = 1
            }
            j = j+4
            
        }
        
        print(array_average)
        
        //*****************
        for _ in 0 ..< array_tableSection.count {
            array_temp_section.addObject("No")
        }
        
        
        //*****************
        for i in 0 ..< array_sectionRow_Sel.count {
            let arr:NSMutableArray = []
            for _ in 0 ..< array_sectionRow_Sel[i].count {
                arr.addObject("No")
            }
            array_temp_row.replaceObjectAtIndex(i, withObject: arr)
        }
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        // setting height of table
        var numberOfCells: Int = 0
        for section in 0 ..< self.numberOfSectionsInTableView(self.tableMenu) {
            numberOfCells += self.tableView(self.tableMenu!, numberOfRowsInSection: section)
        }
        
        
        
        //only for Move section to remove header
        if array_tableSection == ["move_left"] {
            print("enetred")
            self.tableMenu.sectionHeaderHeight = 0
        }
        //
        
        //getting height of tableview to enable scrolling or not
        var height: CGFloat = CGFloat(numberOfCells) * self.tableMenu.rowHeight + self.tableMenu.sectionHeaderHeight
        var tableFrame: CGRect = self.tableMenu.frame
        self.tableMenu.scrollEnabled = false
        
        tableFrame.size.height = height
        
        if height >= 606 {
            height = height-78
            self.tableMenu.scrollEnabled = true
            tableFrame.size.height = 606-78
        }
        
        self.tableMenu.frame = tableFrame
        self.tableMenu.setNeedsDisplay()
        
        // setting Main menu btn frame
        self.btn_MainMenu.frame = CGRectMake(0, self.tableMenu.frame.size.height+self.tableMenu.frame.origin.y, 315, 78)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Back and Main Menu come back btn
    @IBAction func MainMenu_btnAction(sender: AnyObject) {
        var array: [AnyObject] = self.navigationController!.viewControllers
        for i in 0 ..< array.count {
            if (array[i] is HomeVC) {
                self.navigationController!.popToViewController(array[i] as! UIViewController, animated: true)
            }
        }

    }
    
    // MARK: - popNavigation
    @IBAction func BackPop_btnAction(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(false)
    }
    
    // MARK: - Logout
    @IBAction func LogOut_btnAction(sender: AnyObject) {
        let alertView = UIAlertController(title: nil, message: "Are You Sure You Want To Log Out?", preferredStyle: .Alert)
        alertView.addAction(UIAlertAction(title: "NO", style: .Cancel, handler: nil))
        alertView.addAction(UIAlertAction(title: "YES", style: .Default, handler: {(action:UIAlertAction) in
            var array: [AnyObject] = self.navigationController!.viewControllers
            for i in 0 ..< array.count {
                if (array[i] is ViewController) {
                    self.navigationController!.popToViewController(array[i] as! UIViewController, animated: true)
                }
            }
            
            
        }));
        self.presentViewController(alertView, animated: true, completion: nil)
    }
    
    
    // MARK: - Data Sending to API
    @IBAction func DataOffline_btnAction(sender: AnyObject) {
        appDel = (UIApplication.sharedApplication().delegate as! AppDelegate)
        //        if self.appDel.checkInternetConnection()
        //        {
        //            dispatch_async(dispatch_get_main_queue()) {
        //                self.appDel.Show_HUD()
        //            }
        //            self.objDataOffline.backgroundDeletethread()
        //        }
        
        NSUserDefaults.standardUserDefaults().setValue("", forKey: "str_HomeScreen")
        if NSUserDefaults.standardUserDefaults().objectForKey("AllData") != nil
        {
            if NSUserDefaults.standardUserDefaults().objectForKey("AllData") as! String == "AllDataSaved"
            {
                if self.appDel.checkInternetConnection()
                {
                    self.objDataOffline.str_webPacket = ""
                    dispatch_async(dispatch_get_main_queue()) {
                        self.appDel.Show_HUD()
                    }
                    self.objDataOffline.backgroundDeletethread()
                }
                
                
            }
        }
        
        
        self.view.userInteractionEnabled = true
    }
    
    func responsedataOffline(Str: String) {
        if Str == "Complete" {
            self.delegate.responseCommonClassOffline()
            
        }
        
    }
    
    
    // MARK: -  tableview Delegates
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.array_tableSection.count;
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if IIndexPath.section == 1 {
            return 0.0
        }
        return 78.0
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let vw = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, 78))
        let image = UIImageView(frame: CGRectMake(0, 0, 315, 78))
        if array_temp_section[IIndexPath.section] .isEqualToString("No") {
            image.image = UIImage(named: self.array_tableSection[section])
        }
        else
        {
            image.image = UIImage(named: self.array_tableSection_Sel[IIndexPath.section])
        }
        
        vw.addSubview(image)
        return vw
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.array_tableSection [section ]
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.array_sectionRow [section ].count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        cell.textLabel?.text = self.array_sectionRow[indexPath.section][indexPath.row]
        
        let image: UIImageView! = UIImageView()
        image.frame = CGRectMake(0, 0, 315, 76)
        
        if (self.array_temp_row[IIndexPath.section][indexPath.row] .isEqualToString("No")) {
            image.image = UIImage(named: self.array_sectionRow[indexPath.section][indexPath.row])
        }
        else
        {
            image.image = UIImage(named: self.array_sectionRow_Sel[IIndexPath.section][indexPath.row])
        }
        
        cell.contentView.addSubview(image)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        print("You selectIIndexPathed cell #\(IIndexPath.section)\(indexPath.row)!")
        
        let vc:UIViewController = UIViewController()
        if (IIndexPath.section == 0)
        {
            if (indexPath.row == 0) {
                if(!vc .isKindOfClass(AdminSystemVC))
                {self.navigationController!.pushViewController(self.storyboard!.instantiateViewControllerWithIdentifier("AdminSystemVC") as UIViewController, animated: false)
                }
            }
            else if (indexPath.row == 1) {
                self.navigationController!.pushViewController(self.storyboard!.instantiateViewControllerWithIdentifier("AddUserVC") as UIViewController, animated: false)
            }
            else if (indexPath.row == 2) {
                self.navigationController!.pushViewController(self.storyboard!.instantiateViewControllerWithIdentifier("ManageUserVC") as UIViewController, animated: false)
            }
        }
        else if (IIndexPath.section == 1)
        {
            if (indexPath.row == 0) {
                self.navigationController!.pushViewController(self.storyboard!.instantiateViewControllerWithIdentifier("MoveHatchlingVC") as UIViewController, animated: false)
            }
            else if (indexPath.row == 1) {
                self.navigationController!.pushViewController(self.storyboard!.instantiateViewControllerWithIdentifier("MoveSectionVC") as UIViewController, animated: false)
            }
            else if (indexPath.row == 2) {
                self.navigationController!.pushViewController(self.storyboard!.instantiateViewControllerWithIdentifier("AddToDieVC") as UIViewController, animated: false)
            }
            else if (indexPath.row == 3) {
                self.navigationController!.pushViewController(self.storyboard!.instantiateViewControllerWithIdentifier("AddToKillVC") as UIViewController, animated: false)
            }
            else if (indexPath.row == 4) {
                self.navigationController!.pushViewController(self.storyboard!.instantiateViewControllerWithIdentifier("SPMoveVC") as UIViewController, animated: false)
            }
            else if (indexPath.row == 5) {
                self.navigationController!.pushViewController(self.storyboard!.instantiateViewControllerWithIdentifier("GroupAverageVC") as UIViewController, animated: false)
            }
        }
            ////
        else if(IIndexPath.section == 2){
            if (indexPath.row == 0) {
                self.navigationController!.pushViewController(self.storyboard!.instantiateViewControllerWithIdentifier("AddSectionVC") as UIViewController, animated: false)
                
            }
            else if (indexPath.row == 1) {
                self.navigationController!.pushViewController(self.storyboard!.instantiateViewControllerWithIdentifier("LoadToTrailerVC") as UIViewController, animated: false)
                
            }
            else if (indexPath.row == 2) {
                self.navigationController!.pushViewController(self.storyboard!.instantiateViewControllerWithIdentifier("TrailerToSPListVC") as UIViewController, animated: false)
            }
            else if (indexPath.row == 3) {
                self.navigationController!.pushViewController(self.storyboard!.instantiateViewControllerWithIdentifier("EmptyPenListVC") as UIViewController, animated: false)
            }
            else if (indexPath.row == 4)
            {
                self.navigationController!.pushViewController(self.storyboard!.instantiateViewControllerWithIdentifier("AddOutsideSectionVC") as UIViewController, animated: false)
            }
        }
            ////
            //        else if (IIndexPath.section == 2)
            //        {
            //            self.navigationController!.pushViewController(self.storyboard!.instantiateViewControllerWithIdentifier("AddSectionVC") as UIViewController, animated: false)
            //
            //        }
        else if (IIndexPath.section == 3)
        {
            self.navigationController!.pushViewController(self.storyboard!.instantiateViewControllerWithIdentifier("InspectionVC") as UIViewController, animated: false)
            
        }
        else if(IIndexPath.section == 4){
            self.navigationController!.pushViewController(self.storyboard!.instantiateViewControllerWithIdentifier("KillVC") as UIViewController, animated: false)
        }
        else if(IIndexPath.section == 5){
            self.navigationController!.pushViewController(self.storyboard!.instantiateViewControllerWithIdentifier("UpdateSectionVC") as UIViewController, animated: false)
            
        }
        else if(IIndexPath.section == 6){
            if (indexPath.row == 0) {
                self.navigationController!.pushViewController(self.storyboard!.instantiateViewControllerWithIdentifier("AddReportVC") as UIViewController, animated: false)
                
            }
            else if (indexPath.row == 1) {
                self.navigationController!.pushViewController(self.storyboard!.instantiateViewControllerWithIdentifier("KillReportVC") as UIViewController, animated: false)
                
            }
            else if (indexPath.row == 2) {
                self.navigationController!.pushViewController(self.storyboard!.instantiateViewControllerWithIdentifier("GradingReportVC") as UIViewController, animated: false)
            }
            else if (indexPath.row == 3) {
                self.navigationController!.pushViewController(self.storyboard!.instantiateViewControllerWithIdentifier("AgingReportVC") as UIViewController, animated: false)
            }
            else if (indexPath.row == 4) {
                self.navigationController!.pushViewController(self.storyboard!.instantiateViewControllerWithIdentifier("SPinUseReportVC") as UIViewController, animated: false)
            }
            else if (indexPath.row == 5) {
                self.navigationController!.pushViewController(self.storyboard!.instantiateViewControllerWithIdentifier("CommunityReportVC") as UIViewController, animated: false)
            }
            else if (indexPath.row == 6) {
                self.navigationController!.pushViewController(self.storyboard!.instantiateViewControllerWithIdentifier("DieReportVC") as UIViewController, animated: false)
            }
            else if (indexPath.row == 7) {
                self.navigationController!.pushViewController(self.storyboard!.instantiateViewControllerWithIdentifier("ReadyReportVC") as UIViewController, animated: false)
            }
            else if (indexPath.row == 8) {
                self.navigationController!.pushViewController(self.storyboard!.instantiateViewControllerWithIdentifier("GroupAvgReportVC") as UIViewController, animated: false)
            }
        }
    }
    
}


