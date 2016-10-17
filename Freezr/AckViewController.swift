//
//  AckViewController.swift
//  Freezr
//
//  Created by Jack Taylor on 18/10/2016.
//  Copyright © 2016 Jack Taylor. All rights reserved.
//

import UIKit

class AckViewController: UIViewController {
    
    //Custom Colours
    
    let myPurple:UIColor = UIColor(red: 105/255.0, green: 94/255.0, blue: 133/255.0, alpha: 1.0)

    @IBOutlet var ackView: UIView!
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        ackView.backgroundColor = myPurple
        label1.textColor = UIColor.white
        label2.textColor = UIColor.white
    }

}
