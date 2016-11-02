//
//  FridgeViewController.swift
//  Freezr
//
//  Created by Jack Taylor on 01/11/2016.
//  Copyright © 2016 Jack Taylor. All rights reserved.
//

import UIKit

class FridgeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //Outlets.
    
    @IBOutlet weak var itemListTableView: UITableView!
    
    @IBOutlet weak var emptyMessage1: UILabel!
    
    @IBOutlet weak var emptyMessage2: UILabel!
    
    //Variables.
    
    var fridgeItems : [FridgeItem] = []
    
    let today = NSDate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        itemListTableView.dataSource = self
        itemListTableView.delegate = self
        
    }
    
    //Custom colours.
    
    let myPurple:UIColor = UIColor(red: 105/255.0, green: 94/255.0, blue: 133/255.0, alpha: 1.0)
    
    //Retrieve the FridgeItems from CoreData.
    
    override func viewWillAppear(_ animated: Bool) {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        do {
            fridgeItems = try context.fetch(FridgeItem.fetchRequest())
            itemListTableView.reloadData()
        } catch {}
        
        //Orientation setup.
        
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        appdelegate.shouldSupportAllOrientation = true
    }
    
    //Specifies how many rows are in the table.
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection: Int) -> Int {
        if fridgeItems.count == 0 {
            return 1
        } else {
            return fridgeItems.count
        }
    }
    
    //Specifies what goes in the table cells.
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        
        if fridgeItems.count == 0 {
            cell.textLabel?.text = "You should probably go buy food."
        } else {
            let fridgeItem = fridgeItems[indexPath.row]
            cell.textLabel?.text = fridgeItem.name
            cell.imageView?.image = UIImage(data: fridgeItem.image as! Data)
            
            if (fridgeItem.expirydate?.isEmpty)! {
                cell.textLabel?.textColor = myPurple
                cell.detailTextLabel?.text = "Expires: Unknown"
                
            } else {
                
                //Expiry text setup.
                
                // Convert the String to a NSDate.
                
                let dateString = fridgeItem.expirydate
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd/MMM/yyyy"
                //dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
                let dateFromString = dateFormatter.date(from: dateString!)
                
                //Change expiry text and colour accordingly.
                
                if today.isGreaterThanDate(dateToCompare: dateFromString!) {
                    cell.textLabel?.textColor = .red
                    cell.detailTextLabel?.text = "Expired: \(fridgeItem.expirydate!)"
                    cell.detailTextLabel?.textColor = .red
                    
                } else {
                    
                    cell.textLabel?.textColor = myPurple
                    cell.detailTextLabel?.text = "Expires: \(fridgeItem.expirydate!)"
                    cell.detailTextLabel?.textColor = myPurple
                }
                
            }
        }
        
        return cell
    }
    
    //What happens when a cell is tapped.
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if fridgeItems.count == 0 {
            print("User tapped the empty cell message! Do nothing.")
            tableView.deselectRow(at: indexPath, animated: true)
            
        } else {
            
            let fridgeItem = fridgeItems[indexPath.row]
            performSegue(withIdentifier: "fridgeItemSegue", sender: fridgeItem)
        }
    }
    
    //Sets up the next ViewController (ItemViewController) and sends some item data over.
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let nextViewController = segue.destination as! FridgeItemViewController
        nextViewController.fridgeItem = sender as? FridgeItem
        
        if segue.identifier == "fridgeItemSegue" {
            
            if nextViewController.fridgeItem != nil {
                
                let backButton = UIBarButtonItem()
                backButton.title = "Done"
                navigationItem.backBarButtonItem = backButton
                
            } else {
                let backButton = UIBarButtonItem()
                backButton.title = "Cancel"
                navigationItem.backBarButtonItem = backButton
            }
            
            
            //Hide tab bar in item view.
            nextViewController.hidesBottomBarWhenPushed = true
            
        } else {
            
            let nextViewController = segue.destination as! InfoViewController
            nextViewController.navigationItem.title = "Info"
            
            //Hide tab bar in settings.
            nextViewController.hidesBottomBarWhenPushed = true
        }
    }
    
    //Display/hide the table and empty message accordingly.
    
    override func viewDidAppear(_ animated: Bool) {
        
        if fridgeItems.count == 0 {
            itemListTableView.isHidden = true
            emptyMessage1.isHidden = false
            emptyMessage2.isHidden = false
            
        } else {
            
            emptyMessage1.isHidden = true
            emptyMessage2.isHidden = true
            itemListTableView.isHidden = false
        }
    }
    
    //Swipe actions (add to shopping list & delete).
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        //Swipe to add items to shopping list
        
        let swipeToAdd = UITableViewRowAction(style: .normal, title: "Shopping List") { (action:UITableViewRowAction!, NSIndexPath) in
            
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            
            let SLItem = ShoppingListItem(context: context)
            SLItem.name = self.fridgeItems[indexPath.row].name
            SLItem.image = self.fridgeItems[indexPath.row].image!
            
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
            //Add badge to SL icon
            
            for item in self.tabBarController!.tabBar.items! {
                if item.title == "Shopping List" {
                    item.badgeValue = "New!"
                }
                
            }
            
            //Create the alert when an item has been added to the shopping list.
            
            if (self.fridgeItems[indexPath.row].name?.isEmpty)! {
                let alertVC = UIAlertController(title: "Item added", message: "This item has been added to your Shopping List.", preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
                
                alertVC.addAction(okAction)
                
                self.present(alertVC, animated: true, completion: nil)
                
            } else {
                
                let alertVC = UIAlertController(title: "Item added", message: "\(self.fridgeItems[indexPath.row].name!) added to your Shopping List.", preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
                
                alertVC.addAction(okAction)
                
                self.present(alertVC, animated: true, completion: nil)
            }
        }
        
        swipeToAdd.backgroundColor = .purple
        
        //Swipe to delete items from the Freezr.
        
        let swipeToDelete = UITableViewRowAction(style: .normal, title: "Delete") { (action:UITableViewRowAction!, NSIndexPath) in
            
            let fridgeItem = self.fridgeItems[indexPath.row]
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            context.delete(fridgeItem)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
            do {
                self.fridgeItems = try context.fetch(FridgeItem.fetchRequest())
                tableView.reloadData()
            } catch {}
        }
        
        swipeToDelete.backgroundColor = UIColor.red
        
        return[swipeToDelete, swipeToAdd]
    }
    
    //Final declaration:
    
}
