//
//  ChecklistViewController.swift
//  NExt
//
//  Created by Douglas Sexton on 2/19/17.
//  Copyright © 2017 Douglas Sexton. All rights reserved.
//

import UIKit


class ChecklistViewController: UITableViewController {
    
    
    // Variables
    var checklist: Checklist!
    
    // Outlets
    @IBOutlet var headerCell: UITableViewCell!
    @IBOutlet weak var starImageView: UIImageView!
    @IBOutlet weak var captionView: UIView!
    @IBOutlet weak var captionViewColorView: UIImageView!
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet var header: UIView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var headerSubtitleLabel: UILabel!
    
    
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
       headerImageView.image = UIImage(named: checklist.iconName)
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
        return 60
        
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
            withIdentifier: "ChecklistItem", for: indexPath)
    
       checklist.items.sort(by: {$0.dueDate < $1.dueDate })
        
       
        
        let item = checklist.items[indexPath.row]
        configureText(for: cell, with: item)
        configureCheckmark(for: cell, with: item)
        
        return cell
        
      
    }
    
    //MARK: TableView Delegate
    
    

    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            let item = checklist.items[indexPath.row]
     
            item.toggleChecked()
            configureCheckmark(for: cell, with: item)
            configureText(for: cell, with: item)
          
            
       
            
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
   
    func configureCheckmark(for cell: UITableViewCell,
                            with item: ChecklistItem) {
        let checkedImage = cell.viewWithTag(1) as! UIImageView
        
       
       
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, options: .curveEaseInOut, animations: {
            let checkMarkLabel = cell.viewWithTag(2000) as! UILabel
            checkMarkLabel.textColor = UIColor.orange

            if item.checked {
             checkMarkLabel.isHidden = false
                checkedImage.isHidden = false
            } else {
              checkMarkLabel.isHidden = true
                checkedImage.isHidden = true
            }

            
        }, completion: nil)
        
    }
    
    
    func configureText(for cell: UITableViewCell,
                       with item: ChecklistItem) {
        
        
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        
        
        let label = cell.viewWithTag(1000) as! UILabel
       let label2 = cell.viewWithTag(1001) as! UILabel
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, options: .curveEaseInOut, animations: {
            
            if item.checked {
                label.alpha = 0.3
            } else {
                label.alpha = 1.0
            }
            
            
        }, completion: nil)
        
        label.text = item.text
        label2.text = formatter.string(from: item.dueDate)
        
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
                configureText(for: cell, with: item)
            }
        }
        dismiss(animated: true, completion: nil)
        tableView.reloadData()
    }
    
}
