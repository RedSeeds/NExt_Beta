//
//  ProgressRingViewController.swift
//  NExt
//
//  Created by Douglas Sexton on 3/4/17.
//  Copyright © 2017 Douglas Sexton. All rights reserved.
//

import Foundation
import UIKit




class ProgressRingViewController: UIViewController {
    

    @IBOutlet weak var statView: StatView!

    
    var list: Checklist?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
       
        
        statView.range = CGFloat(10.0)
        statView.curValue = CGFloat(5.0)
        
      
        /*
        statView.range = CGFloat(book.chaptersTotal)
        statView.curValue = CGFloat(book.chaptersRead)
        stepper.value = Double(book.chaptersRead)
        stepper.maximumValue = Double(book.chaptersTotal)
    }
    */

}
}
