//
//  ItemViewController.swift
//  Freezr
//
//  Created by Jack Taylor on 09/10/2016.
//  Copyright © 2016 Jack Taylor. All rights reserved.
//

import UIKit
import UserNotifications

class ItemViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    //Custom Colours
    
    let myPurple:UIColor = UIColor(red: 105/255.0, green: 94/255.0, blue: 133/255.0, alpha: 1.0)
    
    //Outlets
    
    @IBOutlet weak var itemImage: UIImageView!
    
    @IBOutlet weak var itemName: UITextField!
    
    @IBOutlet weak var addItemOrUpdateButton: UIButton!
    
    @IBOutlet weak var deleteItemButton: UIButton!
    
    @IBOutlet weak var expirationDateTextField: UITextField!
    
    @IBOutlet weak var placeHolderText1: UILabel!
    
    @IBOutlet weak var placeHolderText2: UILabel!
    
    @IBOutlet weak var addToSLButton: UIButton!
    
    @IBOutlet weak var imageNoticeText: UILabel!
    
    @IBOutlet weak var expiresLabel: UILabel!
    
    //Variables
    
    var imageSelector = UIImagePickerController()
    var item : Item? = nil
    let today = NSDate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageSelector.delegate = self
        
        itemName.delegate = self
        
        itemName.returnKeyType = UIReturnKeyType.done
        
        itemName.textColor = myPurple
        
        expirationDateTextField.textColor = myPurple
        
        //Setup the item view depending on if an existing item is being selected, or a new item is being added.
        
        //If there is an existing item:
        
        if item != nil {
            itemImage.image = UIImage(data: item!.image as! Data)
            itemName.text = item!.name
            expirationDateTextField.text = item!.expirydate
            
            placeHolderText1.isHidden = true
            placeHolderText2.isHidden = true
            imageNoticeText.isHidden = true
            
            addItemOrUpdateButton.setTitle("Update item", for: .normal)
            
            //Expiry text setup.
            
            // Convert the String to a NSDate.
            
            let dateString = expirationDateTextField.text
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM/dd/yyyy"
            dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
            let dateFromString = dateFormatter.date(from: dateString!)
            
            //Change expiry text and colour accordingly.
            
            if today.isGreaterThanDate(dateToCompare: dateFromString!) {
                expirationDateTextField.textColor = .red
                expiresLabel.text = "Expired:"
                expiresLabel.textColor = .red
                
            } else {}
            
            //If there is not existing item:
            
        } else {
            deleteItemButton.isHidden = true
            addToSLButton.isHidden = true
            addItemOrUpdateButton.isEnabled = false
        }
        
        //Dismiss the keyboard setup.
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ItemViewController.dismissKeyboard)))
        
    }
    
    //Select image methods.
    
    @IBAction func photosTapped(_ sender: AnyObject) {
        imageSelector.sourceType = .photoLibrary
        present(imageSelector, animated: true, completion: nil)
    }
    
    @IBAction func cameraTapped(_ sender: AnyObject) {
        imageSelector.sourceType = .camera
        present(imageSelector, animated: true, completion: nil)
    }
    
    //Method called when an image has been selected.
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        itemImage.image = image
        
        imageSelector.dismiss(animated: true, completion: nil)
        
        placeHolderText1.isHidden = true
        placeHolderText2.isHidden = true
        imageNoticeText.isHidden = true
        
        addItemOrUpdateButton.isEnabled = true
    }
    
    //What happens when Add or Update is tapped.
    
    @IBAction func addToFreezrTapped(_ sender: AnyObject) {
        if item != nil {
            item!.name = itemName.text
            item!.image = UIImageJPEGRepresentation(itemImage.image!, 0.1)! as NSData?
            item?.expirydate = expirationDateTextField.text
            
        } else {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            
            let item = Item(context: context)
            item.name = itemName.text
            item.image = UIImageJPEGRepresentation(itemImage.image!, 0.1)! as NSData?
            item.expirydate = expirationDateTextField.text
        }
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        navigationController!.popViewController(animated: true)
    }
    
    //What happens when delete is tapped.
    
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
        
        //        var firstDate = sender.date
        //
        //        func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //            let nextViewController = segue.destination as! FreezrViewController
        //            nextViewController.ifDate = firstDate as NSDate!
        //        }
        
        //Send data to the notification func in delegate.
        let selectedDate = sender.date
        let delegate = UIApplication.shared.delegate as? AppDelegate
        delegate?.scheduleNotification(at: selectedDate)
        
        print("HEYYYYYYYY\(selectedDate)")
    }
    
    //What happens when Add to Shopping List is tapped.
    
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
    
    //Dismiss the keyboard functions.
    
    func dismissKeyboard() {
        itemName.resignFirstResponder()
        
        //Dismiss date picker.
        expirationDateTextField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        itemName.resignFirstResponder()
        return true
    }
    
    //Final declaration:
    
}
