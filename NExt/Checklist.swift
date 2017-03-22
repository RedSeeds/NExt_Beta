//
//  Checklist.swift
//  NExt
//
//  Created by Douglas Sexton on 2/19/17.
//  Copyright © 2017 Douglas Sexton. All rights reserved.
//

import Foundation
import UIKit


class Checklist: NSObject, NSCoding {
    var name = ""
    var items = [ChecklistItem]()
    var iconImage = UIImage()
    var itemsCompleted: Int = 0
    //var itemIDs = [Int]()
    
    convenience init(name: String) {
        self.init(name: name, iconImage: UIImage(named: "Empty-Smilly")! )
    }
    
    init(name: String, iconImage: UIImage) {
        self.name = name
      self.iconImage = iconImage
 
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "Name") as! String
        items = aDecoder.decodeObject(forKey: "Items") as! [ChecklistItem]
        iconImage = aDecoder.decodeObject(forKey: "IconImage") as! UIImage
       // itemsCompleted = aDecoder.decodeInteger(forKey: "ItemsCompleted") as! Int
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "Name")
        aCoder.encode(items, forKey: "Items")
        aCoder.encode(iconImage, forKey: "IconImage")
       // aCoder.encode(itemsCompleted, forKey: "ItemID")
    }
    
    // Class methods 
    /*
    func checklistItemIDs()  {
        for item in items where item.checked {
            if item.itemID ==
            itemIDs.append(item.itemID)
            itemsCompleted += 1
        }
    }
    
     */
    
    func numberOfCompletedItems() -> Int {
        
        for item in items where item.checked {
            itemsCompleted += 1
        }
        return itemsCompleted
    }
    

    func countUncheckedItems() -> Int {
        var count = 0
        for item in items where !item.checked {
            count += 1
        }
        return count
    }
    
    func nextDueItem() -> ChecklistItem {
        
        items.sort { $0.dueDate < $1.dueDate }
        
        return items.first!
        
    }
    
    func totalItems() -> Int {
        return items.count
    }
    
    func countcheckedItems() -> Int {
        
        var count = 0
        for item in items where item.checked {
            count += 1
        }
        return count
        
    }
    
    func overDueItems() -> Int {
        var count = 0
        let date = NSDate()
        for item in items where !item.checked {
            if date.compare(item.dueDate as Date) == ComparisonResult.orderedDescending {
                
                count += 1
            }
          
        }
        print("overdue:\(count)")
          return count
        
    }
    

    
    }












