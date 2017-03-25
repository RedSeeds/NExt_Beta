//
//  ChecklistItem.swift
//  NExt
//
//  Created by Douglas Sexton on 2/19/17.
//  Copyright © 2017 Douglas Sexton. All rights reserved.
//

import Foundation
import UserNotifications

protocol ChecklistItemDelegate: class {
    func itemDidSendAlert(controller: ChecklistItem, didAlert alert: UNUserNotificationCenter)
}

class ChecklistItem: NSObject, NSCoding {
    var text = ""
    var checked = false
    var dueDate = Date()
    var shouldRemind = false
    var itemID: Int
    weak var delgate: ChecklistItemDelegate?
    // Required
    
    required init?(coder aDecoder: NSCoder) {
        text = aDecoder.decodeObject(forKey: "Text") as! String
        checked = aDecoder.decodeBool(forKey: "Checked")
        dueDate = aDecoder.decodeObject(forKey: "DueDate") as! Date
        shouldRemind = aDecoder.decodeBool(forKey: "ShouldRemind")
        itemID = aDecoder.decodeInteger(forKey: "ItemID")
        super.init()
    }
    
    override init() {
        
        itemID = DataModel.nextChecklistItemID()
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(text, forKey: "Text")
        aCoder.encode(checked, forKey: "Checked")
        aCoder.encode(dueDate, forKey: "DueDate")
        aCoder.encode(shouldRemind, forKey: "ShouldRemind")
        aCoder.encode(itemID, forKey: "ItemID")
    }
    
    
        
    // Class methods
    
    func toggleChecked() {
        checked = !checked
    }
   
    func scheduleNotification() {
        removeNotification()
        if shouldRemind && dueDate > Date() {
            // 1
            let content = UNMutableNotificationContent()
            content.title = "Reminder:"
            content.body = text
            content.sound = UNNotificationSound.default()
            // 2
            let calendar = Calendar(identifier: .gregorian)
            let components = calendar.dateComponents(
                [.month, .day, .hour, .minute], from: dueDate)
            // 3
            let trigger = UNCalendarNotificationTrigger(
                dateMatching: components, repeats: false)
            // 4
            let request = UNNotificationRequest(
                identifier: "\(itemID)", content: content, trigger: trigger)
            // 5
            let center = UNUserNotificationCenter.current()
            center.add(request)
            print("Scheduled notification \(request) for itemID \(itemID)")
            delgate?.itemDidSendAlert(controller: self, didAlert: center)
            
        }
    }
    
    func removeNotification() {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(
            withIdentifiers: ["\(itemID)"])
    }
   
    
}
