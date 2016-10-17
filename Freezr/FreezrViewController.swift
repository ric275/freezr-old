//
//  FreezrViewController.swift
//  Freezr
//
//  Created by Jack Taylor on 09/10/2016.
//  Copyright © 2016 Jack Taylor. All rights reserved.
//

import UIKit

class FreezrViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //Outlets
    
    @IBOutlet weak var itemListTableView: UITableView!
    
    @IBOutlet weak var emptyMessage: UILabel!
    
    //Variables
    
    var items : [Item] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        itemListTableView.dataSource = self
        itemListTableView.delegate = self
    }
    
    //Define colours
    
    let myPurple:UIColor = UIColor(red: 105/255.0, green: 94/255.0, blue: 133/255.0, alpha: 1.0)
    
    //Retrieve the Items from CoreData.
    
    override func viewWillAppear(_ animated: Bool) {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        do {
            items = try context.fetch(Item.fetchRequest())
            itemListTableView.reloadData()
        } catch {
            
        }
    }
    
    //Specifies how many rows in the table.
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection: Int) -> Int {
        if items.count == 0 {
            return 1
        } else {
            return items.count
        }
    }
    
    //Specifies what goes in the table cells.
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        
        if items.count == 0 {
            cell.textLabel?.text = "You should probably go buy food."
        } else {
            let item = items[indexPath.row]
            cell.textLabel?.text = item.name
            cell.imageView?.image = UIImage(data: item.image as! Data)
            
            if (item.expirydate?.isEmpty)! {
                cell.detailTextLabel?.text = "Expires: Unknown"
            } else {
                cell.detailTextLabel?.text = "Expires: \(item.expirydate!)"
            }
        }
        
        cell.textLabel?.textColor = myPurple
        
        return cell
    }
    
    //What happens when a cell is tapped.
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if items.count == 0 {
            print("User tapped the empty cell message! Do nothing :/")
            tableView.deselectRow(at: indexPath, animated: true)
        } else {
            let item = items[indexPath.row]
            performSegue(withIdentifier: "itemSegue", sender: item)
        }
    }
    
    //Sets up the next ViewController (ItemViewController) and sends some item data over.
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "itemSegue" {
            
            let backButton = UIBarButtonItem()
            backButton.title = "Done"
            navigationItem.backBarButtonItem = backButton
            
            let nextViewController = segue.destination as! ItemViewController
            nextViewController.item = sender as? Item
            
            //Hide tab bar in item view.
            nextViewController.hidesBottomBarWhenPushed = true
        } else {
            let nextViewController = segue.destination as! AboutViewController
            
            //Hide tab bar in settings.
            nextViewController.hidesBottomBarWhenPushed = true
        }
        
    }
    
    //Swipe to delete setup.
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let item = items[indexPath.row]
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            context.delete(item)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
            do {
                items = try context.fetch(Item.fetchRequest())
                tableView.reloadData()
            } catch {}
            
        }
    }
    
    //Display/hide the table and empty message accordingly.
    
    override func viewDidAppear(_ animated: Bool) {
        
        if items.count == 0 {
            itemListTableView.isHidden = true
            emptyMessage.isHidden = false
        } else {
            emptyMessage.isHidden = true
            itemListTableView.isHidden = false
        }
    }
    
    
    //Swipe to add items to shopping list
    
    //    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
    //
    //        let swipeToAdd = UITableViewRowAction(style: .normal, title: "Add to Shopping List") { (action:UITableViewRowAction!, NSIndexPath) in
    //
    //            addToSLTapped()
    //        }
    //
    //        swipeToAdd.backgroundColor = UIColor.purple
    //
    //        return[swipeToAdd]
    //
    //    }
    
    
    //Final declaration:
    
}
