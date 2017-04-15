

//
//  UpdateMoveSelect.swift
//  Crocodile
//
//  Created by Nibha Aggarwal on 6/10/16.
//  Copyright © 2016 Nibha Aggarwal. All rights reserved.
//

import UIKit

class UpdateMoveSelect: UIViewController {
    var toPassToAnother_dic: NSMutableDictionary! = NSMutableDictionary()
    var appDel : AppDelegate!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let controller = self.storyboard!.instantiateViewControllerWithIdentifier("CommonClassVC") as? CommonClassVC
            else {
                fatalError();
        }
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
        
        appDel = (UIApplication.sharedApplication().delegate as! AppDelegate)
        
        print(toPassToAnother_dic)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func Back_Btn(sender: AnyObject) {
        
//
    }
    @IBAction func SystemSelect_Btn(sender: AnyObject) {
            let obj = self.storyboard?.instantiateViewControllerWithIdentifier("UpdateSystemSelectVC") as! UpdateSystemSelectVC
            obj.toPass = toPassToAnother_dic
            self.navigationController?.pushViewController(obj, animated: false)
    }

    @IBAction func CustomSelect_Btn(sender: AnyObject) {
           let obj = self.storyboard?.instantiateViewControllerWithIdentifier("UpdateCustomSelectVC") as! UpdateCustomSelectVC
            obj.toPass = toPassToAnother_dic
            self.navigationController?.pushViewController(obj, animated: false)


    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
