//
//  CommentConditionView.swift
//  Crocodile
//
//  Created by Nibha Aggarwal on 21/01/17.
//  Copyright © 2017 Nibha Aggarwal. All rights reserved.
//

import UIKit

protocol CommentConditionProtocol: class {
    func cancelCommentMethod()
    func DoneCommentMethod(Comments: String!)
}

class CommentConditionView: UIView {
    @IBOutlet var tabelview_UserList: UITableView!
    var delegate:CommentConditionProtocol!
    var array_List: NSArray = ["P(Pits)", "W(Wrinkle)", "PIX(Pix)", "S(Scar)", "BS(Brown Spot)", "IS(Infected Sensor)", "Select All", "None"]
    var selecteditems: NSMutableArray! = []
    
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "CommentConditionView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! UIView
    }
    
    override func drawRect(rect: CGRect) {
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
        self.delegate.cancelCommentMethod()
    }
    
    @IBAction func Done_btnAction(sender: AnyObject) {
        let temparray: NSMutableArray! = []
        for i in 0 ..< selecteditems.count {
            if !(selecteditems[i] as! String == "NO") {
                if array_List[i] as! String == "None" {
                    temparray.addObject("")
                }
                else if array_List[i] as! String == "Select All" {
                }
                else
                {
                    temparray.addObject(array_List[i] as! String)
                }
                
            }
        }
        
        var comma: String!
        if temparray.count > 0 {
            comma = temparray.componentsJoinedByString(", ")
        }
        self.delegate.DoneCommentMethod(comma)
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
        
        cell.textLabel?.text = array_List.objectAtIndex(indexPath.row) as? String
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
        //        print(tableView.subviews.)
        let cell:UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        print(cell.subviews.description)
        
        
        if tableView.cellForRowAtIndexPath(indexPath)!.accessoryType == .Checkmark {
            tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = .None
            selecteditems[indexPath.row] = "NO"
            
            if indexPath.row != array_List.count-1 {
                //for unselected last row
                let indexPath1 = NSIndexPath(forRow: array_List.count-2, inSection: 0)
                tableView.cellForRowAtIndexPath(indexPath1)?.accessoryType = .None
                selecteditems[array_List.count-2] = "NO"
            }
        }
        else {
            // for Select All
            print(indexPath.row)
            print(array_List.count)
            if indexPath.row == array_List.count-2 {
                for i in 0 ..< array_List.count-1
                {
                    let indexPath = NSIndexPath(forRow: i, inSection: 0)
                    //                    print(indexPath)
                    tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = .Checkmark
                    if i == array_List.count - 2 {
                        selecteditems[i] = "YES"
                    }
                    else
                    {
                        selecteditems[i] = array_List[i]
                    }
                    
                    print(selecteditems)
                }
                //for unselected last row
                let indexPath1 = NSIndexPath(forRow: array_List.count-1, inSection: 0)
                tableView.cellForRowAtIndexPath(indexPath1)?.accessoryType = .None
                selecteditems[array_List.count-1] = "NO"
            }
                //None
            else if indexPath.row == array_List.count-1
            {
                for i in 0 ..< array_List.count-1
                {
                    let indexPath = NSIndexPath(forRow: i, inSection: 0)
                    tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = .None
                    selecteditems[i] = "NO"
                }
                //select last row
                tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = .Checkmark
                selecteditems[indexPath.row] = "" //array_condition[indexPath.row]
            }
            else  // Other selections
            {
                tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = .Checkmark
                selecteditems[indexPath.row] = array_List[indexPath.row]
                
                //                //for unselected last row
                let indexPath1 = NSIndexPath(forRow: array_List.count-1, inSection: 0)
                tableView.cellForRowAtIndexPath(indexPath1)?.accessoryType = .None
                selecteditems[array_List.count-1] = "NO"
            }
            
        }
    }
    
}
