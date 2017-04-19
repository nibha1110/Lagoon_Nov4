//
//  HomeVC.swift
//  Crocodile
//
//  Created by Nibha Aggarwal on 4/27/16.
//  Copyright © 2016 Nibha Aggarwal. All rights reserved.
//

import UIKit
import CoreData

class HomeVC: UIViewController , responseProtocol{
    var objwebservice : webservice! = webservice()
    var str_webservice: NSString!
    var appDel : AppDelegate!
    var arrayKill: [AnyObject] = []
    var arraySinglePen: [AnyObject] = []
    var arrayMoveHatchling: [AnyObject] = []
    var arrayMoveSection: [AnyObject] = []
    var arraySingleSection: [AnyObject] = []
    var arrayGroupSection: [AnyObject] = []
    var killIndex: Int!
    var timer = NSTimer()
    var objDataOffline: DataOffline! = DataOffline()
    var arrData: NSMutableArray! = ["", "" , "admin_dash_btn", "move_dash_btn", "add_dash_btn", "Ins_dash_btn", "kill_dash_btn", "update_Home", "reports"]
    let dateFormatter: NSDateFormatter = NSDateFormatter()
    var slectedarray: NSMutableArray! = []
    
    @IBOutlet weak var Home_collection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        objwebservice?.delegate = self
        appDel = (UIApplication.sharedApplication().delegate as! AppDelegate)
    }

    override func viewDidAppear(animated: Bool) {
        
        if NSUserDefaults.standardUserDefaults().objectForKey("AllData") == nil
        {
            if self.appDel.checkInternetConnection()
            {
                dispatch_async(dispatch_get_main_queue()) {
                    self.appDel.Show_HUD_Offline()
                }
                self.objDataOffline.AllDataWebservice()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
//        let btn: UIButton = (sender as! UIButton)
        NSUserDefaults.standardUserDefaults().setValue("", forKey: "str_HomeScreen")

        slectedarray.removeAllObjects()
        for i in 1 ..< 9 {
            let tmpButton = self.view.viewWithTag(i) as? UIButton
            if (appDel.arrayState[i-1] as! Int == 1) {
                tmpButton?.enabled = true
            }
            else
            {
                tmpButton?.enabled = false
            }
            if i == 1 {
                slectedarray.addObject(1)
                slectedarray.addObject(1)
                slectedarray.addObject(appDel.arrayState[i-1] as! Int)
            }
            else if (i > 2)
            {
                slectedarray.addObject(appDel.arrayState[i-1] as! Int)
            }
            
        }
        Home_collection.reloadData()
        
        //////
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
                    timer = NSTimer.scheduledTimerWithTimeInterval(0.4, target: self, selector: #selector(HomeVC.update), userInfo: nil, repeats: true)
                }
                
                
            }
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        timer.invalidate()
    }
    
    
    
    func update()
    {
        if self.appDel.checkInternetConnection()
        {
            
            self.objDataOffline.backgroundDeletethread()
        }
        self.view.userInteractionEnabled = true
    }
    
    
    // MARK: - Webservice NetLost delegate
    func NetworkLost(str: String!)
    {
        HelperClass.NetworkLost(str, view1: self)
    }
    
    
    func responseDictionary(dic: NSMutableDictionary) {
        
    }
    
    
    
    //MARK: - No Use
    @IBAction func HomeAction(sender : UIButton)
    {
        if(sender.tag == 1){
            self.navigationController!.pushViewController(self.storyboard!.instantiateViewControllerWithIdentifier("AdminSystemVC") as UIViewController, animated: true)
            return
        }
        else if(sender.tag == 2){
            
            // incubator
        }
        else if(sender.tag == 3){
        self.navigationController!.pushViewController(self.storyboard!.instantiateViewControllerWithIdentifier("MoveHatchlingVC") as UIViewController, animated: true)
            return
        }
        else if(sender.tag == 4){
        self.navigationController!.pushViewController(self.storyboard!.instantiateViewControllerWithIdentifier("AddSectionVC") as UIViewController, animated: true)
            return
        }
        else if(sender.tag == 5){
            self.navigationController!.pushViewController(self.storyboard!.instantiateViewControllerWithIdentifier("InspectionVC") as UIViewController, animated: true)
            return
        }
        else if(sender.tag == 6){
            self.navigationController!.pushViewController(self.storyboard!.instantiateViewControllerWithIdentifier("KillVC") as UIViewController, animated: true)
            return
            
        }
        else if(sender.tag == 7){
            self.navigationController!.pushViewController(self.storyboard!.instantiateViewControllerWithIdentifier("UpdateSectionVC") as UIViewController, animated: true)
            return
            
        }
        else if(sender.tag == 8){
            self.navigationController!.pushViewController(self.storyboard!.instantiateViewControllerWithIdentifier("AddReportVC") as UIViewController, animated: true)
            return
        }
    }
    
    
    //MARK:- UICollectionView Delegates
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrData.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("HomeCollectionViewCell",forIndexPath:indexPath) as! HomeCollectionViewCell
        cell.backgroundColor = UIColor.clearColor()
        cell.backgroundView = nil
        
        let image = UIImage(named: self.arrData[indexPath.row] as! String)
        cell.userImage.image = image
        
        if (slectedarray[indexPath.row] as! Int == 1) {
            cell.userInteractionEnabled = true
            cell.alpha = 1
        }
        else {
            cell.alpha = 0.5
            cell.userInteractionEnabled = false
        }
        return cell
    }
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        var collectionViewSize = collectionView.frame.size
        collectionViewSize.width = collectionViewSize.width/3 //Display 2 elements in a row.
        collectionViewSize.height = 236
        
        return collectionViewSize
    }
    //didSelectItemAtIndexPath
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath){
        if(indexPath.row == 2){
            self.navigationController!.pushViewController(self.storyboard!.instantiateViewControllerWithIdentifier("AdminSystemVC") as UIViewController, animated: true)
            return
        }
        else if(indexPath.row == 3){
            self.navigationController!.pushViewController(self.storyboard!.instantiateViewControllerWithIdentifier("MoveHatchlingVC") as UIViewController, animated: true)
            return
        }
        else if(indexPath.row == 4){
            self.navigationController!.pushViewController(self.storyboard!.instantiateViewControllerWithIdentifier("AddSectionVC") as UIViewController, animated: true)
            return
        }
        else if(indexPath.row == 5){
            self.navigationController!.pushViewController(self.storyboard!.instantiateViewControllerWithIdentifier("InspectionVC") as UIViewController, animated: true)
            return
        }
        else if(indexPath.row == 6){
            self.navigationController!.pushViewController(self.storyboard!.instantiateViewControllerWithIdentifier("KillVC") as UIViewController, animated: true)
            return
            
        }
        else if(indexPath.row == 7){
            self.navigationController!.pushViewController(self.storyboard!.instantiateViewControllerWithIdentifier("UpdateSectionVC") as UIViewController, animated: true)
            return
            
        }
        else if(indexPath.row == 8){
            self.navigationController!.pushViewController(self.storyboard!.instantiateViewControllerWithIdentifier("AddReportVC") as UIViewController, animated: true)
            return
        }
    }
    
    
    //MARK: -
    func Databse_dateconvertor(datestr: String!) -> NSDate
    {
        //        let dateFormatter: NSDateFormatter = NSDateFormatter()
        let twelveHourLocale: NSLocale = NSLocale(localeIdentifier: "en_US_POSIX")
        dateFormatter.locale = twelveHourLocale
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC")
        let gotDate: NSDate = dateFormatter.dateFromString(datestr)!
        return gotDate
    }
   

}
