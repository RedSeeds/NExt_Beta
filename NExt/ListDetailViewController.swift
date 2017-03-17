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
    func listDetailViewController(_controller: ListDetailViewController, didFinishAddingPhoto: UIImage)
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
    
    // test for animation of dials
    
    
    
    
    // Set in tableviewdidSetlect to tell UIImage picker methods which thumnail to populate for preview
    
    // Outlets
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    // Icon views and buttons contained within the animated views
    // top display for images picked as icon
    
    @IBOutlet weak var topIconDiplayView: UIView!
    
    // Left icon view
    @IBOutlet weak var leftIconView: UIView!
    @IBOutlet weak var leftIconViewButton: UIButton!
    @IBOutlet weak var leftIconImageVIew: UIImageView!
    @IBOutlet weak var leftIconLabel: UILabel!
    @IBOutlet weak var leftIconXConstraint: NSLayoutConstraint!
    @IBOutlet weak var leftIconYConstraint: NSLayoutConstraint!
    
    //Center view
    @IBOutlet weak var centerIconView: UIView!
    @IBOutlet weak var centerIconImageButton: UIButton!
    @IBOutlet weak var centerIconImageView: UIImageView!
    @IBOutlet weak var centerIconLabel: UILabel!
    @IBOutlet weak var centerIconXConstraint: NSLayoutConstraint!
    @IBOutlet weak var centerIconYConstraint: NSLayoutConstraint!
    
    
    
    // Right Icon view
    @IBOutlet weak var rightIconView: UIView!
    @IBOutlet weak var rightIconViewButton: UIButton!
    @IBOutlet weak var rightIconImageView: UIImageView!
    @IBOutlet weak var rightIconViewLabel: UILabel!
    @IBOutlet weak var rightIconXConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightIconYConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableviewCellone: UITableViewCell!
    
    
    
    // Outlets used to capture user photos for list icons
    // Left IconView Button
    
    
    // Sets "selectedIconImage variable to the clicked view in Icon views
    @IBAction func selectIconButton(_ sender: Any) {
        
        if sender as! UIButton == leftIconViewButton {
            UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.6, options: .curveEaseInOut, animations: {
                self.leftIconXConstraint.constant = 0
                
              
                self.view.layoutIfNeeded()
                
            }, completion: nil)
            takePhoto()
            
        }else if sender as! UIButton == centerIconImageButton {
        
            self.leftIconYConstraint.constant = 0
            
            
        }else if sender as! UIButton == rightIconViewButton {
            pickPhoto()
            
            self.rightIconXConstraint.constant = 0
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
        
        self.transformView(view: self.leftIconView, size: 0)
        self.transformView(view: self.rightIconView, size: 0)
        self.transformView(view: self.centerIconView, size: 0)
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        UIView.animate(withDuration: 0.5, delay: 0.1, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.6, options: .curveEaseInOut, animations: {
            
            // animates imageviews upon appearing
            self.transformView(view: self.leftIconView, size: 1.3)
            self.transformView(view: self.rightIconView, size: 1.3)
            self.transformView(view: self.centerIconView, size: 1.3)
            self.transformView(view: self.topIconDiplayView, size: 1)
            
            self.leftIconXConstraint.constant = -120
            self.centerIconXConstraint.constant = 0
            self.rightIconXConstraint.constant = 120
            
        
            self.view.layoutIfNeeded()
            
            
        }, completion: nil)
        
        
        
        
        
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
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
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
    }
    
    func pickPhoto() {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    /*
     // uncomment to allow user to save photo. Disabled to save on memory storage
     func savePhoto() {
     let imageData = UIImagePNGRepresentation(rightIconImageView.image!)
     let compresedImage = UIImage(data: imageData!)
     UIImageWriteToSavedPhotosAlbum(compresedImage!, nil, nil, nil)
     
     /* Un comment to push alert stating the photo has been saved
     let alert = UIAlertController(title: "Saved", message: "Your image has been saved", preferredStyle: .alert)
     let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
     alert.addAction(okAction)
     self.present(alert, animated: true, completion: nil)
     */
     }
     */
}

extension ListDetailViewController: UINavigationControllerDelegate{
    
}



