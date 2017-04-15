//
//  CustomTableViewCell.swift
//  Crocodile
//
//  Created by Nibha Aggarwal on 6/2/16.
//  Copyright © 2016 Nibha Aggarwal. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var customImageView: UIImageView!
    @IBOutlet weak var customlabel_left: UILabel!
    @IBOutlet weak var customlbl_middle: UILabel!
    @IBOutlet weak var customImg_orange: UIImageView!
    @IBOutlet weak var customlbl_upperImge: UILabel!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
