//
//  PopAnimator.swift
//  Comic Style Controller
//
//  Created by Douglas Sexton on 12/1/15.
//  Copyright © 2015 Douglas Sexton. All rights reserved.
//

import UIKit
import QuartzCore


class PopAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    var startingOrigin = CGRect.zero
    let sizAnimationDuration = 0.5
    
    let duration    = 0.8
    var animating = false
    var operation: UINavigationControllerOperation = .push
    weak var storedContext: UIViewControllerContextTransitioning? = nil
    
    var presenting  = true
    var originFrame = CGRect.zero
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        let containerView = transitionContext.containerView
        
        let toView =
        transitionContext.view(forKey: UITransitionContextViewKey.to)!
        
        let nextVC = presenting ? toView : transitionContext.view(forKey: UITransitionContextViewKey.from)!
        
        
        let initialFrame = presenting ? originFrame : nextVC.frame
               let finalFrame = presenting ? nextVC.frame : originFrame
        
        let xScaleFactor = presenting ?
            initialFrame.width / finalFrame.width :
            finalFrame.width / initialFrame.width
        
        let yScaleFactor = presenting ?
            initialFrame.height / finalFrame.height :
            finalFrame.height / initialFrame.height
 
    
    let scaleTransform = CGAffineTransform(scaleX: xScaleFactor, y: yScaleFactor)
    
    if presenting {
    nextVC.transform = scaleTransform
    nextVC.center = CGPoint(
    x: initialFrame.midX,
    y: initialFrame.midY)
    nextVC.clipsToBounds = true
    }
    
    containerView.addSubview(toView)
    containerView.bringSubview(toFront: nextVC)
        
    nextVC.alpha = 1
    UIView.animate(withDuration: duration, delay:0.0,
    usingSpringWithDamping: 0.7,
    initialSpringVelocity: 0.0,
    options: [],
    animations: {
    nextVC.transform = self.presenting ?
    CGAffineTransform.identity : scaleTransform
    
    nextVC.center = CGPoint(x: finalFrame.midX,
    y: finalFrame.midY)
    
    }, completion:{_ in
    transitionContext.completeTransition(true)
        
    })
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            
            if self.presenting {
                nextVC.alpha = 1
            }else{
                nextVC.alpha = 0
            }
        }) 
        let round = CABasicAnimation(keyPath: "cornerRadius")
        round.fromValue = presenting ? 10.0/xScaleFactor : 0.0
        round.toValue = presenting ? 0.0 : 10.0/xScaleFactor
        round.duration = duration / 2
        nextVC.layer.add(round, forKey: nil)
        nextVC.layer.cornerRadius = presenting ? 0.0 : 10.0/xScaleFactor
    }
    
    // Takes a UIView peramitor and transforms it from location A to B and back
    
    
    
    
    
    
    func animateTransitionOnView(_ view: UIView, startOrigin: CGRect, finalSize: CGRect) {
      
        view.isHidden = !presenting
        
        
        let initialFrame = presenting ? startOrigin : view.frame
        let finalFrame = presenting ? view.frame : startOrigin
        //let padedView = CGRect(x: 20, y: 20, width: 200, height: 400)
        
        let xScaleFactor = presenting ?
            initialFrame.width / finalFrame.width :
            finalFrame.width + initialFrame.width
        
        let yScaleFactor = presenting ?
            initialFrame.height / finalFrame.height :
            finalFrame.height / initialFrame.height
        print("\(initialFrame,finalFrame, xScaleFactor,yScaleFactor)")
        
        let scaleTransform = CGAffineTransform(scaleX: xScaleFactor, y: yScaleFactor)
        
        if presenting {
            view.transform = scaleTransform
            view.center = CGPoint(
                x: initialFrame.midX,
                y: initialFrame.midY)
            view.clipsToBounds = true
        }
        
        view.alpha = 1
        
        UIView.animate(withDuration: duration, delay:0.0,
            usingSpringWithDamping: 0.9,
            initialSpringVelocity: 0.0,
            options: [],
            animations: {
                view.transform = self.presenting ?
                    CGAffineTransform.identity : scaleTransform
                
                view.center = CGPoint(x: finalFrame.midX,
                    y: finalFrame.midY)
                
            }, completion:nil)
        
        UIView.animate(withDuration: 0.1, animations: { () -> Void in
            
            if self.presenting {
               view.alpha = 1
            }else{
                view.alpha = 0
            }
        }  ) 
        let round = CABasicAnimation(keyPath: "cornerRadius")
        round.fromValue = presenting ? 10.0/xScaleFactor : 0.0
        round.toValue = presenting ? 0.0 : 10.0/xScaleFactor
        round.duration = duration / 2
        view.layer.add(round, forKey: nil)
        view.layer.cornerRadius = presenting ? 0.0 : 10.0/xScaleFactor
        
        
        
        print(view.isHidden)
    }

    
}







