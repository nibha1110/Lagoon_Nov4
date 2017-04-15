//
//  UpdateRecheckVC.swift
//  Crocodile
//
//  Created by Nibha Aggarwal on 6/9/16.
//  Copyright © 2016 Nibha Aggarwal. All rights reserved.
//

import UIKit
import CoreData

class UpdateRecheckVC: UIViewController, responseProtocol, EditCommentProtocol, CommentConditionProtocol
    
{
    var toPass_dic: NSMutableDictionary! = NSMutableDictionary()
    var objwebservice : webservice! = webservice()
    var objComment : EditCommentView! = EditCommentView()
    var objCommentCondition : CommentConditionView! = CommentConditionView()
    var appDel : AppDelegate!
    var str_webservice:String!
    var str_condition: String!
    var str_inspection: String!
    var pickerLabel: UILabel!
    var str_comment: String!
    var Bool_comment: Bool = false
    var dic_condition:NSMutableDictionary! = NSMutableDictionary()
    var dic_inspect:NSMutableDictionary! = NSMutableDictionary()
    var nullvalue: AnyObject = NSNull()
    let dateFormatter: NSDateFormatter = NSDateFormatter()
    
    @IBOutlet weak var picker_condition: UIPickerView!
    @IBOutlet weak var picker_recheck: UIPickerView!
    @IBOutlet weak var Label_penDetail: UILabel!
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let controller = self.storyboard!.instantiateViewControllerWithIdentifier("CommonClassVC") as? CommonClassVC
            else {
                fatalError();
        }
        appDel = (UIApplication.sharedApplication().delegate as! AppDelegate)
        addChildViewController(controller)
        controller.view.frame = CGRectMake(0, 0, 1024, 768)
        controller.array_tableSection = ["update"]
        controller.array_sectionRow = [[]]
        view.addSubview(controller.view)
        view.sendSubviewToBack(controller.view)
        controller.label_header.text = "SP UPDATE"
        controller.IIndexPath = NSIndexPath(forRow: 0, inSection: 5)
        controller.array_temp_section.replaceObjectAtIndex(5, withObject: "Yes")
        controller.tableMenu.reloadData()
        
        
        objComment = EditCommentView.instanceFromNib() as! EditCommentView
        objComment?.delegate = self
        
        objCommentCondition = CommentConditionView.instanceFromNib() as! CommentConditionView
        objCommentCondition?.delegate = self
        
        
        objCommentCondition.selecteditems.removeAllObjects()
        objCommentCondition.drawRect(CGRectMake(640, 160, 318, 231))
        
        objwebservice?.delegate = self
        
        Label_penDetail.text = "\((toPass_dic["PenDetails"]![0]["groupcodedisp"] as! String)+" "+(toPass_dic["PenDetails"]![0]["pennodisp"] as! String))"
        
        let strTemp : String!
        strTemp = "\(toPass_dic["PenDetails"]![0]["comment"] as! String)"
        print(strTemp)
        if (strTemp == "Optional(<null>)") || (strTemp == nil) {
            
        }
        else
        {
            str_comment = "\(toPass_dic["PenDetails"]![0]["comment"] as! String)".stringByReplacingOccurrencesOfString("%20", withString: " ")
            
//            str_comment = "\(toPass_dic["PenDetails"]![0]["comment"] as! String)"
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        
        if self.appDel.checkInternetConnection()
        {
            self.GetAllGeneralDetailService()
        }
        else
        {
            var fetchRequest = NSFetchRequest(entityName: "ConditionTable")
            fetchRequest.returnsObjectsAsFaults = false
            //fetchRequest.includesPropertyValues = false
            fetchRequest.fetchBatchSize = 20
            fetchRequest.resultType = NSFetchRequestResultType.DictionaryResultType
            do {
                let results = try appDel.managedObjectContext.executeFetchRequest(fetchRequest)
                self.dic_condition.setValue(results, forKey: "Condition_data")
                self.str_condition = self.dic_condition["Condition_data"]![0]["conditionid"] as! String
                self.picker_condition.selectRow(0, inComponent: 0, animated: true)
                self.picker_condition.reloadAllComponents()
            } catch let error as NSError {
                print("Fetch failed: \(error.localizedDescription)")
            }
            
            //Inspection
            fetchRequest = NSFetchRequest(entityName: "InspectionPeriodTable")
            fetchRequest.returnsObjectsAsFaults = false
            //fetchRequest.includesPropertyValues = false
            fetchRequest.fetchBatchSize = 20
            fetchRequest.resultType = NSFetchRequestResultType.DictionaryResultType
            do {
                let results = try appDel.managedObjectContext.executeFetchRequest(fetchRequest)
                self.dic_inspect.setValue(results, forKey: "inspection_data")
                
                self.str_inspection = dic_inspect["inspection_data"]![0]["inspect_id"] as! String
                self.picker_recheck.selectRow(0, inComponent: 0, animated: true)
                self.picker_recheck.reloadAllComponents()
                
            } catch let error as NSError {
                print("Fetch failed: \(error.localizedDescription)")
            }
            self.appDel.remove_HUD()

        }
        
    }
    
    
    //MARK: - get All Data
    func GetAllGeneralDetailService()
    {
        if self.appDel.checkInternetConnection()
        {
            str_webservice = "getgeneraldetails"
            appDel.Show_HUD()
            let request = NSMutableURLRequest(URL: NSURL(string: "\(Server.local_server)/api/singlepen/getgeneraldetails.php")!)
            let postString = ""
            objwebservice.callServiceCommon(request, postString: postString)
            
        }
    }
    
    // MARK: - get All detail Service No use
    func GetAllConditonDetailService()
    {
        appDel.Show_HUD()
        str_webservice = "getcondition"
        let request = NSMutableURLRequest(URL: NSURL(string: "\(Server.local_server)/api/singlepen/getcondition.php")!)
        let postString = ""
        objwebservice.callServiceCommon(request, postString: postString)
    }
    
    func GetAllInspectedDetailService()
    {
        appDel.Show_HUD()
        str_webservice = "getinspection"
        let request = NSMutableURLRequest(URL: NSURL(string: "\(Server.local_server)/api/singlepen/getinspection.php")!)
        let postString = ""
        objwebservice.callServiceCommon(request, postString: postString)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    
    //MARK: - ALL Response
    func conditionResponse(dic: NSMutableDictionary)
    {
        self.dic_condition = dic["general_details"]![0] as AnyObject as! NSMutableDictionary
        self.str_condition = dic["general_details"]![0]["Condition_data"]!![0]["conditionid"] as! String
        self.picker_condition.selectRow(0, inComponent: 0, animated: true)
        self.picker_condition.reloadAllComponents()
    }
    
    func inspectionResponse(dic: NSMutableDictionary)
    {
        self.dic_inspect = dic["general_details"]![1] as AnyObject as! NSMutableDictionary
        if dic["general_details"]![1]["inspection_data"]!!.count > 7 {
            
            self.str_inspection = dic["general_details"]![1]["inspection_data"]!![0]["inspect_id"] as! String
            self.picker_recheck.selectRow(0, inComponent: 0, animated: true)
            self.picker_recheck.reloadAllComponents()
            
        }
        else
        {
            self.str_inspection = dic["general_details"]![1]["inspection_data"]!![0]["inspect_id"] as! String
            self.picker_recheck.selectRow(0, inComponent: 0, animated: true)
            self.picker_recheck.reloadAllComponents()
        }
        
    }
    
    
    
    // MARK: - Webservice Delegate
    func responseDictionary(dic: NSMutableDictionary) {
        
        //        dispatch_async(dispatch_get_main_queue()) {
        if (self.str_webservice == "getgeneraldetails")
        {
            self.conditionResponse(dic)
            self.inspectionResponse(dic)
            
        }
            
            
            
        else if self.str_webservice == "getcondition" {
            self.dic_condition = dic
            self.str_condition = dic["condition"]![0]["conditionid"] as! String
            self.picker_condition.selectRow(0, inComponent: 0, animated: true)
            self.picker_condition.reloadAllComponents()
            self.GetAllInspectedDetailService()
        }
            //////////
        else if self.str_webservice == "getinspection" {
            self.dic_inspect = dic
            if dic["inspection"]?.count > 7 {
                self.str_inspection = dic["inspection"]![7]["inspect_id"] as! String
                self.picker_recheck.selectRow(7, inComponent: 0, animated: true)
                self.picker_recheck.reloadAllComponents()
            }
            else
            {
                self.str_inspection = dic["inspection"]![0]["inspect_id"] as! String
                self.picker_recheck.selectRow(0, inComponent: 0, animated: true)
                self.picker_recheck.reloadAllComponents()
            }
            
        }
            //////////
        else if (self.str_webservice == "updatedata")
        {
            if (dic["success"] as! String == "False")
            {
                let alertView = UIAlertController(title: nil, message: "Pen Already Allocated\n Please Select Another Pen", preferredStyle: .Alert)
                alertView.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
                self.presentViewController(alertView, animated: true, completion: nil)
            }
            else
            {
                let alertView = UIAlertController(title: nil, message: "Successfully Updated Values.", preferredStyle: .Alert)
                alertView.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: {(action:UIAlertAction) in
                    self.navigationController?.popViewControllerAnimated(false)
                }));
                self.presentViewController(alertView, animated: true, completion: nil)
            }
        }
            //////////
        else if self.str_webservice == "movetokill_list" {
            print(dic)
            if dic["Message"] as! String == "Successfully added to kill list" {
                let alertView = UIAlertController(title: nil, message: "Successfully Added To Kill List.", preferredStyle: .Alert)
                let OKAction = UIAlertAction(title: "OK", style: .Cancel) { (action: UIAlertAction) in
                    // pop here
                    self.navigationController?.popViewControllerAnimated(false)
                }
                alertView.addAction(OKAction)
                self.presentViewController(alertView, animated: true, completion: nil)
            }
        }
        //        }
        //        dispatch_async(dispatch_get_main_queue()) {
        self.appDel.remove_HUD()
        //        }
    }
    
    //MARK:- MoveTo_BtnAction
    @IBAction func MoveTo_BtnAction(sender: AnyObject) {
//        if self.appDel.checkInternetConnection() {
            self.performSegueWithIdentifier("toUpdateMove", sender: self)
//        }
//        else
//        {
//            let alertView = UIAlertController(title: nil, message: Server.noInternet, preferredStyle: .Alert)
//            alertView.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
//            self.presentViewController(alertView, animated: true, completion: nil)
//        }
    }
    
    //MARK: - Add to Kill List
    @IBAction func AddToKillList(sender: AnyObject) {
        
            //            dispatch_async(dispatch_get_main_queue()) {
            let alertView = UIAlertController(title: nil, message: "Are You Sure You Want To Add To Kill List?", preferredStyle: .Alert)
            alertView.addAction(UIAlertAction(title: "NO", style: .Cancel, handler: nil))
            alertView.addAction(UIAlertAction(title: "YES", style: .Default, handler: {(action:UIAlertAction) in
                
                if self.appDel.checkInternetConnection() {
                    self.DeleteFromSingleAllocatedPen(self.toPass_dic["PenDetails"]![0]["penid"] as! String, Offline: "NO", killedFrom: "Kill")
                    self.AddToKillListService()
                }
                else
                {
                    self.DeleteFromSingleAllocatedPen(self.toPass_dic["PenDetails"]![0]["penid"] as! String, Offline: "YES", killedFrom: "Inspection")
                    
                    
                }
            }));
            self.presentViewController(alertView, animated: true, completion: nil)
            
            //            }
        
        
    }
    
    func AddToKillListService()
    {
        appDel.Show_HUD()
        str_webservice = "movetokill_list";
        let request = NSMutableURLRequest(URL: NSURL(string: "\(Server.local_server)/api/sp_inspection/movetokill_list.php?")!)
        let postString = "penid=\(toPass_dic["PenDetails"]![0]["penid"] as! String)&addedby=\(NSUserDefaults.standardUserDefaults().objectForKey("email_username") as! String)&app_id=\(NSUserDefaults.standardUserDefaults().objectForKey("ApplicationIdentifier") as! String)"
        objwebservice.callServiceCommon(request, postString: postString)
        
    }
    
    //MARK: - Save Button Action
    @IBAction func Save_BtnAction(sender: AnyObject) {
        
            let alertView = UIAlertController(title: nil, message: "Are You Sure You Want To Update Values.", preferredStyle: .Alert)
            alertView.addAction(UIAlertAction(title: "NO", style: .Cancel, handler: nil))
            alertView.addAction(UIAlertAction(title: "YES", style: .Default, handler: {(action:UIAlertAction) in
               
                if self.appDel.checkInternetConnection() {
                    self.AddingToRecheck_save()
                    self.recheckoffline()
                }
                else
                {
                    
                    
                    var objCoreTable: RecheckTable!
                    autoreleasepool {
                        objCoreTable = (NSEntityDescription.insertNewObjectForEntityForName("RecheckTable", inManagedObjectContext: self.appDel.managedObjectContext) as! RecheckTable)
                        objCoreTable.penid = self.toPass_dic["PenDetails"]![0]["penid"] as? String
                        objCoreTable.recheck = self.str_inspection
                        objCoreTable.offline = "YES"
                        objCoreTable.commentCondition = self.toPass_dic["PenDetails"]![0]["comment"] as? String
                        if self.str_comment == ""
                        {
                            objCoreTable.commentCondition = ""
                        }
                        else
                        {
                            objCoreTable.commentCondition = self.str_comment
                        }
                    }
                    do
                    {
                        try self.appDel.managedObjectContext.save()
                        NSOperationQueue.mainQueue().addOperationWithBlock({
                            //////////
                            self.recheckoffline()
                        })
                    } catch {
                    }
                    //            }
                    
                }
            }));
            self.presentViewController(alertView, animated: true, completion: nil)
    
        
    }
    
    
    
    func AddingToRecheck_save()
    {
        let GpCode: String = toPass_dic["PenDetails"]![0]["groupcode"] as! String
        let arraytemp = "\(toPass_dic["PenDetails"]![0]["pennodisp"] as! String)".componentsSeparatedByString("-")
        let xx: String = "\(arraytemp[0])"
        let yy: String! = "\(arraytemp[1])"
        let penid: String = toPass_dic["PenDetails"]![0]["penid"] as! String
        
        
        appDel.Show_HUD()
        str_webservice = "updatedata";
        let request = NSMutableURLRequest(URL: NSURL(string: "\(Server.local_server)/api/sp_update/updatedata.php?")!)
        let postString = "groupcode=\(GpCode)&namexx=\(xx)&nameyy=\(yy)&penid=\(penid)&inspectid=\(str_inspection)&conditionid=\(str_condition)&comment=\(str_comment)&app_id=\(NSUserDefaults.standardUserDefaults().objectForKey("ApplicationIdentifier") as! String)"
        objwebservice.callServiceCommon(request, postString: postString)
    }
    
    //MARK: - Comment Btn Action
    @IBAction func textComment_BtnAction(sender: AnyObject) {
    }
    
    // MARK: - PickerView Delegates
    func numberOfComponentsInPickerView(pickerView: UIPickerView!) -> Int{
        return 1
    }
    
    // returns the # of rows in each component..
    func pickerView(pickerView: UIPickerView!, numberOfRowsInComponent component: Int) -> Int{
        if pickerView == picker_condition {
            if dic_condition.count != 0 {
                return (dic_condition["Condition_data"]?.count)!
            }
        }
        else if pickerView == picker_recheck {
            if dic_inspect.count != 0 {
                return (dic_inspect["inspection_data"]?.count)!
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
            pickerLabel.font = UIFont(name: "HelveticaNeue", size: 35)
        }
        if pickerView == picker_condition {
            pickerLabel.text = dic_condition["Condition_data"]![row]["conditionname"] as? String
        }
        else if pickerView == picker_recheck {
            pickerLabel.text = dic_inspect["inspection_data"]![row]["inspect_period"] as? String
        }
        return pickerLabel
        
        
    }
    
    
    func pickerView(pickerView: UIPickerView!, didSelectRow row: Int, inComponent component: Int)
    {
        if pickerView == picker_condition {
            str_condition = dic_condition["Condition_data"]![row]["conditionid"] as! String
        }
        else if pickerView == picker_recheck {
            str_inspection = dic_inspect["inspection_data"]![row]["inspect_id"] as? String
        }
    }
    
    @IBAction func Back_btnAction(sender: AnyObject)
    {
        
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "toUpdateMove") {
            
            let objVC = segue.destinationViewController as! UpdateMoveSelect;
            objVC.toPassToAnother_dic = toPass_dic
            print(objVC.toPassToAnother_dic)
        }
    }
    
    //MARK: - Comment Btn_Action/ EditComment Delegate
    @IBAction func Comment_BtnAction(sender: AnyObject) {
        if !Bool_comment {
//            objComment.textView_comment.text = ""
            objCommentCondition.selecteditems.removeAllObjects()
            objCommentCondition.drawRect(CGRectMake(640, 160, 318, 231))
            
            if (str_comment != "<null>" || str_comment != nil)
            {
                
            }
            
            let arraytemp = "\(str_comment)".componentsSeparatedByString(", ")
            if arraytemp[0] == "" {
                objCommentCondition.selecteditems[objCommentCondition.array_List.count-1] = "YES"
            }
            else
            {
                if (arraytemp.count == 6)
                {
                    objCommentCondition.selecteditems[objCommentCondition.array_List.count-2] = "YES"
                }
                for k in 0 ..< objCommentCondition.array_List.count
                {
                    
                    for i in 0 ..< arraytemp.count
                    {
                        if arraytemp[i] as String == objCommentCondition.array_List[k] as! String {
                            let index1: Int = objCommentCondition.array_List.indexOfObject(arraytemp[i] as String)
                            objCommentCondition.selecteditems[index1] = "YES"
                        }
                    }
                }
            }
            
            
            objCommentCondition.showView(self.view, frame1: CGRectMake(670, 150, 318, 231))
            Bool_comment = true
        }
        else {
            objCommentCondition.removeView(self.view)
            Bool_comment = false
        }
    }
    
    
    //MARK: - Comment Btn_Action/ EditComment Delegate
    func cancelCommentMethod() {
        
        Bool_comment = false
        objCommentCondition.removeView(self.view)
    }
    
    
    func DoneCommentMethod(Comments: String!) {
        
        Bool_comment = false
        objCommentCondition.removeView(self.view)
        if Comments == nil {
            str_comment = ""
        }
        else
        {
            str_comment = Comments
        }
        print(str_comment)
    }
    
    
    //MARK: - NO USE Cancel and Done
    func cancelComment() {
        Bool_comment = false
        objComment.removeCommentView(self.view)
    }
    
    
    func DoneComment(textview: String!) {
        Bool_comment = false
        objComment.removeCommentView(self.view)
        str_comment = textview
        
    }
    
    
    //MARK: - offline
    func DeleteFromSingleAllocatedPen(strPenIds: String!, Offline: String!, killedFrom: String!)
    {
        let arraytemp = strPenIds.componentsSeparatedByString(",")
        print(arraytemp)
        let fetchRequest = NSFetchRequest(entityName: "SingleAllocatedPen")
        let predicate = NSPredicate(format: "penid = '\(strPenIds)'")
        fetchRequest.predicate = predicate
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.fetchBatchSize = 20
        do
        {
            let results = try self.appDel.managedObjectContext.executeFetchRequest(fetchRequest)
            if results.count > 0 {
//                self.InsertToKill(self.toPass_dic["PenDetails"]! as? NSMutableDictionary, Offline: "NO", killedFrom: "Inspection")
                
                self.InsertToKill(self.toPass_dic["PenDetails"]! as! NSMutableArray , Offline: "NO", killedFrom: "Inspection")
            }
            
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            do {
                try self.appDel.persistentStoreCoordinator.executeRequest(deleteRequest, withContext: self.appDel.managedObjectContext)
                do
                {
                    try self.appDel.managedObjectContext.save()
                    
                    
                }
                catch{}
            } catch{}
        } catch {
            
        }
    }
    
    
    func InsertToKill(arrayTemp: NSMutableArray!, Offline: String!, killedFrom: String!)
    {
        var objKillTable: KillTable!
        
        let fetchRequest = NSFetchRequest(entityName: "KillTable")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.fetchBatchSize = 20
        do
        {
            print(arrayTemp)
            
            let results = try self.appDel.managedObjectContext.executeFetchRequest(fetchRequest)
            objKillTable = (NSEntityDescription.insertNewObjectForEntityForName("KillTable", inManagedObjectContext: self.appDel.managedObjectContext) as! KillTable)
            objKillTable.id = results.count+1
            objKillTable.groupcode = "\(arrayTemp[0]["groupcode"] as! String)"
            objKillTable.groupcodedisp = "\(arrayTemp[0]["groupcodedisp"] as! String)"
            objKillTable.killdate = self.todaydate().stringByReplacingOccurrencesOfString(" ", withString: "") as String
            objKillTable.killid = "\(arrayTemp[0]["penid"] as! String)"
            objKillTable.pennodisp = "\(arrayTemp[0]["pennodisp"] as! String)"
            objKillTable.offline = Offline
            objKillTable.killedFrom = killedFrom
            objKillTable.recheck_count = "\(arrayTemp[0]["recheckcount"] as! String)"
            objKillTable.sp_size = "\(arrayTemp[0]["skin_size"] as! String)"
            objKillTable.inspect_date = "\(arrayTemp[0]["entrydate"] as! String)"
            objKillTable.entry_date = "\(arrayTemp[0]["dateadded"] as! String)"
            objKillTable.ispink = "\(arrayTemp[0]["ispink"] as! String)"
            objKillTable.comment = "\(arrayTemp[0]["comment"] as! String)"
            do {
                try self.appDel.managedObjectContext.save()
                let alertView = UIAlertController(title: nil, message: "Successfully Added To Kill List.", preferredStyle: .Alert)
                let OKAction = UIAlertAction(title: "OK", style: .Cancel) { (action: UIAlertAction) in
                    // pop here
                    self.navigationController?.popViewControllerAnimated(false)
                }
                alertView.addAction(OKAction)
                self.presentViewController(alertView, animated: true, completion: nil)
            } catch {}
        }catch {
            
        }
        
        
    }
    
    func recheckoffline()
    {
        let fetchRequest1 = NSFetchRequest(entityName: "SingleAllocatedPen")
        let predicate1 = NSPredicate(format: "penid = '\(self.toPass_dic["PenDetails"]![0]["penid"] as! String)'")
        fetchRequest1.predicate = predicate1
        fetchRequest1.returnsObjectsAsFaults = false
        fetchRequest1.fetchBatchSize = 20
        do {
            let results = try self.appDel.managedObjectContext.executeFetchRequest(fetchRequest1)
            if results.count > 0 {
                autoreleasepool{
                    for i in 0 ..< results.count {
                        if let objTable: SingleAllocatedPen = results[i] as? SingleAllocatedPen {
                           
                            //calculation
                            var intv : Int = ((objTable.recheckcount)?.toInteger())!
                            intv = intv+1
                            // to adding weeks in entry date
                            var Strdate : String! = self.todaydate().stringByReplacingOccurrencesOfString(" ", withString: "")
                            var daysCount: Int! = Int(str_inspection)
                            daysCount = daysCount*7
                            Strdate = self.week_daysBetweenDate(Strdate, recheck: daysCount) as String

                            dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC")
                            dateFormatter.dateFormat = "dd/MM/yyyy"
                            let s = dateFormatter.dateFromString("\(Strdate)")
                            
                            // now saving
                            objTable.comment = str_comment
                            if (objTable.comment == "")
                            {
                                objTable.ispink = "0"
                            }
                            else
                            {
                                objTable.ispink = "1"
                            }
                            objTable.recheckcount = String(intv)
                            objTable.int_recheckcount = intv
                            objTable.entrydate = (Strdate)!
                            objTable.entryConvert = s! as NSDate
                            objTable.recheckcount = objTable.recheckcount!
                            objTable.entrydate = objTable.entrydate!
                            objTable.entryConvert = objTable.entryConvert!
                            objTable.int_recheckcount = objTable.int_recheckcount!
                            print(objTable.int_recheckcount!)
                            do
                            {
                                try self.appDel.managedObjectContext.save()
                                appDel.remove_HUD()
                                
                                if !self.appDel.checkInternetConnection()
                                {
                                    let alertView = UIAlertController(title: nil, message: "Successfully Updated Values.", preferredStyle: .Alert)
                                    alertView.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: {(action:UIAlertAction) in
                                        self.navigationController?.popViewControllerAnimated(false)
                                    }));
                                    self.presentViewController(alertView, animated: true, completion: nil)
                                }
                                
                                
                            }
                            catch{}
                        }
                    }
                }
            }
            
        } catch {
            
        }
    }
    
    
    func todaydate() -> NSString
    {
        
        let twelveHourLocale: NSLocale = NSLocale(localeIdentifier: "en_US_POSIX")
        dateFormatter.locale = twelveHourLocale
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let todayDate: String = "  \(dateFormatter.stringFromDate(NSDate()))"
        return todayDate
    }
    
    func week_daysBetweenDate(currentstrDate: NSString!, recheck: Int!) -> NSString {
        let dateComponents: NSDateComponents = NSDateComponents()
        dateComponents.day = recheck
        let calendar: NSCalendar = NSCalendar.currentCalendar()
        
        var currentDate: NSDate! = NSDate()
        //        let dateForm: NSDateFormatter = NSDateFormatter()
        let twelveHourLocale: NSLocale = NSLocale(localeIdentifier: "en_US_POSIX")
        dateFormatter.locale = twelveHourLocale
        dateFormatter.dateFormat = "dd/MM/yyyy"
        currentDate = dateFormatter.dateFromString(currentstrDate as String)
        
        let newDate: NSDate = calendar.dateByAddingComponents(dateComponents, toDate: currentDate, options: NSCalendarOptions(rawValue: 0))!
        
        let SStr_date = "\(dateFormatter.stringFromDate(newDate))"
        return SStr_date
    }

}
