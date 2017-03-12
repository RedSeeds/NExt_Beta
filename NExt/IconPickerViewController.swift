//
//  IconPickerViewController.swift
//  NExt
//
//  Created by Douglas Sexton on 2/21/17.
//  Copyright © 2017 Douglas Sexton. All rights reserved.
//

import UIKit

protocol IconPickerViewControllerDelegate: class {
    func iconPicker(_ picker: IconPickerViewController,
                    didPick iconName: String)
}



class IconPickerViewController: UICollectionViewController {
    
    
    weak var delegate: IconPickerViewControllerDelegate?
    
    let icons = [
        "No Icon",
        "Home",
        "Appointments",
        "Birthdays",
        "Chores",
        "Drinks",
        "Folder",
        "Groceries",
        "Inbox",
        "Photos",
        "Trips" ]
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pickPhoto" {
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Choose Icon"
        
        
        let width = collectionView!.frame.width / 4
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: width)
        
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return icons.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IconCell", for: indexPath) as? IconCell
        
       
        if indexPath.row == 0 {
            cell?.iconLabel.textColor = UIColor.black
            cell?.iconLabel.text = "Customize"
        }
        let iconName = icons[indexPath.row]
        cell?.iconImageView.image = UIImage(named: iconName)
        if iconName == "No Icon" {
            cell?.iconLabel.text = "Customize"
            cell?.iconLabel.textColor = UIColor.darkGray
        }
      
        
        return cell!
        
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            
            performSegue(withIdentifier: "pickPhoto", sender: nil)
        }else{
            
            if let delegate = delegate {
                let iconName = icons[indexPath.row]
                delegate.iconPicker(self, didPick: iconName)
                print("selected")
            }
            
        }
        

    }
    
}

