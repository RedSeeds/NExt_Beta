//
//  MoodVIewController.swift
//  NExt
//
//  Created by Douglas Sexton on 3/22/17.
//  Copyright © 2017 Douglas Sexton. All rights reserved.
//

import UIKit


class MoodViewController: UIViewController {
    
    
    
    @IBAction func animateButtonPressed(sender: AnyObject) {
        
        // loop for 10 times
        
    
        for _ in 0...10 {
            
            // Create and add a colored square
            // create the square using these constants
            // in this example I've also used the Objective-C convention for making the CGRect
            // but I could have used CGRect(x:0, y:yPosition, width:size, height:size) like we've done previously - they are equivalent
            // set up some constants for the square
            // set up some constants for the animation
            
            // set size to be a random number between 20.0 and 60.0
            let size : CGFloat = CGFloat( arc4random_uniform(40))+20
            
            // set yPosition to be a random number between 20.0 and 220.0
            let yPosition : CGFloat = CGFloat( arc4random_uniform(300))+80
            
            let coloredSquare = UIView()
            
            coloredSquare.backgroundColor = UIColor.blue
            coloredSquare.frame = CGRect(x: -coloredSquare.frame.width, y: yPosition, width: size, height: size)
            self.view.addSubview(coloredSquare)
            
            
            let duration = 1.0
            let delay = TimeInterval(900 + arc4random_uniform(100)) / 200
            
            
            // set background color to blue
            coloredSquare.backgroundColor = UIColor.blue
            
            // set frame (position and size) of the square
            // iOS coordinate system starts at the top left of the screen
            // so this square will be at top left of screen, 50x50pt
            // CG in CGRect stands for Core Graphics
            coloredSquare.frame = CGRect(x: -coloredSquare.frame.width * 3, y: 120, width: 50, height: 50)
            
            // finally, add the square to the screen
            self.view.addSubview(coloredSquare)
            
            
            // lets set the duration to 1.0 seconds
            // and in the animations block change the background color
            // to red and the x-position  of the frame
            
            coloredSquare.layer.cornerRadius = coloredSquare.frame.width / 2
            
            // define the animation
            UIView.animate(withDuration: duration, delay: delay, options: .curveLinear, animations: {
                
                coloredSquare.backgroundColor = UIColor.red
                
                // again use the square constants size and yPosition
                //coloredSquare.frame = CGRect(320-size, y: yPosition, width: size, height: size)
                
                coloredSquare.frame = CGRect(x: self.view.frame.width  + coloredSquare.frame.width, y: yPosition, width: size, height: size)
                coloredSquare.layer.cornerRadius = coloredSquare.frame.width / 2
            }, completion: { animationFinished in
                
                coloredSquare.removeFromSuperview()
                
            })
            // Note: I didn't want to do anything with the completion block
            // in this example so I set it to 'nil'
            }
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
                }
    
    
    
    
    
    
    
    
    
    
}


