//
//  ItemViewController.swift
//  Freezr
//
//  Created by Jack Taylor on 09/10/2016.
//  Copyright © 2016 Jack Taylor. All rights reserved.
//

import UIKit

class ItemViewController: UIViewController {
    @IBOutlet weak var itemImage: UIImageView!

    @IBOutlet weak var itemName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func photosTapped(_ sender: AnyObject) {
    }
    
    @IBAction func cameraTapped(_ sender: AnyObject) {
    }
    
    @IBOutlet weak var addTapped: UIButton!
}
