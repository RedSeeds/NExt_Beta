//
//  ListDetailViewController.swift
//  NExt
//
//  Created by Douglas Sexton on 2/19/17.
//  Copyright © 2017 Douglas Sexton. All rights reserved.
//

import Foundation
import UIKit

protocol ListDetailViewControllerDelegate: class {
    func listDetailViewControllerDidCancel(
        _ controller: ListDetailViewController)
    func listDetailViewController(_ controller: ListDetailViewController,
                                  didFinishAdding checklist: Checklist)
    func listDetailViewController(_ controller: ListDetailViewController,
                                  didFinishEditing checklist: Checklist)
}

class ListDetailViewController: UITableViewController,
UITextFieldDelegate {
    
    // Variable
    weak var delegate: ListDetailViewControllerDelegate?
    var checklistToEdit: Checklist?
    var themeIconName = "Empty-Smilly"
    var iconViews: [UIView]=[]
    var selectedIconImage: UIImageView?
    var defaultIconName = "Empty-Smilly"
    var selectedIconName = ""
    var photoTaken = false
    var photoSelected = false
    var animate = true // tells the controller to only animate upon first view once user is edditing, to avoid over animations

    // Outlets
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    // Icon views and buttons contained within the animated views
    // top display for images picked as icon
    
    // used to animate the textField as textFields are not transformable
    @IBOutlet weak var textFieldView: UIView!
    
    
    @IBOutlet weak var topIconDiplayView: UIView!
    @IBOutlet weak var topIconDisplayViewYconstraint: NSLayoutConstraint!
    
    // Left icon view
    @IBOutlet weak var leftIconView: UIView!
    @IBOutlet weak var leftIconViewButton: UIButton!
    @IBOutlet weak var leftIconImageVIew: UIImageView!
    @IBOutlet weak var leftIconLabel: UILabel!
    @IBOutlet weak var leftIconXConstraint: NSLayoutConstraint!
    @IBOutlet weak var leftIconBottom: NSLayoutConstraint!
    
    //Center view
    @IBOutlet weak var centerIconView: UIView!
    @IBOutlet weak var centerIconImageButton: UIButton!
    @IBOutlet weak var centerIconImageView: UIImageView!
    @IBOutlet weak var centerIconLabel: UILabel!
    @IBOutlet weak var centerIconXConstraint: NSLayoutConstraint!
    @IBOutlet weak var centerIconBottom: NSLayoutConstraint!
    
    
    
    // Right Icon view
    @IBOutlet weak var rightIconView: UIView!
    @IBOutlet weak var rightIconViewButton: UIButton!
    @IBOutlet weak var rightIconImageView: UIImageView!
    @IBOutlet weak var rightIconViewLabel: UILabel!
    @IBOutlet weak var rightIconXConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightIconYBottom: NSLayoutConstraint!
    @IBOutlet weak var tableviewCellone: UITableViewCell!
    
    
    var mirrorImage: UIImage!
    
    // Outlets used to capture user photos for list icons
    // Left IconView Button
    
    
    // Sets "selectedIconImage variable to the clicked view in Icon views
    @IBAction func selectIconButton(_ sender: Any) {
        
        // stops the animations after the first set up
        self.animate = false
        if sender as! UIButton == leftIconViewButton {
            UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.6, options: .curveEaseInOut, animations: {
                
                
               
                self.leftIconXConstraint.constant = -self.topIconDiplayView.frame.height - 20
                
                self.view.layoutIfNeeded()
                
            }, completion: nil)
            takePhoto()
            
        }else if sender as! UIButton == centerIconImageButton {
       
            self.leftIconBottom.constant = self.topIconDiplayView.frame.height + 20
            
            
        }else if sender as! UIButton == rightIconViewButton {
            pickPhoto()
           
            self.rightIconXConstraint.constant = 120
        }
    }
    
    
    // Actions
    @IBAction func cancel() {
        delegate?.listDetailViewControllerDidCancel(self)
    }
    
    @IBAction func done() {
        
        // 1. check to see if a checklist was passed to edit
        
        if let checklist = checklistToEdit {
            
            // 2  set name, all list are required to be named
            checklist.name = textField.text!
            
            // 3 set icon image to the center imageview
            checklist.iconImage = centerIconImageView.image!
            
            
            
            // 4. pass edited checklist back to presenting controller via delegate
            delegate?.listDetailViewController(self, didFinishEditing: checklist)
            
        } else {
            
            // process to pass a NEW Checklist object back to the Delegate
            let checklist = Checklist(name: textField.text!)
            checklist.iconImage = centerIconImageView.image!
            
            delegate?.listDetailViewController(self, didFinishAdding: checklist)
        }
        
    }
    
    // Segue attatched to the button, segues to the pickIcon vc
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PickIcon" {
            
            let controller = segue.destination as! IconPickerViewController
            controller.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1. Checks if a list has been passed to edit, if yes, moves to 2
        if let checklist = checklistToEdit {
            title = "Edit Checklist"
            textField.text = checklist.name
            doneBarButton.isEnabled = true
            mirrorImage = checklist.iconImage
            
            // 2 ask the checklist for the saved icon image
            centerIconImageView.image = checklist.iconImage
            
            
        }
        
        // adds icon image views to array for easy sorting
        iconViews = [leftIconView,centerIconView,rightIconView,topIconDiplayView]
        
        // method used to set radious, borders and border colors on icon Views. Since Icon imageViews are in Icon Views and cliped to bounds the icon imageView is set to the radious of the Parent View
        setUpButtonAndViews()
        
        
    }
    
    // MARK: HELPER METHODS *******************************
    
    // Sets icon views radious to a circle, by itterating through array set up in viewdidload
    func setUpButtonAndViews(){
        for view in iconViews {
            view.layer.cornerRadius = view.frame.width / 2
            view.layer.borderWidth = 0.5
            view.layer.borderColor = UIColor.white.cgColor
            view.transform = CGAffineTransform(scaleX: 0, y: 0)
            
        }
    }
    
    func transformView(view: UIView, size: CGFloat){
        
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            view.transform = CGAffineTransform(scaleX: size, y: size)
        }, completion: nil)
    }
    
    // End of helper menthods *******************************
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Sets text feild to first responder, meaning places curser in filed and shows keypad
        textField.becomeFirstResponder()
        
        if animate {
        self.transformView(view: self.leftIconView, size: 0)
        self.transformView(view: self.rightIconView, size: 0)
        self.transformView(view: self.centerIconView, size: 0)
       self.transformView(view: textFieldView, size: 0.2)
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if animate {
            UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.6, options: .curveEaseInOut, animations: {
                
                self.textFieldView.transform = CGAffineTransform.identity
                self.view.layoutIfNeeded()
                
                
            }, completion: nil)
            
            
            UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.6, options: .curveEaseInOut, animations: {
                
                // animates imageviews upon appearing
                self.transformView(view: self.leftIconView, size: 1.3)
                self.transformView(view: self.rightIconView, size: 1.3)
                self.transformView(view: self.centerIconView, size: 1.3)
                self.transformView(view: self.topIconDiplayView, size: 1)
                
                self.leftIconXConstraint.constant = -self.topIconDiplayView.frame.width - 20
                
                self.centerIconBottom.constant = 150
                self.rightIconXConstraint.constant = self.topIconDiplayView.frame.height + 20
                
                
                self.view.layoutIfNeeded()
                
                
            }, completion: nil)
        }
        
        
        if photoTaken {
            wantToSave()
        }
   
    }
    

    
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.section == 1 {
            return indexPath
        }else{
            return nil
        }
    }
    
    // enables to done button once user enters a text charactor
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text! as NSString
        let newText = oldText.replacingCharacters(in: range, with: string)
            as NSString
        doneBarButton.isEnabled = (newText.length > 0)
        return true
    }
    
}

extension ListDetailViewController: IconPickerViewControllerDelegate {
    
    func iconPicker(_ picker: IconPickerViewController, didPick themeIconImage: UIImage) {
        
        // 1 sets the selected image as the icon image
        centerIconImageView.image = themeIconImage

        
        // 2 allows the vc to be dismissed by the delgate
        let _ = navigationController?.popViewController(animated: true)
    }
    
}

// Used to capture photo from camera or users photos, and use as List icon image
extension ListDetailViewController: UIImagePickerControllerDelegate{
    
    func takePhoto() {
        photoTaken = true
        photoSelected = false
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        
        
        }else{
            NSLog("No Camera.")
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // 1 captures photo taken or image from photos
        if let pickerImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            picker.allowsEditing = true
            
            // 2 place image in the image view as an icon image
            centerIconImageView.image = pickerImage
            
           
        }
        picker.dismiss(animated: true, completion: nil )
        
     
        print("camera used")
    }
    
    func pickPhoto() {
        
        photoTaken = false
        photoSelected = true
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    func wantToSave() {
        
        let alert = UIAlertController(title: "Save", message: "Save to Photos?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { (action: UIAlertAction) in
            self.savePhoto()
            print("saved")
        }
        let cancelAction = UIAlertAction(title: "No", style: .default, handler: nil)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
        
    }
  
     // uncomment to allow user to save photo. Disabled to save on memory storage
     func savePhoto() {
       
     let imageData = UIImagePNGRepresentation(centerIconImageView.image!)
     let compresedImage = UIImage(data: imageData!)
     UIImageWriteToSavedPhotosAlbum(compresedImage!, nil, nil, nil)
     
     /*
    // Un comment to push alert stating the photo has been saved
     let alert = UIAlertController(title: "Saved", message: "Your image has been saved", preferredStyle: .alert)
     let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
     alert.addAction(okAction)
     self.present(alert, animated: true, completion: nil)
   */
    }
 
}

extension ListDetailViewController: UINavigationControllerDelegate{
    
}

extension UIView {
    
    func drawGradient(_ startColor:UIColor, endColor: UIColor, startPoint:CGPoint, endPoint:CGPoint) {
        
        let colors = [startColor.cgColor, endColor.cgColor]
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let colorLocations:[CGFloat] = [0.0, 1.0]
        let gradient = CGGradient(colorsSpace: colorSpace, colors: colors as CFArray, locations: colorLocations)
        let context = UIGraphicsGetCurrentContext()
        
        context?.drawLinearGradient(gradient!,
                                    start: startPoint,
                                    end: endPoint,
                                    options: [])
        
    }
    
}

