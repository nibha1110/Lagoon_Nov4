//
//  KillVC.swift
//  Crocodile
//
//  Created by Nibha Aggarwal on 5/19/16.
//  Copyright © 2016 Nibha Aggarwal. All rights reserved.
//

import UIKit
import CoreData

class KillVC: UIViewController, responseProtocol, CoreDataProtocol, userlistProtocol, CommonClassProtocol{
    var objwebservice : webservice! = webservice()
    var objuserList : UserListView! = UserListView()
    var Bool_viewUsers: Bool = false
    var Bool_viewFilter: Bool = false
    var Bool_confirm: Bool = false
    
    var objCoreData: CoreDataQueryClass! = CoreDataQueryClass()
    
    var str_webservice: NSString!
    var str_tableFilter: String! = "array3"
    var str_tableFilterSelectOption: String!
    var str_tableFilterPenOption: String!
    var str_filterPressed:String = ""
    
    var dic_killList: NSMutableDictionary! = NSMutableDictionary()
    var array_filter: NSMutableArray! = ["IFP", "IFTP", "OFP", "RTF"]
    
    var totalRows: Int! = 0
    var indexRow: Int! = 0
    var appDel : AppDelegate!
    var array_db : [AnyObject] = []
    var dateFormatter: NSDateFormatter = NSDateFormatter()
    
    @IBOutlet var tabelview_killList: UITableView!
    @IBOutlet weak var table_filterList: UITableView!
    @IBOutlet weak var btn_filter: UIButton!
    @IBOutlet weak var view_filter: UIView! = UIView()

   //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        objwebservice?.delegate = self
        objuserList = UserListView.instanceFromNib() as! UserListView
        objuserList?.delegate = self
        guard let controller = self.storyboard!.instantiateViewControllerWithIdentifier("CommonClassVC") as? CommonClassVC
            else {
                fatalError();
        }
        addChildViewController(controller)
        controller.view.frame = CGRectMake(0, 0, 1024, 768)
        controller.array_tableSection = ["kill"]
        controller.array_sectionRow = [[]]
        controller.btn_Sync.hidden = false
        controller.img_Sync.hidden = false
        controller.btn_BackPop.hidden = true
        view.addSubview(controller.view)
        view.sendSubviewToBack(controller.view)
        controller.label_header.text = "KILL LIST"
        controller.IIndexPath = NSIndexPath(forRow: 0, inSection: 4)
        controller.array_temp_section.replaceObjectAtIndex(4, withObject: "Yes")
        controller.tableMenu.reloadData()
        objwebservice?.delegate = self
        objCoreData?.delegate = self
        
        controller.delegate = self
        appDel = (UIApplication.sharedApplication().delegate as! AppDelegate)
        controller.array_userList = NSUserDefaults.standardUserDefaults().objectForKey("UserList")?.mutableCopy() as! NSMutableArray
    }
    
    override func viewWillAppear(animated: Bool) {
        if self.appDel.checkInternetConnection() {
            self.GetKillList()
        }
        else
        {
            if dic_killList == nil {
                dic_killList = NSMutableDictionary()
            }
            
            //  for offline
//            objCoreData.getAllData("KillTable", formatStr: "offline", whereStr: "NO")
//            return
            let fetchRequest = NSFetchRequest(entityName: "KillTable")
            let predicate = NSPredicate(format: "offline = 'NO' OR killedFrom = 'Inspection'", argumentArray: nil)
            fetchRequest.predicate = predicate
            fetchRequest.returnsObjectsAsFaults = false
            fetchRequest.fetchBatchSize = 20
           fetchRequest.resultType = NSFetchRequestResultType.DictionaryResultType
            do {
                let results = try appDel.managedObjectContext.executeFetchRequest(fetchRequest)
                array_db = results
                print(array_db)
                print("results: \(results)")
                dic_killList.setValue(results, forKey: "AllPens")
                self.totalRows = (self.dic_killList["AllPens"]?.count)!
                print(self.totalRows)
                if self.totalRows == 0 {
                    dic_killList.setValue("No Records Found", forKey: "Message")
                }
                
                var newArray = self.dic_killList["AllPens"]! as! NSArray
                let descriptor: NSSortDescriptor = NSSortDescriptor(key:"pennodisp", ascending: true)
                let sortedResults = newArray.sortedArrayUsingDescriptors([descriptor])
                newArray = sortedResults
                self.dic_killList["AllPens"]! = newArray.mutableCopy() as! NSMutableArray
                
                self.tabelview_killList.reloadData()
                self.tabelview_killList.setContentOffset(CGPointZero, animated:true)  // scroll to top
                print(dic_killList)
                // success ...
            } catch{}
        }
     }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - CoreData offline Delegate
    func GetDataResponseCoreData(array: NSArray) {
        dic_killList .setValue(array as [AnyObject], forKey: "AllPens")
        self.totalRows = (self.dic_killList["AllPens"]?.count)!
        print(self.totalRows)
        if self.totalRows == 0 {
            dic_killList.setValue("No Records Found", forKey: "Message")
        }
        self.tabelview_killList.reloadData()
        print(dic_killList)
    }
    
    
    // MARK: - Kill List on TableView
    func GetKillList()
    {
        appDel.Show_HUD()
        self.str_webservice = "kill_list"
        let request = NSMutableURLRequest(URL: NSURL(string: "\(Server.local_server)/api/kill_list/getkill_List.php")!)
        let postString = ""
        objwebservice.callServiceCommon(request, postString: postString)
    }
    

    
    //MARK: - ConfirmKill
    func ConfirmKill()
    {
        
//        appDel.Show_HUD()
        self.str_webservice = "confirmkill"
        let request = NSMutableURLRequest(URL: NSURL(string: "\(Server.local_server)/api/kill_list/confirmkill.php?")!)
        let postString = "killid=\(dic_killList["AllPens"]![indexRow]["killid"] as! String)&app_id=\(NSUserDefaults.standardUserDefaults().objectForKey("ApplicationIdentifier") as! String)"
        objwebservice.callServiceCommon(request, postString: postString)
    }
    
    //MARK: - CommonClass Delegate
    func responseCommonClassOffline() {
        self.viewWillAppear(false)
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
    
    // MARK: - webservice delegate
    func responseDictionary(dic: NSMutableDictionary){
//        dispatch_async(dispatch_get_main_queue()) {
            if self.str_webservice .isEqualToString("kill_list") {
                self.dic_killList = dic.mutableCopy() as! NSMutableDictionary
                if dic_killList["AllPens"] != nil
                {
                    appDel.str_killData = "Filled"
                    self.totalRows = (self.dic_killList["AllPens"]?.count)!
                    self.tabelview_killList.reloadData()
                }
                else
                {
                    self.tabelview_killList.reloadData()
                }
            }
            else if (self.str_webservice == "getblocklist")
            {
                
                self.array_filter.removeAllObjects()
                autoreleasepool{
                    for i in 0 ..< dic["blocks"]!.count {
                        self.array_filter.addObject(dic["blocks"]![i]["block"] as! String)
                    }
                }
                self.str_tableFilter = "array3"
                self.table_filterList.reloadData()
                
            }
            else if (str_webservice == "getinspectionbyfilter")
            {
                self.array_filter.removeAllObjects()
                self.array_filter = ["IFP", "IFTP", "OFP", "RTF"]
                self.str_tableFilter = "array3"
                self.table_filterList.reloadData()
                self.dic_killList.removeAllObjects()
                
                self.dic_killList = dic
                if dic_killList["AllPens"] != nil
                {
                    self.totalRows = (self.dic_killList["AllPens"]?.count)!
                }
                
                self.tabelview_killList.reloadData()
                
            }
            else if (self.str_webservice == "revert")
            {
                if(dic["success"] as! String == "True")
                {
                    self.RevertFromSingleAllocation()
                }
            }
                
            else if (self.str_webservice == "confirmkill")
            {
                print(dic)
                
//                self.tabelview_killList.reloadData()
                if ((dic["success"]) != nil)
                {
                    self.appDel.remove_HUD()
                    var msg: String!
                    if (self.dic_killList["AllPens"]?.count) > 1
                    {
                        msg = "Pen Has Been Killed Successfully."
                    }
                    else
                    {
                        msg = "You Have Removed The Last Animal On The Kill List For Today. Please Choose New Option From Main Menu."
                    }
                    

                    
                    let alertView = UIAlertController(title: nil, message: msg, preferredStyle: .Alert)
                    let OKAction = UIAlertAction(title: "OK", style: .Cancel) { (action: UIAlertAction) in
                        
//                        self.GetKillList()
                        self.Bool_confirm = true
                        self.callAfterConfirm()
                    }
                    alertView.addAction(OKAction)
//                    alertView.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
                    self.presentViewController(alertView, animated: true, completion: nil)
                }
            }
            if (self.str_webservice == "report_sp_kill")
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
        
            if Bool_confirm == true
            {
                self.appDel.Show_HUD()
            }
            else
            {
                self.appDel.remove_HUD()
            }
     }
    
    
    func callAfterConfirm()
    {
        if (Bool_confirm == true)
        {
            self.GetKillList()
            Bool_confirm = false
        }
    }
    
    // MARK: -  tableview Delegates
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }

   
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == table_filterList {
            return array_filter.count
        }
        else
            if dic_killList["Message"] != nil {
            if (dic_killList["Message"] as! String == "No Records Found")
            {
                return 1
            }
        }
        
        print("totalRows \(totalRows)")
        return totalRows
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        
        let view_bg: UIView = UIView(frame: CGRectMake(0, 0, 709, 75))
        view_bg.tag = 50
        if indexPath.row % 2 == 0 {
            view_bg.backgroundColor = UIColor.whiteColor()
        }
        else {
            view_bg.backgroundColor = UIColor(red: 241.0 / 255.0, green: 241 / 255.0, blue: 241 / 255.0, alpha: 1.0)
        }
        
        if tableView == table_filterList {
            cell.textLabel?.text = array_filter[indexPath.row] as? String
            cell.textLabel!.font = UIFont(descriptor: UIFontDescriptor(name: "HelveticaNeue", size: 19), size: 19.0)
        }
        else if (tableView == tabelview_killList)
        {
            //label_gpname
            let label_groupName: UILabel = UILabel(frame: CGRectMake(15, 13, 170, 50))
            label_groupName.font = UIFont(name: "HelveticaNeue", size: 23)
            label_groupName.tag = 51
            
            if dic_killList["Message"] != nil {
                if (dic_killList["Message"] as! String == "No Records Found") {
                    label_groupName.frame = CGRectMake(50, 13, 400, 50)
                    label_groupName.text = "You have no record listed"
                    view_bg.addSubview(label_groupName)
                    cell.contentView .addSubview(view_bg)
                    return cell
                }
            }
            
            print("row \(indexPath.row) & index \(indexRow)")
            
            label_groupName.text = "\((dic_killList["AllPens"]![indexPath.row]["killdate"] as? String)!)"
            
            //label_Grp
            let label_Grp: UILabel = UILabel(frame: CGRectMake(120, 13, 170, 50))
            label_Grp.textAlignment = .Center
            label_Grp.font = UIFont(name: "HelveticaNeue", size: 24)
            label_Grp.tag = 52
            label_Grp.text = dic_killList["AllPens"]![indexPath.row]["groupcodedisp"] as? String
            var str: String! = dic_killList["AllPens"]![indexPath.row]["groupcodedisp"] as? String
            var arrayTemp = str.componentsSeparatedByString("-")
            str = arrayTemp[0].stringByReplacingOccurrencesOfString(" ", withString: "")
            label_Grp.text = str
            
            //PINK CheckMark image
            let Pinkcheck: UIImageView = UIImageView(frame: CGRectMake(268, 18, 40, 35))
            if (dic_killList["AllPens"]![indexPath.row]["ispink"] as! String == "0") {
                Pinkcheck.image = UIImage(named: "Cross")
            }
            else {
                Pinkcheck.image = UIImage(named: "PinkTick")
            }
            
            let btn_Pinkcheck: UIButton = UIButton(frame: CGRectMake(268, 18, 40, 35))
            btn_Pinkcheck.setTitleColor(UIColor.blackColor(), forState: .Normal)
            btn_Pinkcheck.titleLabel?.font = UIFont(descriptor: UIFontDescriptor(name: "HelveticaNeue", size: 22), size: 22.0)
            if (dic_killList["AllPens"]![indexPath.row]["ispink"] as! String == "0") {
                btn_Pinkcheck.setTitle("N", forState: .Normal)
            }
            else {
                btn_Pinkcheck.setTitle("Y", forState: .Normal)
            }
            
            
            
            //blue image
            let img_blue: UIImageView = UIImageView(frame: CGRectMake(355, 10, 125, 52))
            img_blue.image = UIImage(named: "xxyyBlue")
            
            //label_Groups
            let label_revert: UILabel = UILabel(frame: CGRectMake(355, 8, 125, 56))
            label_revert.textAlignment = .Center
            label_revert.font = UIFont(descriptor: UIFontDescriptor(name: "HelveticaNeue", size: 22), size: 22.0)
            label_revert.textColor = UIColor.whiteColor()
            label_revert.text = "REVERT"
            
            
            //Edit_Button
            let btn_revert: UIButton = UIButton(frame: CGRectMake(355, 10, 125, 52))
            btn_revert.addTarget(self, action: #selector(KillVC.RevertBtnAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            btn_revert.tag = indexPath.row
            
            
            //orange image
            let img_orange: UIImageView = UIImageView(frame: CGRectMake(500, 8, 170, 56))
            img_orange.image = UIImage(named: "xxyy")
            img_orange.tag = 53
            
            
            
            
            //label_pens
            let label_pens: UILabel = UILabel(frame: CGRectMake(500, 8, 170, 56))
            label_pens.textAlignment = .Center
            label_pens.textColor = UIColor.whiteColor()
            label_pens.font = UIFont(name: "HelveticaNeue", size: 23)
            label_pens.tag = 54
            label_pens.text = dic_killList["AllPens"]![indexPath.row]["pennodisp"] as? String
            
            view_bg.addSubview(img_orange)
            view_bg.addSubview(label_pens)
            view_bg.addSubview(img_blue)
            view_bg.addSubview(label_revert)
            view_bg.addSubview(btn_revert)
            
            view_bg.addSubview(label_Grp)
            view_bg.addSubview(label_groupName)
            view_bg.addSubview(btn_Pinkcheck)
            cell.contentView .addSubview(view_bg)
            
        }
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        indexRow = indexPath.row
        if tableView == table_filterList{
            if (str_tableFilter == "array2")
            {
                if self.appDel.checkInternetConnection() {
                    appDel.Show_HUD()
                    str_webservice = "getblocklist"
                    let request = NSMutableURLRequest(URL: NSURL(string: "\(Server.local_server)/api/sp_inspection/getblocklist.php?")!)
                    let postString = "group=\(array_filter[indexPath.row] as! String)"
                    objwebservice.callServiceCommon_inspection(request, postString: postString)
                    str_tableFilterSelectOption = array_filter[indexPath.row] as! String
                }
                else
                {
                    
                    if dic_killList["Message"] != nil {
                        dic_killList.removeObjectForKey("Message")
                        
                    }
                    self.GetFilterPenOffline(array_filter[indexPath.row] as! String)
                }
                
            }
            else if (str_tableFilter == "array3")
            {
                str_tableFilterSelectOption = array_filter[indexPath.row] as! String
                self.cancelFilter()
                if self.appDel.checkInternetConnection() {
                    appDel.Show_HUD()
                    
                    str_webservice = "getinspectionbyfilter"
                    let request = NSMutableURLRequest(URL: NSURL(string: "\(Server.local_server)/api/kill_list/getkill_Listbyfilter.php?")!)
                    let postString = "group=\(str_tableFilterSelectOption)"
                    objwebservice.callServiceCommon_inspection(request, postString: postString)
                }
                    
                else
                {
                    self.GetFilterOfflineRecords(str_tableFilterSelectOption, pen: "", month: "")
                }
                
                
                str_tableFilterPenOption = array_filter[indexPath.row] as! String
                str_filterPressed = "block"
            }
        }
            
        else
        {
            if dic_killList["Message"] != nil {
                if (dic_killList["Message"] as! String == "No Records Found") {
                    return
                }
            }
            
            let alertView = UIAlertController(title: nil, message: "Are You Sure You Want To Confirm Kill?", preferredStyle: .Alert)
            alertView.addAction(UIAlertAction(title: "NO", style: .Cancel, handler: nil))
            alertView.addAction(UIAlertAction(title: "YES", style: .Default, handler: {(action:UIAlertAction) in
                if self.appDel.checkInternetConnection() {
                    self.UpDateAddSectionTableEvent((self.dic_killList["AllPens"]![indexPath.row]["groupcode"]) as! String)
                    self.UpDatefetchEvent((self.dic_killList["AllPens"]![indexPath.row]["killid"]) as! String, Offline: "YES")
                    
                    
                    let groupcode: String = (self.dic_killList["AllPens"]![indexPath.row]["groupcode"]) as! String
                    let grpnamedisp: String = "\((self.dic_killList["AllPens"]![indexPath.row]["groupcode"]) as! String)-PEN#"
                    
                    var arraytemp = "\(self.dic_killList["AllPens"]![self.indexRow]["pennodisp"] as! String)".componentsSeparatedByString("-")
                    
                    let namexx: String!  = "\(arraytemp[0])"
                    let nameyy: String!  = "\(arraytemp[1])"
                    
                    let penid: String = (self.dic_killList["AllPens"]![indexPath.row]["killid"]) as! String
                    let pennodisp = (self.dic_killList["AllPens"]![indexPath.row]["pennodisp"]) as! String
                    
                    self.addToEmptyPen(groupcode, grpnamedisp: grpnamedisp, namexx: namexx, nameyy: nameyy, pennodisp: pennodisp, penid: penid)
                    self.ConfirmKill()
                }
                else
                {
                    self.UpDateAddSectionTableEvent((self.dic_killList["AllPens"]![indexPath.row]["groupcode"]) as! String)
                    self.UpDatefetchEvent((self.dic_killList["AllPens"]![indexPath.row]["killid"]) as! String, Offline: "YES")
                    
                    
                    let groupcode: String = (self.dic_killList["AllPens"]![indexPath.row]["groupcode"]) as! String
                    let grpnamedisp: String = "\((self.dic_killList["AllPens"]![indexPath.row]["groupcode"]) as! String)-PEN#"
                    
                    var arraytemp = "\(self.dic_killList["AllPens"]![self.indexRow]["pennodisp"] as! String)".componentsSeparatedByString("-")
                    
                    let namexx: String!  = "\(arraytemp[0])"
                    let nameyy: String!  = "\(arraytemp[1])"
                    
                    let penid: String = (self.dic_killList["AllPens"]![indexPath.row]["killid"]) as! String
                    let pennodisp = (self.dic_killList["AllPens"]![indexPath.row]["pennodisp"]) as! String
                    
                    self.addToEmptyPen(groupcode, grpnamedisp: grpnamedisp, namexx: namexx, nameyy: nameyy, pennodisp: pennodisp, penid: penid)
                }
                
            }));
            self.presentViewController(alertView, animated: true, completion: nil)
        }
        
    }
    
   
    
    //MARK: - RevertBtnAction
    @IBAction func RevertBtnAction(sender: UIButton) {
        
        let btn: UIButton = sender
        self.indexRow = btn.tag
        
        
        
        let alertView = UIAlertController(title: nil, message: "Are You Sure You Want To Revert?", preferredStyle: .Alert)
        alertView.addAction(UIAlertAction(title: "NO", style: .Cancel, handler: nil))
        alertView.addAction(UIAlertAction(title: "YES", style: .Default, handler: {(action:UIAlertAction) in
            if (true)
            {
                
                self.appDel.Show_HUD()
                
                if self.appDel.checkInternetConnection() {
                    self.str_webservice = "revert"
                    let request = NSMutableURLRequest(URL: NSURL(string: "\(Server.local_server)/api/kill_list/revertkill.php?")!)
                    let postString = "killid=\(self.dic_killList["AllPens"]![self.indexRow]["killid"] as! String)&app_id=\(NSUserDefaults.standardUserDefaults().objectForKey("ApplicationIdentifier") as! String)"
                    self.objwebservice.callServiceCommon(request, postString: postString)
                }
                
                else
                {
                    self.RevertFromSingleAllocation()
                }
                
                
            }
        }));
        self.presentViewController(alertView, animated: true, completion: nil)
        
        
        
    }
    
    
    func RevertFromSingleAllocation()
    {
        var objCoreTable: SingleAllocatedPen!
        objCoreTable = (NSEntityDescription.insertNewObjectForEntityForName("SingleAllocatedPen", inManagedObjectContext: self.appDel.managedObjectContext) as! SingleAllocatedPen)
        
        var arraytemp = "\(self.dic_killList["AllPens"]![self.indexRow]["pennodisp"] as! String)".componentsSeparatedByString("-")

        objCoreTable.namexx = "\(arraytemp[0])"
        objCoreTable.nameyy = "\(arraytemp[1])"
        objCoreTable.pennodisp = "\(self.dic_killList["AllPens"]![self.indexRow]["pennodisp"] as! String)"
        objCoreTable.penid = "\(self.dic_killList["AllPens"]![self.indexRow]["killid"] as! String)"
        objCoreTable.skin_size = "\(self.dic_killList["AllPens"]![self.indexRow]["sp_size"] as! String)"
        objCoreTable.recheckcount = "\(self.dic_killList["AllPens"]![self.indexRow]["recheck_count"] as! String)"
        objCoreTable.int_recheckcount = (self.dic_killList["AllPens"]![self.indexRow]["recheck_count"] as! String).toInteger()
        objCoreTable.state = "NO"
        objCoreTable.groupcode = "\(self.dic_killList["AllPens"]![self.indexRow]["groupcode"] as! String)"
        objCoreTable.groupcodedisp = "\(objCoreTable.groupcode!) -PEN#"
        
        objCoreTable.dateadded = "\(self.dic_killList["AllPens"]![self.indexRow]["entry_date"] as! String)"
        
        
        // to adding months in entry date
        objCoreTable.entrydate = "\(self.dic_killList["AllPens"]![self.indexRow]["inspect_date"] as! String)"
        objCoreTable.entryConvert = self.Databse_dateconvertor(objCoreTable.entrydate)
        objCoreTable.addedConvert = self.Databse_dateconvertor(objCoreTable.dateadded)
        objCoreTable.colorcode = "BLACK"
        objCoreTable.ispink = "\(self.dic_killList["AllPens"]![self.indexRow]["ispink"] as! String)"
        objCoreTable.comment = "\(self.dic_killList["AllPens"]![self.indexRow]["comment"] as! String)"
        print(objCoreTable)
        do {
            try self.appDel.managedObjectContext.save()
            
            self.DeleteFromList((self.dic_killList["AllPens"]![self.indexRow]["killid"]) as! String)
        } catch {}
    }
    
    //MARK :- Filter Offline
    func GetFilterPenOffline(grp: String!)
    {
        str_tableFilterSelectOption = grp
        let fetchRequest = NSFetchRequest(entityName: "FirstLetterTable")
        let predicate = NSPredicate(format: "group_code = %@", grp)
        fetchRequest.predicate = predicate
        fetchRequest.fetchBatchSize = 20
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.resultType = NSFetchRequestResultType.DictionaryResultType
        do
        {
            var results = try self.appDel.managedObjectContext.executeFetchRequest(fetchRequest)
            print(results)
            var newArray = results as NSArray
            let descriptor: NSSortDescriptor = NSSortDescriptor(key:"first_letter", ascending: true)
            let sortedResults = newArray.sortedArrayUsingDescriptors([descriptor])
            newArray = sortedResults
            results = newArray as [AnyObject]
            
            var letterArray = [String]()
            autoreleasepool{
                for i in 0 ..< results.count {
                    let pennodisp = results[i]["first_letter"] as! String
                    letterArray.append(String(pennodisp.characters.first!))
                }
            }
            letterArray = uniq(letterArray)
            self.array_filter.removeAllObjects()
            autoreleasepool{
                for i in 0 ..< letterArray.count {
                    self.array_filter.addObject(letterArray[i])
                }
            }
            self.str_tableFilter = "array3"
            self.table_filterList.reloadData()
            
            
        } catch {
            
        }
    }
    
    func uniq<S: SequenceType, E: Hashable where E==S.Generator.Element>(source: S) -> [E] {
        var seen: [E:Bool] = [:]
        return source.filter({ (v) -> Bool in
            return seen.updateValue(true, forKey: v) == nil
        })
    }
    
    func GetFilterOfflineRecords(grpcode: String!, pen: String!, month: String!)
    {
        let fetchRequest = NSFetchRequest(entityName: "KillTable")
//        let predicate = NSPredicate(format: "groupcode = %@ AND pennodisp beginswith[c] %@", str_tableFilterSelectOption, pen)
        let predicate = NSPredicate(format: "groupcode = %@", str_tableFilterSelectOption)
        fetchRequest.predicate = predicate
        fetchRequest.fetchBatchSize = 20
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.resultType = NSFetchRequestResultType.DictionaryResultType
        do
        {
            self.appDel.Show_HUD()
            let results = try self.appDel.managedObjectContext.executeFetchRequest(fetchRequest)
            if results.count > 0 {
                self.dic_killList.removeObjectForKey("Message")
                self.totalRows = results.count
                var newArray = results as NSArray
                let descriptor: NSSortDescriptor = NSSortDescriptor(key:"pennodisp", ascending: true)
                let sortedResults = newArray.sortedArrayUsingDescriptors([descriptor])
                newArray = sortedResults
                self.dic_killList["AllPens"]! = newArray.mutableCopy() as! NSMutableArray
                
                self.tabelview_killList.reloadData()
                self.tabelview_killList.setContentOffset(CGPointZero, animated:true)  // scroll to top
                self.appDel.remove_HUD()
                
            }
            else
            {
                self.totalRows = results.count
                if self.totalRows == 0 {
                    dic_killList.setValue("No Records Found", forKey: "Message")
                }
                self.tabelview_killList.reloadData()
                self.appDel.remove_HUD()
            }
        }
        catch{}
        
        
    }
    
    //MARK: - update database
    func DeleteFromList(killID: String!) -> KillTable? {
        
        // Define fetch request/predicate/sort descriptors
        let fetchRequest = NSFetchRequest(entityName: "KillTable")
        let predicate = NSPredicate(format: "killid == '\(killID)'", argumentArray: nil)
        fetchRequest.predicate = predicate
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.fetchBatchSize = 20
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try self.appDel.persistentStoreCoordinator.executeRequest(deleteRequest, withContext: self.appDel.managedObjectContext)
            do
            {
                try self.appDel.managedObjectContext.save()
                appDel.remove_HUD()
                if self.appDel.checkInternetConnection() {
                    self.dic_killList = nil
                    self.viewWillAppear(false)
                }
                else
                {
                    var objCoreTable : KillRevertTable!
                    objCoreTable = (NSEntityDescription.insertNewObjectForEntityForName("KillRevertTable", inManagedObjectContext: self.appDel.managedObjectContext) as! KillRevertTable)
                    objCoreTable.killid = killID
                    do {
                        try self.appDel.managedObjectContext.save()
//                        self.dic_killList = nil
                        self.viewWillAppear(false)
                        self.tabelview_killList.reloadData()
                    } catch {}
                }
                
                
                
                
            }
            catch{}
        } catch{}
        return nil
    }
    
    //MARK: -
    
    
    func Databse_dateconvertor(datestr: String!) -> NSDate
    {
        let twelveHourLocale: NSLocale = NSLocale(localeIdentifier: "en_US_POSIX")
        dateFormatter.locale = twelveHourLocale
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC")
        let gotDate: NSDate = dateFormatter.dateFromString(datestr)!
        return gotDate
    }
    
    
    //MARK: - update database
    func UpDatefetchEvent(killID: String!, Offline: String!) -> KillTable? {
        
        // Define fetch request/predicate/sort descriptors
        let fetchRequest = NSFetchRequest(entityName: "KillTable")
        let predicate = NSPredicate(format: "killid == '\(killID)'", argumentArray: nil)
        fetchRequest.predicate = predicate
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.fetchBatchSize = 20
        do {
            let fetchedResults = try appDel.managedObjectContext.executeFetchRequest(fetchRequest)
            if fetchedResults.count != 0 {
                for i in 0 ..< fetchedResults.count {
                    if let objTable: KillTable = fetchedResults[i] as? KillTable {
                        objTable.offline = Offline
                        objTable.killedFrom = "Kill"
                        do {
                            try self.appDel.managedObjectContext.save()
                            
                            //popup
                            var msg: String!
                            if (self.dic_killList["AllPens"]?.count) > 1
                            {
                                msg = "Pen Has Been Killed Successfully."
                            }
                            else
                            {
                                msg = "You Have Removed The Last Animal On The Kill List For Today. Please Choose New Option From Main Menu."
                            }
                            let alertView = UIAlertController(title: nil, message: msg, preferredStyle: .Alert)
                            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action: UIAlertAction) in
                                self.dic_killList = nil
                                self.viewWillAppear(false)
                                
                            }
                            alertView.addAction(OKAction)
                            self.presentViewController(alertView, animated: true, completion: nil)
                            //popup end
                            
                        } catch {
                        }
                        return objTable
                    }
                }
            }
        }catch let error as NSError {
            // failure
            print("Fetch failed: \(error.localizedDescription)")
        }
        return nil
    }
    
    //MARK: - update database
    func UpDateAddSectionTableEvent(groupcode: String!) -> AddSectionTable? {
        
        // Define fetch request/predicate/sort descriptors
        let fetchRequest = NSFetchRequest(entityName: "AddSectionTable")
        let predicate = NSPredicate(format: "groupcode = '\(groupcode)'", argumentArray: nil)
        fetchRequest.predicate = predicate
        
        
        
        // Handle results
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.fetchBatchSize = 20
        do {
            let fetchedResults = try appDel.managedObjectContext.executeFetchRequest(fetchRequest)
            if fetchedResults.count != 0 {
                for i in 0 ..< fetchedResults.count {
                    if let objTable: AddSectionTable = fetchedResults[i] as? AddSectionTable {
                        var intvaa : Int = Int(objTable.available! as String)!
                        intvaa = intvaa + 1
                        objTable.available = String(intvaa)
                        do {
                            try self.appDel.managedObjectContext.save()
//                            self.viewWillAppear(false)
                        } catch {
                        }
                        return objTable
                    }
                }
            }
        }catch let error as NSError {
            // failure
            print("Fetch failed: \(error.localizedDescription)")
        }
        
        
        return nil
    }
    
    func addToEmptyPen(groupcode: String, grpnamedisp: String, namexx: String, nameyy: String, pennodisp: String, penid: String)
    {
        let fetchRequest = NSFetchRequest(entityName: "EmptyPensTable")
        var resultscount : Int = 0
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try appDel.managedObjectContext.executeFetchRequest(fetchRequest)
            resultscount = results.count
        }catch  {
            
        }

        
        var objCoreTable : EmptyPensTable!
        objCoreTable = (NSEntityDescription.insertNewObjectForEntityForName("EmptyPensTable", inManagedObjectContext: self.appDel.managedObjectContext) as! EmptyPensTable)
        objCoreTable.id = resultscount+1
        objCoreTable.groupcode = groupcode
        objCoreTable.grpnamedisp = grpnamedisp
        objCoreTable.namexx = namexx
        objCoreTable.nameyy = nameyy
        objCoreTable.pennodisp = pennodisp
        objCoreTable.penid = penid
        do {
            try self.appDel.managedObjectContext.save()
        } catch {}
    }

    
    //MARK: - Export Btn_Action/ UserList Delegate
    @IBAction func Export_BtnAction(sender: AnyObject) {
        if Bool_viewFilter
        {
            self.view_filter.hidden = true
            self.Bool_viewFilter = false
        }
        if !Bool_viewUsers {
            objuserList.showView(self.view, frame1: CGRectMake(677, 145, 318, 231))
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
                str_webservice = "report_sp_kill"
                let request = NSMutableURLRequest(URL: NSURL(string: "\(Server.local_server)/api/file/report_sp_kill.php?")!)
                let postString = "tomail=\(EmailUsers)"
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
    
    //MARK: - FilterBTnAction
    @IBAction func Filter_BtnAction(sender: UIButton) {
        if Bool_viewUsers
        {
            objuserList.removeView(self.view)
            Bool_viewUsers = false
        }
        self.view.userInteractionEnabled = false
        if !Bool_viewFilter {
            self.array_filter.removeAllObjects()
            self.array_filter = ["IFP", "IFTP", "OFP", "RTF"]
            self.str_tableFilter = "array3"
            self.table_filterList.reloadData()
            
            view_filter.hidden = true
            let transitionOptions = UIViewAnimationOptions.TransitionCurlDown
            UIView.transitionWithView(self.view_filter, duration: 0.6, options: transitionOptions, animations: {
                self.view_filter.hidden = false
                
                }, completion: { finished in
                    self.view.userInteractionEnabled = true
                    self.Bool_viewFilter = true
            })
            
        }
        else {
            let transitionOptions = UIViewAnimationOptions.TransitionCurlUp
            UIView.transitionWithView(self.view_filter, duration: 0.6, options: transitionOptions, animations: {
                self.view_filter.hidden = true
                
                }, completion: { finished in
                    
                    self.Bool_viewFilter = false
                    self.view.userInteractionEnabled = true
            })
            
        }
        
    }
    
    @IBAction func CancelFilter_BtnAction(sender: UIButton) {
        cancelFilter()
    }
    
    func cancelFilter()
    {
        let transitionOptions = UIViewAnimationOptions.TransitionCurlUp
        UIView.transitionWithView(self.view_filter, duration: 0.6, options: transitionOptions, animations: {
            self.view_filter.hidden = true
            
            }, completion: { finished in
                
                self.Bool_viewFilter = false
        })
    }
    
    
}