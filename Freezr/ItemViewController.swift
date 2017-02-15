//
//  ItemViewController.swift
//  Freezr
//
//  Created by Jack Taylor on 09/10/2016.
//  Copyright © 2017 Jack Taylor. All rights reserved.
//

import UIKit
import UserNotifications
import AVFoundation

class ItemViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    //Custom colours.
    
    let myPurple:UIColor = UIColor(red: 105/255.0, green: 94/255.0, blue: 133/255.0, alpha: 1.0)
    
    //Outlets.
    
    @IBOutlet weak var itemImage: UIImageView!
    
    @IBOutlet weak var itemName: UITextField!
    
    @IBOutlet weak var addItemOrUpdateButton: UIButton!
    
    @IBOutlet weak var deleteItemButton: UIButton!
    
    @IBOutlet weak var expirationDateTextField: UITextField!
    
    @IBOutlet weak var placeHolderText1: UILabel!
    
    @IBOutlet weak var placeHolderText2: UILabel!
    
    @IBOutlet weak var addToSLButton: UIButton!
    
    @IBOutlet weak var imageNoticeText: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var expiresLabel: UILabel!
    
    @IBOutlet var bck: UIView!
    
    //Variables.
    
    var imageSelector = UIImagePickerController()
    
    var item : Item? = nil
    
    let today = NSDate()
    
    var selectedDate : Date? = nil
    var twoWeeks : Date? = nil
    var oneWeek : Date? = nil
    var twoDays : Date? = nil
    
    var audioPlayer = AVAudioPlayer()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        imageSelector.delegate = self
        
        itemName.delegate = self
        
        itemName.returnKeyType = UIReturnKeyType.done
        
        itemName.textColor = myPurple
        
        expirationDateTextField.textColor = myPurple
        
        itemImage.isUserInteractionEnabled = true
        
        //Setup the item view depending on if an existing item is being selected, or a new item is being added.
        
        //If there is an existing item:
        
    
        if item != nil {
            
                itemImage.image = UIImage(data: item!.image! as Data)
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
                dateFormatter.dateFormat = "dd/MMM/yyyy"
                let dateFromString = dateFormatter.date(from: dateString!)
                let twoWeeks = dateFromString?.addingTimeInterval(-1209600)
                
                //Change expiry text and colour accordingly.
                
                if (item?.expirydate?.isEmpty)! {
                    
                    print("No expiry date given - do nothing")
                    
                } else {
                    
                    if today.isGreaterThanDate(dateToCompare: dateFromString!) {
                        expirationDateTextField.textColor = .red
                        expiresLabel.text = "Expired:"
                        expiresLabel.textColor = .red
                        
                    } else if today.isGreaterThanDate(dateToCompare: twoWeeks!) {
                        expirationDateTextField.textColor = .orange
                        expiresLabel.text = "Expiring soon:"
                        expiresLabel.textColor = .orange
                        
                    } else {}
                    
                }
            
            
            //If there is not an existing item:
            
        } else {
            
            deleteItemButton.isHidden = true
            addToSLButton.isHidden = true
            addItemOrUpdateButton.isEnabled = false
        }
        
        
        //Dismiss the keyboard when tapped away (setup).
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ItemViewController.dismissKeyboard)))
        
        //Tap the image (setup).
        
        self.itemImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ItemViewController.imageTapped)))
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
    
    
    @IBAction func addToFreezerTapped(_ sender: Any) {
        
        //If updating an exisitng item.
        
        if item != nil {
            item!.name = itemName.text
            item!.image = UIImageJPEGRepresentation(itemImage.image!, 0.05)! as NSData?
            item?.expirydate = expirationDateTextField.text
            
            //If creating a new item.
            
        } else {
            
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let item = Item(context: context)
            item.name = itemName.text
            item.image = UIImageJPEGRepresentation(itemImage.image!, 0.05)! as NSData? //was 0.1
            item.expirydate = expirationDateTextField.text
            
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
            if selectedDate != nil {
                
                if UserDefaults.standard.bool(forKey: "freezerSwitchOn") == true {
                    self.scheduleNotification(at: self.selectedDate!)
                }
                
                if UserDefaults.standard.bool(forKey: "preFreq2WeekTicked") == true {
                    self.pre2WeekNotification(at: self.twoWeeks!)
                }
                
                if UserDefaults.standard.bool(forKey: "preFreq1WeekTicked") == true {
                    self.pre1WeekNotification(at: oneWeek!)
                }
                
                if UserDefaults.standard.bool(forKey: "preFreq2DayTicked") == true {
                    self.pre2DayNotification(at: twoDays!)
                }
            }
            
        }
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        //SOUNDS
        
        //Create the alert sound
        
        let alertSound = NSURL(fileURLWithPath: Bundle.main.path(forResource: "addSound", ofType: "mp3")!)
        
        //Set up sound playback
        
        do {
        try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient)
        } catch {
            print("sound error1")
        }
        
        do {
        try AVAudioSession.sharedInstance().setActive(true)
        } catch {
        print("sound error2")
        }
        
        //Play sound
        
        if UserDefaults.standard.bool(forKey: "soundSwitchOn") == false {
            
        do {
           try audioPlayer = AVAudioPlayer(contentsOf: alertSound as URL)
        } catch {
            print("Playback error")
        }
        
        audioPlayer.volume = 0.07
        audioPlayer.prepareToPlay()
        audioPlayer.play()
            
        } else {
        print("sounds off")
        }
        
        navigationController!.popViewController(animated: true)
    }
    
    //What happens when delete is tapped.
    
    @IBAction func deleteItemTapped(_ sender: AnyObject) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        //UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["\(item?.notifID!)"])
        
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
    
    //DATE CHANGED
    
    func datePickerValueChanged(sender:UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        
        //Sets it so the entered date is always UK regardless of region so the app doesn't crash when converting the date.
        dateFormatter.locale = NSLocale(localeIdentifier: "en_GB") as Locale
        
        dateFormatter.dateStyle = DateFormatter.Style.medium
        
        dateFormatter.timeStyle = DateFormatter.Style.none
        
        expirationDateTextField.text = dateFormatter.string(from: sender.date)
        
        //Send data to the notification func.
        selectedDate = sender.date
        twoWeeks = sender.date.addingTimeInterval(-1209600)
        oneWeek = sender.date.addingTimeInterval(-604800)
        twoDays = sender.date.addingTimeInterval(-172800)
        
        print("Selected date: \(selectedDate)")
    }
    
    //What happens when Add to Shopping List is tapped.
    
    @IBAction func addToSLTapped(_ sender: AnyObject) {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let SLItem = ShoppingListItem(context: context)
        SLItem.name = itemName.text
        SLItem.image = UIImageJPEGRepresentation(itemImage.image!, 0.05)! as NSData?
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        //Add badge to SL icon.
        
        for item in self.tabBarController!.tabBar.items! {
            if item.title == "Shopping List" {
                item.badgeValue = "New!"
            }
        }
        
        navigationController!.popViewController(animated: true)
    }
    
    //Dismiss the keyboard functions.
    
    func dismissKeyboard() {
        
        //Dismiss the keyboard.
        itemName.resignFirstResponder()
        
        //Dismiss date picker.
        expirationDateTextField.resignFirstResponder()
    }
    
    //Dismiss the keyboard when return is tapped.
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        itemName.resignFirstResponder()
        return true
    }
    
    //Orientation setup.
    
    override func viewDidAppear(_ animated: Bool) {
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        appdelegate.shouldSupportAllOrientation = false
    }
    
    func imageTapped() {
        
        performSegue(withIdentifier: "freezrBigPictureSegue", sender: nil)
    }
    
    //Sets up the next ViewController (FridgeImageViewController) and sends some item data over.
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "freezrBigPictureSegue" {
            
            let doneButton = UIBarButtonItem()
            doneButton.title = "Done"
            navigationItem.backBarButtonItem = doneButton
            
            let nextViewController = segue.destination as! FreezrImageViewController
            
            nextViewController.image = itemImage.image
            
        }
    }
    
    //Set up notifications.
    
    func scheduleNotification(at date: Date) {
        
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents(in: .current, from: date)
        let newComponents = DateComponents(calendar: calendar, timeZone: .current, month: components.month, day: components.day, hour: components.hour, minute: components.minute)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: newComponents, repeats: false)
        
        let content = UNMutableNotificationContent()
        content.title = "Item expired"
        if (itemName.text?.isEmpty)! {
            content.body = "An item in your freezer has reached its expiry date."
        } else {
            content.body = "\(itemName.text!) has expired in your freezer."
        }
        content.sound = UNNotificationSound.default()
        
        let random = Int(arc4random_uniform(900000))
        
        let identifier = NSString.localizedUserNotificationString(forKey: "\(random)", arguments: nil)
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        print("IDDDDDDDDDDDDD: \(identifier)")
        
        UNUserNotificationCenter.current().add(request) {
            
            (error) in
            if let error = error {
                print("Notification error: \(error)")
            }
        }
    }
    
    func pre2WeekNotification(at date: Date) {
        
        if UserDefaults.standard.bool(forKey: "preFreq2WeekTicked") == true {
            
            let calendar = Calendar(identifier: .gregorian)
            let components = calendar.dateComponents(in: .current, from: date)
            let newComponents = DateComponents(calendar: calendar, timeZone: .current, month: components.month, day: components.day, hour: components.hour, minute: components.minute)
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: newComponents, repeats: false)
            
            let content = UNMutableNotificationContent()
            content.title = "Item expiring soon"
            if (itemName.text?.isEmpty)! {
                content.body = "An item in your freezer will expire in 2 weeks."
            } else {
                content.body = "\(itemName.text!) (in your freezer) will expire in 2 weeks."
            }
            content.sound = UNNotificationSound.default()
            
            let random = Int(arc4random_uniform(900000))
            
            let identifier = NSString.localizedUserNotificationString(forKey: "\(random)", arguments: nil)
            
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) {
                
                (error) in
                if let error = error {
                    print("Notification error: \(error)")
                }
            }
        } else {}
    }
    
    func pre1WeekNotification(at date: Date) {
        
        if UserDefaults.standard.bool(forKey: "preFreq1WeekTicked") == true {
            
            let calendar = Calendar(identifier: .gregorian)
            let components = calendar.dateComponents(in: .current, from: date)
            let newComponents = DateComponents(calendar: calendar, timeZone: .current, month: components.month, day: components.day, hour: components.hour, minute: components.minute)
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: newComponents, repeats: false)
            
            let content = UNMutableNotificationContent()
            content.title = "Item expiring soon"
            if (itemName.text?.isEmpty)! {
                content.body = "An item in your freezer will expire in 1 week."
            } else {
                content.body = "\(itemName.text!) (in your freezer) will expire in 1 week."
            }
            content.sound = UNNotificationSound.default()
            
            let random = Int(arc4random_uniform(900000))
            
            let identifier = NSString.localizedUserNotificationString(forKey: "\(random)", arguments: nil)
            
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) {
                
                (error) in
                if let error = error {
                    print("Notification error: \(error)")
                }
            }
        } else {}
    }
    
    func pre2DayNotification(at date: Date) {
        
        if UserDefaults.standard.bool(forKey: "preFreq2DayTicked") == true {
            
            let calendar = Calendar(identifier: .gregorian)
            let components = calendar.dateComponents(in: .current, from: date)
            let newComponents = DateComponents(calendar: calendar, timeZone: .current, month: components.month, day: components.day, hour: components.hour, minute: components.minute)
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: newComponents, repeats: false)
            
            let content = UNMutableNotificationContent()
            content.title = "Item expiring very soon"
            if (itemName.text?.isEmpty)! {
                content.body = "An item in your freezer will expire in just 2 days."
            } else {
                content.body = "\(itemName.text!) (in your freezer) will expire in just 2 days."
            }
            content.sound = UNNotificationSound.default()
            
            let random = Int(arc4random_uniform(900000))
            
            let identifier = NSString.localizedUserNotificationString(forKey: "\(random)", arguments: nil)
            
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) {
                
                (error) in
                if let error = error {
                    print("Notification error: \(error)")
                }
            }
        } else {}
    }
    
    //Final declaration:
    
}
