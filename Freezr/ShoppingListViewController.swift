//
//  ShoppingListViewController.swift
//  Freezr
//
//  Created by Jack Taylor on 14/10/2016.
//  Copyright © 2016 Jack Taylor. All rights reserved.
//

import UIKit

class ShoppingListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var shoppingListTableView: UITableView!
    
    var SLItems : [ShoppingListItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shoppingListTableView.dataSource = self
        shoppingListTableView.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        do {
            SLItems = try context.fetch(ShoppingListItem.fetchRequest())
            shoppingListTableView.reloadData()
        } catch {}
    }
    
    
    
    
    
    
    
    
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection: Int) -> Int {
        if SLItems.count == 0 {
            return 1
        } else {
            return SLItems.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        
        if SLItems.count == 0 {
            cell.textLabel?.text = "Your Shopping List is empty. Oh well."
            
        } else {
            
            let SLItem = SLItems[indexPath.row]
            cell.textLabel?.text = SLItem.name
            cell.imageView?.image = UIImage(data: SLItem.image as! Data)
            
            
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        for item in self.tabBarController!.tabBar.items! {
            if item.title == "Shopping List" {
                item.badgeValue = nil
            }
            
        }
    }
    
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
    
}
