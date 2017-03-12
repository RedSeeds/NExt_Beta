//
//  ListCell.swift
//  NExt
//
//  Created by Douglas Sexton on 2/22/17.
//  Copyright © 2017 Douglas Sexton. All rights reserved.
//

import Foundation
import UIKit


class ListCell: UITableViewCell {
    
    @IBOutlet weak var statView: StatView!
    
    @IBOutlet var itemImageView: UIImageView!
    @IBOutlet var text1: UILabel!
    @IBOutlet var text2: UILabel!
   
    @IBOutlet weak var badgeView: UIView!

    @IBOutlet weak var badgeLabel: UILabel!
  

    @IBOutlet weak var nextItemText: UILabel!
    
    @IBOutlet weak var nextItemsDueDate: UILabel!
    
    @IBOutlet weak var imageWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var badgeViewLeadingContraint: NSLayoutConstraint!
    
     // Used to possition the badgeView to the top right corner of the Stat view
    
    @IBOutlet weak var badgeViewYContraint: NSLayoutConstraint!
    @IBOutlet weak var badgeViewXConstraint: NSLayoutConstraint!
    
    
    // Actions
    @IBAction func buttonTap(sender: AnyObject) {
        // Something should happen here
        tapAction?(self)
    }
    
    var tapAction: ((UITableViewCell) -> Void)?
    
    
    
    
    
}
