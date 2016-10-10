//
//  ItemViewController.swift
//  Freezr
//
//  Created by Jack Taylor on 09/10/2016.
//  Copyright © 2016 Jack Taylor. All rights reserved.
//

import UIKit

class ItemViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var itemImage: UIImageView!
    
    @IBOutlet weak var itemName: UITextField!
    
    var imageSelector = UIImagePickerController()
    var item : Item? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageSelector.delegate = self
    }
    @IBAction func photosTapped(_ sender: AnyObject) {
        imageSelector.sourceType = .photoLibrary
        present(imageSelector, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        itemImage.image = image
        
        imageSelector.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cameraTapped(_ sender: AnyObject) {
    }
    
 @IBAction func addTapped(_ sender: AnyObject) {
        if item != nil {
            item!.name = itemName.text
            item!.image = UIImagePNGRepresentation(itemImage.image!) as NSData?
        } else {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            
            let item = Item(context: context)
            item.name = itemName.text
            item.image = UIImagePNGRepresentation(itemImage.image!) as NSData?
        }
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
}
