//
//  UserListView.swift
//  Crocodile
//
//  Created by Nibha Aggarwal on 6/13/16.
//  Copyright © 2016 Nibha Aggarwal. All rights reserved.
//

import UIKit

protocol userlistProtocol: class {
    func cancelMethod()
    func DoneMethod(EmailUsers: String!)
}

class UserListView: UIView {
    @IBOutlet var tabelview_UserList: UITableView!
    var delegate:userlistProtocol!
    var array_List: NSMutableArray = []
    var selecteditems: NSMutableArray! = []
    
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "UserListView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! UIView
    }

    override func drawRect(rect: CGRect) {
        array_List = NSUserDefaults.standardUserDefaults().valueForKey("UserList")?.mutableCopy() as! NSMutableArray
        print(array_List)
        tabelview_UserList.reloadData()
        if array_List.count != 0 {
            for _ in 0 ..< array_List.count {
                selecteditems.addObject("NO")
            }
        }
        print(selecteditems)
    }
    
    
    func showView(view1: UIView, frame1: CGRect) -> UIView
    {
        for i in 0 ..< selecteditems.count {
            selecteditems.replaceObjectAtIndex(i, withObject: "NO")
        }
        tabelview_UserList.reloadData()
        self.frame = frame1
        view1.addSubview(self)
        self.alpha = 0
        let transitionOptions = UIViewAnimationOptions.TransitionCurlDown
        UIView.transitionWithView(self, duration: 0.75, options: transitionOptions, animations: {
            self.alpha = 1
            
            }, completion: { finished in
                
                // any code entered here will be applied
                // .once the animation has completed
        })
        return self
    }
    
    
    func removeView(view1: UIView) -> UIView
    {
        let transitionOptions = UIViewAnimationOptions.TransitionCurlUp
        UIView.transitionWithView(self, duration: 0.75, options: transitionOptions, animations: {
            self.alpha = 0
            
            }, completion: { finished in
                self.removeFromSuperview()
                // any code entered here will be applied
                // .once the animation has completed
        })
        
        return self
    }
   
    
    @IBAction func Cancel_btnAction(sender: AnyObject) {
        self.delegate.cancelMethod()
    }
    
    @IBAction func Done_btnAction(sender: AnyObject) {
        let temparray: NSMutableArray! = []
        for i in 0 ..< selecteditems.count {
            if !(selecteditems[i] as! String == "NO") {
                temparray.addObject(selecteditems[i] as! String)
            }
        }
        
        var comma: String!
        if temparray.count > 0 {
            comma = temparray.componentsJoinedByString(",")
        }
        self.delegate.DoneMethod(comma)
    }
    
    // MARK: -  tableview Delegates
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(array_List.count)
        return array_List.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 40.0
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
        cell.textLabel?.text = array_List.objectAtIndex(indexPath.row).valueForKey("Email") as? String
        cell.textLabel!.font = UIFont(name: "HelveticaNeue", size: 22)
        if (selecteditems[indexPath.row] as! String == "NO") {
            cell.accessoryType = .None
        }
        else {
            cell.accessoryType = .Checkmark
        }

        
        
         return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if tableView.cellForRowAtIndexPath(indexPath)!.accessoryType == .Checkmark {
        tableView.cellForRowAtIndexPath(indexPath)!.accessoryType = .None
        selecteditems[indexPath.row] = "NO"
    }
    else {
        tableView.cellForRowAtIndexPath(indexPath)!.accessoryType = .Checkmark
        selecteditems[indexPath.row] = array_List.objectAtIndex(indexPath.row).valueForKey("Email")!
        }
    }

}
