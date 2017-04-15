

//
//  InspectionListVC.swift
//  Crocodile
//
//  Created by Nibha Aggarwal on 6/1/16.
//  Copyright © 2016 Nibha Aggarwal. All rights reserved.
//

import UIKit
import CoreData

extension NSDate {
    func startOfMonth() -> NSDate? {
        guard
            let cal: NSCalendar = NSCalendar.currentCalendar(),
            let comp: NSDateComponents = cal.components([.Year, .Month], fromDate: self)
            
            else { return nil }
        comp.to12pm()
        return cal.dateFromComponents(comp)!
    }
    
    func endOfMonth() -> NSDate? {
        guard
            let cal: NSCalendar = NSCalendar.currentCalendar(),
            let comp: NSDateComponents = NSDateComponents() else { return nil }
        comp.month = 1
        comp.day = -1
        comp.timeZone = NSTimeZone(abbreviation: "UTC")
//        comp.to12pm()
        return cal.dateByAddingComponents(comp, toDate: self.startOfMonth()!, options: [])!
    }
}


internal extension NSDateComponents {
    func to12pm() {
        self.hour = 24
        self.minute = 0
        self.second = 0
    }
}

class InspectionListVC: UIViewController, responseProtocol , userlistProtocol {
    
    var toPassArray: NSMutableArray! = []
    var objwebservice : webservice! = webservice()
    var objuserList : UserListView! = UserListView()
    var appDel : AppDelegate!
    var str_webservice: String! = ""
    var str_Skin: String!
    var str_recheck: String!
    var str_tableFilter: String! = "array1"
    var int_tableAge: Int! = 1
    var str_tableFilterSelectOption: String!
    var str_tableFilterPenOption: String!
    var text_StartDate: String!
    var text_StopDate: String!
    var str_Message_NoData: String! = ""
    var str_FromReadyReport: String!
    var str_SkinReadyReport: String!
    var str_filterPressed:String = ""
    var str_AgePressed:String = ""
    var str_submitPressed: String = ""
    
    var array_List: NSMutableArray! = []
    var array_SkinSize: NSMutableArray! = []
    var array_recheck: NSMutableArray! = []
    var array_filter: NSMutableArray! = ["Group", "Date Range"]
    var array_Age: NSMutableArray! = []
    let arraytemp: NSMutableArray! = []
    let dateFormatter = NSDateFormatter()
    
    @IBOutlet weak var img_addedArrow: UIImageView! = UIImageView()
    @IBOutlet weak var img_dueArrow: UIImageView! = UIImageView()
    @IBOutlet weak var img_grpArrow: UIImageView! = UIImageView()
    @IBOutlet weak var img_RecheckArrow: UIImageView! = UIImageView()
    @IBOutlet weak var img_skinsizeArrow: UIImageView! = UIImageView()
    @IBOutlet weak var img_createAge: UIImageView! = UIImageView()
    @IBOutlet weak var img_createAgeArrow: UIImageView! = UIImageView()
    
    
    @IBOutlet weak var table_InpectionList: UITableView!
    @IBOutlet weak var table_filterList: UITableView!
    @IBOutlet weak var table_ageList: UITableView!
    @IBOutlet weak var pickerview_Skin: UIPickerView!
    @IBOutlet weak var pickerview_Recheck: UIPickerView!
    @IBOutlet weak var picker_StartDate: UIDatePicker!
    @IBOutlet weak var picker_StopDate: UIDatePicker!
    
    @IBOutlet weak var btn_filter: UIButton!
    @IBOutlet weak var btn_age: UIButton!
    
    
    var Bool_viewUsers: Bool = false
    var Bool_viewFilter: Bool = false
    var Bool_viewcalendar: Bool = false
    var Bool_viewCreateAge: Bool = false
    
    @IBOutlet weak var label_Size: UILabel!
    @IBOutlet weak var label_recheck: UILabel!
    @IBOutlet weak var label_date: UILabel!
    var pickerLabel: UILabel!
    
    @IBOutlet weak var view_Size: UIView! = UIView()
    @IBOutlet weak var view_recheck: UIView! = UIView()
    @IBOutlet weak var view_filter: UIView! = UIView()
    @IBOutlet weak var view_calendar: UIView! = UIView()
    @IBOutlet weak var view_createAge: UIView! = UIView()
    
    var index: Int = 0
    var selectedTagRecheck : Int = 0
    var selectedTagSize : Int = 0
    
    let dateForm: NSDateFormatter = NSDateFormatter()
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        objuserList = UserListView.instanceFromNib() as! UserListView
        objuserList?.delegate = self
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
        controller.label_header.text = "SP INSPECTION LIST"
        controller.IIndexPath = NSIndexPath(forRow: 0, inSection: 3)
        controller.array_temp_section.replaceObjectAtIndex(3, withObject: "Yes")
        controller.tableMenu.reloadData()
        array_SkinSize = controller.array_Skin
        objwebservice?.delegate = self
        
        
        appDel = (UIApplication.sharedApplication().delegate as! AppDelegate)
        
        self.str_Skin = array_SkinSize![0] as! String
        self.pickerview_Skin.reloadAllComponents()
        self.pickerview_Skin.selectRow(0, inComponent: 0, animated: true)
        
        
        array_recheck = ["1","2","3", "4", "5","6","7", "8", "9", "10", "11", "12"]
        self.str_recheck = array_recheck![0] as! String
        self.pickerview_Recheck.reloadAllComponents()
        self.pickerview_Recheck.selectRow(0, inComponent: 0, animated: true)
        int_tableAge = self.toPassArray[1].integerValue
        
        if (self.appDel.ForInspectionComes != "Back")
        {
            if (self.toPassArray[2] as! String == "autoInspection") {
                self.getAutoInspectionService()
            }
            else if (self.toPassArray[2] as! String == "create")
            {
                img_createAge.hidden = false
                img_createAgeArrow.hidden = false
                btn_age.hidden = false
                
                self.getCreateService()
            }
            else if (self.toPassArray[2] as! String == "FromReady")
            {
                // ready report comes
                self.appDel.Show_HUD()
                self.getReadyInspectionService()
                
            }
            else if (self.toPassArray[2] as! String == "AllSizesList")
            {
                self.getAllSizesListService()
            }
        }
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        text_StartDate = "\(self.todaydate())"
        text_StopDate = "\(self.daysBetweenDate(self.todaydate()))"
        label_date.text = "\(text_StartDate) - \(text_StopDate)"
        if self.appDel.ForInspectionComes == "Saved"
        {
            if (self.appDel.str_recheckPenId != "" && self.appDel.str_recheckCount != "") {
                
                var data = NSMutableDictionary()
                let newdata = array_List[appDel.int_recheckTag] as! NSDictionary
                data = newdata.mutableCopy() as! NSMutableDictionary
                
                
                data.setObject(self.appDel.str_conditioncomment, forKey: "comment")
                if self.appDel.str_conditioncomment == "" {
                    data.setObject("0", forKey: "ispink")
                }
                else
                {
                    data.setObject("1", forKey: "ispink")
                }
                var intv : Int = (array_List![appDel.int_recheckTag]["recheckcount"])!!.integerValue
                intv = intv+1
                data.setObject("\(intv)", forKey:"recheckcount")
                data.setObject(intv, forKey:"int_recheckcount")
                
                // to adding weeks in entry date
                var Strdate : String! = self.todaydate().stringByReplacingOccurrencesOfString(" ", withString: "")
                var daysCount: Int! = Int(self.appDel.str_recheckCount)
                daysCount = daysCount*7
                Strdate = self.week_daysBetweenDate(Strdate, recheck: daysCount) as String
                data.setObject("\(Strdate)", forKey:"entrydate")
                
                
                //        let dateFormatter = NSDateFormatter()
                dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC")
                dateFormatter.dateFormat = "dd/MM/yyyy"
                let s = dateFormatter.dateFromString("\(Strdate)")
                data.setObject(s! as NSDate, forKey:"entryConvert")
                
                
                let date1 = s! as NSDate
                let date2 = NSDate()
                if (date1.compare(date2) == NSComparisonResult.OrderedAscending) || (date1.compare(date2) == NSComparisonResult.OrderedSame) {
                    data.setObject("YELLOW", forKey:"colorcode")
                }
                else
                {
                    data.setObject("BLACK", forKey:"colorcode")
                }
                array_List[appDel.int_recheckTag] = data
                
                self.recheckoffline(appDel.int_recheckTag)
                
                print(array_List[appDel.int_recheckTag])
                table_InpectionList.reloadData()
            }
        }
            
        else if (self.appDel.ForInspectionComes == "Killed")
        {
            if (self.toPassArray[2] as! String == "autoInspection") {
                self.getAutoInspectionService()
            }
            else if (self.toPassArray[2] as! String == "create")
            {
                img_createAge.hidden = false
                img_createAgeArrow.hidden = false
                btn_age.hidden = false
                self.getCreateService()
            }
            else if (self.toPassArray[2] as! String == "FromReady")
            {
                // ready report comes
                self.appDel.Show_HUD()
                self.getReadyInspectionService()
                
            }
            else if (self.toPassArray[2] as! String == "AllSizesList")
            {
                self.getAllSizesListService()
            }
        }
        
    }
    
    
    
    func GetGroupNameDetailService()
    {
        self.appDel.str_InspectionData = ""
        
        appDel.Show_HUD()
        str_webservice = "allallocatedpens"
        let request = NSMutableURLRequest(URL: NSURL(string: "\(Server.local_server)/api/singlepen/allallocatedpens.php?")!)
        var postString = ""
        if NSUserDefaults.standardUserDefaults().objectForKey("AllData") != nil
        {
            if NSUserDefaults.standardUserDefaults().objectForKey("AllData") as! String == "AllDataSaved"
            {
                let fetchRequest = NSFetchRequest(entityName: "TimeStrampTable")
                fetchRequest.returnsObjectsAsFaults = false
                fetchRequest.fetchBatchSize = 20
                fetchRequest.resultType = NSFetchRequestResultType.DictionaryResultType
                var str: String!
                do {
                    let results = try self.appDel.managedObjectContext.executeFetchRequest(fetchRequest)
                    if (results.count > 0)
                    {
                        print(results)
                        for i in 0 ..< results.count {
                            
                            if let val = results[i]["allocatedPenTym"] {
                                if let x = val {
                                    print(x)
                                    str = "\(results[i]["allocatedPenTym"] as! String)"
                                    str = str.stringByReplacingOccurrencesOfString(" ", withString: "%20")
                                    postString = "last_update=\(str)&app_id=\(NSUserDefaults.standardUserDefaults().objectForKey("ApplicationIdentifier") as! String)"
                                } else {
                                    print("value is nil")
                                }
                            } else {
                                print("key is not present in dict")
                            }
                        }
                        
                        
                    }
                } catch{}
                
                
            }
            
        }
        objwebservice.callServiceCommon_inspection(request, postString: postString)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - Offline Mode
    func InsertToSingleAllocatedPen(dicTemp: NSMutableDictionary!)
    {
        if NSUserDefaults.standardUserDefaults().objectForKey("AllData") != nil
        {
            if NSUserDefaults.standardUserDefaults().objectForKey("AllData") as! String == "AllDataSaved"
            {
                appDel.Show_HUD()
                autoreleasepool{
                    for j in 0 ..< dicTemp["AllocatedPens"]!.count {
                        let fetchRequest = NSFetchRequest(entityName: "SingleAllocatedPen")
                        fetchRequest.returnsObjectsAsFaults = false
                        let predicate = NSPredicate(format: "penid = %@", dicTemp["AllocatedPens"]![j]["penid"] as! String)
                        fetchRequest.predicate = predicate
                        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                        do {
                            try self.appDel.persistentStoreCoordinator.executeRequest(deleteRequest, withContext: self.appDel.managedObjectContext)
                            do
                            {
                                try self.appDel.managedObjectContext.save()
                                print("inside")
                            }
                            catch{}
                        } catch{}
                        
                        
                        
                        let fetchRequest1 = NSFetchRequest(entityName: "EmptyPensTable")
                        fetchRequest1.returnsObjectsAsFaults = false
                        let predicate1 = NSPredicate(format: "penid = %@", dicTemp["AllocatedPens"]![j]["penid"] as! String)
                        fetchRequest1.predicate = predicate1
                        let deleteRequest1 = NSBatchDeleteRequest(fetchRequest: fetchRequest1)
                        
                        do {
                            try self.appDel.persistentStoreCoordinator.executeRequest(deleteRequest1, withContext: self.appDel.managedObjectContext)
                            do
                            {
                                try self.appDel.managedObjectContext.save()
                                print("inside")
                            }
                            catch{}
                        } catch{}
                            
                        
                    }
                }
                
                
                
                
                
                
                autoreleasepool {
                    var objCoreTable: SingleAllocatedPen!
                    let newArray = dicTemp["AllocatedPens"] as! NSArray
                    for i in 0 ..< newArray.count {
                        objCoreTable = (NSEntityDescription.insertNewObjectForEntityForName("SingleAllocatedPen", inManagedObjectContext: self.appDel.managedObjectContext) as! SingleAllocatedPen)
                        objCoreTable.groupcode = newArray[i]["group_code"] as? String
                        objCoreTable.namexx = newArray[i]["sp_namexx"] as? String
                        objCoreTable.nameyy = newArray[i]["sp_nameyy"] as? String
                        objCoreTable.colorcode = newArray[i]["colorcode"] as? String
                        objCoreTable.dateadded = newArray[i]["dateadded"] as? String
                        objCoreTable.entryConvert = self.Databse_dateconvertor(newArray[i]["entrydate"] as? String)
                        objCoreTable.addedConvert = self.Databse_dateconvertor(newArray[i]["dateadded"] as? String)
                        objCoreTable.entrydate = newArray[i]["entrydate"] as? String
                        objCoreTable.groupcodedisp = newArray[i]["groupcodedisp"] as? String
                        objCoreTable.penid = newArray[i]["penid"] as? String
                        objCoreTable.pennodisp = newArray[i]["pennodisp"] as? String
                        objCoreTable.skin_size = newArray[i]["skin_size"] as? String
                        objCoreTable.recheckcount = newArray[i]["recheckcount"] as? String
                        objCoreTable.int_recheckcount = objCoreTable.recheckcount?.toInteger()
                        objCoreTable.state = "NO"
                        objCoreTable.ispink = newArray[i]["ispink"] as? String
                        objCoreTable.comment = newArray[i]["comment"] as? String
                        do {
                            try self.appDel.managedObjectContext.save()
                            
                        } catch {
                        }
                    }
                }
                
                
                
                
                let fetchRequest1 = NSFetchRequest(entityName: "TimeStrampTable")
                fetchRequest1.returnsObjectsAsFaults = false
                do
                {
                    let results = try self.appDel.managedObjectContext.executeFetchRequest(fetchRequest1)
                    if results.count > 0 {
                        //                    for i in 0 ..< results.count {
                        if let objTable: TimeStrampTable = results[0] as? TimeStrampTable {
                            objTable.allocatedPenTym = dicTemp["last_update"] as? String
                            print(objTable.allocatedPenTym)
                            do
                            {
                                try self.appDel.managedObjectContext.save()
                                self.appDel.remove_HUD()
                            }
                            catch{}
                        }
                        //                    }
                        
                        
                    }
                }
                catch {}
                
            }
            self.appDel.str_InspectionData = "comeOn"
        }
        else
        {
            let fetchRequest = NSFetchRequest(entityName: "SingleAllocatedPen")
            fetchRequest.returnsObjectsAsFaults = false
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            do {
                try self.appDel.persistentStoreCoordinator.executeRequest(deleteRequest, withContext: self.appDel.managedObjectContext)
                do
                {
                    try self.appDel.managedObjectContext.save()
                    
                    
                }
                catch{}
            } catch{}
            
            
            
            autoreleasepool {
                var objCoreTable: SingleAllocatedPen!
                let newArray = dicTemp["AllocatedPens"] as! NSArray
                for i in 0 ..< newArray.count {
                    objCoreTable = (NSEntityDescription.insertNewObjectForEntityForName("SingleAllocatedPen", inManagedObjectContext: self.appDel.managedObjectContext) as! SingleAllocatedPen)
                    objCoreTable.groupcode = newArray[i]["group_code"] as? String
                    objCoreTable.namexx = newArray[i]["sp_namexx"] as? String
                    objCoreTable.nameyy = newArray[i]["sp_nameyy"] as? String
                    objCoreTable.colorcode = newArray[i]["colorcode"] as? String
                    objCoreTable.dateadded = newArray[i]["dateadded"] as? String
                    objCoreTable.entryConvert = self.Databse_dateconvertor(newArray[i]["entrydate"] as? String)
                    objCoreTable.addedConvert = self.Databse_dateconvertor(newArray[i]["dateadded"] as? String)
                    objCoreTable.entrydate = newArray[i]["entrydate"] as? String
                    objCoreTable.groupcodedisp = newArray[i]["groupcodedisp"] as? String
                    objCoreTable.penid = newArray[i]["penid"] as? String
                    objCoreTable.pennodisp = newArray[i]["pennodisp"] as? String
                    objCoreTable.skin_size = newArray[i]["skin_size"] as? String
                    objCoreTable.recheckcount = newArray[i]["recheckcount"] as? String
                    objCoreTable.int_recheckcount = objCoreTable.recheckcount?.toInteger()
                    objCoreTable.state = "NO"
                    objCoreTable.ispink = newArray[i]["ispink"] as? String
                    objCoreTable.comment = newArray[i]["comment"] as? String
                    do {
                        try self.appDel.managedObjectContext.save()
                        
                    } catch {
                    }
                }
            }
            
            var objTable: TimeStrampTable!
            objTable = (NSEntityDescription.insertNewObjectForEntityForName("TimeStrampTable", inManagedObjectContext: self.appDel.managedObjectContext) as! TimeStrampTable)
            
            print(dicTemp["last_update"] as! String)
            
            objTable.allocatedPenTym = dicTemp["last_update"] as? String
            objTable.allocatedPenTym = objTable.allocatedPenTym!
            print(objTable.allocatedPenTym)
            do {
                try self.appDel.managedObjectContext.save()
                self.appDel.remove_HUD()
            } catch {}
            
            
            self.appDel.str_InspectionData = "comeOn"
        }
        
        
    }
    
    func GetOfflineSingleAllocatedPen()
    {
        let fetchRequest = NSFetchRequest(entityName: "SingleAllocatedPen")
        let endDate : NSDate = NSDate().endOfMonth()!
        var predicate = NSPredicate(format: "entryConvert <= %@", endDate)
        
        //        let range = NSCalendar.currentCalendar().rangeOfUnit(.Day, inUnit: .Month, forDate: NSDate())
        //        let numDays = range.length
        //        print(numDays) // 31
        
        
        if (self.toPassArray[2] as! String == "create")
        {
            let dateComponents: NSDateComponents = NSDateComponents()
            dateComponents.month = -int_tableAge
            let newDate: NSDate = NSCalendar.currentCalendar().dateByAddingComponents(dateComponents, toDate: NSDate(), options: NSCalendarOptions(rawValue: 0))!
            
//            let newDate: NSDate = NSCalendar.currentCalendar().dateByAddingUnit(.Month, value: toPassArray[1].integerValue, toDate: NSDate(), options: [])!
            predicate = NSPredicate(format: "addedConvert <= %@", newDate)
            fetchRequest.predicate = predicate
        }
        else if (self.toPassArray[2] as! String == "AllSizesList")
        {
            predicate = NSPredicate(format: "skin_size == ''")
            fetchRequest.predicate = predicate
        }
        else if (self.toPassArray[2] as! String == "FromReady")
        {
            let alertView = UIAlertController(title: nil, message: Server.noInternet , preferredStyle: .Alert)
            alertView.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(alertView, animated: true, completion: nil)
        }
        else
        {
            fetchRequest.predicate = predicate
        }
        fetchRequest.fetchBatchSize = 20
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.resultType = NSFetchRequestResultType.DictionaryResultType
        do
        {
            self.appDel.Show_HUD()
            let results = try self.appDel.managedObjectContext.executeFetchRequest(fetchRequest)
            if results.count > 0 {
                str_Message_NoData = ""
                let newArray = results as NSArray
                self.array_List =  newArray.mutableCopy() as! NSMutableArray
                
//                print(self.array_List)
                
                //
                
                autoreleasepool{
                    for i in 0 ..< results.count {
//                        let data = NSMutableDictionary()
//                        let newdata = array_List[i] as! NSDictionary
                        let newdata = self.array_List[i].mutableCopy() as! NSMutableDictionary
                        let date1 = array_List[i]["entryConvert"] as! NSDate
                        let date2 = NSDate()
                        if (date1.compare(date2) == NSComparisonResult.OrderedAscending) || (date1.compare(date2) == NSComparisonResult.OrderedSame) {
                            newdata.setObject("YELLOW", forKey:"colorcode")
                        }
                        else
                        {
                            newdata.setObject("BLACK", forKey:"colorcode")
                        }
//                        data = newdata.mutableCopy() as! NSMutableDictionary
                        self.array_List[i] = newdata
                        print(newdata)
                        print(self.array_List[i])
                    }
                }

                
                self.table_InpectionList.reloadData()
                self.sortwithString("pennodisp", bool: true)
                self.appDel.remove_HUD()
                
            }
            else
            {
                self.appDel.remove_HUD()
                str_Message_NoData = "NoData"
                self.table_InpectionList.reloadData()
//                let alertView = UIAlertController(title: nil, message: "Try Again" , preferredStyle: .Alert)
//                alertView.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
//                self.presentViewController(alertView, animated: true, completion: nil)
                
            }
        } catch {
            
        }
    }
    
    
    //MARK: - Offline Methods
    func DeleteFromSingleAllocatedPen(strPenIds: String!, Offline: String!, killedFrom: String!)
    {
        let arraytemp = strPenIds.componentsSeparatedByString(",")
        print(arraytemp)
        let fetchRequest = NSFetchRequest(entityName: "SingleAllocatedPen")
        let fetchRequest1 = NSFetchRequest(entityName: "SingleAllocatedPen")
        autoreleasepool{
            for i in 0 ..< arraytemp.count {
                let predicate = NSPredicate(format: "penid = '\(arraytemp[i])'")
                fetchRequest.predicate = predicate
                fetchRequest.returnsObjectsAsFaults = false
                fetchRequest.fetchBatchSize = 20
                fetchRequest.resultType = NSFetchRequestResultType.DictionaryResultType
                
                
                fetchRequest1.predicate = predicate
                fetchRequest1.returnsObjectsAsFaults = false
                fetchRequest1.fetchBatchSize = 20
                do
                {
                    let results1 = try self.appDel.managedObjectContext.executeFetchRequest(fetchRequest1)
                    let results = try self.appDel.managedObjectContext.executeFetchRequest(fetchRequest)
                    if results.count > 0 {
                        print(">>>\(results[0])")
                        for i in 0 ..< results.count
                        {
                            self.InsertToKill(results[i] as! NSMutableDictionary, Offline: Offline, killedFrom: killedFrom)
                        }
                    }
                    
                    
                    let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest1)
                    do {
                        try self.appDel.persistentStoreCoordinator.executeRequest(deleteRequest, withContext: self.appDel.managedObjectContext)
                        do
                        {
                            try self.appDel.managedObjectContext.save()
                            
                            
                        }
                        catch{}
                    } catch{}
                    
                    if self.str_webservice == "movetokill_listmultiple"
                    {
                        if Offline == "YES" {
                            let alertView = UIAlertController(title: nil, message: "Succesfully Added.", preferredStyle: .Alert)
                            alertView.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
                            self.presentViewController(alertView, animated: true, completion: nil)
                            self.GetOfflineSingleAllocatedPen()
                            
                        }
                    }
                    
                    
                } catch {
                    
                }
            }
        }
    }
    
    func InsertToKill(arrayTemp: NSMutableDictionary!, Offline: String!, killedFrom: String!)
    {
        print(arrayTemp)
        var objKillTable: KillTable!
        
        let fetchRequest = NSFetchRequest(entityName: "KillTable")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.fetchBatchSize = 20
        do
        {
            let results = try self.appDel.managedObjectContext.executeFetchRequest(fetchRequest)
            objKillTable = (NSEntityDescription.insertNewObjectForEntityForName("KillTable", inManagedObjectContext: self.appDel.managedObjectContext) as! KillTable)
            objKillTable.id = results.count+1
            objKillTable.groupcode = "\(arrayTemp["groupcode"] as! String)"
            objKillTable.groupcodedisp = "\(arrayTemp["groupcodedisp"] as! String)"
            objKillTable.killdate = self.todaydate().stringByReplacingOccurrencesOfString(" ", withString: "") as String
            objKillTable.killid = "\(arrayTemp["penid"] as! String)"
            objKillTable.pennodisp = "\(arrayTemp["pennodisp"] as! String)"
            objKillTable.offline = Offline
            objKillTable.killedFrom = killedFrom
            objKillTable.recheck_count = "\(arrayTemp["recheckcount"] as! String)"
            objKillTable.sp_size = "\(arrayTemp["skin_size"] as! String)"
            objKillTable.inspect_date = "\(arrayTemp["entrydate"] as! String)"
            objKillTable.entry_date = "\(arrayTemp["dateadded"] as! String)"
            objKillTable.ispink = "\(arrayTemp["ispink"] as! String)"
            objKillTable.comment = "\(arrayTemp["comment"] as! String)"
            do {
                try self.appDel.managedObjectContext.save()
            } catch {}
        }catch {
            
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
    
    //MARK: - Webservice Delegate
    func responseDictionary(dic: NSMutableDictionary) {
        print(dic)
        
        self.str_submitPressed = ""
        if (self.str_webservice == "getautopenlist" || self.str_webservice == "getreadyreportbymonth" || self.str_webservice == "AllSizesList" || self.str_webservice == "getpenlist")
        {
            
            if dic["Message"] != nil {
                if (dic["Message"] as! String == "No Pens present for the criteria")
                {
                    str_Message_NoData = "NoData"
                    self.table_InpectionList.reloadData()
                    self.GetGroupNameDetailService()
                }
            }
            else
            {
                str_Message_NoData = ""
                let newArray = dic["AllPens"] as! NSArray
                self.array_List =  newArray.mutableCopy() as! NSMutableArray
                autoreleasepool{
                    for i in 0 ..< self.array_List.count {
                        let dict = self.array_List[i].mutableCopy() as! NSMutableDictionary
                        dict["state"] = "NO"
                        
                        let dateFormatter = NSDateFormatter()
                        dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC")
                        dateFormatter.dateFormat = "dd/MM/yyyy"
                        let s = dateFormatter.dateFromString(self.array_List[i]["entrydate"] as! String)
                        dict["entryConvert"] = s! as NSDate
                        
                        let y = dateFormatter.dateFromString(self.array_List[i]["dateadded"] as! String)
                        dict["addedConvert"] = y! as NSDate
                        
                        dict["int_recheckcount"] = (array_List![i]["recheckcount"])!!.integerValue
                        
                        self.array_List[i] = dict
                    }
                }
                if (self.array_List.count != 0)
                {
                    self.sortwithString("pennodisp", bool: true)
                    self.table_InpectionList.reloadData()
                    self.GetGroupNameDetailService()
                }
            }
        }
/*        else if (self.str_webservice == "getpenlist")
        {
            if dic["Message"] != nil {
                if (dic["Message"] as! String == "No Pens present for the criteria")
                {
                    str_Message_NoData = "NoData"
                    self.table_InpectionList.reloadData()
                }
            }
            else
            {
                let newArray = dic["AllPens"] as! NSArray
                self.array_List =  newArray.mutableCopy() as! NSMutableArray
                if (self.array_List.count != 0)
                {
                    autoreleasepool{
                        for i in 0 ..< self.array_List.count {
                            let dict = self.array_List[i].mutableCopy() as! NSMutableDictionary
                            dict["state"] = "NO"
                            
                            self.dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC")
                            self.dateFormatter.dateFormat = "dd/MM/yyyy"
                            let s = self.dateFormatter.dateFromString(self.array_List[i]["entrydate"] as! String)
                            dict["entryConvert"] = s! as NSDate
                            
                            let y = self.dateFormatter.dateFromString(self.array_List[i]["dateadded"] as! String)
                            dict["addedConvert"] = y! as NSDate
                            
                            dict["int_recheckcount"] = (array_List![i]["recheckcount"])!!.integerValue
                            
                            self.array_List[i] = dict
                        }
                    }
                    self.sortwithString("pennodisp", bool: true)
                    self.table_InpectionList.reloadData()
                    self.GetGroupNameDetailService()
                    
                }
            }
            
        }
*/
        else if (self.str_webservice == "report_sp_inspection")
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
        else if (self.str_webservice == "getblocklist")
        {
            
            self.array_filter.removeAllObjects()
            autoreleasepool{
                for i in 0 ..< dic["blocks"]!.count {
                    self.array_filter.addObject(dic["blocks"]![i]["block"] as! String)
                }
            }
            print( self.array_filter)
            self.str_tableFilter = "array3"
            self.table_filterList.reloadData()
            
        }
        else if (str_webservice == "getinspectionbyAge")
        {
            self.table_ageList.reloadData()
            self.array_List.removeAllObjects()
            
            if dic["Message"] != nil {
                if (dic["Message"] as! String == "No Pens present for the criteria")
                {
                    str_Message_NoData = "NoData"
                    self.table_InpectionList.reloadData()
                }
            }
            else
            {
                str_Message_NoData = ""
                let newArray = dic["AllPens"] as! NSArray
                self.array_List =  newArray.mutableCopy() as! NSMutableArray
                autoreleasepool{
                    for i in 0 ..< self.array_List.count {
                        let dict = self.array_List[i].mutableCopy() as! NSMutableDictionary
                        dict["state"] = "NO"
                        
                        dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC")
                        dateFormatter.dateFormat = "dd/MM/yyyy"
                        let s = dateFormatter.dateFromString(self.array_List[i]["entrydate"] as! String)
                        dict["entryConvert"] = s! as NSDate
                        
                        let y = dateFormatter.dateFromString(self.array_List[i]["dateadded"] as! String)
                        dict["addedConvert"] = y! as NSDate
                        
                        dict["int_recheckcount"] = (array_List![i]["recheckcount"])!!.integerValue
                        
                        self.array_List[i] = dict
                    }
                }
                
                if (self.array_List.count != 0)
                {
                    
                    self.table_InpectionList.reloadData()
                    self.table_InpectionList.setContentOffset(CGPointZero, animated:true)
                }
            }
            
            
            
        }
        else if (str_webservice == "getinspectionbyfilter")
        {
            self.array_filter.removeAllObjects()
            self.array_filter = ["Group", "Date Range"]
            self.str_tableFilter = "array1"
            self.table_filterList.reloadData()
            self.array_List.removeAllObjects()
            
            if dic["Message"] != nil {
                if (dic["Message"] as! String == "No Pens present for the criteria")
                {
                    str_Message_NoData = "NoData"
                    self.table_InpectionList.reloadData()
                }
            }
            else
            {
                str_Message_NoData = ""
                let newArray = dic["AllPens"] as! NSArray
                self.array_List =  newArray.mutableCopy() as! NSMutableArray
                autoreleasepool{
                    for i in 0 ..< self.array_List.count {
                        let dict = self.array_List[i].mutableCopy() as! NSMutableDictionary
                        dict["state"] = "NO"
                        
                        dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC")
                        dateFormatter.dateFormat = "dd/MM/yyyy"
                        let s = dateFormatter.dateFromString(self.array_List[i]["entrydate"] as! String)
                        dict["entryConvert"] = s! as NSDate
                        
                        let y = dateFormatter.dateFromString(self.array_List[i]["dateadded"] as! String)
                        dict["addedConvert"] = y! as NSDate
                        
                        dict["int_recheckcount"] = (array_List![i]["recheckcount"])!!.integerValue
                        
                        self.array_List[i] = dict
                    }
                }
                
                if (self.array_List.count != 0)
                {
                    
                    self.table_InpectionList.reloadData()
                    self.table_InpectionList.setContentOffset(CGPointZero, animated:true)
                }
            }
            
            
            
        }
        else if (self.str_webservice == "getinspectionbyfilterCalendar")
        {
            if dic["Message"] != nil {
                if (dic["Message"] as! String == "No Pens present for the criteria")
                {
                    str_Message_NoData = "NoData"
                    self.table_InpectionList.reloadData()
                }
            }
            else
            {
                str_Message_NoData = ""
                self.array_List.removeAllObjects()
                let newArray = dic["AllPens"] as! NSArray
                self.array_List =  newArray.mutableCopy() as! NSMutableArray
                autoreleasepool{
                    for i in 0 ..< self.array_List.count {
                        let dict = self.array_List[i].mutableCopy() as! NSMutableDictionary
                        dict["state"] = "NO"
                        
                        dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC")
                        dateFormatter.dateFormat = "dd/MM/yyyy"
                        let s = dateFormatter.dateFromString(self.array_List[i]["entrydate"] as! String)
                        dict["entryConvert"] = s! as NSDate
                        
                        let y = dateFormatter.dateFromString(self.array_List[i]["dateadded"] as! String)
                        dict["addedConvert"] = y! as NSDate
                        
                        
                        dict["int_recheckcount"] = (array_List![i]["recheckcount"])!!.integerValue
                        
                        self.array_List[i] = dict
                        
                    }
                }
                if (self.array_List.count != 0)
                {
                    
                    self.table_InpectionList.reloadData()
                    self.table_InpectionList.setContentOffset(CGPointZero, animated:true)
                }
            }
        }
            
        else if (str_webservice == "movetokill_listmultiple" || str_webservice == "movetoConfirmkillmultiple")
        {
            print("aa gya \(dic)")
            let alertView = UIAlertController(title: nil, message: "Succesfully Added.", preferredStyle: .Alert)
            alertView.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: {(action:UIAlertAction) in
                
                self.AfterSubmitToRefreshList()
            }));
            self.presentViewController(alertView, animated: true, completion: nil)
        }
            
        else if (self.str_webservice == "allallocatedpens")
        {
            
            self.InsertToSingleAllocatedPen(dic)
            
        }
        
        if (self.appDel.str_InspectionData == "" || self.str_submitPressed == "submit")
        {
            self.appDel.Show_HUD()
        }
        else
        {
            self.appDel.remove_HUD()
        }
    }
    
    
    
    func AfterSubmitToRefreshList()
    {
        if (self.str_filterPressed == "dateRange")
        {
            if self.appDel.checkInternetConnection() {
                appDel.Show_HUD()
                str_webservice = "getinspectionbyfilterCalendar"
                var start: String! = text_StartDate.stringByReplacingOccurrencesOfString(" ", withString: "")
                start = start.stringByReplacingOccurrencesOfString("/", withString: "-")
                var stop: String! = text_StopDate.stringByReplacingOccurrencesOfString(" ", withString: "")
                stop = stop.stringByReplacingOccurrencesOfString("/", withString: "-")
                
                var request = NSMutableURLRequest(URL: NSURL(string: "\(Server.local_server)/api/sp_inspection/getinspectionbyfilter.php?")!)
                var postString = "datefrom=\(start)&dateto=\(stop)&months="
                
                if (self.toPassArray[2] as! String == "create")
                {
                    img_createAge.hidden = false
                    img_createAgeArrow.hidden = false
                    btn_age.hidden = false
                    postString = "datefrom=\(start)&dateto=\(stop)&months=\(int_tableAge)"
                    
                }
                else if (self.toPassArray[2] as! String == "AllSizesList")
                {
                    request = NSMutableURLRequest(URL: NSURL(string: "\(Server.local_server)/api/sp_inspection/getnoskinbyfilter.php?")!)
                    postString = "group=&block=&datefrom=\(start)&dateto=\(stop)"
                    
                }
                objwebservice.callServiceCommon_inspection(request, postString: postString)
                view_calendar.hidden = true
                
            }
            else
            {
                view_calendar.hidden = true
                self.GetFilterDateOffline(picker_StartDate.date, stopDate: picker_StopDate.date)
            
            }
        }
        else if (self.str_filterPressed == "block")
        {
            if self.appDel.checkInternetConnection() {
                appDel.Show_HUD()
                
                str_webservice = "getinspectionbyfilter"
                var request = NSMutableURLRequest(URL: NSURL(string: "\(Server.local_server)/api/sp_inspection/getinspectionbyfilter.php?")!)
                var postString = "group=\(str_tableFilterSelectOption)&months="
                if (self.toPassArray[2] as! String == "create")
                {
                    postString = "group=\(str_tableFilterSelectOption)&months=\(int_tableAge)"
                }
                else if (self.toPassArray[2] as! String == "AllSizesList")
                {
                    request = NSMutableURLRequest(URL: NSURL(string: "\(Server.local_server)/api/sp_inspection/getnoskinbyfilter.php?")!)
                    postString = "group=\(str_tableFilterSelectOption)&datefrom=&dateto="
                }
                else if (self.toPassArray[2] as! String == "FromReady")
                {
                    request = NSMutableURLRequest(URL: NSURL(string: "\(Server.local_server)/api/sp_inspection/getinspectionbyreadyfilter.php?")!)
                    postString = "group=\(str_tableFilterSelectOption)&datefrom=&dateto=&monthyear=\(toPassArray[0] as! String)"
                    
                }
                objwebservice.callServiceCommon_inspection(request, postString: postString)
            }
                
            else
            {
                if (self.toPassArray[2] as! String == "autoInspection")
                {
                    self.GetFilterOfflineRecords(str_tableFilterSelectOption, pen: "", month: "")
                }
                else if (self.toPassArray[2] as! String == "create")
                {
                    img_createAge.hidden = false
                    img_createAgeArrow.hidden = false
                    btn_age.hidden = false
                    self.GetFilterOfflineRecords(str_tableFilterSelectOption, pen: "", month: "\(int_tableAge)")
                }
                else if (self.toPassArray[2] as! String == "AllSizesList")
                {
                    self.GetFilterOfflineRecords(str_tableFilterSelectOption, pen: "", month: "")
                }
                else if (self.toPassArray[2] as! String == "FromReady")
                {
                    let alertView = UIAlertController(title: nil, message: Server.noInternet, preferredStyle: .Alert)
                    alertView.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
                    self.presentViewController(alertView, animated: true, completion: nil)
                }
            }
            
            
        }
        else
        {
            if (self.toPassArray[2] as! String == "autoInspection") {
                self.getAutoInspectionService()
            }
            else if (self.toPassArray[2] as! String == "create")
            {
                img_createAge.hidden = false
                img_createAgeArrow.hidden = false
                btn_age.hidden = false
                self.getCreateService()
            }
            else if (self.toPassArray[2] as! String == "AllSizesList")
            {
                self.getAllSizesListService()
            }
            else if (self.toPassArray[2] as! String == "FromReady")
            {
                // ready report comes
                self.appDel.Show_HUD()
                self.getReadyInspectionService()
                
            }
        }
        
//        }
    }
    
    
    //MARK: - ReadyReport
    func getReadyInspectionService()
    {
        
        if self.appDel.checkInternetConnection() {
            appDel.Show_HUD()
            self.str_submitPressed = ""
            str_webservice = "getreadyreportbymonth"
            let request = NSMutableURLRequest(URL: NSURL(string: "\(Server.local_server)/api/sp_ready/getreadyreportbymonth.php?")!)
            let postString = "monthyear=\(toPassArray[0] as! String)&skinsize=\(toPassArray[1] as! String)&graphindex=\(toPassArray[3] as! String)"
            objwebservice.callServiceCommon_inspection(request, postString: postString)
        }
        else
        {
            let alertView = UIAlertController(title: nil, message: Server.noInternet, preferredStyle: .Alert)
            alertView.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
            self.presentViewController(alertView, animated: true, completion: nil)
        }
    }
    
    //MARK: - AutoInspection
    func getAutoInspectionService()
    {
        
        if self.appDel.checkInternetConnection() {
            appDel.Show_HUD()
            str_webservice = "getautopenlist"
            let request = NSMutableURLRequest(URL: NSURL(string: "\(Server.local_server)/api/sp_inspection/getautopenlist.php")!)
            let postString = ""
            objwebservice.callServiceCommon_inspection(request, postString: postString)
        }
        else
        {
            GetOfflineSingleAllocatedPen()
        }
    }
    
    //MARK: - getAllSizesListService
    func getAllSizesListService()
    {
        if self.appDel.checkInternetConnection(){
            appDel.Show_HUD()
            
            str_webservice = "AllSizesList"
            let request = NSMutableURLRequest(URL: NSURL(string: "\(Server.local_server)/api/sp_inspection/getnoskinpenlist.php")!)
            let postString = ""
            objwebservice.callServiceCommon_inspection(request, postString: postString)
        }
        else
        {
            GetOfflineSingleAllocatedPen()
        }
    }
    
    //MARK: - CreateService
    func getCreateService()
    {
        if self.appDel.checkInternetConnection(){
            appDel.Show_HUD()
        
            str_webservice = "getpenlist"
            let request = NSMutableURLRequest(URL: NSURL(string: "\(Server.local_server)/api/sp_inspection/getpenlist.php?")!)
            let postString = "month=\(int_tableAge)"
            objwebservice.callServiceCommon_inspection(request, postString: postString)
        }
        else
        {
            GetOfflineSingleAllocatedPen()
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
        else if tableView == table_ageList {
            return array_Age.count
        }
        else
        {
            if str_Message_NoData == "NoData" {
                return 1
            }
            
            return array_List.count
        }
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        /*
         let identifier = "CustomTableViewCell"
         var cus_cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as! CustomTableViewCell
         //        if cus_cell = nil {
         //            tableView.registerNib(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: identifier)
         //            cus_cell = (tableView.dequeueReusableCellWithIdentifier(identifier) as? CustomTableViewCell)!
         //        }
         if indexPath.row % 2 == 0 {
         cus_cell.customImageView.backgroundColor = UIColor.whiteColor()
         }
         else {
         cus_cell.customImageView.backgroundColor = UIColor(red: 241.0 / 255.0, green: 241 / 255.0, blue: 241 / 255.0, alpha: 1.0)
         }
         
         cus_cell.customlabel_left.text = array_List[indexPath.row]["entrydate"] as? String
         cus_cell.customlbl_middle.text = array_List[indexPath.row]["groupcodedisp"] as? String
         cus_cell.customlbl_upperImge.text = array_List[indexPath.row]["pennodisp"] as? String
         return cus_cell
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
        
        
        if tableView == table_filterList {
            cell.textLabel?.text = array_filter[indexPath.row] as? String
            cell.textLabel!.font = UIFont(descriptor: UIFontDescriptor(name: "HelveticaNeue", size: 19), size: 19.0)
            
            if str_tableFilter == "array1" {
                if indexPath.row == 1 {
                    let btn_edit: UIButton = UIButton(frame: CGRectMake(0, 2, 130, 40))
                    btn_edit.addTarget(self, action: #selector(InspectionListVC.Calendar_BtnAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                    btn_edit.backgroundColor = UIColor.clearColor()
                    btn_edit.setTitleColor(UIColor.blackColor(), forState: .Normal)
                    btn_edit.titleLabel!.font = UIFont(descriptor: UIFontDescriptor(name: "HelveticaNeue", size: 20), size: 20.0)
                    btn_edit.titleLabel?.text = "Date Range"
                    btn_edit.tag = indexPath.row
                    
                    cell.contentView .addSubview(btn_edit)
                }
            }
        }
        else if tableView == table_ageList
        {
            cell.textLabel?.text = array_Age[indexPath.row] as? String
            cell.textLabel!.font = UIFont(descriptor: UIFontDescriptor(name: "HelveticaNeue", size: 19), size: 19.0)
        }
        else if (tableView == table_InpectionList)
        {
            
            if (str_Message_NoData == "NoData")
            {
                let label_groupName : UILabel = UILabel(frame: CGRectMake(50, 13, 400, 50))
                label_groupName.text = "You have no record listed"
                label_groupName.font = UIFont(descriptor: UIFontDescriptor(name: "HelveticaNeue", size: 25), size: 25.0)
                view_bg.addSubview(label_groupName)
                cell.contentView .addSubview(view_bg)
                return cell
            }
            else
            {
                if array_List[indexPath.row]["colorcode"] as? String == "YELLOW" {
                    view_bg.backgroundColor = UIColor.yellowColor()
                }
                else if array_List[indexPath.row]["colorcode"] as? String == "RED" {
                    view_bg.backgroundColor = UIColor.redColor()
                }
                
                //label_DateAdded
                let label_DateAdded: UILabel = UILabel(frame: CGRectMake(2, 13, 120, 50))
                label_DateAdded.textAlignment = .Center
                label_DateAdded.font = UIFont(descriptor: UIFontDescriptor(name: "HelveticaNeue", size: 24), size: 24.0)
                
                let DateAdded = array_List[indexPath.row]["dateadded"] as? String
                var range = DateAdded!.startIndex.advancedBy(0) ..< DateAdded!.startIndex.advancedBy(6)
                var strdd = DateAdded!.substringWithRange(range)
                
                range = DateAdded!.startIndex.advancedBy(8) ..< DateAdded!.startIndex.advancedBy(10)
                strdd = "\(strdd)\(DateAdded!.substringWithRange(range))"
                
                label_DateAdded.text = strdd
                
                //label_dueDate
                let label_dueDate: UILabel = UILabel(frame: CGRectMake(124, 13, 120, 50))
                label_dueDate.textAlignment = .Center
                label_dueDate.font = UIFont(descriptor: UIFontDescriptor(name: "HelveticaNeue", size: 24), size: 24.0)
                
                let DateDue = array_List[indexPath.row]["entrydate"] as? String
                range = DateDue!.startIndex.advancedBy(0) ..< DateDue!.startIndex.advancedBy(6)
                strdd = DateDue!.substringWithRange(range)
                
                range = DateDue!.startIndex.advancedBy(8) ..< DateDue!.startIndex.advancedBy(10)
                strdd = "\(strdd)\(DateDue!.substringWithRange(range))"
                
                label_dueDate.text = strdd
                
                
                //orange image
                let img_orange: UIImageView = UIImageView(frame: CGRectMake(240, 10, 140, 52))
                img_orange.image = UIImage(named: "xxyy")
                
                //label_Groups
                let label_Groups: UILabel = UILabel(frame: CGRectMake(241, 8, 139, 56))
                label_Groups.textAlignment = .Center
                label_Groups.font = UIFont(descriptor: UIFontDescriptor(name: "HelveticaNeue", size: 22), size: 22.0)
                label_Groups.textColor = UIColor.whiteColor()
                label_Groups.numberOfLines = 2
                label_Groups.text = "\(array_List[indexPath.row]["groupcode"] as! String)/\(array_List[indexPath.row]["pennodisp"] as! String)" as String
                
                
                //Edit_Button
                let btn_edit: UIButton = UIButton(frame: CGRectMake(245, 10, 130, 52))
                btn_edit.addTarget(self, action: #selector(InspectionListVC.EditBtnAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                btn_edit.tag = indexPath.row
                
                
                //CheckMark image
                let btn_check: UIButton = UIButton(frame: CGRectMake(400, 18, 40, 35))
                if (array_List[indexPath.row]["state"] as! String == "NO") {
                    btn_check.setImage(UIImage(named: "Checkbox_NoTick"), forState: .Normal)
                }
                else {
                    btn_check.setImage(UIImage(named: "Checkbox_tick"), forState: .Normal)
                }
                btn_check.addTarget(self, action: #selector(InspectionListVC.radioBtnAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                btn_check.tag = indexPath.row
                
                //PINK CheckMark image
                let btn_Pinkcheck: UIButton = UIButton(frame: CGRectMake(540, 18, 40, 35))
                btn_Pinkcheck.setTitleColor(UIColor.blackColor(), forState: .Normal)
                btn_Pinkcheck.titleLabel?.font = UIFont(descriptor: UIFontDescriptor(name: "HelveticaNeue", size: 22), size: 22.0)
                if (array_List[indexPath.row]["ispink"] as! String == "0") {
//                    btn_Pinkcheck.setImage(UIImage(named: "Checkbox_PinkNoTick"), forState: .Normal)
                    btn_Pinkcheck.setTitle("N", forState: .Normal)
                }
                else {
                    btn_Pinkcheck.setTitle("Y", forState: .Normal)
//                    btn_Pinkcheck.setImage(UIImage(named: "Checkbox_PInk_tick"), forState: .Normal)
                }
//                btn_Pinkcheck.addTarget(self, action: #selector(InspectionListVC.Pink_radioBtnAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
//                btn_Pinkcheck.tag = indexPath.row
                
                
                
                
                
                //btn_Recheck
                let btn_Recheck: UIButton = UIButton(frame: CGRectMake(450, 10, 70, 50))
                btn_Recheck.addTarget(self, action: #selector(InspectionListVC.ReheckBtnAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                btn_Recheck.setTitleColor(UIColor.blackColor(), forState: .Normal)
                btn_Recheck.setTitle(array_List[indexPath.row]["recheckcount"] as? String, forState: .Normal)
                btn_Recheck.titleLabel!.font = UIFont(descriptor: UIFontDescriptor(name: "HelveticaNeue", size: 21), size: 21.0)
                btn_Recheck.tag = indexPath.row
                
                
                //img_down
                let img_down: UIImageView = UIImageView(frame: CGRectMake(500, 32, 10, 6))
                img_down.image = UIImage(named: "downarrow")
                
                
                //btn_Size
                let btn_Size: UIButton = UIButton(frame: CGRectMake(550+40, 10, 150-40, 52))
                btn_Size.addTarget(self, action: #selector(InspectionListVC.SizeBtnAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                btn_Size.setTitleColor(UIColor.blackColor(), forState: .Normal)
                btn_Size.titleLabel!.font = UIFont(descriptor: UIFontDescriptor(name: "HelveticaNeue", size: 21), size: 21.0)
                btn_Size.setTitle(array_List[indexPath.row]["skin_size"] as? String, forState: .Normal)
                if array_List[indexPath.row]["skin_size"] as? String == "" || array_List[indexPath.row]["skin_size"] as? String == "Select Size" {
                    btn_Size.setTitle("!", forState: .Normal)
                    btn_Size.setTitleColor(UIColor.redColor(), forState: .Normal)
                }
                btn_Size.tag = indexPath.row
                
                
                //img_down
                let img_down1: UIImageView = UIImageView(frame: CGRectMake(678, 32, 10, 6))
                img_down1.image = UIImage(named: "downarrow")
                
                view_bg.addSubview(label_dueDate)
                view_bg.addSubview(label_DateAdded)
                view_bg.addSubview(img_orange)
                view_bg.addSubview(label_Groups)
                view_bg.addSubview(btn_check)
                view_bg.addSubview(btn_edit)
                view_bg.addSubview(btn_Size)
                view_bg.addSubview(img_down)
                view_bg.addSubview(btn_Recheck)
                view_bg.addSubview(img_down1)
                view_bg.addSubview(btn_Pinkcheck)
                
                cell.contentView .addSubview(view_bg)
            }

            }
            
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        index = indexPath.row
        //        self.performSegueWithIdentifier("toInspectionGpKill", sender: self)
        if tableView == table_ageList {
            int_tableAge = Int(array_Age[indexPath.row] as! String)
            self.cancelAge()
            
            if self.appDel.checkInternetConnection() {
                appDel.Show_HUD()
                str_webservice = "getinspectionbyAge"
                var request = NSMutableURLRequest(URL: NSURL(string: "\(Server.local_server)/api/sp_inspection/getinspectionbyfilter.php?")!)
                
                var postString = "group=\(str_tableFilterSelectOption)&months=\(int_tableAge)"
                if str_tableFilterSelectOption == nil{
                    request = NSMutableURLRequest(URL: NSURL(string: "\(Server.local_server)/api/sp_inspection/getpenlist.php?")!)
                    postString = "month=\(int_tableAge)"
                }
                
                objwebservice.callServiceCommon_inspection(request, postString: postString)
            }
            else
            {
                if str_tableFilterSelectOption == nil{
                    self.GetOfflineSingleAllocatedPen()
                }
                else
                {
                    self.GetFilterOfflineRecords(str_tableFilterSelectOption, pen: "", month: "\(int_tableAge)")
                    
                }
            }
            
        }
        else if tableView == table_filterList{
            if (str_tableFilter == "array1")
            {
                if (indexPath.row == 0)
                {
                    array_filter.removeAllObjects()
                    array_filter = ["IFP", "IFTP", "OFP", "RTF"]
                    print(array_filter)
                    str_tableFilter = "array3"
                    table_filterList .reloadData()
                    
                }
                
            }
                /*
            else if (str_tableFilter == "array2")
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
                    self.GetFilterPenOffline(array_filter[indexPath.row] as! String)
                }
                
            }
             */
            else if (str_tableFilter == "array3")
            {
                str_tableFilterSelectOption = array_filter[indexPath.row] as! String
                self.cancelFilter()
                if self.appDel.checkInternetConnection() {
                    appDel.Show_HUD()
                
                    str_webservice = "getinspectionbyfilter"
                    var request = NSMutableURLRequest(URL: NSURL(string: "\(Server.local_server)/api/sp_inspection/getinspectionbyfilter.php?")!)
                    var postString = "group=\(str_tableFilterSelectOption)&months="
                    if (self.toPassArray[2] as! String == "create")
                    {
                        postString = "group=\(str_tableFilterSelectOption)&months=\(int_tableAge)"
                    }
                    else if (self.toPassArray[2] as! String == "AllSizesList")
                    {
                        request = NSMutableURLRequest(URL: NSURL(string: "\(Server.local_server)/api/sp_inspection/getnoskinbyfilter.php?")!)
                        postString = "group=\(str_tableFilterSelectOption)&datefrom=&dateto="
                    }
                    else if (self.toPassArray[2] as! String == "FromReady")
                    {
                        request = NSMutableURLRequest(URL: NSURL(string: "\(Server.local_server)/api/sp_inspection/getinspectionbyreadyfilter.php?")!)
                        postString = "group=\(str_tableFilterSelectOption)&datefrom=&dateto=&monthyear=\(toPassArray[0] as! String)"
                        
                    }
                    objwebservice.callServiceCommon_inspection(request, postString: postString)
                }
                
                else
                {
                    if (self.toPassArray[2] as! String == "autoInspection")
                    {
                        self.GetFilterOfflineRecords(str_tableFilterSelectOption, pen: "", month: "")
                    }
                    else if (self.toPassArray[2] as! String == "create")
                    {
                        self.GetFilterOfflineRecords(str_tableFilterSelectOption, pen: "", month: "\(int_tableAge)")
                    }
                    else if (self.toPassArray[2] as! String == "AllSizesList")
                    {
                        self.GetFilterOfflineRecords(str_tableFilterSelectOption, pen: "", month: "")
                    }
                    else if (self.toPassArray[2] as! String == "FromReady")
                    {
                        let alertView = UIAlertController(title: nil, message: Server.noInternet, preferredStyle: .Alert)
                        alertView.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
                        self.presentViewController(alertView, animated: true, completion: nil)
                    }
                }
                
                
                str_tableFilterPenOption = array_filter[indexPath.row] as! String
                str_filterPressed = "block"
            }
        }
    }
    
    
    
    // MARK: - PickerView Delegates
    func numberOfComponentsInPickerView(pickerView: UIPickerView!) -> Int{
        return 1
    }
    
    // returns the # of rows in each component..
    func pickerView(pickerView: UIPickerView!, numberOfRowsInComponent component: Int) -> Int{
        if pickerView == pickerview_Skin {
            if array_SkinSize.count != 0 {
                return (array_SkinSize?.count)!
            }
            
        }
        else if pickerView == pickerview_Recheck {
            if array_recheck.count != 0 {
                return (array_recheck?.count)!
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
            pickerLabel.font = UIFont(descriptor: UIFontDescriptor(name: "HelveticaNeue", size: 35), size: 35.0)
        }
        if pickerView == pickerview_Skin {
            
            pickerLabel.text = (array_SkinSize[row] as! String)
        }
        else if pickerView == pickerview_Recheck {
            
            pickerLabel.text = (array_recheck[row] as! String)
        }
        return pickerLabel
    }
    
    
    
    func pickerView(pickerView: UIPickerView!, didSelectRow row: Int, inComponent component: Int)
    {
        if pickerView == pickerview_Skin {
            
            str_Skin = array_SkinSize![row] as! String
        }
        else if pickerView == pickerview_Recheck {
            
            str_recheck = array_recheck![row] as! String
        }
        
    }
    
    
    //MARK: - FilterOffline
    
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
        let fetchRequest = NSFetchRequest(entityName: "SingleAllocatedPen")
        let endDate : NSDate = NSDate().endOfMonth()!
        //var predicate = NSPredicate(format: "groupcode = %@ AND pennodisp beginswith[c] %@ AND entryConvert <= %@", str_tableFilterSelectOption, pen, endDate)
        var predicate = NSPredicate(format: "groupcode = %@ AND entryConvert <= %@", str_tableFilterSelectOption, endDate)
        
        if (self.toPassArray[2] as! String == "create")
        {
            
            let dateComponents: NSDateComponents = NSDateComponents()
            dateComponents.month = -int_tableAge
            let newDate: NSDate = NSCalendar.currentCalendar().dateByAddingComponents(dateComponents, toDate: NSDate(), options: NSCalendarOptions(rawValue: 0))!
            
//            let newDate: NSDate = NSCalendar.currentCalendar().dateByAddingUnit(.Month, value: toPassArray[1].integerValue, toDate: NSDate(), options: [])!
//            predicate = NSPredicate(format: "groupcode = %@ AND pennodisp beginswith[c] %@ AND addedConvert <= %@", str_tableFilterSelectOption, pen, newDate)
            predicate = NSPredicate(format: "groupcode = %@ AND addedConvert <= %@", str_tableFilterSelectOption, newDate)
            if str_tableFilterSelectOption == nil{
                predicate = NSPredicate(format: "addedConvert <= %@", newDate)
            }
            
            fetchRequest.predicate = predicate
        }
        else if (self.toPassArray[2] as! String == "AllSizesList")
        {
//            predicate = NSPredicate(format: "groupcode = %@ AND pennodisp beginswith[c] %@ AND skin_size == ''", str_tableFilterSelectOption, pen)
            predicate = NSPredicate(format: "groupcode = %@ AND skin_size == ''", str_tableFilterSelectOption)
            fetchRequest.predicate = predicate
        }
        else if (self.toPassArray[2] as! String == "FromReady")
        {
            let alertView = UIAlertController(title: nil, message: Server.noInternet, preferredStyle: .Alert)
            alertView.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
            self.presentViewController(alertView, animated: true, completion: nil)
        }

        else
        {
            fetchRequest.predicate = predicate
        }
        fetchRequest.fetchBatchSize = 20
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.resultType = NSFetchRequestResultType.DictionaryResultType
        do
        {
            self.appDel.Show_HUD()
            let results = try self.appDel.managedObjectContext.executeFetchRequest(fetchRequest)
            if results.count > 0 {
                str_Message_NoData = ""
                let newArray = results as NSArray
                self.array_List =  newArray.mutableCopy() as! NSMutableArray
                autoreleasepool{
                    for i in 0 ..< results.count {
                        let newdata = array_List[i].mutableCopy() as! NSMutableDictionary
                        
                        let date1 = array_List[i]["entryConvert"] as! NSDate
                        let date2 = NSDate()
                        if (date1.compare(date2) == NSComparisonResult.OrderedAscending) || (date1.compare(date2) == NSComparisonResult.OrderedSame) {
                            newdata.setObject("YELLOW", forKey:"colorcode")
                        }
                        else
                        {
                            newdata.setObject("BLACK", forKey:"colorcode")
                        }
                        self.array_List[i] = newdata
                    }
                }
                
                self.table_InpectionList.reloadData()
                self.sortwithString("pennodisp", bool: true)
                self.appDel.remove_HUD()
                
            }
            else
            {
                str_Message_NoData = "NoData"
                self.table_InpectionList.reloadData()
                self.appDel.remove_HUD()
            }
        }
        catch{}
        
        
    }
    
    
    func GetFilterDateOffline(startDate: NSDate, stopDate: NSDate)
    {
        let fetchRequest = NSFetchRequest(entityName: "SingleAllocatedPen")
        //        let endDate : NSDate = NSDate().endOfMonth()!
        var predicate = NSPredicate(format: "entryConvert >= %@ AND entryConvert <= %@", picker_StartDate.date, picker_StopDate.date)
        
        if (self.toPassArray[2] as! String == "AllSizesList")
        {
            predicate = NSPredicate(format: "entryConvert >= %@ AND entryConvert <= %@ AND skin_size == ''", picker_StartDate.date, picker_StopDate.date)
            fetchRequest.predicate = predicate
        }
        else if (self.toPassArray[2] as! String == "FromReady")
        {
            let alertView = UIAlertController(title: nil, message: Server.noInternet, preferredStyle: .Alert)
            alertView.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
            self.presentViewController(alertView, animated: true, completion: nil)
        }
        else
        {
            fetchRequest.predicate = predicate
        }
        fetchRequest.fetchBatchSize = 20
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.resultType = NSFetchRequestResultType.DictionaryResultType
        do
        {
            self.appDel.Show_HUD()
            let results = try self.appDel.managedObjectContext.executeFetchRequest(fetchRequest)
            if results.count > 0 {
                str_Message_NoData = ""
                let newArray = results as NSArray
                self.array_List =  newArray.mutableCopy() as! NSMutableArray
                autoreleasepool{
                    for i in 0 ..< results.count {
                        let newdata = array_List[i].mutableCopy() as! NSMutableDictionary
                        
                        let date1 = array_List[i]["entryConvert"] as! NSDate
                        let date2 = NSDate()
                        if (date1.compare(date2) == NSComparisonResult.OrderedAscending) || (date1.compare(date2) == NSComparisonResult.OrderedSame) {
                            newdata.setObject("YELLOW", forKey:"colorcode")
                        }
                        else
                        {
                            newdata.setObject("BLACK", forKey:"colorcode")
                        }
                        self.array_List[i] = newdata
                    }
                }
                
                self.table_InpectionList.reloadData()
                self.sortwithString("pennodisp", bool: true)
                self.appDel.remove_HUD()
                
            }
            else
            {
                str_Message_NoData = "NoData"
                self.table_InpectionList.reloadData()
                self.appDel.remove_HUD()
            }
        }
        catch{}
        
        
    }
    
    //MARK: - Pink_radioBtnAction
    @IBAction func Pink_radioBtnAction(sender: UIButton) {
        
        let btn: UIButton = sender
        let selectedTag : Int = btn.tag
        
        var data = NSMutableDictionary()
        let newdata = array_List[selectedTag] as! NSDictionary
        data = newdata.mutableCopy() as! NSMutableDictionary
        let img : UIImage = UIImage(named: "Checkbox_PinkNoTick")!
        
        if img == btn.currentImage {
            btn.setImage(UIImage(named: "Checkbox_PInk_tick"), forState: .Normal)
            
            //            var data = NSMutableDictionary()
            //            let newdata = array_List[selectedTag] as! NSDictionary
            //            data = newdata.mutableCopy() as! NSMutableDictionary
            data.setObject("1", forKey:"ispink") // YES
            array_List[selectedTag] = data
            table_InpectionList.reloadData()
            
            if self.appDel.checkInternetConnection() {
                str_webservice = "updatepinkvalue"
                let request = NSMutableURLRequest(URL: NSURL(string: "\(Server.local_server)/api/sp_update/updatepinkvalue.php?")!)
                let postString = "penid=\(array_List[selectedTag]["penid"] as! String)&markvalue=\(array_List[selectedTag]["ispink"] as! String)&app_id=\(NSUserDefaults.standardUserDefaults().objectForKey("ApplicationIdentifier") as! String)"
                objwebservice.callServiceCommon_inspection(request, postString: postString)
                
                PinkOffline(selectedTag)
            }
            else
            {
                let fetchRequest = NSFetchRequest(entityName: "PinkMarkTable")
                let predicate = NSPredicate(format: "penid = '\(self.array_List[selectedTag]["penid"] as! String)'")
                fetchRequest.predicate = predicate
                fetchRequest.returnsObjectsAsFaults = false
                fetchRequest.fetchBatchSize = 20
                do {
                    let results = try self.appDel.managedObjectContext.executeFetchRequest(fetchRequest)
                    if results.count > 0 {
                        
                        if let objTable: PinkMarkTable = results[0] as? PinkMarkTable {
                            objTable.ispink = array_List[selectedTag]["ispink"] as? String
                            do {
                                try self.appDel.managedObjectContext.save()
                                NSOperationQueue.mainQueue().addOperationWithBlock({
                                    self.PinkOffline(selectedTag)
                                })
                            } catch {
                            }
                        }
                    }
                        
                    else
                    {
                        var objCoreTable: PinkMarkTable!
                        //                    self.appDel.managedObjectContext.persistentStoreCoordinator!.performBlock {
                        autoreleasepool {
                            objCoreTable = (NSEntityDescription.insertNewObjectForEntityForName("PinkMarkTable", inManagedObjectContext: self.appDel.managedObjectContext) as! PinkMarkTable)
                            objCoreTable.penid = self.array_List[selectedTag]["penid"] as? String
                            objCoreTable.ispink = self.array_List[selectedTag]["ispink"] as? String
                            objCoreTable.offline = "YES"
                        }
                        do {
                            try self.appDel.managedObjectContext.save()
                            NSOperationQueue.mainQueue().addOperationWithBlock({
                                self.PinkOffline(selectedTag)
                            })
                            
                        } catch {
                        }
                    }
                    //                }
                    
                } catch {
                    
                }
            }
        }
        else
        {
            btn.setImage(UIImage(named: "Checkbox_PinkNoTick"), forState: .Normal)
            
            //            var data = NSMutableDictionary()
            //            let newdata = array_List[selectedTag] as! NSDictionary
            //            data = newdata.mutableCopy() as! NSMutableDictionary
            data.setObject("0", forKey:"ispink")
            array_List[selectedTag] = data
            table_InpectionList.reloadData()
            
            if self.appDel.checkInternetConnection() {
                str_webservice = "updatepinkvalue"
                let request = NSMutableURLRequest(URL: NSURL(string: "\(Server.local_server)/api/sp_update/updatepinkvalue.php?")!)
                let postString = "penid=\(array_List[selectedTag]["penid"] as! String)&markvalue=\(array_List[selectedTag]["ispink"] as! String)&app_id=\(NSUserDefaults.standardUserDefaults().objectForKey("ApplicationIdentifier") as! String)"
                objwebservice.callServiceCommon_inspection(request, postString: postString)
                
                PinkOffline(selectedTag)
            }
            else
            {
                let fetchRequest = NSFetchRequest(entityName: "PinkMarkTable")
                let predicate = NSPredicate(format: "penid = '\(self.array_List[selectedTag]["penid"] as! String)'")
                fetchRequest.predicate = predicate
                fetchRequest.returnsObjectsAsFaults = false
                fetchRequest.fetchBatchSize = 20
                do {
                    let results = try self.appDel.managedObjectContext.executeFetchRequest(fetchRequest)
                    if results.count > 0 {
                        
                        if let objTable: PinkMarkTable = results[0] as? PinkMarkTable {
                            objTable.ispink = array_List[selectedTag]["ispink"] as? String
                            do {
                                try self.appDel.managedObjectContext.save()
                                NSOperationQueue.mainQueue().addOperationWithBlock({
                                    self.PinkOffline(selectedTag)
                                })
                            } catch {
                            }
                        }
                    }
                        
                    else
                    {
                        var objCoreTable: PinkMarkTable!
                        //                    self.appDel.managedObjectContext.persistentStoreCoordinator!.performBlock {
                        autoreleasepool {
                            objCoreTable = (NSEntityDescription.insertNewObjectForEntityForName("PinkMarkTable", inManagedObjectContext: self.appDel.managedObjectContext) as! PinkMarkTable)
                            objCoreTable.penid = self.array_List[selectedTag]["penid"] as? String
                            objCoreTable.ispink = self.array_List[selectedTag]["ispink"] as? String
                            objCoreTable.offline = "YES"
                        }
                        do {
                            try self.appDel.managedObjectContext.save()
                            NSOperationQueue.mainQueue().addOperationWithBlock({
                                self.PinkOffline(selectedTag)
                            })
                            
                        } catch {
                        }
                    }
                    //                }
                    
                } catch {
                    
                }
            }
            
        }
    }
    
    
    
    func PinkOffline(tag: Int)
    {
        let fetchRequest1 = NSFetchRequest(entityName: "SingleAllocatedPen")
        let predicate1 = NSPredicate(format: "penid = '\(self.array_List[tag]["penid"] as! String)'")
        fetchRequest1.predicate = predicate1
        fetchRequest1.returnsObjectsAsFaults = false
        fetchRequest1.fetchBatchSize = 20
        do {
            let results = try self.appDel.managedObjectContext.executeFetchRequest(fetchRequest1)
            if results.count > 0 {
                for i in 0 ..< results.count {
                    if let objTable: SingleAllocatedPen = results[i] as? SingleAllocatedPen
                    {
                        objTable.ispink = (self.array_List[tag]["ispink"] as? String)!
                        do
                        {
                            try self.appDel.managedObjectContext.save()
                            appDel.remove_HUD()
                        }
                        catch
                        {
                        }
                    }
                }
            }
            
        } catch {
            
        }
    }

    
    //MARK: - ReheckBtnAction
    @IBAction func ReheckBtnAction(sender: UIButton)
    {
        let btn: UIButton = sender
        selectedTagRecheck = btn.tag
        view_recheck.hidden = false
        
        label_recheck.text = array_List[selectedTagRecheck]["pennodisp"] as? String
        
        self.pickerview_Recheck.reloadAllComponents()
    }

    
    @IBAction func cancelRecheckMethod(sender: UIButton) {
        view_recheck.hidden = true
    }
    
    
    @IBAction func DoneRecheckMethod(sender: UIButton) {
        view_recheck.hidden = true
        var data = NSMutableDictionary()
        let newdata = array_List[selectedTagRecheck] as! NSDictionary
        data = newdata.mutableCopy() as! NSMutableDictionary
        var intv : Int = (array_List![selectedTagRecheck]["recheckcount"])!!.integerValue
        intv = intv+1
        data.setObject("\(intv)", forKey:"recheckcount")
        
        data.setObject(intv, forKey:"int_recheckcount")
        
        
        // to adding weeks in entry date
        var Strdate : String! = self.todaydate().stringByReplacingOccurrencesOfString(" ", withString: "")
        var daysCount: Int! = Int(str_recheck)
        daysCount = daysCount*7
        Strdate = self.week_daysBetweenDate(Strdate, recheck: daysCount) as String
        data.setObject("\(Strdate)", forKey:"entrydate")
        
        
//        let dateFormatter = NSDateFormatter()
        dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let s = dateFormatter.dateFromString("\(Strdate)")
        data.setObject(s! as NSDate, forKey:"entryConvert")
        
        
        let date1 = s! as NSDate
        let date2 = NSDate()
        if (date1.compare(date2) == NSComparisonResult.OrderedAscending) || (date1.compare(date2) == NSComparisonResult.OrderedSame) {
            data.setObject("YELLOW", forKey:"colorcode")
        }
        else
        {
            data.setObject("BLACK", forKey:"colorcode")
        }
        array_List[selectedTagRecheck] = data
        
        if self.appDel.checkInternetConnection() {
//            self.appDel.Show_HUD()
            str_webservice = "updaterecheck"
            let request = NSMutableURLRequest(URL: NSURL(string: "\(Server.local_server)/api/sp_update/updaterecheck.php?")!)
            let postString = "penid=\(array_List[selectedTagRecheck]["penid"] as! String)&recheck=\(str_recheck)&app_id=\(NSUserDefaults.standardUserDefaults().objectForKey("ApplicationIdentifier") as! String)"
            objwebservice.callServiceCommon_inspection(request, postString: postString)
            
            self.recheckoffline(selectedTagRecheck)
        }
        else
        {
            var objCoreTable: RecheckTable!
//            self.appDel.managedObjectContext.persistentStoreCoordinator!.performBlock {
                autoreleasepool {
                    objCoreTable = (NSEntityDescription.insertNewObjectForEntityForName("RecheckTable", inManagedObjectContext: self.appDel.managedObjectContext) as! RecheckTable)
                    objCoreTable.penid = self.array_List[self.selectedTagRecheck]["penid"] as? String
                    objCoreTable.recheck = self.str_recheck
                    objCoreTable.offline = "YES"
                    objCoreTable.commentCondition = self.array_List[self.selectedTagRecheck]["comment"] as? String
                }
                do
                {
                    try self.appDel.managedObjectContext.save()
                    NSOperationQueue.mainQueue().addOperationWithBlock({
                        //////////
                        self.recheckoffline(self.selectedTagRecheck)
                    })
                } catch {
                }
//            }
            
        }
        
        print(array_List[selectedTagRecheck])
        table_InpectionList.reloadData()
    }
    
    
    func recheckoffline(tagRecheck: Int)
    {
        let fetchRequest1 = NSFetchRequest(entityName: "SingleAllocatedPen")
        let predicate1 = NSPredicate(format: "penid = '\(self.array_List[tagRecheck]["penid"] as! String)'")
        fetchRequest1.predicate = predicate1
        fetchRequest1.returnsObjectsAsFaults = false
        fetchRequest1.fetchBatchSize = 20
        do {
            let results = try self.appDel.managedObjectContext.executeFetchRequest(fetchRequest1)
            if results.count > 0 {
                autoreleasepool{
                    for i in 0 ..< results.count {
                        if let objTable: SingleAllocatedPen = results[i] as? SingleAllocatedPen {
                            objTable.recheckcount = (self.array_List[tagRecheck]["recheckcount"] as? String)!
                            objTable.int_recheckcount = (self.array_List[tagRecheck]["recheckcount"] as? String)?.toInteger()
                            objTable.entrydate = (self.array_List[tagRecheck]["entrydate"] as? String)!
                            objTable.entryConvert = (self.array_List[tagRecheck]["entryConvert"] as? NSDate)!
                            objTable.recheckcount = objTable.recheckcount!
                            objTable.entrydate = objTable.entrydate!
                            objTable.entryConvert = objTable.entryConvert!
                            objTable.int_recheckcount = objTable.int_recheckcount!
                            print(objTable.ispink!)
                            do
                            {
                                try self.appDel.managedObjectContext.save()
                                appDel.remove_HUD()
                            }
                            catch{}
                        }
                    }
                }
            }
            
        } catch {
            
        }
    }
    
    //MARK: - SizeBtnAction
    @IBAction func SizeBtnAction(sender: UIButton) {
        
        let btn: UIButton = sender
        selectedTagSize = btn.tag
        view_Size.hidden = false
        
        label_Size.text = array_List[selectedTagSize]["pennodisp"] as? String
        
        self.pickerview_Skin.reloadAllComponents()
        autoreleasepool{
            for i in 0 ..< array_SkinSize.count {
                if array_SkinSize[i] as! String ==  array_List[selectedTagSize]["skin_size"] as! String{
                    self.str_Skin = array_SkinSize[i] as! String
                    print(self.str_Skin)
                    self.pickerview_Skin.selectRow(i, inComponent: 0, animated: true)
                    self.pickerview_Skin.reloadAllComponents()
                    break
                }
            }
        }
    }
    
    
    @IBAction func cancelSizeMethod(sender: UIButton) {
        view_Size.hidden = true
    }
    
    
    @IBAction func DoneSizeMethod(sender: UIButton) {
        view_Size.hidden = true
        var data = NSMutableDictionary()
        let newdata = array_List[selectedTagSize] as! NSDictionary
        data = newdata.mutableCopy() as! NSMutableDictionary
        data.setObject(str_Skin, forKey:"skin_size")
        if str_Skin == "Select Size"
        {
            str_Skin = ""
            data.setObject("", forKey:"skin_size")
        }
        
        if self.appDel.checkInternetConnection() {
//            self.appDel.Show_HUD()
            str_webservice = "updatedataskin"
            let request = NSMutableURLRequest(URL: NSURL(string: "\(Server.local_server)/api/sp_update/updatedataskin.php?")!)
            let postString = "penid=\(array_List[selectedTagSize]["penid"] as! String)&skinsize=\(str_Skin)&app_id=\(NSUserDefaults.standardUserDefaults().objectForKey("ApplicationIdentifier") as! String)"
            objwebservice.callServiceCommon_inspection(request, postString: postString)
            
            SkinSizeOffline()
        }
        else
        {
            let fetchRequest = NSFetchRequest(entityName: "SkinSizeTable")
            let predicate = NSPredicate(format: "penid = '\(self.array_List[self.selectedTagSize]["penid"] as! String)'")
            fetchRequest.predicate = predicate
            fetchRequest.returnsObjectsAsFaults = false
            fetchRequest.fetchBatchSize = 20
            do {
                let results = try self.appDel.managedObjectContext.executeFetchRequest(fetchRequest)
                if results.count > 0 {
                    
                    if let objTable: SkinSizeTable = results[0] as? SkinSizeTable {
                        objTable.skinsize = self.str_Skin
                        do {
                            try self.appDel.managedObjectContext.save()
                            NSOperationQueue.mainQueue().addOperationWithBlock({
                                self.SkinSizeOffline()
                            })
                        } catch {
                        }
                    }
                }
                    
                else
                {
                    var objCoreTable: SkinSizeTable!
//                    self.appDel.managedObjectContext.persistentStoreCoordinator!.performBlock {
                        autoreleasepool {
                            objCoreTable = (NSEntityDescription.insertNewObjectForEntityForName("SkinSizeTable", inManagedObjectContext: self.appDel.managedObjectContext) as! SkinSizeTable)
                            objCoreTable.penid = self.array_List[self.selectedTagSize]["penid"] as? String
                            objCoreTable.skinsize = self.str_Skin
                            objCoreTable.offline = "YES"
                        }
                        do {
                            try self.appDel.managedObjectContext.save()
                            NSOperationQueue.mainQueue().addOperationWithBlock({
                                self.SkinSizeOffline()
                            })
                            
                        } catch {
                        }
                    }
//                }
                
            } catch {
                
            }
        }
        array_List[selectedTagSize] = data
        table_InpectionList.reloadData()
    }
    
    
    func SkinSizeOffline()
    {
        let fetchRequest1 = NSFetchRequest(entityName: "SingleAllocatedPen")
        let predicate1 = NSPredicate(format: "penid = '\(self.array_List[self.selectedTagSize]["penid"] as! String)'")
        fetchRequest1.predicate = predicate1
        fetchRequest1.returnsObjectsAsFaults = false
        fetchRequest1.fetchBatchSize = 20
        do {
            let results = try self.appDel.managedObjectContext.executeFetchRequest(fetchRequest1)
            if results.count > 0 {
                for i in 0 ..< results.count {
                    if let objTable: SingleAllocatedPen = results[i] as? SingleAllocatedPen
                    {
                        objTable.skin_size = (self.array_List[selectedTagSize]["skin_size"] as? String)!
                        do
                        {
                            try self.appDel.managedObjectContext.save()
                            appDel.remove_HUD()
                        }
                        catch
                        {
                        }
                    }
                }
                
            }
            
        } catch {
            
        }
    }
    
    
    //MARK: - EditBtnAction
    @IBAction func EditBtnAction(sender: UIButton) {
        
        let btn: UIButton = sender
        let selectedTag : Int = btn.tag
        index = selectedTag
        if self.appDel.checkInternetConnection() {
            self.performSegueWithIdentifier("toInspectionGpKill", sender: self)
        }
        else
        {
            if (self.toPassArray[2] as! String == "FromReady")
            {
                let alertView = UIAlertController(title: nil, message: Server.noInternet, preferredStyle: .Alert)
                alertView.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
                self.presentViewController(alertView, animated: true, completion: nil)
            }
            else
            {
                self.performSegueWithIdentifier("toInspectionGpKill", sender: self)
            }
        }
        
    }
    
    
    //MARK: - radioBtnAction
    @IBAction func radioBtnAction(sender: UIButton) {
        
        let btn: UIButton = sender
        let selectedTag : Int = btn.tag
        let img : UIImage = UIImage(named: "Checkbox_NoTick")!
        
        if img == btn.currentImage {
            btn.setImage(UIImage(named: "Checkbox_tick"), forState: .Normal)
            
            var data = NSMutableDictionary()
            let newdata = array_List[selectedTag] as! NSDictionary
            data = newdata.mutableCopy() as! NSMutableDictionary
            data.setObject("YES", forKey:"state")
            array_List[selectedTag] = data
            table_InpectionList.reloadData()
            
            
        }
        else
        {
            btn.setImage(img, forState: .Normal)
            
            var data = NSMutableDictionary()
            let newdata = array_List[selectedTag] as! NSDictionary
            data = newdata.mutableCopy() as! NSMutableDictionary
            data.setObject("NO", forKey:"state")
            array_List[selectedTag] = data
            table_InpectionList.reloadData()
            
        }
        table_InpectionList .reloadData()
        
    }
    

    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "toInspectionGpKill") {
            let objVC = segue.destinationViewController as! InspectionGpKillVC;
            appDel.int_recheckTag = index
            
            let fetchRequest = NSFetchRequest(entityName: "SingleAllocatedPen")
            let predicate = NSPredicate(format: "penid = '\(array_List[index]["penid"] as! String)'")
            fetchRequest.predicate = predicate
            fetchRequest.returnsObjectsAsFaults = false
            fetchRequest.resultType = NSFetchRequestResultType.DictionaryResultType
            
            
            do {
                let results = try self.appDel.managedObjectContext.executeFetchRequest(fetchRequest)
                if results.count > 0 {
                    print(">>>\(results[0])")
                    objVC.toPassDic = results[0] as! NSMutableDictionary
                    print(objVC.toPassDic)
                }
            } catch{}
            
            
            
        }
    }
    
    //MARK:- SortBtnAction
    @IBAction func Sort_BtnAction(sender: UIButton) {
        let btn: UIButton = sender
        
        
        if btn.tag == 11 {
            btn.selected = !btn.selected
            if btn.selected {
                img_addedArrow.image = UIImage(named: "up-arrow")
                self.sortwithString("addedConvert", bool: false)
                
            }
            else {
                
                img_addedArrow.image = UIImage(named: "downarrow")
                self.sortwithString("addedConvert", bool: true)
            }
        }
        else if btn.tag == 12 {
            btn.selected = !btn.selected
            if btn.selected {
                img_dueArrow.image = UIImage(named: "up-arrow")
                self.sortwithString("entryConvert", bool: false)
                
            }
            else {
                img_dueArrow.image = UIImage(named: "downarrow")
                self.sortwithString("entryConvert", bool: true)
                
            }
        }
        else if btn.tag == 13 {
            btn.selected = !btn.selected
            if btn.selected {
                img_grpArrow.image = UIImage(named: "up-arrow")
                self.sortwithString("pennodisp", bool: false)
            }
            else {
                img_grpArrow.image = UIImage(named: "downarrow")
                self.sortwithString("pennodisp", bool: true)
                
            }
        }
            
        else if btn.tag == 14 {
            btn.selected = !btn.selected
            if btn.selected {
                img_RecheckArrow.image = UIImage(named: "up-arrow")
                self.sortwithString("int_recheckcount", bool: false)
            }
            else {
                img_RecheckArrow.image = UIImage(named: "downarrow")
                self.sortwithString("int_recheckcount", bool: true)
            }
        }
        else if btn.tag == 15 {
            btn.selected = !btn.selected
            if btn.selected {
                img_skinsizeArrow.image = UIImage(named: "up-arrow")
                self.sortwithString("skin_size", bool: false)
            }
            else {
                img_skinsizeArrow.image = UIImage(named: "downarrow")
                self.sortwithString("skin_size", bool: true)
            }
        }
        else if btn.tag == 16 {
            btn.selected = !btn.selected
            if btn.selected {
                self.sortwithString("ispink", bool: false)
            }
            else {
                self.sortwithString("ispink", bool: true)
            }
        }
        table_InpectionList.reloadData()
    }
    
    
    
    
    func sortwithString(strKey: String, bool: Bool)
    {
        var newArray = array_List as NSArray
        let descriptor: NSSortDescriptor = NSSortDescriptor(key:strKey, ascending: bool)
        let sortedResults = newArray.sortedArrayUsingDescriptors([descriptor])
        newArray = sortedResults
        self.array_List = newArray.mutableCopy() as! NSMutableArray
        table_InpectionList.reloadData()
        self.table_InpectionList.setContentOffset(CGPointZero, animated:true)  // scroll to top

        
        
    }
    
    
    //MARK: - FilterBTnAction
    @IBAction func Filter_BtnAction(sender: UIButton) {
        if Bool_viewUsers
        {
            objuserList.removeView(self.view)
            Bool_viewUsers = false
        }
        if Bool_viewCreateAge
        {
            self.cancelAge()
        }
        self.view.userInteractionEnabled = false
        if !Bool_viewFilter {
            self.array_filter.removeAllObjects()
            self.array_filter = ["Group", "Date Range"]
            self.str_tableFilter = "array1"
//            dispatch_async(dispatch_get_main_queue()) {
                self.table_filterList.reloadData()
//            }
            
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
    
    
    
    //MARK: - CreateAgeBtnAction
    @IBAction func CreateAge_BtnAction(sender: UIButton) {
        if Bool_viewUsers
        {
            objuserList.removeView(self.view)
            Bool_viewUsers = false
        }
        if Bool_viewFilter
        {
            self.cancelFilter()
        }
        self.view.userInteractionEnabled = false
        if !Bool_viewCreateAge {
            self.array_Age.removeAllObjects()
            for i in 1 ..< 13
            {
                self.array_Age.addObject("\(i)")
            }
//            self.str_tableFilter = "array1"
            self.table_ageList.reloadData()
            
            view_createAge.hidden = true
            let transitionOptions = UIViewAnimationOptions.TransitionCurlDown
            UIView.transitionWithView(self.view_createAge, duration: 0.6, options: transitionOptions, animations: {
                self.view_createAge.hidden = false
                
                }, completion: { finished in
                    self.view.userInteractionEnabled = true
                    self.Bool_viewCreateAge = true
            })
            
        }
        else {
            let transitionOptions = UIViewAnimationOptions.TransitionCurlUp
            UIView.transitionWithView(self.view_createAge, duration: 0.6, options: transitionOptions, animations: {
                self.view_createAge.hidden = true
                
                }, completion: { finished in
                    
                    self.Bool_viewCreateAge = false
                    self.view.userInteractionEnabled = true
            })
            
        }
        
    }
    
    @IBAction func Cancel_Age_BtnAction(sender: UIButton) {
        cancelAge()
    }
    
    func cancelAge()
    {
        let transitionOptions = UIViewAnimationOptions.TransitionCurlUp
        UIView.transitionWithView(self.view_createAge, duration: 0.6, options: transitionOptions, animations: {
            self.view_createAge.hidden = true
            
            }, completion: { finished in
                
                self.Bool_viewCreateAge = false
        })
    }
    
    //MARK: - Confirm Kill
    
    @IBAction func ConfirmKill_BtnAction(sender: UIButton) {
        let stateStr : String = "YES"
        let resultPredicate = NSPredicate(format: "state contains[c] %@", stateStr)
        let aNames: [AnyObject] = self.array_List.filteredArrayUsingPredicate(resultPredicate)
        if aNames.count != 0 {
            let alertView = UIAlertController(title: nil, message: "Are You Sure To Comfirm Kill The Selected Animals?", preferredStyle: .Alert)
            alertView.addAction(UIAlertAction(title: "NO", style: .Cancel, handler: nil))
            alertView.addAction(UIAlertAction(title: "YES", style: UIAlertActionStyle.Default, handler: {(action:UIAlertAction) in
                
                self.arraytemp.removeAllObjects()
                for i in 0..<aNames.count {
                    self.arraytemp.addObject(aNames[i]["penid"] as! String)
                }
                let joined = self.arraytemp.componentsJoinedByString(",")
                if self.appDel.checkInternetConnection() {
                    self.appDel.Show_HUD()
                    self.DeleteFromSingleAllocatedPen(joined, Offline: "NO", killedFrom: "Inspection")
                    
                    for i in 0 ..< aNames.count
                    {
                        self.UpDateAddSectionTableEvent(aNames[i]["groupcode"] as! String)
                        self.UpDatefetchEvent(aNames[i]["penid"] as! String, Offline: "NO")
                        
                        let groupcode: String = (aNames[i]["groupcode"]) as! String
                        let grpnamedisp: String = "\((aNames[i]["groupcode"]) as! String)-PEN#"
                        var arraytemp = "\((aNames[i]["pennodisp"]) as! String)".componentsSeparatedByString("-")
                        let namexx: String! = "\(arraytemp[0] as String)"
                        let nameyy: String! = "\(arraytemp[1] as String)"
                        
                        let penid: String = (aNames[i]["penid"]) as! String
                        let pennodisp = "\(namexx)-\(nameyy)"
                        
                        self.addToEmptyPen(groupcode, grpnamedisp: grpnamedisp, namexx: namexx, nameyy: nameyy, pennodisp: pennodisp, penid: penid)
                    }
                    self.str_webservice = "movetoConfirmkillmultiple"
                    let request = NSMutableURLRequest(URL: NSURL(string: "\(Server.local_server)/api/sp_inspection/confirm_kill_multiple.php?")!)
                    let postString = "penids=\(joined)&addedby=\(NSUserDefaults.standardUserDefaults().objectForKey("email_username") as! String)&app_id=\(NSUserDefaults.standardUserDefaults().objectForKey("ApplicationIdentifier") as! String)"
                    self.objwebservice.callServiceCommon_inspection(request, postString: postString)
                    
                    
                }
                else
                {
                    if (self.toPassArray[2] as! String == "FromReady")
                    {
                        let alertView = UIAlertController(title: nil, message: Server.noInternet, preferredStyle: .Alert)
                        alertView.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
                        self.presentViewController(alertView, animated: true, completion: nil)
                    }
                    else
                    {
                        self.str_webservice = "movetoConfirmkillmultiple"
                        self.DeleteFromSingleAllocatedPen(joined, Offline: "YES", killedFrom: "Inspection")

                        for i in 0 ..< aNames.count
                        {
                            
                            self.UpDateAddSectionTableEvent(aNames[i]["groupcode"] as! String)
                            self.UpDatefetchEvent(aNames[i]["penid"] as! String, Offline: "YES")
                            
                            let groupcode: String = (aNames[i]["groupcode"]) as! String
                            let grpnamedisp: String = "\((aNames[i]["groupcode"]) as! String)-PEN#"
                            var arraytemp = "\((aNames[i]["pennodisp"]) as! String)".componentsSeparatedByString("-")
                            let namexx: String! = "\(arraytemp[0] as String)"
                            let nameyy: String! = "\(arraytemp[1] as String)"
//                            let namexx: String! = (aNames[i]["namexx"]) as! String
//                            let nameyy: String! = (aNames[i]["nameyy"]) as! String
                            
                            let penid: String = (aNames[i]["penid"]) as! String
                            let pennodisp = "\(namexx)-\(nameyy)"
                            
                            self.addToEmptyPen(groupcode, grpnamedisp: grpnamedisp, namexx: namexx, nameyy: nameyy, pennodisp: pennodisp, penid: penid)
                        }
                        
                    }
                }
            }));
            self.presentViewController(alertView, animated: true, completion: nil)
        }
        else
        {
            let alertView = UIAlertController(title: nil, message: "Please Select Animal.", preferredStyle: .Alert)
            alertView.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
            self.presentViewController(alertView, animated: true, completion: nil)
        }
    }

    
    
    //MARK: - Scroll To Bottom
    @IBAction func SubmitScroll_BtnAction()
    {
        self.scrollToLastRow()
    }
    
    func scrollToLastRow() {
        self.table_InpectionList.reloadData()
        let indexPath = NSIndexPath(forRow: array_List.count - 1, inSection: 0)
        self.table_InpectionList.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Bottom, animated: true)
    }
    
    //MARK: - Submit UIButton
    @IBAction func Submit_BtnAction(sender: UIButton) {
        
//        str_filterPressed = ""
        
//        dispatch_async(dispatch_get_main_queue())
//        {
            
            let stateStr : String = "YES"
            let resultPredicate = NSPredicate(format: "state contains[c] %@", stateStr)
            let aNames: [AnyObject] = self.array_List.filteredArrayUsingPredicate(resultPredicate)
            if aNames.count != 0 {
                let alertView = UIAlertController(title: nil, message: "Are You Sure To Add Animals In Kill List?", preferredStyle: .Alert)
                alertView.addAction(UIAlertAction(title: "NO", style: .Cancel, handler: nil))
                alertView.addAction(UIAlertAction(title: "YES", style: UIAlertActionStyle.Default, handler: {(action:UIAlertAction) in
                    
                    self.arraytemp.removeAllObjects()
                    for i in 0..<aNames.count {
                        self.arraytemp.addObject(aNames[i]["penid"] as! String)
                    }
                    let joined = self.arraytemp.componentsJoinedByString(",")
                    if self.appDel.checkInternetConnection() {
                        self.appDel.Show_HUD()
                        self.DeleteFromSingleAllocatedPen(joined, Offline: "NO", killedFrom: "Inspection")
                        self.str_webservice = "movetokill_listmultiple"
                        let request = NSMutableURLRequest(URL: NSURL(string: "\(Server.local_server)/api/sp_inspection/movetokill_listmultiple.php?")!)
                        let postString = "penids=\(joined)&addedby=\(NSUserDefaults.standardUserDefaults().objectForKey("email_username") as! String)&app_id=\(NSUserDefaults.standardUserDefaults().objectForKey("ApplicationIdentifier") as! String)"
                        self.objwebservice.callServiceCommon_inspection(request, postString: postString)
                        
                        
                    }
                    else
                    {
                        if (self.toPassArray[2] as! String == "FromReady")
                        {
                            let alertView = UIAlertController(title: nil, message: Server.noInternet, preferredStyle: .Alert)
                            alertView.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
                            self.presentViewController(alertView, animated: true, completion: nil)
                        }
                        else
                        {
                            self.str_webservice = "movetokill_listmultiple"
                            self.DeleteFromSingleAllocatedPen(joined, Offline: "YES", killedFrom: "Inspection")

                        }
                    }
                }));
                self.presentViewController(alertView, animated: true, completion: nil)
            }
            else
            {
                let alertView = UIAlertController(title: nil, message: "Please Select Animal.", preferredStyle: .Alert)
                alertView.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
                self.presentViewController(alertView, animated: true, completion: nil)
            }
            
            
//        }
    }
    
    

    //MARK: - calendar Btn_Action/ Calendar Delegate
    @IBAction func Calendar_BtnAction(sender: UIButton) {
        
        self.cancelFilter()
        view_calendar.hidden = false
    }

    //MARK: - DATE convertors
    func Databse_dateconvertor(datestr: String!) -> NSDate
    {
//        let dateForm: NSDateFormatter = NSDateFormatter()
        let twelveHourLocale: NSLocale = NSLocale(localeIdentifier: "en_US_POSIX")
        dateFormatter.locale = twelveHourLocale
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC")
        let gotDate: NSDate = dateFormatter.dateFromString(datestr)!
        return gotDate
    }
    
    func todaydate() -> NSString
    {
//        let dateForm: NSDateFormatter = NSDateFormatter()
        let twelveHourLocale: NSLocale = NSLocale(localeIdentifier: "en_US_POSIX")
        dateFormatter.locale = twelveHourLocale
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let todayDate: String = "  \(dateFormatter.stringFromDate(NSDate()))"
        return todayDate
    }
    
    func daysBetweenDate(currentstrDate: NSString!) -> NSString {
        let dateComponents: NSDateComponents = NSDateComponents()
        dateComponents.year = 1
        let calendar: NSCalendar = NSCalendar.currentCalendar()
        
        var currentDate: NSDate! = NSDate()
//        let dateForm: NSDateFormatter = NSDateFormatter()
        let twelveHourLocale: NSLocale = NSLocale(localeIdentifier: "en_US_POSIX")
        dateFormatter.locale = twelveHourLocale
        dateFormatter.dateFormat = "dd/MM/yyyy"
        currentDate = dateFormatter.dateFromString(currentstrDate as String)
        
        let newDate: NSDate = calendar.dateByAddingComponents(dateComponents, toDate: currentDate, options: NSCalendarOptions(rawValue: 0))!
        
        picker_StartDate.setDate(currentDate, animated: true)
        picker_StopDate.setDate(newDate, animated: true)
        picker_StopDate.minimumDate = picker_StartDate.date
        
        let SStr_date = "\(dateFormatter.stringFromDate(newDate))"
        return SStr_date
    }
    
//    func MonthsBetweenDate(currentstrDate: NSString!, monthInt: Int!) -> NSString {
//        let dateComponents: NSDateComponents = NSDateComponents()
//        dateComponents.month = monthInt
//        let calendar: NSCalendar = NSCalendar.currentCalendar()
//        
//        var currentDate: NSDate! = NSDate()
//        let dateForm: NSDateFormatter = NSDateFormatter()
//        let twelveHourLocale: NSLocale = NSLocale(localeIdentifier: "en_US_POSIX")
//        dateForm.locale = twelveHourLocale
//        dateForm.dateFormat = "dd/MM/yyyy"
//        currentDate = dateForm.dateFromString(currentstrDate as String)
//        
//        let newDate: NSDate = calendar.dateByAddingComponents(dateComponents, toDate: currentDate, options: NSCalendarOptions(rawValue: 0))!
//        
//        //        picker_StopDate.maximumDate = NSCalendar.currentCalendar().dateByAddingUnit(.Year, value: 1, toDate: NSDate(), options: [])
//        
//        let SStr_date = "\(dateForm.stringFromDate(newDate))"
//        return SStr_date
//    }
    
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
        
        picker_StartDate.setDate(currentDate, animated: true)
        picker_StopDate.setDate(newDate, animated: true)
        picker_StopDate.minimumDate = picker_StartDate.date
        
        let SStr_date = "\(dateFormatter.stringFromDate(newDate))"
        return SStr_date
    }
    
    
    @IBAction func picker_StartDateChanged(sender: AnyObject) {
        let twelveHourLocale: NSLocale = NSLocale(localeIdentifier: "en_US_POSIX")
        dateForm.locale = twelveHourLocale
        dateForm.dateFormat = "dd/MM/yyyy"
        text_StartDate = "\(dateForm.stringFromDate(picker_StartDate.date))"
        picker_StopDate.minimumDate = picker_StartDate.date
        
        label_date.text = "\(text_StartDate) - \(text_StopDate)"
        print(text_StartDate)
    }
    
    
    @IBAction func picker_StopDateChanged(sender: AnyObject) {
        let twelveHourLocale: NSLocale = NSLocale(localeIdentifier: "en_US_POSIX")
        dateForm.locale = twelveHourLocale
        dateForm.dateFormat = "dd/MM/yyyy"

        text_StopDate = "\(dateForm.stringFromDate(picker_StopDate.date))"
        picker_StartDate.maximumDate = picker_StopDate.date
        print(text_StopDate)
        
        label_date.text = "\(text_StartDate) - \(text_StopDate)"
    }
    
    
    @IBAction func CancelCalendar_BtnAction(sender: AnyObject)
    {
        view_calendar.hidden = true
    }
    
    
    @IBAction func DoneCalendar_BtnAction(sender: AnyObject) {
        str_tableFilterSelectOption = nil
        str_filterPressed = "dateRange"
        if self.appDel.checkInternetConnection() {
            appDel.Show_HUD()
            str_webservice = "getinspectionbyfilterCalendar"
            var start: String! = text_StartDate.stringByReplacingOccurrencesOfString(" ", withString: "")
            start = start.stringByReplacingOccurrencesOfString("/", withString: "-")
            var stop: String! = text_StopDate.stringByReplacingOccurrencesOfString(" ", withString: "")
            stop = stop.stringByReplacingOccurrencesOfString("/", withString: "-")
            
            var request = NSMutableURLRequest(URL: NSURL(string: "\(Server.local_server)/api/sp_inspection/getinspectionbyfilter.php?")!)
            var postString = "datefrom=\(start)&dateto=\(stop)&months="
            
            if (self.toPassArray[2] as! String == "create")
            {
                postString = "datefrom=\(start)&dateto=\(stop)&months=\(int_tableAge)"
            }
            else if (self.toPassArray[2] as! String == "AllSizesList")
            {
                request = NSMutableURLRequest(URL: NSURL(string: "\(Server.local_server)/api/sp_inspection/getnoskinbyfilter.php?")!)
                postString = "group=&block=&datefrom=\(start)&dateto=\(stop)"
                
            }
            objwebservice.callServiceCommon_inspection(request, postString: postString)
            view_calendar.hidden = true
            
        }
        else
        {
            view_calendar.hidden = true
            self.GetFilterDateOffline(picker_StartDate.date, stopDate: picker_StopDate.date)
            
        }
        
    }

    //MARK: - Export Btn_Action/ UserList Delegate
    @IBAction func Export_BtnAction(sender: AnyObject) {
        if Bool_viewFilter
        {
            self.cancelFilter()
        }
        if Bool_viewCreateAge
        {
            self.cancelAge()
        }
        if !Bool_viewUsers {
            objuserList.showView(self.view, frame1: CGRectMake(677, 140, 318, 231))
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
        
        print(EmailUsers)
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
                str_webservice = "report_sp_inspection"
                appDel.Show_HUD()
                var start: String! = text_StartDate.stringByReplacingOccurrencesOfString(" ", withString: "")
                start = start.stringByReplacingOccurrencesOfString("/", withString: "-")
                var stop: String! = text_StopDate.stringByReplacingOccurrencesOfString(" ", withString: "")
                stop = stop.stringByReplacingOccurrencesOfString("/", withString: "-")
                
                if (toPassArray[2] as! String == "autoInspection")
                {
                    let request = NSMutableURLRequest(URL: NSURL(string: "\(Server.local_server)/api/file/report_sp_inspection_autonew.php?")!)
                    var postString = "tomail=\(EmailUsers)&group=&block=&datefrom=&dateto="
                    if str_filterPressed == "dateRange" {
                        postString = "tomail=\(EmailUsers)&datefrom=\(start)&dateto=\(stop)"
                    }
                    else if str_filterPressed == "block" {
                        postString = "tomail=\(EmailUsers)&group=\(str_tableFilterSelectOption)"
                    }
                    objwebservice.callServiceCommon_inspection(request, postString: postString)
                }
                    
                else if (toPassArray[2] as! String == "create")
                {
                    let request = NSMutableURLRequest(URL: NSURL(string: "\(Server.local_server)/api/file/report_sp_inspection_new.php?")!)
                    var postString = "months=\(int_tableAge)&tomail=\(EmailUsers)&datefrom=&dateto="
                    if str_filterPressed == "dateRange" {
                        postString = "months=\(int_tableAge)&tomail=\(EmailUsers)&datefrom=\(start)&dateto=\(stop)"
                    }
                    else if str_filterPressed == "block" {
                        postString = "months=\(int_tableAge)&tomail=\(EmailUsers)&group=\(str_tableFilterSelectOption)"
                        
                    }
                    objwebservice.callServiceCommon_inspection(request, postString: postString)
                }
                else if (toPassArray[2] as! String == "AllSizesList") //edit
                {
                    let request = NSMutableURLRequest(URL: NSURL(string: "\(Server.local_server)/api/file/report_no_skin.php?")!)
                    var postString = "tomail=\(EmailUsers)"
                    if str_filterPressed == "dateRange" {
                        postString = "tomail=\(EmailUsers)&datefrom=\(start)&dateto=\(stop)"
                    }
                    else if str_filterPressed == "block" {
                        postString = "tomail=\(EmailUsers)&group=\(str_tableFilterSelectOption)"
                    }
                    objwebservice.callServiceCommon_inspection(request, postString: postString)
                }
                else if (self.toPassArray[2] as! String == "FromReady")
                {
                    
                    var request = NSMutableURLRequest(URL: NSURL(string: "\(Server.local_server)/api/file/report_sp_inspection_ready.php?")!)
                    var postString = "monthyear=\(toPassArray[0] as! String)&tomail=\(EmailUsers)&skinsize=\(toPassArray[1] as! String)&graphindex=\(toPassArray[3] as! String)"
                    if (str_filterPressed != "")
                    {
                        request = NSMutableURLRequest(URL: NSURL(string: "\(Server.local_server)/api/file/report_sp_inspection_autonew.php?")!)
                        postString = "tomail=\(EmailUsers)&group=&datefrom=&dateto="
                        
                        if str_filterPressed == "dateRange" {
                            postString = "tomail=\(EmailUsers)&datefrom=\(start)&dateto=\(stop)"
                        }
                        else if str_filterPressed == "block" {
                            postString = "tomail=\(EmailUsers)&group=\(str_tableFilterSelectOption)"
                        }
                    }
                    
                    objwebservice.callServiceCommon_inspection(request, postString: postString)
                }
            }
            else
            {
                let alertView = UIAlertController(title: nil, message: Server.noInternet, preferredStyle: .Alert)
                alertView.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
                self.presentViewController(alertView, animated: true, completion: nil)
            }
        }
        
        
        
        
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
                            
                            if self.appDel.checkInternetConnection()
                            {
                                
                            }
                            else
                            {
                                let alertView = UIAlertController(title: nil, message: "Successfully Added." , preferredStyle: .Alert)
                                alertView.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                                self.presentViewController(alertView, animated: true, completion: nil)
                                
                                self.GetOfflineSingleAllocatedPen()
                            }
                            
                            
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
    

    
}