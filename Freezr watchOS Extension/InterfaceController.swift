//
//  InterfaceController.swift
//  Freezr watchOS Extension
//
//  Created by Jack Taylor on 23/10/2017.
//  Copyright © 2017 Jack Taylor. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

    @IBOutlet var table: WKInterfaceTable!
    
   //Using this array for now.
    var templates = ["Fish", "Beans", "Carrots", "Burgers", "Fair Trade Coffee", "Cheese"]
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        
        table.setNumberOfRows(templates.count, withRowType: "itemsRow")
        
        for index in 0..<templates.count {
            
            if let row = table.rowController(at: index) as? ItemRowController {
                row.itemLabel.setText(templates[index])
            }
            
            
        }
        
        
        
    }

}
