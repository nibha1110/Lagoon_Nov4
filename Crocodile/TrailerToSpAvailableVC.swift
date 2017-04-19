//
//  TrailerToSpAvailableVC.swift
//  Crocodile
//
//  Created by Nibha Aggarwal on 10/17/16.
//  Copyright © 2016 Nibha Aggarwal. All rights reserved.
//

import UIKit
import CoreData

class TrailerToSpAvailableVC: UIViewController, responseProtocol {
    var appDel : AppDelegate!
    var objwebservice : webservice! = webservice()
    
    var toPass : NSMutableDictionary! = NSMutableDictionary()
    var array_List: NSMutableArray! = []
    var array_SkinSize: NSMutableArray! = []
    let arraytemp: NSMutableArray! = []
    var dic_sendToserver : NSMutableDictionary! = NSMutableDictionary()
    let dateFormatter: NSDateFormatter = NSDateFormatter()
    
    var str_webservice: String!
    var str_Skin: String!
    var pickerLabel: UILabel!
    
    var selectedTagSize : Int = 0
    
    @IBOutlet weak var tabelview_GrpList: UITableView!
    @IBOutlet weak var pickerview_Skin: UIPickerView!
    @IBOutlet weak var view_Size: UIView! = UIView()
    @IBOutlet weak var label_Size: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appDel = (UIApplication.sharedApplication().delegate as! AppDelegate)
        guard let controller = self.storyboard!.instantiateViewControllerWithIdentifier("CommonClassVC") as? CommonClassVC
            else {
                fatalError();
        }
        addChildViewController(controller)
        controller.view.frame = CGRectMake(0, 0, 1024, 768)
        controller.array_tableSection = ["add"]
        controller.array_sectionRow = [["SP_ADD_unselected", "Load_to_trailer", "Trailer_to SP_unselected", "All_empty_pens", "Add_animal_unselected"]]
        view.addSubview(controller.view)
        view.sendSubviewToBack(controller.view)
        controller.IIndexPath = NSIndexPath(forRow: 2, inSection: 2)
        controller.label_header.text = "TRAILER TO SP"
        controller.array_temp_section.replaceObjectAtIndex(2, withObject: "Yes")
        controller.tableMenu.reloadData()
        let arrt = controller.array_temp_row[2]
        arrt.replaceObjectAtIndex(2, withObject: "Yes")
        array_SkinSize = controller.array_Skin
        objwebservice?.delegate = self
        
        str_Skin = "Select Size"
        
    }
    
    
    override func viewDidAppear(animated: Bool) {
        
        self.GetGroupNameDetailService()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - GetGroupNameDetailService
    func GetGroupNameDetailService()
    {
        if self.appDel.checkInternetConnection() {
            appDel.Show_HUD()
            str_webservice = "getavlpens"
            let request = NSMutableURLRequest(URL: NSURL(string: "\(Server.local_server)/api/singlepen/getavlpens.php?")!)
            let postString = "grpcode=\(toPass["group"] as! String)"
            objwebservice.callServiceCommon(request, postString: postString)
        }
        else
        {
            HelperClass.MessageAletOnly(Server.noInternet, selfView: self)
        }
        
    }
    
    
    // MARK: -  tableview Delegates
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(array_List.count)
        if array_List.count == 0 {
            return 1
        }
        
        return array_List.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        
        //view Backgd
        let view_bg: UIView = UIView(frame: CGRectMake(0, 0, 709, 75))
        if indexPath.row % 2 == 0 {
            view_bg.backgroundColor = UIColor.whiteColor()
        }
        else {
            view_bg.backgroundColor = UIColor(red: 241.0 / 255.0, green: 241 / 255.0, blue: 241 / 255.0, alpha: 1.0)
        }
        
        
        //label_Grp
        let label_Grp: UILabel = UILabel(frame: CGRectMake(20, 13, 150, 50))
        label_Grp.textAlignment = .Center
        label_Grp.font = UIFont(name: "HelveticaNeue", size: 26)
        
        if array_List.count == 0 {
            label_Grp.frame = CGRectMake(20, 13, 500, 50)
            label_Grp.text = "There Is No Pen Available."
            label_Grp.textAlignment = .Left
            view_bg.addSubview(label_Grp)
            cell.contentView .addSubview(view_bg)
            return cell
        }
        
        
        label_Grp.text = array_List[indexPath.row]["grpnamedisp"] as? String
        
        
        //orange image
        let img_orange: UIImageView = UIImageView(frame: CGRectMake(180, 8, 170, 56))
        img_orange.image = UIImage(named: "xxyy")
        
        //label_pens
        let label_pens: UILabel = UILabel(frame: CGRectMake(180, 8, 170, 56))
        label_pens.textAlignment = .Center
        label_pens.textColor = UIColor.whiteColor()
        label_pens.font = UIFont(name: "HelveticaNeue", size: 23)
        label_pens.text = array_List[indexPath.row]["pennodisp"] as? String
        
        //btn_Size
        let btn_Size: UIButton = UIButton(frame: CGRectMake(350, 10, 150, 52))
        btn_Size.addTarget(self, action: #selector(InspectionListVC.SizeBtnAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        btn_Size.setTitleColor(UIColor.blackColor(), forState: .Normal)
        btn_Size.titleLabel!.font = UIFont(descriptor: UIFontDescriptor(name: "HelveticaNeue", size: 23), size: 23.0)
        btn_Size.setTitle("\(array_List[indexPath.row]["skinsize"] as! String)", forState: .Normal)
        
        if (array_List[indexPath.row]["skinsize"] as! String == "")
        {
            btn_Size.setTitle("Select Size", forState: .Normal)
        }
        btn_Size.tag = indexPath.row
        
        
        //img_down
        let img_down1: UIImageView = UIImageView(frame: CGRectMake(500, 32, 10, 6))
        img_down1.image = UIImage(named: "downarrow")
        
        //CheckMark image
        let btn_check: UIButton = UIButton(frame: CGRectMake(560, 18, 40, 35))
        if (array_List[indexPath.row]["state"] as! String == "NO") {
            btn_check.setImage(UIImage(named: "Checkbox_NoTick"), forState: .Normal)
        }
        else {
            btn_check.setImage(UIImage(named: "Checkbox_tick"), forState: .Normal)
        }
        btn_check.addTarget(self, action: #selector(TrailerToSpAvailableVC.radioBtnAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        btn_check.tag = indexPath.row
        
        view_bg.addSubview(img_orange)
        view_bg.addSubview(label_pens)
        view_bg.addSubview(label_Grp)
        view_bg.addSubview(btn_Size)
        view_bg.addSubview(img_down1)
        view_bg.addSubview(btn_check)
        
        cell.contentView .addSubview(view_bg)
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
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
            tabelview_GrpList.reloadData()
            
            
        }
        else
        {
            btn.setImage(img, forState: .Normal)
            
            var data = NSMutableDictionary()
            let newdata = array_List[selectedTag] as! NSDictionary
            data = newdata.mutableCopy() as! NSMutableDictionary
            data.setObject("NO", forKey:"state")
            array_List[selectedTag] = data
            tabelview_GrpList.reloadData()
            
        }
        tabelview_GrpList .reloadData()
        
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
        return pickerLabel
    }
    
    
    
    func pickerView(pickerView: UIPickerView!, didSelectRow row: Int, inComponent component: Int)
    {
        if pickerView == pickerview_Skin {
            
            str_Skin = array_SkinSize![row] as! String
        }
        
    }
    
    //MARK: - SizeBtnAction
    @IBAction func SizeBtnAction(sender: UIButton) {
        
        let btn: UIButton = sender
        selectedTagSize = btn.tag
        view_Size.hidden = false
        
        label_Size.text = array_List[selectedTagSize]["pennodisp"] as? String
        
        self.pickerview_Skin.reloadAllComponents()
        
    }
    
    
    @IBAction func cancelSizeMethod(sender: UIButton) {
        view_Size.hidden = true
    }
    
    
    @IBAction func DoneSizeMethod(sender: UIButton) {
        view_Size.hidden = true
        var data = NSMutableDictionary()
        let newdata = array_List[selectedTagSize] as! NSDictionary
        data = newdata.mutableCopy() as! NSMutableDictionary
        data.setObject(str_Skin, forKey:"skinsize")
        if str_Skin == "Select Size"
        {
            str_Skin = ""
            data.setObject("", forKey:"skinsize")
        }
        
        array_List[selectedTagSize] = data
        print(data)
        tabelview_GrpList.reloadData()
    }

    
    // MARK: - Webservice delegate
    func responseDictionary(dic: NSMutableDictionary) {
        
        print(toPass)
        
        if str_webservice == "getavlpens" {
            self.array_List = dic["EmptyPens"] as! NSMutableArray
            
            let newArray = dic["EmptyPens"] as! NSArray
            self.array_List =  newArray.mutableCopy() as! NSMutableArray
            for i in 0 ..< self.array_List.count {
                let dict = self.array_List[i].mutableCopy() as! NSMutableDictionary
                dict["state"] = "NO"
                dict["skinsize"] = ""
                dict["trailerid"] = toPass["trailerid"] as! String
                dict["graderid"] = toPass["grader"] as! String
                dict["app_id"] = "\(NSUserDefaults.standardUserDefaults().objectForKey("ApplicationIdentifier") as! String)"
                self.array_List[i] = dict
            }
            
            self.tabelview_GrpList.reloadData()
        }
        else if (self.str_webservice == "trailersp")
        {
            if dic["success"] as! String == "True" {
                let alertView = UIAlertController(title: nil, message: "\(dic["Message"] as! String)", preferredStyle: .Alert)
            alertView.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: {(action:UIAlertAction) in
                for controller in self.navigationController!.viewControllers as Array {
                    if controller.isKindOfClass(TrailerToSPListVC) {
                        self.navigationController?.popToViewController(controller as UIViewController, animated: false)
                    }
                }
            }));
                self.presentViewController(alertView, animated: true, completion: nil)
            }
            else
            {
                HelperClass.MessageAletOnly("\(dic["Message"] as! String)", selfView: self)
            }
        }
        self.appDel.remove_HUD()
    }
    
    // MARK: - Webservice NetLost delegate
    func NetworkLost(str: String!)
    {
        HelperClass.NetworkLost(str, view1: self)
    }
    
    //MARK: - radioBtnAction
    @IBAction func SubmitBtnAction(sender: UIButton) {
        
        
        let stateStr : String = "YES"
        let resultPredicate = NSPredicate(format: "state contains[c] %@", stateStr)
        let aNames: [AnyObject] = self.array_List.filteredArrayUsingPredicate(resultPredicate)
        if aNames.count != 0 {
            
            if ((toPass["qty"] as! String).toInteger() < aNames.count)
            {
                HelperClass.MessageAletOnly("Selected Pens are Greater Than Quantity Available.", selfView: self)
            }
            else {
                let alertView = UIAlertController(title: nil, message: "Are You Sure To Add Selected Pens?", preferredStyle: .Alert)
                alertView.addAction(UIAlertAction(title: "NO", style: .Cancel, handler: nil))
                alertView.addAction(UIAlertAction(title: "YES", style: UIAlertActionStyle.Default, handler: {(action:UIAlertAction) in
                    
                    self.arraytemp.removeAllObjects()
                    self.dic_sendToserver.setValue(aNames, forKey: "TrailerToSP")
                    print(self.dic_sendToserver)
                   
                    if self.appDel.checkInternetConnection() {
                        self.appDel.Show_HUD()
                        self.str_webservice = "trailersp"
                        self.offline(aNames)
                        self.objwebservice.post(self.dic_sendToserver, url: "\(Server.local_server)/api/trailer/trailersp.php")
                    }
 
                }));
                self.presentViewController(alertView, animated: true, completion: nil)
            }
            
        }
        else
        {
            HelperClass.MessageAletOnly("Please Select Pen.", selfView: self)
        }
    }
    
    func offline(aNames : AnyObject)
    {
        print(aNames)
        for i in 0 ..< aNames.count {
            if (true) {
                
                let fetchRequest1 = NSFetchRequest(entityName: "EmptyPensTable")
                let predicate = NSPredicate(format: "penid == '\(aNames[i]["penid"] as! String)'", argumentArray: nil)
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
                
                ///
            }
            
            
            
            
            
            
            if (true)
            {
                var objCoreTable: SingleAllocatedPen!
                objCoreTable = (NSEntityDescription.insertNewObjectForEntityForName("SingleAllocatedPen", inManagedObjectContext: self.appDel.managedObjectContext) as! SingleAllocatedPen)
                
                
                objCoreTable.pennodisp = "\(aNames[i]["pennodisp"] as! String)".stringByReplacingOccurrencesOfString(" ", withString: "")
                var arraytemp = "\(objCoreTable.pennodisp!)".componentsSeparatedByString("-")
                
                objCoreTable.namexx = "\(arraytemp[0] as String)"
                objCoreTable.nameyy = "\(arraytemp[1] as String)"
                
                
                //                objCoreTable.namexx = "\(self.toPass_array[5] as! String)"
                //                objCoreTable.nameyy = "\(self.toPass_array[7] as! String)"
                objCoreTable.pennodisp = "\(objCoreTable.pennodisp!)"
                objCoreTable.penid = (aNames[i]["penid"] as! String)
                objCoreTable.skin_size = (aNames[i]["skinsize"] as! String)
                objCoreTable.recheckcount = "0"
                objCoreTable.int_recheckcount = objCoreTable.recheckcount?.toInteger()
                objCoreTable.state = aNames[i]["state"] as? String
                objCoreTable.comment = ""
                
                objCoreTable.groupcode = "\(aNames[i]["groupcode"] as! String)"
                objCoreTable.groupcodedisp = "\(objCoreTable.groupcode!) -PEN#"
                
                print("\(self.todaydate())")
                objCoreTable.dateadded = self.todaydate() as String
                
                
                // to adding months in entry date
                let monthsCount: Int! = Int("8")
                objCoreTable.entrydate = self.months_BetweenDate(objCoreTable.dateadded, recheck: monthsCount) as String
                objCoreTable.entryConvert = self.Databse_dateconvertor(objCoreTable.entrydate)
                objCoreTable.addedConvert = self.Databse_dateconvertor(objCoreTable.dateadded)
                objCoreTable.colorcode = "BLACK"
                objCoreTable.ispink = "0"
                print(objCoreTable)
                do {
                    try self.appDel.managedObjectContext.save()
                    
                } catch {}
            }
            
        }
        
    }
    //MARK: -
    func months_BetweenDate(currentstrDate: NSString!, recheck: Int!) -> NSString {
        let dateComponents: NSDateComponents = NSDateComponents()
        dateComponents.month = recheck
        let calendar: NSCalendar = NSCalendar.currentCalendar()
        
        var currentDate: NSDate! = NSDate()
        let twelveHourLocale: NSLocale = NSLocale(localeIdentifier: "en_US_POSIX")
        dateFormatter.locale = twelveHourLocale
        dateFormatter.dateFormat = "dd/MM/yyyy"
        currentDate = dateFormatter.dateFromString(currentstrDate as String)
        
        let newDate: NSDate = calendar.dateByAddingComponents(dateComponents, toDate: currentDate, options: NSCalendarOptions(rawValue: 0))!
        
        let SStr_date = "\(dateFormatter.stringFromDate(newDate))"
        return SStr_date
    }
    
    func Databse_dateconvertor(datestr: String!) -> NSDate
    {
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
        let todayDate: String = "\(dateFormatter.stringFromDate(NSDate()))"
        return todayDate
    }

}
