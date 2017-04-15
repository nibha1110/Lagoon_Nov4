//
//  SPMoveVC.swift
//  Crocodile
//
//  Created by Nibha Aggarwal on 24/01/17.
//  Copyright © 2017 Nibha Aggarwal. All rights reserved.
//

import UIKit
import CoreData

class SPMoveVC: UIViewController, CommonClassProtocol, responseProtocol {
    var appDel : AppDelegate!
    var objwebservice : webservice! = webservice()
    
    @IBOutlet weak var btn_fromPen: UIButton!
    @IBOutlet weak var btn_toPen: UIButton!
    
    @IBOutlet var tableView_Move: UITableView!
    @IBOutlet weak var table_filterList1: UITableView!
    
    @IBOutlet weak var view_filter1: UIView! = UIView()
    
    var array_List: NSMutableArray = []
    var dic_main: NSMutableDictionary! = NSMutableDictionary()
    
    var str_webservice: NSString!
    
    var Bool_PickerView: Bool = false
    var Bool_viewFilter1: Bool = false
    var Bool_viewFilter2: Bool = false
    
    var str_tableFilter1: String! = "array2"
    var str_tableFilterSelectOption1: String! = ""
    var str_AlloctedOREmpty: String! = ""
    var array_filter1: NSMutableArray! = ["IFP", "IFTP", "OFP", "RTF"]
    
    var str_fromOrToBtn: String! = ""
    var str_Message_NoData1: String! = "NoData"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appDel = (UIApplication.sharedApplication().delegate as! AppDelegate)
        
        guard let controller = self.storyboard!.instantiateViewControllerWithIdentifier("CommonClassVC") as? CommonClassVC
            else {
                fatalError();
        }
        addChildViewController(controller)
        controller.view.frame = CGRectMake(0, 0, 1024, 768)
        controller.btn_Sync.hidden = false
        controller.img_Sync.hidden = false
        controller.btn_BackPop.hidden = true
        controller.array_tableSection = ["move_left"]
        controller.array_sectionRow = [["Move_Hatchlings_UnSel", "move_left", "add_to_dieBLUE", "add_to_killBLUE", "Sp_move_blue", "GroupAverage_blue"]]
        view.addSubview(controller.view)
        view.sendSubviewToBack(controller.view)
        controller.IIndexPath = NSIndexPath(forRow: 4, inSection: 1)
        controller.tableMenu.reloadData()
        controller.label_header.text = "SP MOVES"
        controller.array_temp_section.replaceObjectAtIndex(1, withObject: "Yes")
        let arrt = controller.array_temp_row[1]
        arrt.replaceObjectAtIndex(4, withObject: "Yes")
        
        controller.delegate = self
        objwebservice.delegate = self
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        if self.appDel.checkInternetConnection() {
        }
        
        let fetchRequest = NSFetchRequest(entityName: "SPMoveBulkTable")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.fetchBatchSize = 20
        fetchRequest.resultType = NSFetchRequestResultType.DictionaryResultType
        do {
            let results = try appDel.managedObjectContext.executeFetchRequest(fetchRequest)
            if results.count > 0 {
                let newArray = results as NSArray
                self.array_List =  newArray.mutableCopy() as! NSMutableArray
                print(self.array_List)
                tableView_Move.reloadData()
            }
            else
            {
                self.array_List.removeAllObjects()
                print(self.array_List)
                tableView_Move.reloadData()
            }
        }
        catch{
            
        }
    }
    
    func resetAllPickers()
    {
        btn_fromPen.setTitle("From Pen", forState: .Normal)
        btn_toPen.setTitle("To Pen", forState: .Normal)
    }
    
    
    //MARK: -  CommonClass Delegate
    func responseCommonClassOffline() {
        self.viewDidAppear(false)
    }
    
    // MARK: -  tableview Delegates
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == table_filterList1 {
            if str_Message_NoData1 == "NoData" {
                return 1
            }
            return array_filter1.count
        }
        else
        {
            if array_List.count == 0 {
                return 1
            }
            return array_List.count
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        if tableView == table_filterList1 {
            return 45
        }
        return 75.0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        
        //view Backgd
        let view_bg: UIView = UIView(frame: CGRectMake(0, 0, 318, 75))
        if indexPath.row % 2 == 0 {
            view_bg.backgroundColor = UIColor.whiteColor()
        }
        else {
            view_bg.backgroundColor = UIColor(red: 241.0 / 255.0, green: 241 / 255.0, blue: 241 / 255.0, alpha: 1.0)
        }
        
        
        if tableView == table_filterList1 {
            cell.textLabel!.font = UIFont(descriptor: UIFontDescriptor(name: "HelveticaNeue-Medium", size: 19), size: 19.0)
            if  str_tableFilter1 == "array4"{
                if (str_Message_NoData1 == "NoData")
                {
                    cell.textLabel?.text = "No Pen In The List."
                }
                else
                {
                    cell.textLabel?.text = "\(array_filter1[indexPath.row]["namexx"] as! String)-\(array_filter1[indexPath.row]["nameyy"] as! String)"
                }
                return cell
            }else
            {
                cell.textLabel?.text = array_filter1[indexPath.row] as? String
            }
            
            return cell
        }
        
        //label_Grp
        let label_Grp: UILabel = UILabel(frame: CGRectMake(40, 13, 100, 50))
        label_Grp.textAlignment = .Left
        label_Grp.font = UIFont(descriptor: UIFontDescriptor(name: "HelveticaNeue", size: 26), size: 26.0)
        
        if array_List.count == 0 {
            label_Grp.font = UIFont(descriptor: UIFontDescriptor(name: "HelveticaNeue", size: 24), size: 24.0)
            label_Grp.frame = CGRectMake(20, 13, 500, 50)
            label_Grp.text = "Please Add Pens Into The List."
            view_bg.addSubview(label_Grp)
            cell.contentView .addSubview(view_bg)
            
            return cell
        }
        
        label_Grp.text = "From"
        
        //orange image
        let img_orange: UIImageView = UIImageView(frame: CGRectMake(118, 8, 222, 56))
        img_orange.image = UIImage(named: "xxyy")
        
        //label_pens
        let label_pens: UILabel = UILabel(frame: CGRectMake(118, 8, 222, 56))
        label_pens.textAlignment = .Center
        label_pens.textColor = UIColor.whiteColor()
        label_pens.font = UIFont(descriptor: UIFontDescriptor(name: "HelveticaNeue", size: 26), size: 26.0)
        label_pens.text = "\(array_List[indexPath.row]["fromGroup"] as! String)/\(array_List[indexPath.row]["from_namexx"] as! String)-\(array_List[indexPath.row]["from_nameyy"] as! String)"
        
        //label_Grp
        let label_GrpTO: UILabel = UILabel(frame: CGRectMake(332, 13, 50, 50))
        label_GrpTO.textAlignment = .Center
        label_GrpTO.font = UIFont(descriptor: UIFontDescriptor(name: "HelveticaNeue", size: 26), size: 26.0)
        label_GrpTO.text = "-"
        
        //orange image
        let img_orangeTO: UIImageView = UIImageView(frame: CGRectMake(376, 8, 222, 56))
        img_orangeTO.image = UIImage(named: "xxyy")
        
        //label_pens
        let label_pensTO: UILabel = UILabel(frame: CGRectMake(376, 8, 222, 56))
        label_pensTO.textAlignment = .Center
        label_pensTO.textColor = UIColor.whiteColor()
        label_pensTO.font = UIFont(descriptor: UIFontDescriptor(name: "HelveticaNeue", size: 26), size: 26.0)
        label_pensTO.text = "\(array_List[indexPath.row]["toGroup"] as! String)/\(array_List[indexPath.row]["to_namexx"] as! String)-\(array_List[indexPath.row]["to_nameyy"] as! String)"
        
        view_bg.addSubview(img_orange)
        view_bg.addSubview(label_pens)
        view_bg.addSubview(label_Grp)
        view_bg.addSubview(img_orangeTO)
        view_bg.addSubview(label_pensTO)
        view_bg.addSubview(label_GrpTO)
        
        cell.contentView .addSubview(view_bg)
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if tableView == table_filterList1{
            if (str_tableFilter1 == "array2")
            {
                str_tableFilterSelectOption1 = array_filter1[indexPath.row] as! String
                self.GetFilterPenOffline(array_filter1[indexPath.row] as! String)
                
            }
            else if (str_tableFilter1 == "array3")
            {
                self.GetFilterOfflineRecords(str_tableFilterSelectOption1, pen: array_filter1[indexPath.row] as! String, type: str_AlloctedOREmpty)
                
            }
            else if (str_tableFilter1 == "array4")
            {
                self.cancelFilter()
                if (str_Message_NoData1 == "NoData") {
                   return
                }
                self.checkIntoBulkTable(str_tableFilterSelectOption1, nameXX: (array_filter1[indexPath.row]["namexx"] as! String), nameYY: (array_filter1[indexPath.row]["nameyy"] as! String))
                
            }
        }
        else
        {
            if array_List.count == 0 {
            }
            else
            {
                
            }

        }
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            print("deleted \(indexPath.row)")
            
            // handle delete (by removing the data from your array and updating the tableview)
            let fetchRequest = NSFetchRequest(entityName: "SPMoveBulkTable")
            let predicate = NSPredicate(format: "fromGroup = '\(array_List[indexPath.row]["fromGroup"] as! String)' AND from_namexx = '\(array_List[indexPath.row]["from_namexx"] as! String)' AND from_nameyy = '\(array_List[indexPath.row]["from_nameyy"] as! String)' AND toGroup = '\(array_List[indexPath.row]["toGroup"] as! String)' AND to_namexx = '\(array_List[indexPath.row]["to_namexx"] as! String)' AND to_nameyy = '\(array_List[indexPath.row]["to_nameyy"] as! String)'")
            fetchRequest.predicate = predicate
            fetchRequest.returnsObjectsAsFaults = false
            fetchRequest.fetchBatchSize = 20
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            
            do {
                try self.appDel.persistentStoreCoordinator.executeRequest(deleteRequest, withContext: self.appDel.managedObjectContext)
                do
                {
                    try self.appDel.managedObjectContext.save()
                    self.appDel.remove_HUD()
                    
                    self.array_List.removeObjectAtIndex(indexPath.row)
                    
//                    self.viewDidAppear(false)
                    self.tableView_Move.reloadData()
                    
                }
                catch{}
            } catch{}
        }
    }
    
    
    
    //MARK: - From Pen Action
    @IBAction func FromPen_btnAction(sender: AnyObject) {
        
        if !Bool_PickerView {
            str_fromOrToBtn = "From"
            self.resetAllPickers()
        }
        else
        {
            str_fromOrToBtn = ""
        }
    }
    
    @IBAction func ToPen_btnAction(sender: AnyObject) {
        if !Bool_PickerView {
            str_fromOrToBtn = "To"
            self.resetAllPickers()
        }
        else {
            str_fromOrToBtn = ""
        }
    }
    
  
    
    
    @IBAction func Add_btnAction(sender: AnyObject) {
        if btn_fromPen.titleLabel?.text == "From Pen" || btn_toPen.titleLabel?.text == "To Pen"{
            let alertView = UIAlertController(title: nil, message: "Please Select Pen.", preferredStyle: .Alert)
            alertView.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
            self.presentViewController(alertView, animated: true, completion: nil)
        }
        else
        {
            let dictemp: NSMutableDictionary! = NSMutableDictionary()
            var arraytemp = "\((btn_fromPen.titleLabel?.text!)! as String)".componentsSeparatedByString("/")
            var str_grp: String! = "\(arraytemp[0])"
            dictemp.setValue(str_grp, forKey: "fromGroup")
 
            arraytemp = "\(arraytemp[1])".componentsSeparatedByString("-")
            dictemp.setValue("\(arraytemp[0])", forKey: "from_namexx")
            dictemp.setValue("\(arraytemp[1])", forKey: "from_nameyy")
            
            arraytemp = "\((btn_toPen.titleLabel?.text!)! as String)".componentsSeparatedByString("/")
            str_grp = "\(arraytemp[0])"
            dictemp.setValue(str_grp, forKey: "toGroup")
            
            arraytemp = "\(arraytemp[1])".componentsSeparatedByString("-")
            dictemp.setValue("\(arraytemp[0] )", forKey: "to_namexx")
            dictemp.setValue("\(arraytemp[1])", forKey: "to_nameyy")
            
            
            self.GetPenInBulkTable(dictemp)
            
            
            
            
            /*
            let alertView = UIAlertController(title: nil, message: "Are You Sure You Want To Add?", preferredStyle: .Alert)
            alertView.addAction(UIAlertAction(title: "NO", style: .Cancel, handler: nil))
            alertView.addAction(UIAlertAction(title: "YES", style: .Default, handler: {(action:UIAlertAction) in
               
            }));
            self.presentViewController(alertView, animated: true, completion: nil)
 
             */
        }
    }
    
    
    @IBAction func MoveToEmpty_btnAction(sender: AnyObject) {
        if array_List.count > 0
        {
            let alertView = UIAlertController(title: nil, message: "Are You Sure You Want To Move the Listed Pens?", preferredStyle: .Alert)
            alertView.addAction(UIAlertAction(title: "NO", style: .Cancel, handler: nil))
            alertView.addAction(UIAlertAction(title: "YES", style: .Default, handler: {(action:UIAlertAction) in
                if self.appDel.checkInternetConnection() {
                    self.str_webservice = "empty_move"
                    self.appDel.Show_HUD()
                    
                    let dictForPacket: NSMutableDictionary! = NSMutableDictionary()
                    let arrayPacket: [AnyObject] = self.array_List.mutableCopy() as! [AnyObject]
                    dictForPacket.setValue(arrayPacket, forKey: "PacketBulkMove")
                    dictForPacket.setValue("\(NSUserDefaults.standardUserDefaults().objectForKey("ApplicationIdentifier") as! String)", forKey: "app_id")
                    
                    self.objwebservice.post(dictForPacket, url: "\(Server.local_server)/api/sptospbulk/sptospmove.php")
                    print("dictForPacket inside \(dictForPacket)")
                    self.OfflineMoveToAnother()
                }
                else
                {
                    self.appDel.Show_HUD()
                    self.OfflineMoveToAnother()
                }
            }));
            
            
            self.presentViewController(alertView, animated: true, completion: nil)
        }
        else
        {
            let alertView = UIAlertController(title: nil, message: "Please Select Pens To Move." , preferredStyle: .Alert)
            alertView.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(alertView, animated: true, completion: nil)
        }
        
    }
    
    
    // MARK: - Webservice NetLost delegate
    func NetworkLost(str: String!)
    {
        if str == "netLost" {
            
            
            self.appDel.remove_HUD()
            
        }
        else if (str == "noResponse")
        {
            
            self.appDel.remove_HUD()
        }
    }

    
    func responseDictionary(dic: NSMutableDictionary)
    {
        if self.str_webservice == "empty_move" {
            self.appDel.remove_HUD()
        }
    }
    
    //MARK: - Check From Bulk Table Available
    func GetPenInBulkTable(dictemp: NSMutableDictionary!)
    {
        let fetchRequest = NSFetchRequest(entityName: "SPMoveBulkTable")
        let predicate = NSPredicate(format: "fromGroup = '\(dictemp["fromGroup"] as! String)' AND from_namexx = '\(dictemp["from_namexx"] as! String)' AND from_nameyy = '\(dictemp["from_nameyy"] as! String)'")
        fetchRequest.predicate = predicate
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.fetchBatchSize = 20
        fetchRequest.resultType = NSFetchRequestResultType.DictionaryResultType
        do
        {
            let results = try self.appDel.managedObjectContext.executeFetchRequest(fetchRequest)
            print(results)
            if results.count > 0 {
                let alertView = UIAlertController(title: nil, message: "You Have Already Added Pen In The List." , preferredStyle: .Alert)
                alertView.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                self.presentViewController(alertView, animated: true, completion: nil)
            }
            else
            {
                
                let fetchRequest1 = NSFetchRequest(entityName: "SPMoveBulkTable")
                let predicate1 = NSPredicate(format: "toGroup = '\(dictemp["toGroup"] as! String)' AND to_namexx = '\(dictemp["to_namexx"] as! String)' AND to_nameyy = '\(dictemp["to_nameyy"] as! String)'")
                fetchRequest1.predicate = predicate1
                fetchRequest1.returnsObjectsAsFaults = false
                fetchRequest1.fetchBatchSize = 20
                fetchRequest1.resultType = NSFetchRequestResultType.DictionaryResultType
                do
                {
                    let results1 = try self.appDel.managedObjectContext.executeFetchRequest(fetchRequest1)
                    print(results1)
                    if results1.count > 0 {
                        let alertView = UIAlertController(title: nil, message: "You Have Already Added Pen In The List." , preferredStyle: .Alert)
                        alertView.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                        self.presentViewController(alertView, animated: true, completion: nil)
                    }
                    else
                    {
                        var objCoreTable : SPMoveBulkTable!
                        objCoreTable = (NSEntityDescription.insertNewObjectForEntityForName("SPMoveBulkTable", inManagedObjectContext: self.appDel.managedObjectContext) as! SPMoveBulkTable)
                        objCoreTable.fromGroup = dictemp["fromGroup"] as? String
                        objCoreTable.from_namexx = dictemp["from_namexx"] as? String
                        objCoreTable.from_nameyy = dictemp["from_nameyy"] as? String
                        objCoreTable.toGroup = dictemp["toGroup"] as? String
                        objCoreTable.to_namexx = dictemp["to_namexx"] as? String
                        objCoreTable.to_nameyy = dictemp["to_nameyy"] as? String
                        do {
                            try self.appDel.managedObjectContext.save()
                            array_List.addObject(dictemp)
                            
                            if array_List.count > 0 {
                                tableView_Move.reloadData()
                            }
                            
                            self.resetAllPickers()
                        } catch{}
                    }
                }
                catch{}
            }
        } catch {}
    }
    
    
    //MARK: -
    
    func OfflineMoveToAnother()
    {
        
        
        for i in 0 ..< array_List.count {
//          let penid: String! = toPass["PenDetails"]![0]["penid"] as! String
            let fetchRequest = NSFetchRequest(entityName: "EmptyPensTable")
            let predicate = NSPredicate(format: "groupcode = '\(array_List[i]["toGroup"] as! String)' AND namexx = '\(array_List[i]["to_namexx"] as! String)' AND nameyy = '\(array_List[i]["to_nameyy"] as! String)'", argumentArray: nil)
            fetchRequest.predicate = predicate
            fetchRequest.returnsObjectsAsFaults = false
            fetchRequest.fetchBatchSize = 20
            fetchRequest.resultType = NSFetchRequestResultType.DictionaryResultType
            do {
                let results = try self.appDel.managedObjectContext.executeFetchRequest(fetchRequest)
                let ToPen_Array = results as AnyObject
                if ToPen_Array.count > 0
                {
                    let fetchRequest1 = NSFetchRequest(entityName: "SingleAllocatedPen")
                    let predicate1 = NSPredicate(format: "groupcode = '\(array_List[i]["fromGroup"] as! String)' AND namexx = '\(array_List[i]["from_namexx"] as! String)' AND nameyy = '\(array_List[i]["from_nameyy"] as! String)'")
                    fetchRequest1.predicate = predicate1
                    fetchRequest1.returnsObjectsAsFaults = false
                    fetchRequest1.fetchBatchSize = 20
                    
                    let fetchRequest3 = NSFetchRequest(entityName: "SingleAllocatedPen")
                    fetchRequest3.predicate = predicate1
                    
                    fetchRequest3.resultType = NSFetchRequestResultType.DictionaryResultType
                    do {
                        let results1 = try self.appDel.managedObjectContext.executeFetchRequest(fetchRequest1)// from pen array
                        let results_temp = try self.appDel.managedObjectContext.executeFetchRequest(fetchRequest3)
                        let fromPen_Array = results_temp as AnyObject
                        if results1.count > 0 {
                            for k in 0 ..< results1.count {
                                if let objTable: SingleAllocatedPen = results1[k] as? SingleAllocatedPen
                                {
                                    objTable.penid = ToPen_Array[0]["penid"] as? String
                                    objTable.namexx = ToPen_Array[0]["namexx"] as? String
                                    objTable.nameyy = ToPen_Array[0]["nameyy"] as? String
                                    objTable.pennodisp = "\(objTable.namexx!)-\(objTable.nameyy!)"
                                    objTable.groupcode = ToPen_Array[0]["groupcode"] as? String
                                    objTable.groupcodedisp = ToPen_Array[0]["groupcodedisp"] as? String
                                    do
                                    {
                                        try self.appDel.managedObjectContext.save()
                                        
                                        self.SubtractUpDateAddSectionTableEvent(ToPen_Array[0]["groupcode"] as! String)
                                        self.UpDateAddSectionTableEvent(fromPen_Array[0]["groupcode"] as! String)
                                        
                                        self.addToEmptyPen(fromPen_Array[0]["groupcode"] as! String, grpnamedisp: "\(fromPen_Array[0]["groupcode"] as! String) - PEN#", namexx: "\(fromPen_Array[0]["namexx"] as! String)", nameyy: "\(fromPen_Array[0]["nameyy"] as! String)", pennodisp: "\(fromPen_Array[0]["pennodisp"] as! String)", penid: fromPen_Array[0]["penid"] as! String, to_Penid: ToPen_Array[0]["penid"] as! String)
                                        
                                        self.DeleteFromEmptyTable(ToPen_Array[0]["penid"] as! String, groupcode: ToPen_Array[0]["groupcode"] as! String)
                                        
                                        self.resetAllPickers()
                                        if !self.appDel.checkInternetConnection() {
                                            self.saveToUpdateMoveTable(fromPen_Array[0]["penid"] as! String, From_namexx: fromPen_Array[0]["namexx"] as! String, From_nameyy: fromPen_Array[0]["nameyy"] as! String, topen_id: ToPen_Array[0]["penid"] as! String, to_namexx: ToPen_Array[0]["namexx"] as! String, to_nameyy: ToPen_Array[0]["nameyy"] as! String)
                                        }
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
                
                
                // success ...
            } catch{}
        }
        
        self.DeleteFromBulkTable()
        
        
        
    }
    
    //MARK: - update database
    func UpDateAddSectionTableEvent(groupcode: String!) -> AddSectionTable? {
        
        // Define fetch request/predicate/sort descriptors
        let fetchRequest = NSFetchRequest(entityName: "AddSectionTable")
        let predicate = NSPredicate(format: "groupcode = '\(groupcode)'", argumentArray: nil)
        fetchRequest.predicate = predicate
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

    
    //MARK: - update database
    func SubtractUpDateAddSectionTableEvent(groupcode: String!) -> AddSectionTable? {
        
        // Define fetch request/predicate/sort descriptors
        let fetchRequest = NSFetchRequest(entityName: "AddSectionTable")
        let predicate = NSPredicate(format: "groupcode = '\(groupcode)'", argumentArray: nil)
        fetchRequest.predicate = predicate
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.fetchBatchSize = 20
        do {
            let fetchedResults = try appDel.managedObjectContext.executeFetchRequest(fetchRequest)
            if fetchedResults.count != 0 {
                for i in 0 ..< fetchedResults.count {
                    if let objTable: AddSectionTable = fetchedResults[i] as? AddSectionTable {
                        var intvaa : Int = Int(objTable.available! as String)!
                        intvaa = intvaa - 1
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
    
    func addToEmptyPen(groupcode: String, grpnamedisp: String, namexx: String, nameyy: String, pennodisp: String, penid: String, to_Penid: String)
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
    
    func DeleteFromEmptyTable(to_Penid: String, groupcode: String!)
    {
        let fetchRequest1 = NSFetchRequest(entityName: "EmptyPensTable")
        let predicate = NSPredicate(format: "penid == '\(to_Penid)'", argumentArray: nil)
        fetchRequest1.predicate = predicate
        fetchRequest1.returnsObjectsAsFaults = false
        fetchRequest1.fetchBatchSize = 20
        // delete records
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest1)
        
        do {
            try self.appDel.persistentStoreCoordinator.executeRequest(deleteRequest, withContext: self.appDel.managedObjectContext)
            do
            {
                try self.appDel.managedObjectContext.save()
                
            }
            catch{}
        } catch{}
    }
    
    
    func DeleteFromBulkTable()
    { 
            let fetchRequest1 = NSFetchRequest(entityName: "SPMoveBulkTable")
            fetchRequest1.returnsObjectsAsFaults = false
            fetchRequest1.fetchBatchSize = 20
            // delete records
            let deleteRequest1 = NSBatchDeleteRequest(fetchRequest: fetchRequest1)
            
            do {
                try self.appDel.persistentStoreCoordinator.executeRequest(deleteRequest1, withContext: self.appDel.managedObjectContext)
                do
                {
                    try self.appDel.managedObjectContext.save()
                    self.appDel.remove_HUD()
                    self.viewDidAppear(false)
                    self.tableView_Move.reloadData()
                }
                catch{}
            } catch{}
    }
    
    
    func saveToUpdateMoveTable(Frompen_id: String, From_namexx: String, From_nameyy: String, topen_id: String, to_namexx: String, to_nameyy: String)
    {
        var objCoreTable: UpdateMoveToAnother!
        objCoreTable = (NSEntityDescription.insertNewObjectForEntityForName("UpdateMoveToAnother", inManagedObjectContext: self.appDel.managedObjectContext) as! UpdateMoveToAnother)
        objCoreTable.from_xx = From_namexx
        objCoreTable.from_yy = From_nameyy
        objCoreTable.from_penid = Frompen_id
        objCoreTable.to_penid = topen_id
        objCoreTable.to_xx = to_namexx
        objCoreTable.to_yy = to_nameyy
        do {
            try self.appDel.managedObjectContext.save()
            self.appDel.remove_HUD()
            
        } catch {
        }
        
    }
    
    
    func checkIntoBulkTable(group: String!, nameXX: String!, nameYY: String!)
    {
        let fetchRequest1 = NSFetchRequest(entityName: "SPMoveBulkTable")
        var predicate1 = NSPredicate(format: "fromGroup = '\(group)' AND from_namexx = '\(nameXX)' AND from_nameyy = '\(nameYY)'")
        if str_AlloctedOREmpty == "Empty" {
            predicate1 = NSPredicate(format: "toGroup = '\(group)' AND to_namexx = '\(nameXX)' AND to_nameyy = '\(nameYY)'")
        }
        fetchRequest1.predicate = predicate1
        fetchRequest1.returnsObjectsAsFaults = false
        fetchRequest1.fetchBatchSize = 20
        fetchRequest1.resultType = NSFetchRequestResultType.DictionaryResultType
        do
        {
            let results1 = try self.appDel.managedObjectContext.executeFetchRequest(fetchRequest1)
            print(results1)
            if results1.count > 0 {
                let alertView = UIAlertController(title: nil, message: "You Have Already Added Pen In The List." , preferredStyle: .Alert)
                alertView.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                self.presentViewController(alertView, animated: true, completion: nil)
            }
            else
            {
                if str_AlloctedOREmpty == "Allocated" {
                    btn_fromPen.setTitle("\(group)/\(nameXX)-\(nameYY)", forState: .Normal)
                }
                else if str_AlloctedOREmpty == "Empty" {
                    btn_toPen.setTitle("\(group)/\(nameXX)-\(nameYY)", forState: .Normal)
                }
            }
        }catch{}
    }
    
    
    //MARK: - FilterBTnAction
    @IBAction func Filter_BtnAction(sender: UIButton) {
        
        if sender.tag == 101 {
            self.view_filter1.frame = CGRectMake(445, 152, 228, 234)
            if Bool_viewFilter2 {
                self.view_filter1.hidden = true
                self.Bool_viewFilter2 = false
            }
            if !Bool_viewFilter1 {
                str_Message_NoData1 = ""
                str_AlloctedOREmpty = "Allocated"
                self.array_filter1.removeAllObjects()
                self.array_filter1 = ["IFP", "IFTP", "OFP", "RTF"]
                self.str_tableFilter1 = "array2"
                //            dispatch_async(dispatch_get_main_queue()) {
                self.table_filterList1.reloadData()
                //            }
                
                view_filter1.hidden = true
                let transitionOptions = UIViewAnimationOptions.TransitionCurlDown
                UIView.transitionWithView(self.view_filter1, duration: 0.6, options: transitionOptions, animations: {
                    self.view_filter1.hidden = false
                    
                    }, completion: { finished in
                        self.view.userInteractionEnabled = true
                        self.Bool_viewFilter1 = true
                })
                
            }
            else {
                str_AlloctedOREmpty = ""
                let transitionOptions = UIViewAnimationOptions.TransitionCurlUp
                UIView.transitionWithView(self.view_filter1, duration: 0.6, options: transitionOptions, animations: {
                    self.view_filter1.hidden = true
                    
                    }, completion: { finished in
                        
                        self.Bool_viewFilter1 = false
                        self.view.userInteractionEnabled = true
                })
                
            }
        }
        
        else if sender.tag == 102 {
            
            self.view_filter1.frame = CGRectMake(691, 152, 228, 234)
            if Bool_viewFilter1 {
                self.view_filter1.hidden = true
                self.Bool_viewFilter1 = false
            }
            if !Bool_viewFilter2 {
                str_Message_NoData1 = ""
                str_AlloctedOREmpty = "Empty"
                self.array_filter1.removeAllObjects()
                self.array_filter1 = ["IFP", "IFTP", "OFP", "RTF"]
                self.str_tableFilter1 = "array2"
                //            dispatch_async(dispatch_get_main_queue()) {
                self.table_filterList1.reloadData()
                //            }
                
                view_filter1.hidden = true
                let transitionOptions = UIViewAnimationOptions.TransitionCurlDown
                UIView.transitionWithView(self.view_filter1, duration: 0.6, options: transitionOptions, animations: {
                    self.view_filter1.hidden = false
                    
                    }, completion: { finished in
                        self.view.userInteractionEnabled = true
                        self.Bool_viewFilter2 = true
                })
                
            }
            else {
                str_AlloctedOREmpty = ""
                let transitionOptions = UIViewAnimationOptions.TransitionCurlUp
                UIView.transitionWithView(self.view_filter1, duration: 0.6, options: transitionOptions, animations: {
                    self.view_filter1.hidden = true
                    
                    }, completion: { finished in
                        
                        self.Bool_viewFilter2 = false
                        self.view.userInteractionEnabled = true
                })
                
            }
        }
        
    }
    
    @IBAction func CancelFilter_BtnAction(sender: UIButton) {
        str_AlloctedOREmpty = ""
        cancelFilter()
    }
    
    func cancelFilter()
    {
        if Bool_viewFilter1 {
            let transitionOptions = UIViewAnimationOptions.TransitionCurlUp
            UIView.transitionWithView(self.view_filter1, duration: 0.6, options: transitionOptions, animations: {
                self.view_filter1.hidden = true
                
                }, completion: { finished in
                    
                    self.Bool_viewFilter1 = false
            })
        }
        else if Bool_viewFilter2
        {
            let transitionOptions = UIViewAnimationOptions.TransitionCurlUp
            UIView.transitionWithView(self.view_filter1, duration: 0.6, options: transitionOptions, animations: {
                self.view_filter1.hidden = true
                
                }, completion: { finished in
                    
                    self.Bool_viewFilter2 = false
            })
        }
    }
    
    //MARK: - FilterOffline
    
    func GetFilterPenOffline(grp: String!)
    {
        str_Message_NoData1 = ""
        str_tableFilterSelectOption1 = grp
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
            self.array_filter1.removeAllObjects()
            autoreleasepool{
                for i in 0 ..< letterArray.count {
                    self.array_filter1.addObject(letterArray[i])
                }
            }
            self.str_tableFilter1 = "array3"
            
            
            
            self.table_filterList1.reloadData()
            
            
            
        } catch {
            
        }
    }
    
    func uniq<S: SequenceType, E: Hashable where E==S.Generator.Element>(source: S) -> [E] {
        var seen: [E:Bool] = [:]
        return source.filter({ (v) -> Bool in
            return seen.updateValue(true, forKey: v) == nil
        })
    }
    
    
    func GetFilterOfflineRecords(grpcode: String!, pen: String!, type: String!)
    {
        str_tableFilter1 = "array4"
        var fetchRequest = NSFetchRequest(entityName: "SingleAllocatedPen")
        var predicate = NSPredicate(format: "groupcode = %@ AND pennodisp BEGINSWITH[c] %@", str_tableFilterSelectOption1, pen)
        
        if str_AlloctedOREmpty == "Empty" {
            
            fetchRequest = NSFetchRequest(entityName: "EmptyPensTable")
            predicate = NSPredicate(format: "groupcode = %@ AND pennodisp BEGINSWITH[c] %@",
                                            str_tableFilterSelectOption1, pen)
        }
        
        fetchRequest.predicate = predicate
        fetchRequest.fetchBatchSize = 20
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.resultType = NSFetchRequestResultType.DictionaryResultType
        do
        {
            self.appDel.Show_HUD()
            let results = try self.appDel.managedObjectContext.executeFetchRequest(fetchRequest)
            if results.count > 0 {
                str_Message_NoData1 = ""
                self.array_filter1.removeAllObjects()
                let newArray = results as NSArray
                self.array_filter1 =  newArray.mutableCopy() as! NSMutableArray
                print(self.array_filter1)
                self.table_filterList1.reloadData()
                if (self.array_filter1.count != 0)
                {
                    self.sortwithString("pennodisp", bool: true)
                    self.table_filterList1.reloadData()
                }
                self.appDel.remove_HUD()
                
            }
            else
            {
                array_filter1.removeAllObjects()
                str_Message_NoData1 = "NoData"
                self.table_filterList1.reloadData()
                self.appDel.remove_HUD()
            }
        }
        catch{}
        
        
    }
    
    func sortwithString(strKey: String, bool: Bool)
    {
        var newArray = array_filter1 as NSArray
        let descriptor: NSSortDescriptor = NSSortDescriptor(key:strKey, ascending: bool)
        let sortedResults = newArray.sortedArrayUsingDescriptors([descriptor])
        newArray = sortedResults
        self.array_filter1 = newArray.mutableCopy() as! NSMutableArray
        
        
        table_filterList1.reloadData()
        self.table_filterList1.setContentOffset(CGPointZero, animated:true)  // scroll to top
        
    }

    
}