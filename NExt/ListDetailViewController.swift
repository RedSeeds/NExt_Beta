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
    var iconName = "Empty-Smilly"
    var iconViews: [UIView]=[]
    
    // Set in tableviewdidSetlect to tell UIImage picker methods which thumnail to populate for preview
    var cameraSelected = false
    var myphotosSelected = false
    var centerIconViewSelected = false
    var selectedIconImage: UIView?
    
    // Outlets
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    // Icon views and buttons contained within the animated views
    // Left icon view
    @IBOutlet weak var leftIconView: UIView!
    @IBOutlet weak var leftIconViewButton: UIButton!
    @IBOutlet weak var leftIconImageVIew: UIImageView!
    @IBOutlet weak var leftIconViewXconstraint: NSLayoutConstraint!
    @IBOutlet weak var leftIconLabel: UILabel!
    
    //Center view
    @IBOutlet weak var centerIconView: UIView!
    @IBOutlet weak var centerIconImageButton: UIButton!
    @IBOutlet weak var centerIconImageView: UIImageView!
    @IBOutlet weak var centerViewXconstraint: NSLayoutConstraint!
    @IBOutlet weak var centerViewYconstraint: NSLayoutConstraint!
    @IBOutlet weak var centerIconLabel: UILabel!
    
    
    
    // Right Icon view
    @IBOutlet weak var rightIconView: UIView!
    @IBOutlet weak var rightIconViewButton: UIButton!
    @IBOutlet weak var rightIconImageView: UIImageView!
    @IBOutlet weak var rightIconViewXcostraint: NSLayoutConstraint!
    @IBOutlet weak var rightIconViewLabel: UILabel!
    
    
    
    // Outlets used to capture user photos for list icons
    // Left IconView Button
    @IBAction func leftIconViewButton(_ sender: Any) {
        takePhoto()
        selectedIconImage = sender as? UIView
        
        print("SeleectedIconImage:\(String(describing: selectedIconImage))")
    }
    
    
    // Sets "selectedIconImage variable to the clicked view in Icon views
    @IBAction func rightIconViewButton(_ sender: Any) {
        pickPhoto()
        
        if sender as! UIButton == leftIconViewButton {
            takePhoto()
            selectedIconImage = leftIconImageVIew
            
        }else if sender as! UIButton == centerIconImageButton {
            performSegue(withIdentifier: "PickIcon", sender: nil)
            selectedIconImage = centerIconImageView
            
        }else if sender as! UIButton == rightIconViewButton {
            pickPhoto()
            selectedIconImage = rightIconImageView
        }
    }
    
    
    // Actions
    @IBAction func cancel() {
        delegate?.listDetailViewControllerDidCancel(self)
    }
    
    @IBAction func done() {
        if let checklist = checklistToEdit {
            // Process to pass back an edited Checklist object back to the Delegate
            checklist.name = textField.text!
            // Check to see if the camera, or take picture option was selected. If yes, image views are set to relect
            
            if cameraSelected {
                checklist.iconName = ""
                checklist.capturedPhoto = leftIconImageVIew.image
                checklist.photo = nil
            }else if myphotosSelected {
                checklist.iconName = ""
                checklist.photo = rightIconImageView.image
                checklist.capturedPhoto = nil
            }else if centerIconViewSelected {
                checklist.iconName = iconName
                checklist.capturedPhoto = nil
                checklist.photo = nil
            }
            
            // checklist.iconName = iconName // add this
            delegate?.listDetailViewController(self, didFinishEditing: checklist)
            
        } else {
            // process to pass a new Checklist object back to the Delegate
            let checklist = Checklist(name: textField.text!)
            
            if cameraSelected {
                checklist.iconName = ""
                checklist.capturedPhoto = leftIconImageVIew.image
                checklist.photo = nil
            }else if myphotosSelected{
                checklist.iconName = ""
                checklist.photo = rightIconImageView.image
                checklist.capturedPhoto = nil
            }else if centerIconViewSelected {
                // if no photo selected, or new picture taken then the selected icon will be passed back
                checklist.iconName = iconName
                
            }else{
                checklist.iconName = "Empty-Smilly"
            }
            delegate?.listDetailViewController(self, didFinishAdding: checklist)
        }
        
    }
    
    // Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PickIcon" {
            
            let controller = segue.destination as! IconPickerViewController
            controller.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // sets a default image for all three icon images prior to user setting own
        let defaultIconImage = UIImage(named: "Empty-Smilly")
        
        // 1. Checks if a list has been passed to edit, if yes, moves to 2
        if let checklist = checklistToEdit {
            title = "Edit Checklist"
            textField.text = checklist.name
            doneBarButton.isEnabled = true
            
            // 2. Check to see if a photo has been saved as an Icon, if not then sets to a default image specified by the developer
            
            if let photo = checklist.photo {
                rightIconImageView.image = photo
            }else{
                rightIconImageView.image = defaultIconImage
            }
            
            if let capturedPicture = checklist.capturedPhoto {
                rightIconImageView.image = capturedPicture
            }else{
                rightIconImageView.image = defaultIconImage
            }
            
            if checklist.iconName == "" {
                centerIconImageView.image = UIImage(named: checklist.iconName)
                
            }else{
                centerIconImageView.image = defaultIconImage
            }
        }
        
        // adds icon image views to array for easy sorting
        iconViews = [leftIconView,centerIconView,rightIconView]
        
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        // Animation to set the selected view label to bold
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
        
        UIView.animate(withDuration: 0.5, delay: 0.8, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.6, options: .curveEaseIn, animations: {
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text! as NSString
        let newText = oldText.replacingCharacters(in: range, with: string)
            as NSString
        doneBarButton.isEnabled = (newText.length > 0)
        return true
    }
    
}

extension ListDetailViewController: IconPickerViewControllerDelegate {
    
    func iconPicker(_ picker: IconPickerViewController, didPick iconName: String) {
        self.iconName = iconName
        print(iconName)
        centerIconImageView.image = UIImage(named: iconName)
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
        
        if let pickerImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            picker.allowsEditing = true
            if cameraSelected {
                leftIconImageVIew.contentMode = .scaleAspectFill
                leftIconImageVIew.image = pickerImage
            }else if myphotosSelected {
                rightIconImageView.contentMode = .scaleAspectFill
                rightIconImageView.image = pickerImage
            }
            picker.dismiss(animated: true, completion: nil )
            
        }
    }
    func pickPhoto() {
        
        myphotosSelected = true
        cameraSelected = false
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
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
}

extension ListDetailViewController: UINavigationControllerDelegate{
    
}



