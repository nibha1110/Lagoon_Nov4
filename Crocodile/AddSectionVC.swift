//
//  AddSectionVC.swift
//  Crocodile
//
//  Created by Nibha Aggarwal on 5/18/16.
//  Copyright © 2016 Nibha Aggarwal. All rights reserved.
//

import UIKit
import CoreData

class AddSectionVC: UIViewController, responseProtocol, UITableViewDelegate, UITableViewDataSource, CommonClassProtocol {
    var objwebservice : webservice! = webservice()
    var array_List: [AnyObject] = []
    var groupCode: String!
    var appDel : AppDelegate!
    @IBOutlet var tableview_group: UITableView!
    
    //MARK: - LifeCycle
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
        controller.label_header.text = "ADD TO SINGLE PEN"
        controller.btn_Sync.hidden = false
        controller.img_Sync.hidden = false
        controller.btn_BackPop.hidden = true
        controller.IIndexPath = NSIndexPath(forRow: 0, inSection: 2)
        controller.array_temp_section.replaceObjectAtIndex(2, withObject: "Yes")
        controller.tableMenu.reloadData()
        
        let arrt = controller.array_temp_row[2]
        arrt.replaceObjectAtIndex(0, withObject: "Yes")
        
        objwebservice?.delegate = self
        
        controller.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
       appDel.ForSPAddComes = "NoBack"
        if self.appDel.checkInternetConnection() {
            self .GetAddEmptyRecords()
        }
        else
        {
            if true {
                //  for offline
                let fetchRequest = NSFetchRequest(entityName: "AddSectionTable")
                fetchRequest.returnsObjectsAsFaults = false
                //fetchRequest.includesPropertyValues = false
                fetchRequest.fetchBatchSize = 20
                fetchRequest.resultType = NSFetchRequestResultType.DictionaryResultType
                do {
                    let results = try appDel.managedObjectContext.executeFetchRequest(fetchRequest)
                    if results.count > 0 {
                        if array_List.count != 0 {
                            array_List.removeAll()
                        }
                        array_List = results
                        print(array_List)
                        self.tableview_group.reloadData()
                        
                    }
                    else
                    {
                        for i in 0 ..< 4{
                            var objAddSectionTable: AddSectionTable!
                            
                            objAddSectionTable = (NSEntityDescription.insertNewObjectForEntityForName("AddSectionTable", inManagedObjectContext: self.appDel.managedObjectContext) as! AddSectionTable)
                            objAddSectionTable.id = i
                            objAddSectionTable.groupcode = "\(i+1)"
                            objAddSectionTable.groupname = "\(i+1)"
                            objAddSectionTable.available = "0"
                            objAddSectionTable.total = "0"
                            do {
                                try self.appDel.managedObjectContext.save()
                                
                                
                            } catch {
                                // Replace this implementation with code to handle the error appropriately.
                                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                                //print("Unresolved error \(error), \(error.userInfo)")
                            }
                        }
                        print(array_List)
                        self.tableview_group.reloadData()
                    }
                    
                    // success ...
                } catch let error as NSError {
                    // failure
                    print("Fetch failed: \(error.localizedDescription)")
                }
                //
            }
            self.tableview_group.reloadData()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - AddSection List on TableView
    func GetAddEmptyRecords()
    {
        appDel.Show_HUD()
        let request = NSMutableURLRequest(URL: NSURL(string: "\(Server.local_server)/api/singlepen/getgroups.php")!)
        let postString = ""
        objwebservice.callServiceCommon(request, postString: postString)
    }
    
    func GetAddList_Response(dic: NSMutableDictionary)
    {
        array_List = dic.valueForKey("AllGroups") as! NSMutableArray as [AnyObject]
        print(array_List)
        self.tableview_group.reloadData()
        self.appDel.remove_HUD()
        
    }
    
    //MARK: -  CommonClass Delegate
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
        print(dic)
        self.GetAddList_Response(dic)
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
        
        let cell:UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        
        //view Backgd
        let view_bg: UIView = UIView(frame: CGRectMake(0, 0, 709, 75))
        if indexPath.row % 2 == 0 {
            view_bg.backgroundColor = UIColor.whiteColor()
        }
        else {
            view_bg.backgroundColor = UIColor(red: 241.0 / 255.0, green: 241 / 255.0, blue: 241 / 255.0, alpha: 1.0)
        }
        
        //
        var str_gpName: String
        var available: String
        var total: String
        
        // gp Name , Avalibale, total
        str_gpName = array_List[indexPath.row]["groupname"] as! String
        available = array_List[indexPath.row]["available"] as! String
        total = array_List[indexPath.row]["total"] as! String
        
        //label_gpname
        let label_groupName: UILabel = UILabel(frame: CGRectMake(64, 13, 200, 50))
        label_groupName.font = UIFont(name: "HelveticaNeue", size: 26)
        
        // right arrow
        let img_arrow: UIImageView = UIImageView(frame: CGRectMake(650, 27, 16, 22))
        img_arrow.image = UIImage(named: "arrow")
        view_bg.addSubview(img_arrow)
        
        // orange image
        let img_orange: UIImageView = UIImageView(frame: CGRectMake(250, 22, 237, 24))
        img_orange.image = UIImage(named: "santari_tandi")
        view_bg.addSubview(img_orange)
        // slider
        let sliderGp: UISlider = UISlider(frame: CGRectMake(250, 22, 237 + 2, 24))
        let imgback2: UIImage = UIImage(named: "blankTransparent")!
        sliderGp.setThumbImage(imgback2, forState: .Normal)
        
//        var imgback3: UIImage = UIImage(named: "blankTransparent_slider")!
//        sliderGp.setMinimumTrackImage(imgback3.stretchableImageWithLeftCapWidth(20.0 as Double, topCapHeight: 0.0), forState: .Normal)
        var maxTrack: UIImage = UIImage(named: "grey_tandi")!
        maxTrack = maxTrack.resizableImageWithCapInsets(UIEdgeInsetsMake(0, 15, 0, 15))
        sliderGp.setMaximumTrackImage(maxTrack, forState: .Normal)

        sliderGp.minimumValue = 0.0
        sliderGp.setValue(CFloat(available)!, animated: true)
        sliderGp.userInteractionEnabled = false
        view_bg.addSubview(sliderGp)
        
        
        let label_pens: UILabel = UILabel(frame: CGRectMake(550, 13, 100, 50))
        label_pens.textAlignment = .Center
        label_pens.font = UIFont(name: "HelveticaNeue", size: 26)
        
        label_groupName.text = str_gpName
        label_pens.text = available
        sliderGp.maximumValue = CFloat(total)!
        sliderGp.setValue(CFloat(available)!, animated: true)
        
        
        view_bg.addSubview(label_pens)
        view_bg.addSubview(label_groupName)
        cell.contentView.addSubview(view_bg)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("You selectIIndexPathed cell #\(indexPath.section)\(indexPath.row)!")
        if (array_List[indexPath.row]["available"] as! String == "0") {

            let alertView = UIAlertController(title: nil, message: "There Is No Empty Pen\n Please Check Another.", preferredStyle: .Alert)
            alertView.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
            self.presentViewController(alertView, animated: true, completion: nil)
        }
            
        else if (array_List[indexPath.row]["available"] as! String != "0")
        {
            groupCode = array_List[indexPath.row]["groupcode"] as! String
            let objVC = self.storyboard?.instantiateViewControllerWithIdentifier("AddGroupVC") as! AddGroupVC
            objVC.toPass = groupCode
            self.navigationController?.pushViewController(objVC, animated: false)
//            self.performSegueWithIdentifier("toaddGroup", sender: self)

        }
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "toaddGroup") {
            let objVC = segue.destinationViewController as! AddGroupVC;
            objVC.toPass = groupCode
        }
    }

}
