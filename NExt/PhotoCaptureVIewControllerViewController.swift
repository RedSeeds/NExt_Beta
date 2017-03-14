//
//  PhotoCaptureVIewControllerViewController.swift
//  NExt
//
//  Created by Douglas Sexton on 3/8/17.
//  Copyright © 2017 Douglas Sexton. All rights reserved.
//

import UIKit

protocol PhotoCatureViewControllerDelegate: class {
    func photoCapture(_ controller: PhotoCaptureVIewControllerViewController,
                    didPick iconImage: UIImage)
}

class PhotoCaptureVIewControllerViewController: UITableViewController {

    
    
    // Set in tableviewdidSetlect to tell UIImage picker methods which thumnail to populate for preview
    var cameraSelected = false
    var myphotosSelected = false
    
    weak var delegate: PhotoCatureViewControllerDelegate?

    
    // Outlets used to capture user photos for list icons
    @IBOutlet weak var photoPreviewImage: UIImageView!

    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil )
    }

    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    
    @IBAction func done(_ sender: Any) {
        
        dismiss(animated: true, completion: nil )
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        photoPreviewImage.layer.cornerRadius = self.photoPreviewImage.frame.width / 2
        
      
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        
      

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let delegate = delegate {
            let iconImage = photoPreviewImage.image
            delegate.photoCapture(self, didPick: iconImage!)
            
        }
        
        if indexPath.section == 0 && indexPath.row == 1 {
            cameraSelected = false
            myphotosSelected = true
            print("selected cell 2")
            takePhoto()
            
        }else if indexPath.section == 0 && indexPath.row == 2 {
            myphotosSelected = false
            cameraSelected = true
            print("Selecteed cell 3")
            pickPhoto()
        
        }else if indexPath.section == 1 && indexPath.row == 0 {
            savePhoto()
        }else {
            print("error")
        }
        
    }

    override func viewWillAppear(_ animated: Bool) {
        
        
        
          print(delegate as Any)
        if UserDefaults.standard.object(forKey: "keyp2Image") != nil
        {
            let data = UserDefaults.standard.object(forKey: "keyp2Image") as! NSData
            photoPreviewImage.image = UIImage(data: data as Data)
        }
        
     
    }
    
    /*
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let delegate = delegate {
            let iconName = icons[indexPath.row]
            delegate.iconPicker(self, didPick: iconName)
        }    }

    */
    
}

extension PhotoCaptureVIewControllerViewController {
    //  To take a photo with the user’s camera add the following code to takePhoto button

    

}


// Used to capture photo from camera or users photos, and use as List icon image
extension PhotoCaptureVIewControllerViewController: UIImagePickerControllerDelegate{
    
    func takePhoto() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    /*
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            // thumnail determined by state set in didselect. User can select camera or photos to add images for list icons
            if cameraSelected {
                photoPreviewImage.contentMode = .scaleAspectFill
                photoPreviewImage.image = pickedImage
                
            }else if myphotosSelected {
                photoPreviewImage.contentMode = .scaleAspectFill
                photoPreviewImage.image = pickedImage
                pickPhoto()
            }
            
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
 */
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
    
            

        if let pickerImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            picker.allowsEditing = true
            if cameraSelected {
                photoPreviewImage.contentMode = .scaleAspectFill
                photoPreviewImage.image = pickerImage
            }else if myphotosSelected {
                photoPreviewImage.contentMode = .scaleAspectFill
                photoPreviewImage.image = pickerImage
            }
            picker.dismiss(animated: true, completion: nil )
            
               photoPreviewImage.layer.cornerRadius = self.photoPreviewImage.frame.width / 2
        }
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
    
    func savePhoto() {
        let imageData = UIImagePNGRepresentation(photoPreviewImage.image!)
        let compresedImage = UIImage(data: imageData!)
        UIImageWriteToSavedPhotosAlbum(compresedImage!, nil, nil, nil)
        
        let alert = UIAlertController(title: "Saved", message: "Your image has been saved", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
}

extension PhotoCaptureVIewControllerViewController: UINavigationControllerDelegate{
    
}



