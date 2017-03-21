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
    
    
    override func draw(_ rect: CGRect) {
    
        // gradient layer for cell
        gradientLayer.frame = bounds
        let color1 = UIColor(red: 66/255, green: 66/255, blue: 66/255, alpha: 1.0)
        //let color1 = UIColor(white: 1.0, alpha: 0.2).cgColor as CGColor
       // let color2 = UIColor(white: 1.0, alpha: 0.1).cgColor as CGColor
       // let color3 = UIColor.clear.cgColor as CGColor
        //let color4 = UIColor(white: 0.0, alpha: 0.1).cgColor as CGColor
        let color4 = UIColor(red: 25/255, green: 25/255, blue: 25/255, alpha: 1.0)
        gradientLayer.colors = [color1, color4]
        gradientLayer.locations = [0.0, 1.0]
        layer.insertSublayer(gradientLayer, at: 0)
    
    
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
    
    
}
