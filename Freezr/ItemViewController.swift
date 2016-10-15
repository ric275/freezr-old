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
    
    @IBOutlet weak var addItemOrUpdateButton: UIButton!
    
    @IBOutlet weak var deleteItemButton: UIButton!
    
    @IBOutlet weak var expirationDateTextField: UITextField!
    
    @IBOutlet weak var placeHolderText1: UILabel!
    
    @IBOutlet weak var placeHolderText2: UILabel!

    @IBOutlet weak var addToSLButton: UIButton!
    
    @IBOutlet weak var imageNoticeText: UILabel!
    
    var imageSelector = UIImagePickerController()
    var item : Item? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageSelector.delegate = self
        
        if item != nil{
            itemImage.image = UIImage(data: item!.image as! Data)
            itemName.text = item!.name
            expirationDateTextField.text = item!.expirydate
            
            placeHolderText1.isHidden = true
            placeHolderText2.isHidden = true
            imageNoticeText.isHidden = true
            
            addItemOrUpdateButton.setTitle("Update item", for: .normal)
        } else {
            deleteItemButton.isHidden = true
            addToSLButton.isHidden = true
            addItemOrUpdateButton.isEnabled = false
        }
        
    }
    @IBAction func photosTapped(_ sender: AnyObject) {
        imageSelector.sourceType = .photoLibrary
        present(imageSelector, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        itemImage.image = image
        
        imageSelector.dismiss(animated: true, completion: nil)
        
        placeHolderText1.isHidden = true
        placeHolderText2.isHidden = true
        imageNoticeText.isHidden = true

        addItemOrUpdateButton.isEnabled = true
    }
    
    @IBAction func cameraTapped(_ sender: AnyObject) {
        imageSelector.sourceType = .camera
        present(imageSelector, animated: true, completion: nil)
    }
    
    @IBAction func addToFreezrTapped(_ sender: AnyObject) {
        if item != nil {
            item!.name = itemName.text
            item!.image = UIImageJPEGRepresentation(itemImage.image!, 0.1)! as NSData?
            
            //DatePicker
            item!.expirydate = expirationDateTextField.text
            
        } else {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            
            let item = Item(context: context)
            item.name = itemName.text
            item.image = UIImageJPEGRepresentation(itemImage.image!, 0.1)! as NSData?
            
            //DatePicker
            item.expirydate = expirationDateTextField.text
        }
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        navigationController!.popViewController(animated: true)
    }
    
    @IBAction func deleteItemTapped(_ sender: AnyObject) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        context.delete(item!)
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        navigationController!.popViewController(animated: true)
        
    }
    
    //Expiry date setup
    
    @IBAction func editingExpirationDateTextField(_ sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        
        datePickerView.datePickerMode = UIDatePickerMode.date
        
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: #selector(ItemViewController.datePickerValueChanged), for: UIControlEvents.valueChanged)
    }
    
    func datePickerValueChanged(sender:UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = DateFormatter.Style.medium
        
        dateFormatter.timeStyle = DateFormatter.Style.none
        
        expirationDateTextField.text = dateFormatter.string(from: sender.date)
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    @IBAction func addToSLTapped(_ sender: AnyObject) {
        
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            
            let SLItem = ShoppingListItem(context: context)
            SLItem.name = itemName.text
            SLItem.image = UIImageJPEGRepresentation(itemImage.image!, 0.1)! as NSData?
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        //Add badge to SL icon
        
        for item in self.tabBarController!.tabBar.items! {
            if item.title == "Shopping List" {
                item.badgeValue = "New!"
            }
            
        }
        
        navigationController!.popViewController(animated: true)
    }
    









}
