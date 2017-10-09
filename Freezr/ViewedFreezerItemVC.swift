//
//  ViewedFreezerItemVC.swift
//  Freezr
//
//  Created by Jack Taylor on 08/10/2017.
//  Copyright © 2017 Jack Taylor. All rights reserved.
//

import UIKit

class ViewedFreezerItemVC: UIViewController {
    //Outlets
    
    @IBOutlet weak var itemNameLabel: UILabel!
    
    @IBOutlet weak var itemImage: UIImageView!
    
    @IBOutlet weak var quantityLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var expiresTextLabel: UILabel!
    
    //Variables
    
    var item : Item? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

            itemImage.image = UIImage(data: item!.image! as Data)
        
        if item!.name != nil {
            itemNameLabel.text = item!.name
        } else {
            itemNameLabel.isHidden = true
        }
        
        if item!.expirydate != nil {
            dateLabel.text = item!.expirydate
        } else {
            dateLabel.text = "No expiry date set"
            expiresTextLabel.isHidden = true
        }
        
        if item!.quantity != nil {
            quantityLabel.text = item!.quantity
        } else {
            quantityLabel.text = "?"
        }
   
    }
}
