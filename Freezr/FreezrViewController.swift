//
//  FreezrViewController.swift
//  Freezr
//
//  Created by Jack Taylor on 09/10/2016.
//  Copyright © 2016 Jack Taylor. All rights reserved.
//

import UIKit

class FreezrViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var itemListTableView: UITableView!
    
    var items : [Item] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        itemListTableView.dataSource = self
        itemListTableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        do {
            items = try context.fetch(Item.fetchRequest())
            itemListTableView.reloadData()
        } catch {
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection: Int) -> Int {
        if items.count == 0 {
            return 1
        } else {
            return items.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        
        if items.count == 0 {
            cell.textLabel?.text = "No items in Freezr. Tap '+' to get started! 🍉"
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
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if items.count == 0 {
            print("User tapped the empty cell message! Do nothing :/")
            tableView.deselectRow(at: indexPath, animated: true)
        } else {
            let item = items[indexPath.row]
            performSegue(withIdentifier: "itemSegue", sender: item)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "itemSegue" {
            
            let backButton = UIBarButtonItem()
            backButton.title = "Done"
            navigationItem.backBarButtonItem = backButton
            
            let nextViewController = segue.destination as! ItemViewController
            nextViewController.item = sender as? Item
        }
    }
    
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
    
}
