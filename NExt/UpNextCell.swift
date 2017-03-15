//
//  UpNextCell.swift
//  NExt
//
//  Created by Douglas Sexton on 2/28/17.
//  Copyright © 2017 Douglas Sexton. All rights reserved.
//

import Foundation
import UIKit



class UpNextCell: UICollectionViewCell {
    
    @IBOutlet var dueDate: UILabel!
    @IBOutlet var itemText: UILabel!
    

    
    @IBOutlet weak var centerIconImageView: UIImageView!
    

    
    
    func activateRedLine(){
        
        UIView.animate(withDuration: 0.5, delay: 3.0, options: .curveEaseInOut, animations: {
            
            
            self.layoutIfNeeded()
            
            
        }, completion: nil)
        
    }
    
    
}
