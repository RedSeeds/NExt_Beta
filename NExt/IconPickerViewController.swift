//
//  IconPickerViewController.swift
//  NExt
//
//  Created by Douglas Sexton on 2/21/17.
//  Copyright © 2017 Douglas Sexton. All rights reserved.
//

import UIKit

protocol IconPickerViewControllerDelegate: class {
   // func iconPicker(_ picker: IconPickerViewController,
                    // didPick themeIconName: String)
    func iconPicker(_ picker: IconPickerViewController,
                    didPick themeIconImage: UIImage)
}



class IconPickerViewController: UICollectionViewController {
    
    
    weak var delegate: IconPickerViewControllerDelegate?
    
    let icons = [
        "Empty-Smilly",
        "target.png",
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
            cell?.iconImageView.backgroundColor = UIColor.clear
        }
        let themeIcon = UIImage(named: icons[indexPath.row])
        cell?.iconImageView.image = themeIcon
        
        
       // let themeIconName = icons[indexPath.row]
        //cell?.iconImageView.image = UIImage(named: themeIconName)
        
        // Label is pressent but hidden until needed
      cell?.iconLabel.isHidden = true
        
        return cell!
        
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let themeIcon = UIImage(named: icons[indexPath.row])
        delegate?.iconPicker(self, didPick: themeIcon!)
        
        
      // let themeIconName = icons[indexPath.row]
        //delegate?.iconPicker(self, didPick: themeIcon)

    }
    
}

