//
//  ShoppingListViewController.swift
//  Freezr
//
//  Created by Jack Taylor on 14/10/2016.
//  Copyright © 2016 Jack Taylor. All rights reserved.
//

import UIKit

class ShoppingListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //Outlets
    
    @IBOutlet weak var shoppingListTableView: UITableView!
    
    @IBOutlet weak var emptyMessage: UILabel!
    
    //Variables
    
    var SLItems : [ShoppingListItem] = []
    
    //Define colours
    
    let myPurple:UIColor = UIColor(red: 105/255.0, green: 94/255.0, blue: 133/255.0, alpha: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shoppingListTableView.dataSource = self
        shoppingListTableView.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    //Retrieve the ShoppingListItems from CoreData.
    
    override func viewWillAppear(_ animated: Bool) {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        do {
            SLItems = try context.fetch(ShoppingListItem.fetchRequest())
            shoppingListTableView.reloadData()
        } catch {}
    }
    
    //Specifies how many rows in the table.
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection: Int) -> Int {
        if SLItems.count == 0 {
            return 1
        } else {
            return SLItems.count
        }
    }
    
    //Specifies what goes in the table cells.
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        
        if SLItems.count == 0 {
            cell.textLabel?.text = "Guess you bought everything ✔"
            
        } else {
            
            let SLItem = SLItems[indexPath.row]
            cell.textLabel?.text = SLItem.name
            cell.imageView?.image = UIImage(data: SLItem.image as! Data)
            
            //This part works
            if SLItem.isSelected {
                cell.accessoryType = .checkmark
                
            } else {
                
                cell.accessoryType = .none
                
            }
        }
        
        cell.textLabel?.textColor = myPurple
        
        return cell
    }
    
    //What happens when a cell is tapped - tick the items.
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)!
        
        if SLItems.count == 0 {
            print("User selected empty SL message, do not tick!")
        } else {
            
            //Ticks when I select cell - this works.
            
            if (cell.isSelected){
                cell.isSelected = false
                if (cell.accessoryType == UITableViewCellAccessoryType.none){
                    cell.accessoryType = UITableViewCellAccessoryType.checkmark
                }
                else
                {
                    cell.accessoryType = UITableViewCellAccessoryType.none
                }
            }
            
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            
            let SLItem = ShoppingListItem(context: context)
            
            
            SLItem.isSelected = true
            
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
            tableView.deselectRow(at: indexPath, animated: true)
            
            print(SLItem.isSelected)
            
        }
    }
    
    //Display/hide the table and empty message accordingly.
    
    override func viewDidAppear(_ animated: Bool) {
        
        if SLItems.count == 0 {
            shoppingListTableView.isHidden = true
            emptyMessage.isHidden = false
        } else {
            emptyMessage.isHidden = true
            shoppingListTableView.isHidden = false
        }
        
        //Remove badge from SL icon when the view loads.
        
        for item in self.tabBarController!.tabBar.items! {
            if item.title == "Shopping List" {
                item.badgeValue = nil
            }
            
        }
    }
    
    //Swipe to delete setup.
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let item = SLItems[indexPath.row]
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            context.delete(item)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
            do {
                SLItems = try context.fetch(ShoppingListItem.fetchRequest())
                tableView.reloadData()
            } catch {}
            
        }
    }
    
    //Final declaration:
    
}
