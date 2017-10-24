//
//  ItemInterfaceController.swift
//  Freezr watchOS Extension
//
//  Created by Jack Taylor on 24/10/2017.
//  Copyright © 2017 Jack Taylor. All rights reserved.
//

import WatchKit
import Foundation


class ItemInterfaceController: WKInterfaceController {

    @IBOutlet var nameLabel: WKInterfaceLabel!
    @IBOutlet var itemImage: WKInterfaceImage!
    @IBOutlet var button: WKInterfaceButton!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        
        
        
    }
}
