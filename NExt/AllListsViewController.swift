 //
//  AllListsViewController.swift
//  NExt
//
//  Created by Douglas Sexton on 2/19/17.
//  Copyright © 2017 Douglas Sexton. All rights reserved.
//

import Foundation
import UIKit


protocol ButtonCellDelegate {
    func cellTapped(cell: UIButton)
}

class AllListsViewController: UITableViewController {
    
    // Variables
    let transition = PopAnimator()
    var progressPercentage: CGFloat = 0
    var dataModel: DataModel!
    var categoryImage = ""
    var allItems: [ChecklistItem] = []
    var redLineShowing = false
    var nextItemDue: ChecklistItem?
    
    // Outlets
    @IBOutlet var headerView: UIView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet var upNextView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nextItemDueDate: UILabel!
    @IBOutlet weak var nextItemText: UILabel!
    @IBOutlet weak var redLine: UIView!
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBAction func addItem(_ sender: Any) {
      
    }
    
    @IBOutlet weak var redLineWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var nextDueItemButton: UIButton!
    @IBAction func nextDueItem(_ sender: Any) {
        
    }
    
    // MARK:-Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ShowChecklist" {
            let controller = segue.destination as! ChecklistViewController
            controller.checklist = sender as! Checklist
            
        }  else if segue.identifier == "AddChecklit" {
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.topViewController as! ListDetailViewController
            controller.delegate = self
            controller.checklistToEdit = nil
            
        }else if segue.identifier == "EditChecklist" {
            let index = dataModel.indexOfSelectedChecklist // change this
            if index >= 0 && index < dataModel.lists.count {
                let checklist = dataModel.lists[index]
                performSegue(withIdentifier: "ShowChecklist", sender: checklist)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        tableView.rowHeight = 120
        
        /* // Uncomment to limit Checklists to 3 as a free app
         if dataModel.lists.count > 2 {
         navigationItem.rightBarButtonItem?.isEnabled = false
         }
         */
    }
    
    // HEADER
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        headerView.layer.borderColor = UIColor(red: 32/255, green: 32/255, blue: 32/255, alpha: 1.0).cgColor
        headerView.layer.borderWidth = 0.3
        headerLabel.text = "NExt Due"
        
        dataModel.nextDueItem()

        if dataModel.allItems.isEmpty {
            nextItemText.text = "Nothing Due!"
            nextItemDueDate.text = ""
            nextDueItemButton.isEnabled = false
            
        }else{
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            formatter.timeStyle = .short
            nextItemText.text = dataModel.allItems.first?.text
            nextItemDueDate.text = formatter.string(from: (dataModel.allItems.first?.dueDate)!)
        }
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.lists.count
    }
    
    func configureBadge(cell: ListCell, view: UIView){
        UIView.animate(withDuration: 0.5, delay: 0.5, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.6, options: .curveEaseOut, animations: {
            
            cell.badgeView.transform = CGAffineTransform(scaleX: 1, y: 1)
            
        }, completion: nil)
    }
   
    // Enables user to reorder manually the tableview cells
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObject = self.dataModel.lists[sourceIndexPath.row]
        dataModel.lists.remove(at: sourceIndexPath.row)
        dataModel.lists.insert(movedObject, at: destinationIndexPath.row)
  
        // To check for correctness enable: self.tableView.reloadData()
    }
    
    // Disables delete buttons while in edit mode
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        
     
            return.delete
     
    }
    
    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "List", for: indexPath) as! ListCell
   
        
        
        let checklist = dataModel.lists[indexPath.row]
        cell.text1.text = checklist.name
        let count = checklist.countUncheckedItems()
        cell.badgeView.transform = CGAffineTransform(scaleX: 1, y: 1)
        cell.badgeView.layer.cornerRadius = cell.badgeView.frame.width / 2
        
        if checklist.items.count == 0 {
            cell.text2.text = "(No Items)"
            cell.badgeView.transform = CGAffineTransform(scaleX: 0, y: 0)
        
        } else if count == 0 {
            cell.text2.text = "All Done!"
            cell.badgeView.transform = CGAffineTransform(scaleX: 0, y: 0)
        
        } else {
            cell.text2.text = ""
            cell.badgeView.transform = CGAffineTransform(scaleX: 0, y: 0)
            if checklist.items.count > 0 && checklist.countcheckedItems() == 0{
                cell.text2.text = "Not Started"
            }
            
            if checklist.overDueItems() > 0 {
                configureBadge(cell: cell, view: cell.badgeView)
                cell.badgeLabel.text = String(checklist.overDueItems())
            }
            
            cell.badgeView.backgroundColor = UIColor.red
            cell.text2.text = "\(checklist.countUncheckedItems()) Remaining"
        }
        
        cell.badgeViewYContraint.constant = -cell.statView.frame.height / 2 + cell.badgeView.frame.height / 2
        cell.badgeViewXConstraint.constant = -cell.statView.frame.height / 2 + cell.badgeView.frame.height / 2
        
        
       cell.itemImageView.image = checklist.iconImage
        
        
        cell.itemImageView?.layer.borderColor = UIColor.lightGray.cgColor
        cell.itemImageView?.layer.borderWidth = 0.5
        cell.itemImageView?.layer.cornerRadius = cell.statView.frame.width / 2
        
        cell.statView.range = CGFloat(checklist.items.count)
        cell.statView.curValue = CGFloat(checklist.countcheckedItems())
        
        return cell
    }
    
    // Delegate methods
    
    
    
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        // change this line
        dataModel.indexOfSelectedChecklist = indexPath.row
        let checklist = dataModel.lists[indexPath.row]
        
        performSegue(withIdentifier: "ShowChecklist", sender: checklist)
        
    }
    
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCellEditingStyle,
                            forRowAt indexPath: IndexPath) {
        dataModel.lists.remove(at: indexPath.row)
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
        collectionView.reloadData()
        
        
    }
    
    
    
    override func tableView(_ tableView: UITableView,
                            accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let navigationController = storyboard!.instantiateViewController(
            withIdentifier: "ListDetailNavigationController")
            as! UINavigationController
        let controller = navigationController.topViewController
            as! ListDetailViewController
        controller.delegate = self
        let checklist = dataModel.lists[indexPath.row]
        controller.checklistToEdit = checklist
        present(navigationController, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        dataModel.nextDueItem()
        // collectionView.reloadData()
        
        
    }
    
    override func viewDidAppear(_ _animated: Bool) {
        super.viewDidAppear(_animated)
        navigationController?.delegate = self
        let index = dataModel.indexOfSelectedChecklist // change this
        if index >= 0 && index < dataModel.lists.count {
            let checklist = dataModel.lists[index]
            performSegue(withIdentifier: "ShowChecklist", sender: checklist)
        }
        /*
         if redLineShowing {
         
         UIView.animate(withDuration: 0.5, delay: 0.5, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.6, options: .curveEaseInOut, animations: {
         self.redLine.backgroundColor = UIColor.red
         self.redLineWidthConstraint.constant = self.headerView.frame.width / 3
         self.headerView.layoutIfNeeded()
         }, completion: nil)
         
         UIView.animate(withDuration: 0.5, delay: 1.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.6, options: .curveEaseInOut, animations: {
         
         self.redLine.backgroundColor = UIColor.red
         self.redLineWidthConstraint.constant = 0
         self.headerView.layoutIfNeeded()
         
         }, completion: nil)
         
         }
         */
    }
    
    
}



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

extension AllListsViewController:ListDetailViewControllerDelegate {
    func listDetailViewController(_controller: ListDetailViewController, didFinishAddingPhoto: UIImage) {
        
        
    }
    
    func listDetailViewControllerDidCancel(_ controller: ListDetailViewController) {
dismiss(animated: true, completion: nil)
    }
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishAdding checklist: Checklist) {
       dataModel.lists.insert(checklist, at: 0)
        
       // dataModel.lists.append(checklist)
        //dataModel.sortChecklists()
        tableView.reloadData()
        //collectionView.reloadData()
        dismiss(animated: true, completion: nil)
    }
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishEditing checklist: Checklist) {
        // dataModel.sortChecklists()
        tableView.reloadData()
        // collectionView.reloadData()
        dismiss(animated: true, completion: nil)
    }
    
}

extension AllListsViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController,
                              willShow viewController: UIViewController,
                              animated: Bool) {
        if viewController === self {
            dataModel.indexOfSelectedChecklist = -1 // change this
        }
    }
}

 
 
