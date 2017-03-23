//
//  StressHeadViewController.swift
//  NExt
//
//  Created by Douglas Sexton on 3/22/17.
//  Copyright © 2017 Douglas Sexton. All rights reserved.
//

import UIKit



class StressHeadViewController: UIViewController, UIDynamicAnimatorDelegate {
    
    var animator: UIDynamicAnimator!
    var gravity: UIGravityBehavior!
    var collision: UICollisionBehavior!
    
    var square: UIView!
    var snap: UISnapBehavior!
    
    @IBOutlet weak var stressHeadView: UIView!
    
    @IBAction func handlePan(recognizer:UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self.view)
        if let view = recognizer.view {
            view.center = CGPoint(x:view.center.x + translation.x,
                                  y:view.center.y + translation.y)
        }
        recognizer.setTranslation(CGPoint.zero, in: self.view)
        
        if recognizer.state == UIGestureRecognizerState.ended {
            // 1
            let velocity = recognizer.velocity(in: self.view)
            let magnitude = sqrt((velocity.x * velocity.x) + (velocity.y * velocity.y))
            let slideMultiplier = magnitude / 200
            print("magnitude: \(magnitude), slideMultiplier: \(slideMultiplier)")
            
            // 2
            let slideFactor = 0.1 * slideMultiplier     //Increase for more of a slide
            // 3
            var finalPoint = CGPoint(x:recognizer.view!.center.x + (velocity.x * slideFactor),
                                     y:recognizer.view!.center.y + (velocity.y * slideFactor))
            // 4
            finalPoint.x = min(max(finalPoint.x, 0), self.view.bounds.size.width)
            finalPoint.y = min(max(finalPoint.y, 0), self.view.bounds.size.height)
            
            // 5
            UIView.animate(withDuration: Double(slideFactor * 2),
                                       delay: 0,
                                       // 6
                options: UIViewAnimationOptions.curveEaseOut,
                animations: {recognizer.view!.center = finalPoint },
                completion: nil)
        }
        
    }
    
    @IBOutlet weak var doneButton: UIButton!
    
    @IBAction func done(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        square = UIView(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
        let frame = CGRect(x: 100, y: 100, width: 100, height: 100)
        stressHeadView.frame = frame
        square.backgroundColor = UIColor.gray
        view.addSubview(square)
        
        let barrier = UIView(frame: CGRect(x: 0, y: 300, width: 130, height: 20))
        barrier.backgroundColor = UIColor.red
        view.addSubview(barrier)
        
        animator = UIDynamicAnimator(referenceView: view)
        gravity = UIGravityBehavior(items: [square,stressHeadView])
        animator.addBehavior(gravity)
        
        // causes   collision = UICollisionBehavior(items: [square, barrier])
        collision = UICollisionBehavior(items: [square,stressHeadView])
        // add a boundary that has the same frame as the barrier
        collision.addBoundary(withIdentifier: "barrier" as NSCopying, for: UIBezierPath(rect: barrier.frame))
        collision.translatesReferenceBoundsIntoBoundary = true
        animator.addBehavior(collision)
        
        let itemBehaviour = UIDynamicItemBehavior(items: [square,stressHeadView])
        itemBehaviour.elasticity = 0.6
        animator.addBehavior(itemBehaviour)
    }
    
     func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        if (snap != nil) {
            animator.removeBehavior(snap)
        }
        
        let touch = touches.anyObject() as! UITouch
        snap = UISnapBehavior(item: square, snapTo: touch.location(in: view))
        animator.addBehavior(snap)
    }
    
}

extension StressHeadViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
}
