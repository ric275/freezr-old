//
//  AboutViewController.swift
//  Freezr
//
//  Created by Jack Taylor on 13/10/2016.
//  Copyright © 2016 Jack Taylor. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {
    
    //Custom Colours
    
    let myPurple:UIColor = UIColor(red: 105/255.0, green: 94/255.0, blue: 133/255.0, alpha: 1.0)
    
    //Outlets - loads of label outlets because I'm too lazy to change the text colour in the storyboard.
    
    @IBOutlet var aboutView: UIView!
    
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var label4: UILabel!
    @IBOutlet weak var label5: UILabel!
    
    @IBOutlet weak var ackButton: UIButton!
    
    //Variables
    
    var tapCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        aboutView.backgroundColor = myPurple
        label1.textColor = UIColor.white
        label2.textColor = UIColor.white
        label3.textColor = UIColor.white
        label4.textColor = UIColor.white
        label5.textColor = UIColor.white
        ackButton.tintColor = UIColor.white
        
        
    }
    
    @IBAction func ackButtonTapped(_ sender: AnyObject) {
    }
    
    @IBAction func raspberryTapped(_ sender: AnyObject) {
        
        tapCount = tapCount + 1
        
        if tapCount == 7 {
            label1.text = "Meow meow"
            label2.text = "Meow meow"
            label3.text = "Meow meow"
            label4.text = "Meow meow"
            label5.text = "🐱🐱🐱"
            aboutView.backgroundColor = UIColor.black
            
        } else {}
        
    }
    
    
    //Final declaration:
    
}
