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
    
    // Outlets
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    // Icon views and buttons contained within the animated views
    // Left icon view
    @IBOutlet weak var leftIconView: UIView!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var cameraImageView: UIImageView!
    @IBOutlet weak var leftIconViewXconstraint: NSLayoutConstraint!
     @IBOutlet weak var leftIconLabel: UILabel!
    
    //Center view
    @IBOutlet weak var centerIconView: UIView!
    @IBOutlet weak var iconButton: UIButton!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var centerViewXconstraint: NSLayoutConstraint!
    @IBOutlet weak var centerViewYconstraint: NSLayoutConstraint!
    @IBOutlet weak var centerIconLabel: UILabel!
   
    
    
    // Right Icon view
    @IBOutlet weak var rightIconView: UIView!
    @IBOutlet weak var photoButton: UIButton!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var rightIconViewXcostraint: NSLayoutConstraint!
    @IBOutlet weak var rightIconViewLabel: UILabel!
    
    
    
    // Outlets used to capture user photos for list icons
    // Left IconView Button
    @IBAction func leftIconViewButton(_ sender: Any) {
        takePhoto()
    }
    
    @IBAction func rightIconViewButton(_ sender: Any) {
        pickPhoto()
    }

    
    // Actions
    @IBAction func cancel() {
        delegate?.listDetailViewControllerDidCancel(self)
    }
    @IBAction func done() {
        if let checklist = checklistToEdit {
            checklist.name = textField.text!
            if cameraSelected {
                checklist.iconName = ""
                checklist.pictureTaken = cameraImageView.image
                checklist.photo = nil
            }else if myphotosSelected {
                checklist.iconName = ""
                checklist.photo = photoImageView.image
                checklist.pictureTaken = nil
            }else{
                checklist.iconName = iconName
                checklist.pictureTaken = nil
                checklist.photo = nil
            }
           // checklist.photo =  photoImageView.image
           // checklist.pictureTaken = cameraImageView.image
            
            
          
           // checklist.iconName = iconName // add this
            delegate?.listDetailViewController(self,
                                               didFinishEditing: checklist)
                } else {
            
            let checklist = Checklist(name: textField.text!)
            checklist.iconName = iconName // add this
            
            if photoImageView.image == UIImage(named: "Empty-Smilly") {
                checklist.photo = photoImageView.image
                checklist.pictureTaken = nil
                checklist.iconName = ""
            }else if cameraImageView.image == UIImage(named: "Empty-Smilly") {
                checklist.pictureTaken = cameraImageView.image
                checklist.photo = nil
                checklist.iconName = iconName
                
            }
            delegate?.listDetailViewController(self,
                                               didFinishAdding: checklist)
        }
        
        // Method to pass photo back to AllListViewController to display as the List icon image
        
        
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
        if let checklist = checklistToEdit {
            title = "Edit Checklist"
            textField.text = checklist.name
            doneBarButton.isEnabled = true
            
            // Checks for a stored photo
            if let photo = checklist.photo {
                
                photoImageView.image = photo
                
            }
            if let pictureTaken = checklist.pictureTaken {
                cameraImageView.image = pictureTaken
                
            }
            
            iconName = checklist.iconName
            iconImageView.image = UIImage(named: iconName)
            
            
            
        }else{
            
            photoImageView.image = UIImage(named: "Empty-Smilly")
            cameraImageView.image = UIImage(named: "Empty-Smilly")
        }
        
       iconViews = [leftIconView,centerIconView,rightIconView]
        setUpButtonAndViews()
        transform(transform: true)
        
    }
    
    // Data source
    
    
    
    // Delegate Methods
    
    // Sets images views radious to a circle
    
    func setUpButtonAndViews(){
        for view in iconViews {
            view.layer.cornerRadius = view.frame.width / 2
            view.layer.borderWidth = 0.5
            view.layer.borderColor = UIColor.white.cgColor
           
            
        }
    }
    
    func transform(transform: Bool){
        
        for view in iconViews {
            
            if transform {
                view.transform = CGAffineTransform(scaleX: 0, y: 0)
            }else if !transform{
                
                view.transform = CGAffineTransform(scaleX: 1, y: 1)
            }
          
        }
     
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
       
        
        // Animation to set the selected view label to bold
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            
            if self.cameraSelected {
                
                
                self.leftIconLabel.text = "Useing"
                self.leftIconLabel.font = UIFont.boldSystemFont(ofSize: 15.0)
                self.centerIconLabel.text = "Themes"
                 self.centerIconLabel.font = UIFont.systemFont(ofSize: 15)
                self.rightIconViewLabel.text = "Photos"
                   self.rightIconViewLabel.font = UIFont.systemFont(ofSize: 15)
               
             
            }else if self.myphotosSelected {
                self.leftIconLabel.text = "Camera"
                self.centerIconLabel.font = UIFont.systemFont(ofSize: 15)
                self.centerIconLabel.text = "Themes"
                self.centerIconLabel.font = UIFont.systemFont(ofSize: 15)
                self.rightIconViewLabel.text = "Useing"
                self.rightIconViewLabel.font = UIFont.boldSystemFont(ofSize: 15.0)
            }else{
                self.leftIconLabel.text = "Camera"
                self.leftIconLabel.font = UIFont.systemFont(ofSize: 15)
                self.centerIconLabel.text = "Useing"
                self.centerIconLabel.font = UIFont.boldSystemFont(ofSize: 15.0)
                self.rightIconViewLabel.text = "Photos"
                 self.rightIconViewLabel.font = UIFont.systemFont(ofSize: 15)
                
            }
         
            self.transform(transform: false)
            
            
            self.view.layoutIfNeeded()
            
        }, completion: nil)
        
        // Alert to prompt user to save image to photos or decline. Photo can still be used but will not be accessable once replaced by a new image
        if cameraSelected {
            let alertController = UIAlertController(title: "Photo Captured", message: "Would you like to save your image", preferredStyle: UIAlertControllerStyle.alert) //Replace UIAlertControllerStyle.Alert by UIAlertControllerStyle.alert
            let doNotSave = UIAlertAction(title: "Don't save", style: UIAlertActionStyle.destructive) {
                (result : UIAlertAction) -> Void in
                print("")
            }
            
            // Replace UIAlertActionStyle.Default by UIAlertActionStyle.default
            let saveAction = UIAlertAction(title: "Save", style: UIAlertActionStyle.default) {
                (result : UIAlertAction) -> Void in
                print("")
                
                // Saves to users Photos
                self.savePhoto()
            }
            
            alertController.addAction(doNotSave)
            alertController.addAction(saveAction)
            self.present(alertController, animated: true, completion: nil)
        }
        
        
        
        UIView.animate(withDuration: 0.5, delay: 0.8, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.6, options: .curveEaseIn, animations: {
            
            
            
            
            
            self.view.layoutIfNeeded()
            
        }, completion: nil)
        
    }
    
    override func tableView(_ tableView: UITableView,
                            willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
        if indexPath.section == 1 {
            
            return indexPath
        }else{
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        let oldText = textField.text! as NSString
        let newText = oldText.replacingCharacters(in: range, with: string)
            as NSString
        doneBarButton.isEnabled = (newText.length > 0)
        return true
    }
}


extension ListDetailViewController: IconPickerViewControllerDelegate {
    
    func iconPicker(_ picker: IconPickerViewController,
                    didPick iconName: String) {
        self.iconName = iconName
        print(iconName)
        iconImageView.image = UIImage(named: iconName)
        let _ = navigationController?.popViewController(animated: true)
    }
}

// Used to capture photo from camera or users photos, and use as List icon image
extension ListDetailViewController: UIImagePickerControllerDelegate{
    
    @IBAction func takePhoto() {
        cameraSelected = true
        myphotosSelected = false
        
        
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
                cameraImageView.contentMode = .scaleAspectFill
                cameraImageView.image = pickerImage
            }else if myphotosSelected {
                photoImageView.contentMode = .scaleAspectFill
                photoImageView.image = pickerImage
            }
            picker.dismiss(animated: true, completion: nil )
            
        }
    }
    @IBAction func pickPhoto() {
        
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
    
    @IBAction func savePhoto() {
        let imageData = UIImagePNGRepresentation(photoImageView.image!)
        let compresedImage = UIImage(data: imageData!)
        UIImageWriteToSavedPhotosAlbum(compresedImage!, nil, nil, nil)
        
        let alert = UIAlertController(title: "Saved", message: "Your image has been saved", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
}

extension ListDetailViewController: UINavigationControllerDelegate{
    
}



