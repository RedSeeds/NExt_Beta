/*
//  AddToCodeSnipit.swift
//  NExt
//
//  Created by Douglas Sexton on 3/14/17.
//  Copyright © 2017 Douglas Sexton. All rights reserved.
//

import Foundation


 extension AllListsViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
 
 func numberOfSections(in collectionView: UICollectionView) -> Int {
 
 return 1
 }
 
 func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
 var count = 0
 
 dataModel.nextDueItem()
 if dataModel.allItems.count > 0 {
 count = dataModel.allItems.count
 }
 
 
 return count
 }
 
 func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
 let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "nextCell", for: indexPath) as! UpNextCell
 dataModel.nextDueItem()
 
 let item = dataModel.allItems[indexPath.row]
 if dataModel.allItems.count > 0 {
 let formatter = DateFormatter()
 formatter.dateStyle = .long
 formatter.timeStyle = .short
 cell.dueDate.text = formatter.string(from: item.dueDate)
 cell.itemText.text = item.text
 
 
 
 }else{
 cell.dueDate.text = "No Task with Dates"
 cell.itemText.text = ""
 }
 
 //Compare Values
 let date = NSDate()
 if date.compare(item.dueDate as Date) == ComparisonResult.orderedDescending {
 // TableView set to show the red line view in CollectionView View as an indecator of an over due or due item
 
 redLineShowing = true
 cell.dueDate.textColor = UIColor.red
 cell.dueDate.text = "Past Due"
 showAlertRedLine()
 }else{
 redLineShowing = false
 cell.dueDate.textColor = UIColor.white
 }
 
 
 return cell
 
 
 }
 
 
 func showAlertRedLine(){
 
 UIView.animate(withDuration: 0.5, delay: 2.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.9, options: .curveEaseOut, animations: {
 // self.tableView.contentInset.top = self.tableView.contentInset.top + 10
 
 
 }, completion: nil)
 
 
 }
 
 // MARK: - UICollectionViewFlowLayout
 func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
 //let picDimension = self.view.frame.size.width - 20
 return CGSize(width: self.view.frame.size.width, height: upNextView.frame.height)
 }
 }
 
 
 // DATE SOrt extentions
 extension NSDate {
 func isGreaterThanDate(dateToCompare: NSDate) -> Bool {
 //Declare Variables
 var isGreater = false
 
 //Compare Values
 if self.compare(dateToCompare as Date) == ComparisonResult.orderedDescending {
 isGreater = true
 }
 
 //Return Result
 return isGreater
 }
 
 func isLessThanDate(dateToCompare: NSDate) -> Bool {
 //Declare Variables
 var isLess = false
 
 //Compare Values
 if self.compare(dateToCompare as Date) == ComparisonResult.orderedAscending {
 isLess = true
 }
 
 //Return Result
 return isLess
 }
 
 func equalToDate(dateToCompare: NSDate) -> Bool {
 //Declare Variables
 var isEqualTo = false
 
 //Compare Values
 if self.compare(dateToCompare as Date) == ComparisonResult.orderedSame {
 isEqualTo = true
 }
 
 //Return Result
 return isEqualTo
 }
 
 func addDays(daysToAdd: Int) -> NSDate {
 let secondsInDays: TimeInterval = Double(daysToAdd) * 60 * 60 * 24
 let dateWithDaysAdded: NSDate = self.addingTimeInterval(secondsInDays)
 
 //Return Result
 return dateWithDaysAdded
 }
 
 func addHours(hoursToAdd: Int) -> NSDate {
 let secondsInHours: TimeInterval = Double(hoursToAdd) * 60 * 60
 let dateWithHoursAdded: NSDate = self.addingTimeInterval(secondsInHours)
 
 //Return Result
 return dateWithHoursAdded
 }
 }

 */
