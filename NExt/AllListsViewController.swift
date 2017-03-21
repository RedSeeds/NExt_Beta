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
    var progressPercentage: CGFloat = 0
    var dataModel: DataModel!
    var allItems: [ChecklistItem] = []
    var checklistWithNextDueItem: Checklist?
    var nextDueItem: ChecklistItem?
    
    // Outlets
    @IBOutlet var headerView: UIView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var nextItemDueDate: UILabel!
    @IBOutlet weak var nextItemText: UILabel!
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var nextDueItemButton: UIButton!
    
    // button action to show next due item in headerview
    @IBAction func nextDueItem(_ sender: Any) {
        // 1 grab checklist from dataModel
        for checklist in dataModel.lists {
            let items = checklist.items
        
        // 2 search through checklistItems for the next due item by calling the DataModel function that returns the first item in the sorted array containing all due items by date
            for checklistitem in items {
                if checklistitem == dataModel.nextDueItem().first {
                 
        // 3 call segue and pass checklist containing the next due item. THis is done to give the delegete access to all properties on the checklistItem
                    performSegue(withIdentifier: "ShowChecklist", sender: checklist)
                }
            }
        }
    }
    
    // MARK:-Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // 1 segue will show the selected checklist items
        if segue.identifier == "ShowChecklist" {
            let controller = segue.destination as! ChecklistViewController
            controller.checklist = sender as! Checklist
            
            // 2 sets the destination delegate to self and sets the checklistItem to nil, informing the segue destination VC to add an item when complete
        }  else if segue.identifier == "AddChecklit" {
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.topViewController as! ListDetailViewController
            controller.delegate = self
            controller.checklistToEdit = nil
          
            // 3 passes the checklist item to eddit, also serves as a means to navigate to the last item presented when the app was terminated. This is a conviencne method helping the user to quickly access the last state and location
        }else if segue.identifier == "EditChecklist" {
            
            // found on the DataModel
            let index = dataModel.indexOfSelectedChecklist // change this
            if index >= 0 && index < dataModel.lists.count {
                let checklist = dataModel.lists[index]
                performSegue(withIdentifier: "ShowChecklist", sender: checklist)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // sets the barbuttonitem to an edit button, allowing user to delete and move cells
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        // sets the tableview row hight to accomidate the icon image. In future release cells will be sized with the icon image to adjust for multiple devices that include iPad
        tableView.rowHeight = 120
        
        /* // Uncomment to limit Checklists to 3 as a free app
         if dataModel.lists.count > 2 {
         navigationItem.rightBarButtonItem?.isEnabled = false
         }
         */
    }
    
    // HELPERS

    
    // HEADER, contains labels that display the next due item by date, also includes a button to segue to the next due item currently being displayed
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        // header is sized to occupy 10% of the view hight to account for multiple size devices. This is set this way due to the fact the header contains text that can be displayed on a larger scale. Labels are not currently set to increase with size as this version supports only iPhone
        let height = self.view.frame.height / 10
        return height
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // 1 header border set for estedics, and design
        headerView.layer.borderColor = UIColor(red: 32/255, green: 32/255, blue: 32/255, alpha: 1.0).cgColor
        headerView.layer.borderWidth = 0.3
        
       // 2 app title displayed in header
        headerLabel.text = "NExt Due"
        
        // 3 first confirm there are checklistitems, if none then display below
        if dataModel.nextDueItem().isEmpty {
            nextItemText.text = "Nothing!"
            nextItemDueDate.text = ""
            
            // disable button that segueas to next due item to prevent crashes, and set the text color
            nextDueItemButton.isEnabled = false
            nextItemText.textColor = UIColor.lightGray
          
            // if items exist then the checklist item name and due date will be displayed
        }else{
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            formatter.timeStyle = .short
            
            // create todays date to compare to the due date in order to change the color of text on items that are past due
            let today = NSDate()
            
            // enable button for segue to next due item
            nextDueItemButton.isEnabled = true
            
            // asking the dataModel for the next due item located in the array contained on the DataModel
            if let dueItem = dataModel.nextDueItem().first {
                if dueItem.dueDate < today as Date {
                    nextItemText.textColor = UIColor.red
                }
            }
           
            // displaying item per the above comments
            nextItemText.text = dataModel.nextDueItem().first?.text
            nextItemDueDate.text = formatter.string(from: (dataModel.nextDueItem().first?.dueDate)!)
        }
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.lists.count
    }
    
    
    func configureBadge(cell: ListCell, view: UIView){
        
        // set and animate badge located on checklist icons image, indecating the number of past due items that are unchecked
        UIView.animate(withDuration: 0.5, delay: 0.5, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.6, options: .curveEaseOut, animations: {
            
            // animates the view from 0 - 100% scale size
            cell.badgeView.transform = CGAffineTransform(scaleX: 1, y: 1)
            
        }, completion: nil)
    }
   
    // Enables user to reorder manually the tableview cells
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObject = self.dataModel.lists[sourceIndexPath.row]
        dataModel.lists.remove(at: sourceIndexPath.row)
        dataModel.lists.insert(movedObject, at: destinationIndexPath.row)
  
        // To check for correctness enable: 
        self.tableView.reloadData()
    }
    
    // Disables delete buttons while in edit mode
    override func tableView(_ tableView: UITableView,
                            editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
            return.delete
    }
    
    // determins if the tableview cells indent to expose the delete buttons on the left side of cell. Currently set to show
    override func tableView(_ tableView: UITableView,
                            shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // custon cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "List", for: indexPath) as! ListCell
   
        // grabs the checklist and loads cell
        let checklist = dataModel.lists[indexPath.row]
        cell.text1.text = checklist.name
        
        // returns the count of uncheckeditems to populate the badge view label
        let count = checklist.countUncheckedItems()
        
        // expand badge view to 100%
        cell.badgeView.transform = CGAffineTransform(scaleX: 1, y: 1)
        cell.badgeView.layer.cornerRadius = cell.badgeView.frame.width / 2
        
        // if no items, then user has no checklist items in app
        if checklist.items.count == 0 {
            cell.text2.text = "(No Items)"
            cell.badgeView.transform = CGAffineTransform(scaleX: 0, y: 0)
        
            // app contains items but all have been set to checked
        } else if count == 0 {
            cell.text2.text = "All Done!"
            cell.badgeView.transform = CGAffineTransform(scaleX: 0, y: 0)
        
            // handles empty
        } else {
            cell.text2.text = ""
            cell.badgeView.transform = CGAffineTransform(scaleX: 0, y: 0)
            if checklist.items.count > 0 && checklist.countcheckedItems() == 0{
                cell.text2.text = "Not Started"
            }
            
            // used to set badge text with amount of items overdue
            if checklist.overDueItems() > 0 {
                configureBadge(cell: cell, view: cell.badgeView)
                cell.badgeLabel.text = String(checklist.overDueItems())
            }
            
            // sets badge color to show red
            cell.badgeView.backgroundColor = UIColor.red
            cell.text2.text = "\(checklist.countUncheckedItems()) Remaining"
        }
        
        // set badgeview size
        cell.badgeViewYContraint.constant = -cell.statView.frame.height / 2 + cell.badgeView.frame.height / 2
        cell.badgeViewXConstraint.constant = -cell.statView.frame.height / 2 + cell.badgeView.frame.height / 2
        cell.itemImageView.image = checklist.iconImage
        cell.itemImageView?.layer.borderColor = UIColor.lightGray.cgColor
        cell.itemImageView?.layer.borderWidth = 0.5
        cell.itemImageView?.layer.cornerRadius = cell.statView.frame.width / 2
        
        // status view (radious) is set by the following. This enables view to show progression based on color and the bezil cure layer
        cell.statView.range = CGFloat(checklist.items.count)
        cell.statView.curValue = CGFloat(checklist.countcheckedItems())
        
        return cell
    }
    
    // Delegate methods
    
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        
        // segues to the selected checklist item
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
    }
    
    // accessory view navigates to the ListDetailViewController
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
    }
    
    override func viewDidAppear(_ _animated: Bool) {
        super.viewDidAppear(_animated)
        
        // set inorder for the automatic navigation to the last visited checklist item
        navigationController?.delegate = self
        let index = dataModel.indexOfSelectedChecklist
        
        // if no items then segue is not executed
        if index >= 0 && index < dataModel.lists.count {
            let checklist = dataModel.lists[index]
            performSegue(withIdentifier: "ShowChecklist", sender: checklist)
        }
    }
}

extension AllListsViewController:ListDetailViewControllerDelegate {

    // handles the passing of edited and newly created checklist items passed back from the ListDetailViewController
    func listDetailViewControllerDidCancel(_ controller: ListDetailViewController) {
dismiss(animated: true, completion: nil)
    }
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishAdding checklist: Checklist) {
       dataModel.lists.insert(checklist, at: 0)
        
        // uncomment to sort checklist by A-Z. Currently user will have option to move manualy and list is not sorted. New items are added to the top of the list
        /*
        dataModel.lists.append(checklist)
        dataModel.sortChecklists()
    */
        tableView.reloadData()
        dismiss(animated: true, completion: nil)
    }
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishEditing checklist: Checklist) {
        // dataModel.sortChecklists()
        tableView.reloadData()
        // collectionView.reloadData()
        dismiss(animated: true, completion: nil)
    }
}

 // permites the VC to segue to the last selected item once the view appears
extension AllListsViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController,
                              willShow viewController: UIViewController,
                              animated: Bool) {
        if viewController === self {
            dataModel.indexOfSelectedChecklist = -1 // change this
        }
    }
}

 
 
