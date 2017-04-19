//
//  MoveSectionVC.swift
//  Crocodile
//
//  Created by Nibha Aggarwal on 6/21/16.
//  Copyright © 2016 Nibha Aggarwal. All rights reserved.
//

import UIKit
import CoreData

class MoveSectionVC: UIViewController , responseProtocol, CommonClassProtocol {
    var appDel : AppDelegate!
    var objwebservice : webservice! = webservice()
    @IBOutlet weak var pickerview1_movePen: UIPickerView!
    @IBOutlet weak var pickerview2_movePen: UIPickerView!
    @IBOutlet weak var pickerview3_movePen: UIPickerView!
    
    @IBOutlet weak var pickerview1_animalMoved: UIPickerView!
    @IBOutlet weak var pickerview2_animalMoved: UIPickerView!
    @IBOutlet weak var pickerview3_animalMoved: UIPickerView!
    
    @IBOutlet weak var pickerview1_moveToPen: UIPickerView!
    @IBOutlet weak var pickerview2_moveToPen: UIPickerView!
    @IBOutlet weak var pickerview3_moveToPen: UIPickerView!
    
    @IBOutlet weak var label_move: UILabel!
    @IBOutlet weak var view_moveToPen: UIView!
    @IBOutlet weak var btn_backW: UIButton!
    
    var str_MovePen1: NSString!
    var str_MovePen2: NSString!
    var str_MovePen3: NSString!
    var str_Animal1: NSString!
    var str_Animal2: NSString!
    var str_Animal3: NSString!
    
    var str_MoveToPen1: NSString!
    var str_MoveToPen2: NSString!
    var str_MoveToPen3: NSString!
    
    var str_TotalAnimal: String!
    var str_webservice: NSString!

    
    var pickerLabel: UILabel!
    
    var array_Group: NSMutableArray = []
    var array_X : NSMutableArray = []
    var array_SinglePens: NSMutableArray = []
    var array_AnimalCount: NSMutableArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let controller = self.storyboard!.instantiateViewControllerWithIdentifier("CommonClassVC") as? CommonClassVC
            else {
                fatalError();
        }
        addChildViewController(controller)
        controller.view.frame = CGRectMake(0, 0, 1024, 768)
        
        controller.array_tableSection = ["move_left"]
        controller.array_sectionRow = [["Move_Hatchlings_UnSel", "move_left", "add_to_dieBLUE", "add_to_killBLUE", "Sp_move_blue", "GroupAverage_blue"]]
        view.addSubview(controller.view)
        view.sendSubviewToBack(controller.view)
        controller.IIndexPath = NSIndexPath(forRow: 1, inSection: 1)
        controller.tableMenu.reloadData()
        controller.label_header.text = "MOVE"
        controller.btn_Sync.hidden = false
        controller.img_Sync.hidden = false
        controller.btn_BackPop.hidden = true
        controller.array_temp_section.replaceObjectAtIndex(1, withObject: "Yes")
        let arrt = controller.array_temp_row[1]
        arrt.replaceObjectAtIndex(1, withObject: "Yes")
        
        controller.delegate = self
        
        objwebservice?.delegate = self
        appDel = (UIApplication.sharedApplication().delegate as! AppDelegate)
        
        for i in 1 ..< 5{
            array_Group.addObject("Y\(i)")
        }
        
        
        for char in "ABCDEFGHIJKLMNOP".characters {
            array_X.addObject("\(char)")
        }
        
        for i in 1 ..< 11{
            array_SinglePens.addObject("\(i)")
        }
        for i in 0 ..< 10{
            array_AnimalCount.addObject("\(i)")
        }
        
        pickerview1_movePen.reloadAllComponents()
        pickerview1_movePen.selectRow(0, inComponent: 0, animated: true)  //Y1
        
        pickerview2_movePen.reloadAllComponents()
        pickerview2_movePen.selectRow(0, inComponent: 0, animated: true)  //0
        
        pickerview3_movePen.reloadAllComponents()
        pickerview3_movePen.selectRow(0, inComponent: 0, animated: true)  //0
        
        pickerview1_animalMoved.reloadAllComponents()
        pickerview1_animalMoved.selectRow(0, inComponent: 0, animated: true)  //0
        
        pickerview2_animalMoved.reloadAllComponents()
        pickerview2_animalMoved.selectRow(0, inComponent: 0, animated: true)  //0
        
        pickerview3_animalMoved.reloadAllComponents()
        pickerview3_animalMoved.selectRow(0, inComponent: 0, animated: true)  //0
        
        pickerview1_moveToPen.reloadAllComponents()
        pickerview2_moveToPen.reloadAllComponents()
        pickerview3_moveToPen.reloadAllComponents()
        
        pickerview1_moveToPen.selectRow(0, inComponent: 0, animated: true)  //0
        pickerview2_moveToPen.selectRow(0, inComponent: 0, animated: true)  //0
        pickerview3_moveToPen.selectRow(0, inComponent: 0, animated: true)  //0
        
        str_MovePen1 = array_Group[0] as! String
        str_MovePen2 = "A"
        str_MovePen3 = "1"
        str_Animal1 = "0"
        str_Animal2 = "0"
        str_Animal3 = "0"
        str_MoveToPen1 = "Y1"
        str_MoveToPen2 = "A"
        str_MoveToPen3 = "1"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: -  CommonClass Delegate
    func responseCommonClassOffline() {
        
    }
    

    // MARK: - PickerView Delegates
    func numberOfComponentsInPickerView(pickerView: UIPickerView!) -> Int{
        return 1
    }
    
    // returns the # of rows in each component..
    func pickerView(pickerView: UIPickerView!, numberOfRowsInComponent component: Int) -> Int{
        
        if pickerView == pickerview1_movePen || pickerView == pickerview1_moveToPen
        {
            return array_Group.count
        }
        else if pickerView == pickerview2_movePen || pickerView == pickerview2_moveToPen
        {
            return array_X.count
        }
        else if pickerView == pickerview3_movePen || pickerView == pickerview3_moveToPen
        {
            return array_SinglePens.count
        }
        
        return array_AnimalCount.count
    }
    
    func pickerView(pickerView: UIPickerView!, titleForRow row: Int, forComponent component: Int) -> String! {
        if pickerView == pickerview1_movePen || pickerView == pickerview1_moveToPen {
            return array_Group[row] as! String
        }
        else if pickerView == pickerview2_movePen || pickerView == pickerview2_moveToPen
        {
            return array_X[row] as! String
        }
        else if pickerView == pickerview3_movePen || pickerView == pickerview3_moveToPen
        {
            return array_SinglePens[row] as! String
        }
        return array_AnimalCount[row] as! String
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
        if pickerView == pickerview1_movePen || pickerView == pickerview1_moveToPen {
            pickerLabel.text = array_Group[row] as? String
        }
        else if pickerView == pickerview2_movePen || pickerView == pickerview2_moveToPen
        {
            pickerLabel.text = array_X[row] as? String
        }
        else if pickerView == pickerview3_movePen || pickerView == pickerview3_moveToPen
        {
            pickerLabel.text = array_SinglePens[row] as? String
        }
        else
        {
            pickerLabel.text = array_AnimalCount[row] as? String
        }
        
        return pickerLabel
    }
    
    func pickerView(pickerView: UIPickerView!, didSelectRow row: Int, inComponent component: Int)
    {
        var max1: Int = 0
        var max2: Int = 0
        var max3: Int = 0
        
        var rowIndex: Int = row
        
        if pickerView == pickerview1_movePen {
            str_MovePen1 = array_Group[row] as! String
        }
        else if pickerView == pickerview2_movePen {
            str_MovePen2 = array_X[row] as! String
        }
        else if pickerView == pickerview3_movePen {
            str_MovePen3 = array_SinglePens[row] as! String
        }
        else if pickerView == pickerview1_animalMoved {
            str_Animal1 = array_AnimalCount[row] as! String
        }
        else if pickerView == pickerview2_animalMoved {
            str_Animal2 = array_AnimalCount[row] as! String
        }
        else if pickerView == pickerview3_animalMoved {
            str_Animal3 = array_AnimalCount[row] as! String
        }
        else if pickerView == pickerview1_moveToPen {
            str_MoveToPen1 = array_Group[row] as! String
        }
        else if pickerView == pickerview2_moveToPen {
            str_MoveToPen2 = array_X[row] as! String
        }
        else if pickerView == pickerview3_moveToPen {
            str_MoveToPen3 = array_SinglePens[row] as! String
        }
        
        return

        
        if pickerView == pickerview1_movePen {
            str_MovePen1 = array_Group[row] as! NSString
            pickerview2_movePen.selectRow(0, inComponent: 0, animated: true)
            str_MovePen2 = array_SinglePens[0] as! NSString
            pickerview3_movePen.selectRow(0, inComponent: 0, animated: true)
            str_MovePen3 = array_SinglePens[0] as! NSString
        }
        
        //
        if str_MovePen1 == "Y1" {
            max1 = 2
            max2 = 0
            max3 = 9
            if pickerView == pickerview2_movePen {
                if row > max1 {
                    rowIndex = max1
                    pickerView.selectRow(max1, inComponent: 0, animated: true)
                    if pickerview3_movePen.selectedRowInComponent(0) > max2 {
                        pickerview3_movePen.selectRow(max2, inComponent: 0, animated: true)
                        str_MovePen3 = array_SinglePens[max2] as! NSString
                        
                    }
                    
                }
                else if row == max1 {
                    pickerview3_movePen.selectRow(max2, inComponent: 0, animated: true)
                    
                }
                str_MovePen2 = array_SinglePens[rowIndex] as! NSString
            }
            else if pickerView == pickerview3_movePen {
                if pickerview2_movePen.selectedRowInComponent(0) == max1 {
                    if row > max2 {
                        rowIndex = max2
                        pickerView.selectRow(max2, inComponent: 0, animated: true)
                        
                    }
                }
                str_MovePen3 = array_SinglePens[rowIndex] as! NSString
            }
            
        }
        else if(str_MovePen1 == "Y2")
        {
            max1 = 0
            max2 = 8
            max3 = 5
            if pickerView == pickerview2_movePen {
                if row > max1 {
                    rowIndex = max1
                    pickerView.selectRow(max1, inComponent: 0, animated: true)
                    if pickerview3_movePen.selectedRowInComponent(0) > max2 {
                        pickerview3_movePen.selectRow(max2, inComponent: 0, animated: true)
                        str_MovePen3 = array_SinglePens[max2] as! NSString
                        
                    }
                }
                str_MovePen2 = array_SinglePens[rowIndex] as! NSString
            }
            else if pickerView == pickerview3_movePen {
                if pickerview2_movePen.selectedRowInComponent(0) == max1 {
                    if row > max2 {
                        rowIndex = max2
                        pickerView.selectRow(max2, inComponent: 0, animated: true)
                        
                    }
                }
                if row == max2 {
                    //[pickerview4_movePen selectRow:max3 inComponent:0 animated:YES];
                    
                }
                str_MovePen3 = array_SinglePens[rowIndex] as! NSString
            }
            
        }
        else if(str_MovePen1 == "Y3")
        {
            max1 = 0;
            max2 = 5;
            max3 = 8;
            if (pickerView == pickerview2_movePen)
            {
                if(row > max1){
                    rowIndex = max1
                    pickerView.selectRow(max1, inComponent: 0, animated: true)
                    if pickerview3_movePen.selectedRowInComponent(0) > max2 {
                        pickerview3_movePen.selectRow(max2, inComponent: 0, animated: true)
                        str_MovePen3 = array_SinglePens[max2] as! NSString
                        
                    }

                }
                str_MovePen2 = array_SinglePens[rowIndex] as! NSString

                
                
            }
            else if (pickerView == pickerview3_movePen)
            {
                if pickerview2_movePen.selectedRowInComponent(0) == max1 {
                    if row > max2 {
                        rowIndex = max2
                        pickerView.selectRow(max2, inComponent: 0, animated: true)
                        
                    }
                }

                if row == max2 {
                                    }
                
                str_MovePen3 = array_SinglePens[rowIndex] as! NSString

            }
            
        }
        else if(str_MovePen1 == "Y4")
        {
            max1 = 0;
            max2 = 7;
            max3 = 6;
            if pickerView == pickerview2_movePen {
                if row > max1 {
                    rowIndex = max1
                    pickerView.selectRow(max1, inComponent: 0, animated: true)
                    if pickerview3_movePen.selectedRowInComponent(0) > max2 {
                        pickerview3_movePen.selectRow(max2, inComponent: 0, animated: true)
                        str_MovePen3 = array_SinglePens[max2] as! NSString
                        
                    }
                }
                str_MovePen2 = array_SinglePens[rowIndex] as! NSString
            }
            else if pickerView == pickerview3_movePen {
                if pickerview2_movePen.selectedRowInComponent(0) == max1 {
                    if row > max2 {
                        rowIndex = max2
                        pickerView.selectRow(max2, inComponent: 0, animated: true)
                        
                    }
                }
                if row == max2 {
                    //[pickerview4_movePen selectRow:max3 inComponent:0 animated:YES];
                    
                }
                
                
                str_MovePen3 = array_SinglePens[rowIndex] as! NSString

            }
            

        }
        
        //
        if pickerView == pickerview1_moveToPen {
            str_MoveToPen1 = array_Group[row] as! NSString
            pickerview2_moveToPen.selectRow(0, inComponent: 0, animated: true)
            str_MoveToPen2 = array_SinglePens[0] as! NSString
            pickerview3_moveToPen.selectRow(0, inComponent: 0, animated: true)
            str_MoveToPen3 = array_SinglePens[0] as! NSString
            
        }
        
        //
        if str_MoveToPen1 == "Y1" {
            max1 = 2
            max2 = 0
            max3 = 9
            if pickerView == pickerview2_moveToPen {
                if row > max1 {
                    rowIndex = max1
                    pickerView.selectRow(max1, inComponent: 0, animated: true)
                    if pickerview3_moveToPen.selectedRowInComponent(0) > max2 {
                        pickerview3_moveToPen.selectRow(max2, inComponent: 0, animated: true)
                        str_MoveToPen3 = array_SinglePens[max2] as! NSString
                        
                    }
                    
                }
                else if row == max1 {
                    pickerview3_moveToPen.selectRow(max2, inComponent: 0, animated: true)
                    
                }
                str_MoveToPen2 = array_SinglePens[rowIndex] as! NSString
            }
            else if pickerView == pickerview3_moveToPen {
                if pickerview2_moveToPen.selectedRowInComponent(0) == max1 {
                    if row > max2 {
                        rowIndex = max2
                        pickerView.selectRow(max2, inComponent: 0, animated: true)
                        
                    }
                }
                str_MoveToPen3 = array_SinglePens[rowIndex] as! NSString
            }
            
        }
        else if(str_MoveToPen1 == "Y2")
        {
            max1 = 0
            max2 = 8
            max3 = 5
            if pickerView == pickerview2_moveToPen {
                if row > max1 {
                    rowIndex = max1
                    pickerView.selectRow(max1, inComponent: 0, animated: true)
                    if pickerview3_moveToPen.selectedRowInComponent(0) > max2 {
                        pickerview3_moveToPen.selectRow(max2, inComponent: 0, animated: true)
                        str_MoveToPen3 = array_SinglePens[max2] as! NSString
                        
                    }
                }
                str_MoveToPen2 = array_SinglePens[rowIndex] as! NSString
            }
            else if pickerView == pickerview3_moveToPen {
                if pickerview2_moveToPen.selectedRowInComponent(0) == max1 {
                    if row > max2 {
                        rowIndex = max2
                        pickerView.selectRow(max2, inComponent: 0, animated: true)
                        
                    }
                }
                if row == max2 {
                    //[pickerview4_moveToPen selectRow:max3 inComponent:0 animated:YES];
                    
                }
                str_MoveToPen3 = array_SinglePens[rowIndex] as! NSString
            }
            
        }
        else if(str_MoveToPen1 == "Y3")
        {
            max1 = 0;
            max2 = 5;
            max3 = 8;
            if (pickerView == pickerview2_moveToPen)
            {
                if(row > max1){
                    rowIndex = max1
                    pickerView.selectRow(max1, inComponent: 0, animated: true)
                    if pickerview3_moveToPen.selectedRowInComponent(0) > max2 {
                        pickerview3_moveToPen.selectRow(max2, inComponent: 0, animated: true)
                        str_MoveToPen3 = array_SinglePens[max2] as! NSString
                        
                    }
                    
                }
                str_MoveToPen2 = array_SinglePens[rowIndex] as! NSString
                
                
                
            }
            else if (pickerView == pickerview3_moveToPen)
            {
                if pickerview2_moveToPen.selectedRowInComponent(0) == max1 {
                    if row > max2 {
                        rowIndex = max2
                        pickerView.selectRow(max2, inComponent: 0, animated: true)
                        
                    }
                }
                
                if row == max2 {
                    
                }
                
                str_MoveToPen3 = array_SinglePens[rowIndex] as! NSString
                
            }
            
        }
        else if(str_MoveToPen1 == "Y4")
        {
            max1 = 0;
            max2 = 7;
            max3 = 6;
            if pickerView == pickerview2_moveToPen {
                if row > max1 {
                    rowIndex = max1
                    pickerView.selectRow(max1, inComponent: 0, animated: true)
                    if pickerview3_moveToPen.selectedRowInComponent(0) > max2 {
                        pickerview3_moveToPen.selectRow(max2, inComponent: 0, animated: true)
                        str_MoveToPen3 = array_SinglePens[max2] as! NSString
                        
                    }
                }
                str_MoveToPen2 = array_SinglePens[rowIndex] as! NSString
            }
            else if pickerView == pickerview3_moveToPen {
                if pickerview2_moveToPen.selectedRowInComponent(0) == max1 {
                    if row > max2 {
                        rowIndex = max2
                        pickerView.selectRow(max2, inComponent: 0, animated: true)
                        
                    }
                }
                if row == max2 {
                    //[pickerview4_moveToPen selectRow:max3 inComponent:0 animated:YES];
                    
                }
                
                
                str_MoveToPen3 = array_SinglePens[rowIndex] as! NSString
                
            }
            
            
        }

        
        str_TotalAnimal = "\(str_Animal1)\(str_Animal2)\(str_Animal3)"
        
    }
    
    //MARK: -  addAnimaltoPen
    func addAnimaltoPen()
    {
        if self.appDel.checkInternetConnection() {
            str_webservice = "empty_move_add"
            appDel.Show_HUD()
            let request = NSMutableURLRequest(URL: NSURL(string: "\(Server.local_server)/api/animals/empty_move_add.php?")!)
            let postString = "noofanimals=\(str_TotalAnimal)&group=\(str_MovePen1)&tonamexx=\(str_MovePen2)&tonameyy=\(str_MovePen3)&movedby=\(NSUserDefaults.standardUserDefaults().objectForKey("email_username") as! String)&app_id=\(NSUserDefaults.standardUserDefaults().objectForKey("ApplicationIdentifier") as! String)"
            objwebservice.callServiceCommon(request, postString: postString)
        }
    }
    
    //MARK: - Empty Button
    @IBAction func Empty_btnAction(sender: AnyObject) {
       
            
            let alertView = UIAlertController(title: nil, message: "Are You Sure You Want To Empty #\(str_MovePen1)-\(str_MovePen2)\(str_MovePen3)?", preferredStyle: .Alert)
            alertView.addAction(UIAlertAction(title: "NO", style: .Cancel, handler: nil))
            alertView.addAction(UIAlertAction(title: "YES", style: .Default, handler: {(action:UIAlertAction) in
                if self.appDel.checkInternetConnection() {
                    self.str_webservice = "empty_move_sub"
                    self.appDel.Show_HUD()
                    let request = NSMutableURLRequest(URL: NSURL(string: "\(Server.local_server)/api/animals/empty_move_sub.php?")!)
                    let postString = "groupname=\(self.str_MovePen1)&fromnamexx=\(self.str_MovePen2)&fromnameyy=\(self.str_MovePen3)&movedby=\(NSUserDefaults.standardUserDefaults().objectForKey("email_username") as! String)&app_id=\(NSUserDefaults.standardUserDefaults().objectForKey("ApplicationIdentifier") as! String)"
                    self.objwebservice.callServiceCommon(request, postString: postString)
                }
                else
                {
                    self.UpdateAnimalsCountTable()
                }
            }));
            

            self.presentViewController(alertView, animated: true, completion: nil)
    }
    
    
    func UpdateAnimalsCountTable()
    {
        // Define fetch request/predicate/sort descriptors
        let fetchRequest = NSFetchRequest(entityName: "AnimalsCountTable")
        let predicate = NSPredicate(format: "count_namexx = '\(str_MovePen2)' and count_nameyy = '\(str_MovePen3)' and groupname = '\(str_MovePen1)'")
        fetchRequest.predicate = predicate
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let fetchedResults = try appDel.managedObjectContext.executeFetchRequest(fetchRequest)
            if fetchedResults.count != 0 {
                for i in 0 ..< fetchedResults.count {
                    if let objTable: AnimalsCountTable = fetchedResults[i] as? AnimalsCountTable {
                        objTable.total_animals = "0"
                        do {
                            try self.appDel.managedObjectContext.save()
                            self.InsertToAnimalgroupEmpty()
                        } catch {
                        }}}}
            else
            {
                HelperClass.MessageAletOnly("Pen Does Not Exist.", selfView: self)
            }
        }catch  {
            
        }
    }
    
    
    func InsertToAnimalgroupEmpty()
    {
        let fetchRequest = NSFetchRequest(entityName: "AnimalgroupEmpty")
        let predicate = NSPredicate(format: "namexx = '\(str_MovePen2)' AND nameyy = '\(str_MovePen3)' AND groupname = '\(str_MovePen1)'")
        fetchRequest.predicate = predicate
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.fetchBatchSize = 20
        do {
            let fetchedResults = try appDel.managedObjectContext.executeFetchRequest(fetchRequest)
            if fetchedResults.count != 0 {
                    do {
                        try self.appDel.managedObjectContext.save()
                        HelperClass.MessageAletOnly("Successfully Moved To Empty.", selfView: self)
                        
                    } catch {}
//                }
            }
            else
            {
                
                var objCoreTable: AnimalgroupEmpty!
                objCoreTable = (NSEntityDescription.insertNewObjectForEntityForName("AnimalgroupEmpty", inManagedObjectContext: self.appDel.managedObjectContext) as! AnimalgroupEmpty)
                objCoreTable.groupname = "\(str_MovePen1)"
                objCoreTable.namexx = "\(str_MovePen2)"
                objCoreTable.nameyy = "\(str_MovePen3)"
                objCoreTable.userid = "\(NSUserDefaults.standardUserDefaults().objectForKey("email_username") as! String)"
                do {
                    try self.appDel.managedObjectContext.save()
                    HelperClass.MessageAletOnly("Successfully Moved To Empty.", selfView: self)
                } catch {
                }
            }
        }
        catch {
            
        }
    }
    
    
    //MARK: - Next Button/NextPenService
    @IBAction func Next_btnAction(sender: AnyObject) {
        str_TotalAnimal = "\(str_Animal1)\(str_Animal2)\(str_Animal3)"
        if (str_TotalAnimal == "000")
        {
            HelperClass.MessageAletOnly("Moving Animal Quantity Should Be Greater Than Zero", selfView: self)
        }
        else {
            if self.appDel.checkInternetConnection() {
                self.NextPenService()
            }
            else
            {
                self.getDataFromAnimalsCountTable()
            }
        }
        label_move.text = "Move From \(str_MovePen1)-\(str_MovePen2)\(str_MovePen3)"

        
    }
    
    
    func NextPenService()
    {
        str_webservice = "check_movement"
        let request = NSMutableURLRequest(URL: NSURL(string: "\(Server.local_server)/api/animals/check_movement.php?")!)
        let postString = "noofanimals=\(str_TotalAnimal)&group=\(str_MovePen1)&fromnamexx=\(str_MovePen2)&fromnameyy=\(str_MovePen3)"
        objwebservice.callServiceCommon(request, postString: postString)
    }
    
    func SaveIntoOfflineWhileOnlineAnimalsCountTable()
    {
        
        let fetchRequest = NSFetchRequest(entityName: "AnimalsCountTable")
        let predicate = NSPredicate(format: "count_namexx = '\(self.str_MovePen2)' and count_nameyy = '\(self.str_MovePen3)' and groupname = '\(self.str_MovePen1)'")
        fetchRequest.predicate = predicate
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.fetchBatchSize = 20
        do {
            let results = try self.appDel.managedObjectContext.executeFetchRequest(fetchRequest)
            print(results)
            if (results.count != 0)
            {
                let objCoreTable: AnimalsCountTable = (results[0] as? AnimalsCountTable)!
                let intvaa : Int = Int(objCoreTable.total_animals! as String)!
                let inttotalAnimals : Int = Int(str_TotalAnimal! as String)!
                if intvaa >= inttotalAnimals  {
                }
                else
                {
                    objCoreTable.offline = "NO"
                    var intvaa : Int = Int(objCoreTable.total_animals! as String)!
                    intvaa = intvaa + Int("\(inttotalAnimals-intvaa)" as String)!
                    objCoreTable.total_animals = String(intvaa)
                    
                    do {
                        try self.appDel.managedObjectContext.save()
                    } catch {
                    }
                }
            }
            else
            {
                
            }
            
            
            
            // success ...
        } catch let error as NSError {
            // failure
            print("Fetch failed: \(error.localizedDescription)")
        }
    }
    
    
    func getDataFromAnimalsCountTable()
    {
        
        let fetchRequest = NSFetchRequest(entityName: "AnimalsCountTable")
        let predicate = NSPredicate(format: "count_namexx = '\(self.str_MovePen2)' and count_nameyy = '\(self.str_MovePen3)' and groupname = '\(self.str_MovePen1)'")
        fetchRequest.predicate = predicate
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.fetchBatchSize = 20
//        fetchRequest.resultType = NSFetchRequestResultType.DictionaryResultType
        do {
            let results = try self.appDel.managedObjectContext.executeFetchRequest(fetchRequest)
            print(results)
            if (results.count != 0)
            {
                let objCoreTable: AnimalsCountTable = (results[0] as? AnimalsCountTable)!
                let intvaa : Int = Int(objCoreTable.total_animals! as String)!
                let inttotalAnimals : Int = Int(str_TotalAnimal! as String)!
                if intvaa >= inttotalAnimals  {
                    self.view_moveToPen.hidden = false
                    self.btn_backW.hidden = false
                    
                }
                else
                {
                    let alertView = UIAlertController(title: nil, message: "Selected Animals are Greater Than Animals Present in the Pen. Want To Add \(inttotalAnimals-intvaa)?", preferredStyle: .Alert)
                    alertView.addAction(UIAlertAction(title: "NO", style: .Cancel, handler: nil))
                    alertView.addAction(UIAlertAction(title: "YES", style: .Default, handler: {(action:UIAlertAction) in
                            self.saveToMoveAddAnimal("\(inttotalAnimals-intvaa)")
                        
                    }));
                    self.presentViewController(alertView, animated: true, completion: nil)
                }
            }
            else
            {
                HelperClass.MessageAletOnly("Pen Does Not Exist.", selfView: self)
            }
            
            
            
            // success ...
        } catch let error as NSError {
            // failure
            print("Fetch failed: \(error.localizedDescription)")
        }
    }
    
    
    func saveToMoveAddAnimal(totalAnimal: String!)
    {
        let fetchRequest = NSFetchRequest(entityName: "MoveAddAnimal")
        let predicate = NSPredicate(format: "namexx = '\(self.str_MovePen2)' and nameyy = '\(self.str_MovePen3)' and groupname = '\(str_MovePen1)'")
        fetchRequest.predicate = predicate
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.fetchBatchSize = 20
        do {
            let results = try self.appDel.managedObjectContext.executeFetchRequest(fetchRequest)
            if results.count == 0 {
                var objCoreTable: MoveAddAnimal!
                objCoreTable = (NSEntityDescription.insertNewObjectForEntityForName("MoveAddAnimal", inManagedObjectContext: self.appDel.managedObjectContext) as! MoveAddAnimal)
                objCoreTable.groupname = str_MovePen1 as String
                objCoreTable.namexx = str_MovePen2 as String
                objCoreTable.nameyy = str_MovePen3 as String
                objCoreTable.moved_by = NSUserDefaults.standardUserDefaults().objectForKey("email_username") as? String
                objCoreTable.totalanimal = self.str_TotalAnimal as String
                do {
                    try self.appDel.managedObjectContext.save()
                    self.getAndInsertIntoAnimalsCount_offline(totalAnimal)
                    
                } catch {
                }
            }
            else
            {
                if let objTable: MoveAddAnimal = results[0] as? MoveAddAnimal {
                    var intvaa : Int = Int(objTable.totalanimal! as String)!
                    intvaa = intvaa + Int(self.str_TotalAnimal as String)!
                    objTable.totalanimal = String(intvaa)
                    
                    do {
                        try self.appDel.managedObjectContext.save()
                        self.getAndInsertIntoAnimalsCount_offline(totalAnimal)
                    } catch {
                    }
                }
            }
            
        }
        catch{}
            
            
        
        
    }
    
    
    func getAndInsertIntoAnimalsCount_offline(totalAnimal : String!)
    {
        let fetchRequest = NSFetchRequest(entityName: "AnimalsCountTable")
        let predicate = NSPredicate(format: "count_namexx = '\(self.str_MovePen2)' and count_nameyy = '\(self.str_MovePen3)' and groupname = '\(str_MovePen1)'")
        fetchRequest.predicate = predicate
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.fetchBatchSize = 20
        do {
            let results = try self.appDel.managedObjectContext.executeFetchRequest(fetchRequest)
            if (results.count == 0)
            {
                var objCoreTable: AnimalsCountTable!
                objCoreTable = (NSEntityDescription.insertNewObjectForEntityForName("AnimalsCountTable", inManagedObjectContext: self.appDel.managedObjectContext) as! AnimalsCountTable)
                objCoreTable.count_id = results.count
                objCoreTable.groupname = self.str_MovePen1 as String
                objCoreTable.count_namexx = self.str_MovePen2 as String
                objCoreTable.count_nameyy = self.str_MovePen3 as String
                objCoreTable.movedby = NSUserDefaults.standardUserDefaults().objectForKey("email_username") as? String
                objCoreTable.total_animals = totalAnimal as String
                objCoreTable.offline = "NO"
                do {
                    try self.appDel.managedObjectContext.save()
                    let alertView = UIAlertController(title: nil, message: "Animals Added Successfully.", preferredStyle: .Alert)
                    alertView.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: {(action:UIAlertAction) in
                            self.view_moveToPen.hidden = false
                            self.btn_backW.hidden = false
                        
                    }));
                    self.presentViewController(alertView, animated: true, completion: nil)
                } catch {
                }
            }
            else
            {
                for i in 0 ..< results.count {
                    if let objTable: AnimalsCountTable = results[i] as? AnimalsCountTable {                                            objTable.offline = "NO"
                        var intvaa : Int = Int(objTable.total_animals! as String)!
                        intvaa = intvaa + Int(totalAnimal as String)!
                        objTable.total_animals = String(intvaa)
                        
                        do {
                            try self.appDel.managedObjectContext.save()
                            let alertView = UIAlertController(title: nil, message: "Animals Added Successfully.", preferredStyle: .Alert)
                            alertView.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: {(action:UIAlertAction) in
                                self.view_moveToPen.hidden = false
                                self.btn_backW.hidden = false
                                
                            }));
                            self.presentViewController(alertView, animated: true, completion: nil)
                        } catch {
                        }
                    }
                }
            }
            
            // success ...
        } catch {}
    }
    
    
    // MARK: - Webservice NetLost delegate
    func NetworkLost(str: String!)
    {
        HelperClass.NetworkLost(str, view1: self)
    }
    
    //MARK: - Webservice Delegate
    func responseDictionary(dic: NSMutableDictionary) {
        print(dic)
//        dispatch_async(dispatch_get_main_queue()) {
            if self.str_webservice == "check_movement"
            {
                if dic["success"] as! String == "True"
                {
                    self.view_moveToPen.hidden = false
                    self.btn_backW.hidden = false
                }
                else
                {
                    let alertView = UIAlertController(title: nil, message: dic["Message"] as? String, preferredStyle: .Alert)
                    if dic["Message"] as? String == "Pen Does Not Exist."{
                        alertView.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
                    }
                    else
                    {
                        alertView.addAction(UIAlertAction(title: "NO", style: .Cancel, handler: nil))
                        alertView.addAction(UIAlertAction(title: "YES", style: .Default, handler: {(action:UIAlertAction) in
                            
                            if self.appDel.checkInternetConnection() {
                                self.addAnimaltoPen()
                            }
                            
                        }));
                    }
                    
                    self.presentViewController(alertView, animated: true, completion: nil)
                }
            }
            else if (self.str_webservice == "empty_move_sub")
            {
                if dic["success"] as! String == "True"
                {
                    let fetchRequest = NSFetchRequest(entityName: "AnimalsCountTable")
                    let predicate = NSPredicate(format: "count_namexx = '\(str_MovePen2)' and count_nameyy = '\(str_MovePen3)' and groupname = '\(str_MovePen1)'")
                    fetchRequest.predicate = predicate
                    fetchRequest.returnsObjectsAsFaults = false
                    do {
                        let fetchedResults = try appDel.managedObjectContext.executeFetchRequest(fetchRequest)
                        if fetchedResults.count != 0 {
                            for i in 0 ..< fetchedResults.count {
                                if let objTable: AnimalsCountTable = fetchedResults[i] as? AnimalsCountTable {
                                    objTable.total_animals = "0"
                                    do {
                                        try self.appDel.managedObjectContext.save()
                                    } catch {
                                    }}}}
                    }catch  {
                        
                    }

                }

                HelperClass.MessageAletOnly("\(dic["Message"] as? String)", selfView: self)
            }
            else if (self.str_webservice == "empty_move_add")
            {
                if dic["success"] as! String == "True"
                {
                    self.SaveIntoOfflineWhileOnlineAnimalsCountTable()
                    
                    let alertView = UIAlertController(title: nil, message: "Animals Added Successfully.", preferredStyle: .Alert)
                    alertView.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: {(action:UIAlertAction) in
                        self.view_moveToPen.hidden = false
                        self.btn_backW.hidden = false
                        
                    }));
                    self.presentViewController(alertView, animated: true, completion: nil)
                    
                }
                else
                {
                    
                    HelperClass.MessageAletOnly("\(dic["Message"] as? String)", selfView: self)
                    
                }
            }
            else if (self.str_webservice == "check_grp_count")
            {
                if dic["success"] as! String == "True" {
                    if self.appDel.checkInternetConnection() {
                        self.MovePenService()
                    }
                    else
                    {
                        self.updateToAnimalsCountTable()
                        
                        
                    }
                }
                else
                {
                    
                    let alertView = UIAlertController(title: nil, message: dic["Message"] as? String, preferredStyle: .Alert)
                    alertView.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
                    alertView.addAction(UIAlertAction(title: "OK", style: .Default, handler: {(action:UIAlertAction) in
                        if self.appDel.checkInternetConnection() {
                            self.MovePenService()
                        }
                        else
                        {
                            self.updateToAnimalsCountTable()
                            
                        }
                        self.btn_backW.hidden = false
                    }));
                    self.presentViewController(alertView, animated: true, completion: nil)
                    
                }
            }
            else if (self.str_webservice == "move_animals")
            {
                if dic["success"] as! String == "True" {
                    
                    self.saveToAnimalsCountTable()
                    HelperClass.MessageAletOnly("Animals Moved Successfully.", selfView: self)
                    self.view_moveToPen.hidden = true
                    self.btn_backW.hidden = true
                    
                    
                }
                else
                {
                    HelperClass.MessageAletOnly("\(dic["Message"] as? String)", selfView: self)
                    
                }
                
            }
//        }
        self.appDel.remove_HUD()
    }
    
    func InsertToMoveAnimal()
    {
        
        let fetchRequest = NSFetchRequest(entityName: "Move_animal")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.fetchBatchSize = 20
        var objCoreTable: Move_animal!
        do {
            let fetchedResults = try self.appDel.managedObjectContext.executeFetchRequest(fetchRequest)
            objCoreTable = (NSEntityDescription.insertNewObjectForEntityForName("Move_animal", inManagedObjectContext: self.appDel.managedObjectContext) as! Move_animal)
            objCoreTable.id = fetchedResults.count+1
            objCoreTable.from_groupname = self.str_MovePen1 as String
            objCoreTable.from_namexx = self.str_MovePen2 as String
            objCoreTable.from_nameyy = self.str_MovePen3 as String
            objCoreTable.to_groupname = self.str_MoveToPen1 as String
            objCoreTable.to_namexx = self.str_MoveToPen2 as String
            objCoreTable.to_nameyy = self.str_MoveToPen3 as String
            objCoreTable.no_animals = self.str_TotalAnimal as String
            objCoreTable.moved_on = "nn"
            objCoreTable.moved_by = NSUserDefaults.standardUserDefaults().objectForKey("email_username") as? String
            objCoreTable.offline = "YES"
            
            
            do {
                try self.appDel.managedObjectContext.save()
                HelperClass.MessageAletOnly("Animals Moved Successfully.", selfView: self)
                
                self.view_moveToPen.hidden = true
                self.btn_backW.hidden = true
                
            } catch {
            }
        }
        catch {
        }
        
        
    }
    
    func updateToAnimalsCountTable1()
    {
        ////
        let fetchRequest = NSFetchRequest(entityName: "AnimalsCountTable")
        let predicate1 = NSPredicate(format: "count_namexx = '\(self.str_MoveToPen2)' and count_nameyy = '\(self.str_MoveToPen3)' and groupname = '\(self.str_MoveToPen1)'")
        fetchRequest.predicate = predicate1
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.fetchBatchSize = 20
//        fetchRequest.resultType = NSFetchRequestResultType.DictionaryResultType
        do {
            let fetchedResults = try self.appDel.managedObjectContext.executeFetchRequest(fetchRequest)
            if fetchedResults.count != 0 {
                for i in 0 ..< fetchedResults.count {
                    if let objTable: AnimalsCountTable = fetchedResults[i] as? AnimalsCountTable {                                            objTable.offline = "NO"
                        var intvaa : Int = Int(objTable.total_animals! as String)!
                        intvaa = intvaa + Int(self.str_TotalAnimal as String)!
                        objTable.total_animals = String(intvaa)
                        
                        do {
                            try self.appDel.managedObjectContext.save()
                            NSOperationQueue.mainQueue().addOperationWithBlock({
                                self.InsertToMoveAnimal()
                            })
                            
                            
                        } catch {
                        }
                    }
                }
            }
        }catch let error as NSError {
            // failure
            print("Fetch failed: \(error.localizedDescription)")
        }
    }
    
    func updateToAnimalsCountTable()
    {
        let fetchRequest = NSFetchRequest(entityName: "AnimalsCountTable")
        let predicate = NSPredicate(format: "count_namexx = '\(self.str_MovePen2)' and count_nameyy = '\(self.str_MovePen3)' and groupname = '\(self.str_MovePen1)'")
        fetchRequest.predicate = predicate
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.fetchBatchSize = 20
//        fetchRequest.resultType = NSFetchRequestResultType.DictionaryResultType
        do {
            let fetchedResults = try self.appDel.managedObjectContext.executeFetchRequest(fetchRequest)
            if fetchedResults.count != 0 {
                for i in 0 ..< fetchedResults.count {
                    if let objTable: AnimalsCountTable = fetchedResults[i] as? AnimalsCountTable {                                            objTable.offline = "NO"
                        var intvaa : Int = Int(objTable.total_animals! as String)!
                        intvaa = intvaa - Int(self.str_TotalAnimal as String)!
                        objTable.total_animals = String(intvaa)
                        
                        do {
                            try self.appDel.managedObjectContext.save()
                            NSOperationQueue.mainQueue().addOperationWithBlock({
                                self.updateToAnimalsCountTable1()
                            })
                        } catch {
                        }
                    }
                }
            }
            else
            {
                HelperClass.MessageAletOnly("Selected Number of Animals are Greater Than The Animals Present in the Pen.", selfView: self)
            }
        }catch let error as NSError {
            // failure
            print("Fetch failed: \(error.localizedDescription)")
        }
    }
    
    
    func saveToAnimalsCountTable()
    {
        //fetch from AnimalCountTable
        let fetchRequest = NSFetchRequest(entityName: "AnimalsCountTable")
        let predicate = NSPredicate(format: "count_namexx = '\(self.str_MoveToPen2)' and count_nameyy = '\(self.str_MoveToPen3)' and groupname = '\(self.str_MoveToPen1)'")
        fetchRequest.predicate = predicate
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.fetchBatchSize = 20
//        fetchRequest.resultType = NSFetchRequestResultType.DictionaryResultType
        do {
            let results = try self.appDel.managedObjectContext.executeFetchRequest(fetchRequest)
            if (results.count == 0)
            {
                var objCoreTable: AnimalsCountTable!
                objCoreTable = (NSEntityDescription.insertNewObjectForEntityForName("AnimalsCountTable", inManagedObjectContext: self.appDel.managedObjectContext) as! AnimalsCountTable)
                objCoreTable.count_id = 1
                objCoreTable.groupname = self.str_MoveToPen1 as String
                objCoreTable.count_namexx = self.str_MoveToPen2 as String
                objCoreTable.count_nameyy = self.str_MoveToPen3 as String
                objCoreTable.movedby = NSUserDefaults.standardUserDefaults().objectForKey("email_username") as? String
                objCoreTable.total_animals = self.str_TotalAnimal as String
                objCoreTable.offline = "NO"
                do {
                    try self.appDel.managedObjectContext.save()
                    let predicate = NSPredicate(format: "count_namexx = '\(self.str_MovePen2)' and count_nameyy = '\(self.str_MovePen3)' and groupname = '\(self.str_MovePen1)'")
                    fetchRequest.predicate = predicate
                    fetchRequest.returnsObjectsAsFaults = false
                    fetchRequest.fetchBatchSize = 20
//                    fetchRequest.resultType = NSFetchRequestResultType.DictionaryResultType
                    do {
                        let fetchedResults = try self.appDel.managedObjectContext.executeFetchRequest(fetchRequest)
                        if fetchedResults.count != 0 {
                            for i in 0 ..< fetchedResults.count {
                                if let objTable: AnimalsCountTable = fetchedResults[i] as? AnimalsCountTable {                                            objTable.offline = "NO"
                                    var intvaa : Int = Int(objTable.total_animals! as String)!
                                    intvaa = intvaa - Int(self.str_TotalAnimal as String)!
                                    objTable.total_animals = String(intvaa)
                                    
                                    do {
                                        try self.appDel.managedObjectContext.save()
                                        
                                        
                                    } catch {
                                    }
                                }
                            }
                        }
                    }catch let error as NSError {
                        // failure
                        print("Fetch failed: \(error.localizedDescription)")
                    }
                } catch {
                }
            }
            else
            {
                let predicate = NSPredicate(format: "count_namexx = '\(self.str_MovePen2)' and count_nameyy = '\(self.str_MovePen3)' and groupname = '\(str_MovePen1)'")
                fetchRequest.predicate = predicate
                fetchRequest.returnsObjectsAsFaults = false
                fetchRequest.fetchBatchSize = 20
//                fetchRequest.resultType = NSFetchRequestResultType.DictionaryResultType
                do {
                    let fetchedResults = try self.appDel.managedObjectContext.executeFetchRequest(fetchRequest)
                    if fetchedResults.count != 0 {
                        for i in 0 ..< fetchedResults.count {
                            if let objTable: AnimalsCountTable = fetchedResults[i] as? AnimalsCountTable {                                            objTable.offline = "NO"
                                var intvaa : Int = Int(objTable.total_animals! as String)!
                                intvaa = intvaa - Int(self.str_TotalAnimal as String)!
                                objTable.total_animals = String(intvaa)
                                
                                do {
                                    try self.appDel.managedObjectContext.save()
                                    
                                    
                                } catch {
                                }
                            }
                        }
                    }
                }catch let error as NSError {
                    // failure
                    print("Fetch failed: \(error.localizedDescription)")
                }
                
                /////
                
                let predicate1 = NSPredicate(format: "count_namexx = '\(self.str_MoveToPen2)' and count_nameyy = '\(self.str_MoveToPen3)' and groupname = '\(str_MoveToPen1)'")
                fetchRequest.predicate = predicate1
//                fetchRequest.resultType = NSFetchRequestResultType.DictionaryResultType
                do {
                    let fetchedResults = try self.appDel.managedObjectContext.executeFetchRequest(fetchRequest)
                    if fetchedResults.count != 0 {
                        for i in 0 ..< fetchedResults.count {
                            if let objTable: AnimalsCountTable = fetchedResults[i] as? AnimalsCountTable {                                            objTable.offline = "NO"
                                var intvaa : Int = Int(objTable.total_animals! as String)!
                                intvaa = intvaa + Int(self.str_TotalAnimal as String)!
                                objTable.total_animals = String(intvaa)
                                
                                do {
                                    try self.appDel.managedObjectContext.save()
                                    
                                    
                                } catch {
                                }
                            }
                        }
                    }
                }catch let error as NSError {
                    // failure
                    print("Fetch failed: \(error.localizedDescription)")
                }
                
                
                
            }

            
            
            
            }
            catch {
            }
            // success ...
        }
    
    //MARK: - view_moveToPen/ Move Button/ MoveConfirmationPenService
    @IBAction func Move_btnAction(sender: AnyObject) {
        
       
            let alertView = UIAlertController(title: nil, message: "Are You Sure You Want To Move \(str_TotalAnimal) Animals To Pen #\(str_MoveToPen1)-\(str_MoveToPen2)\(str_MoveToPen3)?", preferredStyle: .Alert)
            alertView.addAction(UIAlertAction(title: "NO", style: .Cancel, handler: nil))
            alertView.addAction(UIAlertAction(title: "YES", style: .Default, handler: {(action:UIAlertAction) in
                if self.appDel.checkInternetConnection() {
                    self.MoveConfirmationPenService()
                }
                else
                {
                    self.OfflineMoveConfirmationPenService()
                }
                
            }));
            self.presentViewController(alertView, animated: true, completion: nil)
        
    }
    
    func OfflineMoveConfirmationPenService()
    {
        var limit: Int = 0
        if (str_MoveToPen1 == "Y1") {
            limit = 100
        }
        else if (str_MoveToPen1 == "Y2" || str_MoveToPen1 == "Y3") {
            limit = 200
        }
        else if (str_MoveToPen1 == "Y4") {
            limit = 300
        }
        
        let alertView = UIAlertController(title: nil, message: "Add \(str_TotalAnimal) Animals = Total Density of \(limit) Animals", preferredStyle: .Alert)
        alertView.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        alertView.addAction(UIAlertAction(title: "OK", style: .Default, handler: {(action:UIAlertAction) in
            NSOperationQueue.mainQueue().addOperationWithBlock({
                self.updateToAnimalsCountTable()
                })
            
        }));
        self.presentViewController(alertView, animated: true, completion: nil)
    }
    
    
    func MoveConfirmationPenService()
    {
        str_webservice = "check_grp_count";
        let request = NSMutableURLRequest(URL: NSURL(string: "\(Server.local_server)/api/animals/check_grp_count.php?")!)
        let postString = "noofanimals=\(str_TotalAnimal)&group=\(str_MoveToPen1)&fromnamexx=\(str_MoveToPen2)"
        objwebservice.callServiceCommon(request, postString: postString)
    }
    
    //MARK: - MovePenService
    func MovePenService()
    {
        str_webservice = "move_animals";
        let request = NSMutableURLRequest(URL: NSURL(string: "\(Server.local_server)/api/animals/move_animals.php?")!)
        let postString = "noofanimals=\(str_TotalAnimal)&from_group=\(str_MovePen1)&fromnamexx=\(str_MovePen2)&fromnameyy=\(str_MovePen3)&to_group=\(str_MoveToPen1)&tonamexx=\(str_MoveToPen2)&tonameyy=\(str_MoveToPen3)&movedby=\(NSUserDefaults.standardUserDefaults().objectForKey("email_username") as! String)&app_id=\(NSUserDefaults.standardUserDefaults().objectForKey("ApplicationIdentifier") as! String)"
        objwebservice.callServiceCommon(request, postString: postString)
    }
    
    //MARK: - BackButton with two views
    @IBAction func button_back(sender: AnyObject) {
        view_moveToPen.hidden = true
        btn_backW.hidden = true
    }
    
}
