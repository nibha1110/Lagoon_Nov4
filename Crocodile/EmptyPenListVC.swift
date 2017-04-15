//
//  EmptyPenListVC.swift
//  Crocodile
//
//  Created by Nibha Aggarwal on 15/11/16.
//  Copyright © 2016 Nibha Aggarwal. All rights reserved.
//

import UIKit

class EmptyPenListVC: UIViewController, responseProtocol, userlistProtocol {
    
    @IBOutlet weak var tabelview_GrpList: UITableView!
    @IBOutlet weak var tabelview_UserList: UITableView!
    
    var objwebservice : webservice! = webservice()
    var objuserList : UserListView! = UserListView()
    var appDel : AppDelegate!
    var array_List: [AnyObject] = []
    var str_webservice: NSString!
    
    var Bool_viewUsers: Bool = false
    var Bool_valueCome: Bool = false

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
        controller.btn_BackPop.hidden = true
        controller.IIndexPath = NSIndexPath(forRow: 3, inSection: 2)
        controller.label_header.text = "EMPTY PENS LIST"
        controller.array_temp_section.replaceObjectAtIndex(2, withObject: "Yes")
        controller.tableMenu.reloadData()
        let arrt = controller.array_temp_row[2]
        arrt.replaceObjectAtIndex(3, withObject: "Yes")
        objwebservice?.delegate = self
        objuserList = UserListView.instanceFromNib() as! UserListView
        objuserList?.delegate = self
        controller.array_userList = NSUserDefaults.standardUserDefaults().objectForKey("UserList")?.mutableCopy() as! NSMutableArray
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        if self.appDel.checkInternetConnection() {
            self.GetGroupNameDetailService()
        }
        else
        {
            let alertView = UIAlertController(title: nil, message: Server.noInternet, preferredStyle: .Alert)
            alertView.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
            self.presentViewController(alertView, animated: true, completion: nil)
        }
    }
    
    //MARK: - Export Btn_Action/ UserList Delegate
    @IBAction func Export_BtnAction(sender: AnyObject) {
        
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
                str_webservice = "report_sp_available_all"
                
                let request = NSMutableURLRequest(URL: NSURL(string: "\(Server.local_server)/api/file/report_sp_available_all.php?")!)
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
    
    
    //    func recreatePersistentStore() {
    //
    //        let stores = appDel.persistentStoreCoordinator.persistentStores
    //        for store: NSPersistentStore in stores {
    //            do {
    //                try appDel.persistentStoreCoordinator.removePersistentStore(store)
    //            }
    //            catch {
    //            }
    //            do {
    //                try NSFileManager.defaultManager().removeItemAtPath(store.URL!.path!)
    //            }
    //            catch {
    //            }
    //        }
    //    }
    //
    
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
        if str_webservice == "getavlpens" {
            self.array_List = dic["EmptyPens"] as! NSMutableArray as [AnyObject]
            if self.array_List.count == 0 {
                Bool_valueCome = true
            }
            else
            {
                Bool_valueCome = false
            }
            self.tabelview_GrpList.reloadData()
        }
        else if (str_webservice == "report_sp_available_all")
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
    
    
    //MARK: - GetGroupNameDetailService
    func GetGroupNameDetailService()
    {
        appDel.Show_HUD()
        str_webservice = "getavlpens"
        let request = NSMutableURLRequest(URL: NSURL(string: "\(Server.local_server)/api/singlepen/get_all_avlpens.php")!)
        let postString = ""
        objwebservice.callServiceCommon(request, postString: postString)
    }
    
    // MARK: -  tableview Delegates
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(array_List.count)
        if Bool_valueCome == true
        {
            return 1
        }
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
        
        
        //label_Grp
        let label_Grp: UILabel = UILabel(frame: CGRectMake(50, 13, 200, 50))
        label_Grp.textAlignment = .Center
        label_Grp.font = UIFont(name: "HelveticaNeue", size: 26)
        
        if array_List.count == 0
        {
            label_Grp.frame = CGRectMake(50, 13, 500, 50)
            label_Grp.text = "There Is No Empty Pen."
            view_bg.addSubview(label_Grp)
            cell.contentView .addSubview(view_bg)
            return cell
        }
        
        
        label_Grp.text = array_List[indexPath.row]["grpnamedisp"] as? String
        
        //orange image
        let img_orange: UIImageView = UIImageView(frame: CGRectMake(275, 8, 192, 56))
        img_orange.image = UIImage(named: "xxyy")
        
        //label_pens
        let label_pens: UILabel = UILabel(frame: CGRectMake(275, 8, 192, 56))
        label_pens.textAlignment = .Center
        label_pens.textColor = UIColor.whiteColor()
        label_pens.font = UIFont(name: "HelveticaNeue", size: 26)
        label_pens.text = array_List[indexPath.row]["pennodisp"] as? String
        
        view_bg.addSubview(img_orange)
        view_bg.addSubview(label_pens)
        view_bg.addSubview(label_Grp)
        
        cell.contentView .addSubview(view_bg)
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }

}