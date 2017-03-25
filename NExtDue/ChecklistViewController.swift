//
//  ChecklistViewController.swift
//  NExt
//
//  Created by Douglas Sexton on 2/19/17.
//  Copyright © 2017 Douglas Sexton. All rights reserved.
//

import UIKit
import QuartzCore

class ChecklistViewController: UITableViewController {
    
    
    // Variables
    var checklist: Checklist!
    
    // Outlets
    @IBOutlet var headerCell: UITableViewCell!
 
    @IBOutlet weak var captionView: UIView!
    @IBOutlet weak var captionViewColorView: UIImageView!
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet var header: UIView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var headerSubtitleLabel: UILabel!

    @IBOutlet weak var starLabel: UILabel!
    
    @IBOutlet weak var starLarge: UIImageView!
    
    
    // button added to header as a UX prompt for thoese who cant see the + or unfamiliar with....duh
    @IBOutlet weak var headerAddButton: UIButton!
    @IBAction func addFromHeader(_ sender: Any) {
        
        performSegue(withIdentifier: "AddItem", sender: nil)
    }
    
    @IBOutlet weak var headerImageView: UIImageView!

    // Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // 1
        if segue.identifier == "AddItem" {
            // 2
            let navigationController = segue.destination
                as! UINavigationController
            // 3
            let controller = navigationController.topViewController
                as! ItemDetailViewController
            // 4
            controller.delegate = self
            
    } else if segue.identifier == "EditItem" {
            let navigationController = segue.destination
                as! UINavigationController
            let controller = navigationController.topViewController
                as! ItemDetailViewController
            controller.delegate = self
            if let indexPath = tableView.indexPath(
                for: sender as! UITableViewCell) {
                controller.itemToEdit = checklist.items[indexPath.row]
            }
        }
    }
    
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        //title = checklist.name
       captionViewColorView.alpha = 0.8
     headerImageView.image = checklist.iconImage
     headerImageView.contentMode = .scaleAspectFill
  
       
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // HEADER
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80
        
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
       
       let borderColor = UIColor(red: 25/255, green: 25/255, blue: 25/255, alpha: 1.0).cgColor
        headerImageView.layer.borderWidth = 0.3
        headerImageView.layer.borderColor = borderColor
        
        header.layer.borderColor = borderColor
        header.layer.borderWidth = 0.3
       
        if checklist.items.count == 0 {
            headerSubtitleLabel.text = "No Items"
             headerLabel.text = ("\(checklist.name):")
        }else{
            headerLabel.text = ("\(checklist.name)")
            headerSubtitleLabel.text = ""
        }
        updateStarLabel()
               return header
        
    }
    
    
    //MARK: TableView Data Source
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return checklist.items.count
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "ChecklistItem", for: indexPath) as! TableViewCellForGradiant
    
       checklist.items.sort(by: {$0.dueDate < $1.dueDate })
        
        let item = checklist.items[indexPath.row]
        configureText(for: cell, with: item)
        configureCheckmark(for: cell, with: item)
       
        
       
        return cell
        
      
    }
    
    // MARK: - Table view delegate
    /*
    func colorForIndex(index: Int) -> UIColor {
        let itemCount = checklist.items.count - 1
      
        let val = (CGFloat(index) / CGFloat(itemCount)) * 0.6
        return UIColor(red: val, green: val, blue: val, alpha: 1.0)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = colorForIndex(index: indexPath.row)
    }
    
*/
    
    // configure gradiant for cells which will aid in seperating cells vissually without having to us line seperators only
    
    //MARK: TableView Delegate
    
    func updateStarLabel() {
        var count = 0
        UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.6, options: .curveEaseInOut, animations: { 
            
            
            self.starLarge.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
            
            self.view.layoutIfNeeded()
            
        }, completion: nil)
        
        UIView.animate(withDuration: 0.3, delay: 0.1, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.6, options: .curveEaseInOut, animations: {
            
            
            self.starLarge.transform = CGAffineTransform(scaleX: 1, y: 1)
            
            self.view.layoutIfNeeded()
            
        }, completion: nil)
        
        
        
        for item in checklist.items where item.checked {
            count += 1
        }
        starLabel.text = String(count)
        

        
    }

    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            let item = checklist.items[indexPath.row]
     
            item.toggleChecked()
            configureCheckmark(for: cell as! TableViewCellForGradiant, with: item)
            configureText(for: cell as! TableViewCellForGradiant, with: item)
            updateStarLabel()
            
            // Move the corresponding row in the table view to reflect this change
            
        }
        tableView.deselectRow(at: indexPath, animated: true)
  
      
    }
    
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCellEditingStyle,
                            forRowAt indexPath: IndexPath) {
        // 1
        checklist.items.remove(at: indexPath.row)
        // 2
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
       
        
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObject = self.checklist.items[sourceIndexPath.row]
        checklist.items.remove(at: sourceIndexPath.row)
        checklist.items.insert(movedObject, at: destinationIndexPath.row)
      
        // To check for correctness enable: self.tableView.reloadData()
    }
}


extension ChecklistViewController {
    // private methods
   
    func configureCheckmark(for cell: TableViewCellForGradiant,
                            with item: ChecklistItem) {
        //let checkedImage = cell.viewWithTag(1) as! UIImageView
        
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, options: .curveEaseInOut, animations: {
            let checkMarkLabel = cell.viewWithTag(2000) as! UILabel
            checkMarkLabel.textColor = UIColor.orange

            if item.checked {
            cell.checkMark.isHidden = false
                //checkedImage.isHidden = false
            } else {
              cell.checkMark.isHidden = true
                //checkedImage.isHidden = true
            }
        }, completion: nil)
    }
    
    func configureText(for cell: TableViewCellForGradiant,
                       with item: ChecklistItem) {
        
        let today = NSDate()
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short
       
   
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, options: .curveEaseInOut, animations: {

            if item.dueDate < today as Date, !item.checked {
                cell.dateLable.textColor = UIColor.red
            }
            
            if item.checked {
                cell.titleText.alpha = 0.3
                cell.dateLable.alpha = 0.3
            } else {
                cell.titleText.alpha = 1.0
                cell.dateLable.alpha = 1.0
            }
            
            
        }, completion: nil)
        
        cell.titleText.text = item.text
        cell.dateLable.text = formatter.string(from: item.dueDate)
             //  label.text = "\(item.itemID): \(item.text)"
    }
   

    
    
}

// Delegate methods that pass the new or edited Check list item, back to the Checklist View Contorller
extension ChecklistViewController: ItemDetailViewControllerDelegate{
    func itemDetailViewControllerDidCancel(
        _ controller: ItemDetailViewController) {
        dismiss(animated: true, completion: nil)
    }
    func itemDetailViewController(_ controller: ItemDetailViewController,
                               didFinishAdding item: ChecklistItem) {
        let newRowIndex = checklist.items.count
        checklist.items.append(item)
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        dismiss(animated: true, completion: nil)
        
        
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController,
                               didFinishEditing item: ChecklistItem) {
        if let index = checklist.items.index(of: item) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                configureText(for: cell as! TableViewCellForGradiant, with: item)
            }
        }
        dismiss(animated: true, completion: nil)
        tableView.reloadData()
    }
    
}
