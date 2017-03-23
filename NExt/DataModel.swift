//
//  DataModel.swift
//  NExt
//
//  Created by Douglas Sexton on 2/20/17.
//  Copyright © 2017 Douglas Sexton. All rights reserved.
//

import Foundation


class DataModel {
    var lists = [Checklist]()
    var allItems = [ChecklistItem]()
    var totalItemsCompleted: Int = 0
    var itemIDs = [Int]()
    init() {
        loadChecklists()
        registerDefaults()
        handleFirstTime()
       // totalCompleteItems()
        //nextDueItem()
        print(totalCompleteItems())
    }
    
    func manageItemIds(item: ChecklistItem) -> Int {
        for item in itemIDs {
            
            
            if !itemIDs.contains(item) {
                itemIDs.append(item)
                
            }
           
        }
        
         return itemIDs.count
        
        
    }
    
    
    func totalCompleteItems() -> Int {
        
        for checklist in lists where checklist.items.count > 0 {
            
            for item in checklist.items where item.checked {
            print("Count before: \(totalItemsCompleted)")
                
               
                totalItemsCompleted += 1
                 print("Count before: \(totalItemsCompleted)")
            }
 
        }
        return totalItemsCompleted
    }
    
    
    func nextDueItem() -> [ChecklistItem]{
       var allitems = [ChecklistItem]()
        // sort items by due date
     
        for list in lists {
            let items = list.items
            for item in items where item.checked == false {
                allitems.append(item)
            }
            
        }
        
       return allitems.sorted { $0.dueDate < $1.dueDate }
        
    }


    
    class func nextChecklistItemID() -> Int {
        let userDefaults = UserDefaults.standard
        let itemID = userDefaults.integer(forKey: "ChecklistItemID")
        userDefaults.set(itemID + 1, forKey: "ChecklistItemID")
        userDefaults.synchronize()
        return itemID
    }
    
    func registerDefaults() {
        let dictionary: [String: Any] = [ "ChecklistIndex": -1,
                                          "FirstTime": true,
                                          "ChecklistItemID": 0 ]
        UserDefaults.standard.register(defaults: dictionary)
    }
    
    func handleFirstTime() {
        let userDefaults = UserDefaults.standard
        let firstTime = userDefaults.bool(forKey: "FirstTime")
        if firstTime {
            let checklist = Checklist(name: "List")
            lists.append(checklist)
            indexOfSelectedChecklist = 0
            userDefaults.set(false, forKey: "FirstTime")
            userDefaults.synchronize()
        }
    }
    
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory,
                                             in: .userDomainMask)
        return paths[0]
    }
    func dataFilePath() -> URL {
        return documentsDirectory().appendingPathComponent("Checklists.plist")
    }
    // this method is now called saveChecklists()
    func saveChecklists() {
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWith: data)
        // this line is different from before
        archiver.encode(lists, forKey: "Checklists")
        archiver.encode(totalItemsCompleted, forKey: "TotalItemsCompleted")
        archiver.finishEncoding()
        data.write(to: dataFilePath(), atomically: true)
    }
    
    // this method is now called loadChecklists()
    func loadChecklists() {
        let path = dataFilePath()
        if let data = try? Data(contentsOf: path) {
            let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
            // this line is different from before
            lists = unarchiver.decodeObject(forKey: "Checklists") as! [Checklist]
            totalItemsCompleted = unarchiver.decodeObject(forKey: "TotalItemsCompleted") as! Int
            unarchiver.finishDecoding()
            sortChecklists()
        }
    }

    var indexOfSelectedChecklist: Int {
        get {
            return UserDefaults.standard.integer(forKey: "ChecklistIndex")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "ChecklistIndex")
            UserDefaults.standard.synchronize()
        }
    }
    
    func sortChecklists() {
        lists.sort(by: { checklist1, checklist2 in
            return checklist1.name.localizedStandardCompare(checklist2.name) ==
                .orderedAscending })
    }
    
    
}
