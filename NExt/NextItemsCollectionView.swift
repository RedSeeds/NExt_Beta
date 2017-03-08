//
//  NextItemsCollectionView.swift
//  NExt
//
//  Created by Douglas Sexton on 2/28/17.
//  Copyright © 2017 Douglas Sexton. All rights reserved.
//

import Foundation
import UIKit



class NextItemCollectionView: UICollectionViewController {
    
    let dataModel = DataModel()
    var allItems: [ChecklistItem]=[]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let width = collectionView!.frame.width
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: 125)
        
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
    
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "nextCell", for: indexPath) as! UpNextCell
        
        
        
        
        let item = dataModel.allItems[indexPath.row]
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        
        cell.dueDate.text = formatter.string(from: item.dueDate)
        cell.itemText.text = item.text

      //  print(allItems.count)
     
        
        
        return cell
    }
    
    
    func nextDueItem() {
        
        // sort items by due date
        
        for list in dataModel.lists {
            let items = list.items
            for item in items where item.checked == false {
                allItems.append(item)
            }
            
        }
        
        allItems.sort { $0.dueDate < $1.dueDate }
        
       
    }

    override func viewWillAppear(_ animated: Bool) {
        collectionView?.reloadData()
    }
}
