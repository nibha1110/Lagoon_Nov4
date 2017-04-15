//
//  AddToDieVC.swift
//  Crocodile
//
//  Created by Nibha Aggarwal on 6/23/16.
//  Copyright © 2016 Nibha Aggarwal. All rights reserved.
//

import UIKit

class AddToDieVC: UIViewController {

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
        controller.IIndexPath = NSIndexPath(forRow: 2, inSection: 1)
        controller.tableMenu.reloadData()
        controller.label_header.text = "ADD TO DIE"
        controller.btn_Sync.hidden = false
        controller.img_Sync.hidden = false
        controller.btn_BackPop.hidden = true
        controller.array_temp_section.replaceObjectAtIndex(1, withObject: "Yes")
        let arrt = controller.array_temp_row[1]
        arrt.replaceObjectAtIndex(2, withObject: "Yes")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //MARK: - button_singlePen
    @IBAction func button_singlePen(sender: AnyObject)
    {
        let obj = self.storyboard?.instantiateViewControllerWithIdentifier("SingleDieVC") as! SingleDieVC
        self.navigationController?.pushViewController(obj, animated: false)
    }
    
    //MARK: - button_grouped
    @IBAction func button_grouped(sender: AnyObject)
    {
        let obj = self.storyboard?.instantiateViewControllerWithIdentifier("GroupDieVC") as! GroupDieVC
        self.navigationController?.pushViewController(obj, animated: false)
    }
    

}
