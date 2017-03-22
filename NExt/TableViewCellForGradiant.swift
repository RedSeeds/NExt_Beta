//
//  TableViewCellForGradiant.swift
//  NExt
//
//  Created by Douglas Sexton on 3/21/17.
//  Copyright © 2017 Douglas Sexton. All rights reserved.
//

import UIKit
import QuartzCore



class TableViewCellForGradiant: UITableViewCell {
    
    // outlets

    @IBOutlet weak var titleText: UILabel!
    
    @IBOutlet weak var dateLable: UILabel!
    
    @IBOutlet weak var checkMark: UILabel!
    let gradientLayer = CAGradientLayer()
    
    /*
    override func draw(_ rect: CGRect) {
    
        // gradient layer for cell
        gradientLayer.frame = bounds
        let color1 = UIColor(white: 1.0, alpha: 0.2).cgColor as CGColor
        let color2 = UIColor(white: 1.0, alpha: 0.1).cgColor as CGColor
        let color3 = UIColor.clear.cgColor as CGColor
        let color4 = UIColor(white: 0.0, alpha: 0.1).cgColor as CGColor
        gradientLayer.colors = [color1, color2, color3, color4]
        gradientLayer.locations = [0.0, 0.01, 0.95, 1.0]
        layer.insertSublayer(gradientLayer, at: 0)
    }
    

    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
    
    */
}
