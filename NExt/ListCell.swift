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
    
    func transformIn(delay:TimeInterval){
        UIView.animate(withDuration: 0.5, delay: delay, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.6, options:.curveEaseIn, animations: {
            
            self.statView.layer.cornerRadius = self.statView.frame.width / 2
            self.statView.transform = CGAffineTransform.identity
            
        }, completion: nil )
        statView.transform = CGAffineTransform.identity
    }
    
    
    var startSize: CGFloat? {
        didSet{
            if let startSize = startSize {
                statView.transform = CGAffineTransform(scaleX: startSize, y: startSize)
            }
        }
    }
    
    var endSize: CGFloat? {
        didSet{
            
            if let endSize = endSize {
                statView.transform = CGAffineTransform(scaleX: endSize, y: endSize)
            }
        }
    }
   
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
