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

     // Used to possition the badgeView to the top right corner of the Stat view
    @IBOutlet weak var badgeViewYContraint: NSLayoutConstraint!
    @IBOutlet weak var badgeViewXConstraint: NSLayoutConstraint!
    
    // applied when a new List is added or eddited, used for vissual ref to a change
    func statViewBounce() {
        statView.alpha = 0.0
        
         statView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        text1.alpha = 0
        text2.alpha = 0
        
        
        UIView.animate(withDuration: 0.5, delay: 0.2, options: .curveEaseOut, animations: {
            
             self.statView.transform = CGAffineTransform(scaleX: 1, y: 1)
            
            self.statView.alpha = 1.0
            self.text1.alpha = 1.0
            self.text2.alpha = 1.0
        }, completion: nil)
    
    }
    
    
}
