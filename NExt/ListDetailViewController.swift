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
    var iconName = "Folder"
    
    // Set in tableviewdidSetlect to tell UIImage picker methods which thumnail to populate for preview
    var cameraSelected = false
    var myphotosSelected = false
    
    // Outlets
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var cameraImageView: UIImageView!
    
    
    // Outlets used to capture user photos for list icons
 
    @IBOutlet weak var photoImageXConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var cameraImageViewXContraint: NSLayoutConstraint!
    
    // Actions
    @IBAction func cancel() {
        delegate?.listDetailViewControllerDidCancel(self)
    }
    @IBAction func done() {
        if let checklist = checklistToEdit {
            checklist.name = textField.text!
            checklist.iconName = iconName // add this
            delegate?.listDetailViewController(self,
                                               didFinishEditing: checklist)
        } else {
            let checklist = Checklist(name: textField.text!)
            checklist.iconName = iconName // add this
            delegate?.listDetailViewController(self,
                                               didFinishAdding: checklist)
        }
    }
    
    // Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PickIcon" {
            let controller = segue.destination as! IconPickerViewController
            controller.delegate = self
        }else if segue.identifier == "addPhoto" {
         
            let controller = segue.destination as! PhotoCaptureVIewControllerViewController
            controller.delegate = self
        

        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let checklist = checklistToEdit {
            title = "Edit Checklist"
            textField.text = checklist.name
            doneBarButton.isEnabled = true
            iconName = checklist.iconName
            iconImageView.image = UIImage(named: iconName)
           // photoImageView.image = checklist.photo
        
        }
        
 
        
        makeRadious(view: photoImageView)
        makeRadious(view: iconImageView)
        makeRadious(view: cameraImageView)

    }
    
    // Data source

    
    
    // Delegate Methods
    
    func makeRadious(view:UIView) {
        
        view.layer.cornerRadius = self.iconImageView.frame.width / 2
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 0.25

        //view.transform = CGAffineTransform(scaleX: 0, y: 0)
        
      
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.5, delay: 0.3, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.6, options: .curveEaseIn, animations: {
            
            self.photoImageXConstraint.constant = self.photoImageView.frame.width + 4
            self.cameraImageViewXContraint.constant = -self.cameraImageView.frame.width - 4
           
            
            self.view.layoutIfNeeded()
            
        }, completion: nil)
        
        UIView.animate(withDuration: 0.5, delay: 0.8, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.6, options: .curveEaseIn, animations: {
            
        
          
        
            
            self.view.layoutIfNeeded()
            
        }, completion: nil)
     
    }
    
    override func tableView(_ tableView: UITableView,
                            willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
        if indexPath.section == 0 {
            return indexPath
        } else if indexPath.section == 1 {
            
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
        iconImageView.image = UIImage(named: iconName)
        let _ = navigationController?.popViewController(animated: true)
    }
}

extension ListDetailViewController: PhotoCatureViewControllerDelegate {

    
    func photoCapture(_ controller: PhotoCaptureVIewControllerViewController, didPick iconImage: UIImage) {
        self.iconImageView.image = iconImage
    }

}

