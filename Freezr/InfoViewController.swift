//
//  InfoViewController.swift
//  Freezr
//
//  Created by Jack Taylor on 30/10/2016.
//  Copyright © 2017 Jack Taylor. All rights reserved.
//

import UIKit
import MessageUI
import AVKit
import AVFoundation
import UserNotifications

class InfoViewController: UITableViewController, MFMailComposeViewControllerDelegate {
    
    //Custom colours.
    
    let myPurple:UIColor = UIColor(red: 105/255.0, green: 94/255.0, blue: 133/255.0, alpha: 1.0)
    
    
    //Variables.
    
    var playerViewController = LandscapeAVPlayerController()
    var playerView = AVPlayer()
    var fridgeSwitch = UISwitch()
    var freezerSwitch = UISwitch()
    var soundSwitch = UISwitch()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Video setup.
        
        let urlPathString:String? = Bundle.main.path(forResource: "Freezr Demo", ofType: "mp4")
        
        if let urlPath = urlPathString {
            let fileURL = NSURL(fileURLWithPath: urlPath)
            playerView = AVPlayer(url: fileURL as URL)
            playerViewController.player = playerView
            
            fridgeSwitch.onTintColor = .purple
            freezerSwitch.onTintColor = .purple
            soundSwitch.onTintColor = .purple
            
        }
    }
    
    //Specifies how many sections are in the table.
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 6
    }
    
    //Specifies how many rows are in the table.
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return 2
        } else if section == 2 {
            return 2
        } else if section == 3 {
            return 4
        } else {
            return 1
        }
    }
    
    //Specifies what goes in the table cells.
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Set up the cells.
        
        let howCell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        let aboutCell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        let feedbackCell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        let versionCell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        let freezerNotifCell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        let fridgeNotifCell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        let preFreqNeverCell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        let preFreq2WeekCell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        let preFreq1WeekCell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        let preFreq2DayCell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        let soundCell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        
        
        howCell.textLabel?.text = "Video: How to use Freezr"
        howCell.textLabel?.textColor = .purple
        howCell.textLabel?.font = UIFont(name: "Gill Sans", size: 17)
        howCell.accessoryType =  .disclosureIndicator
        
        aboutCell.textLabel?.text = "About Freezr"
        aboutCell.textLabel?.textColor = .purple
        aboutCell.textLabel?.font = UIFont(name: "Gill Sans", size: 17)
        aboutCell.accessoryType =  .disclosureIndicator
        
        feedbackCell.textLabel?.text = "Send Feedback"
        feedbackCell.textLabel?.textColor = .purple
        feedbackCell.textLabel?.font = UIFont(name: "Gill Sans", size: 17)
        feedbackCell.accessoryType =  .disclosureIndicator
        
        versionCell.textLabel?.text = "App Version:"
        versionCell.textLabel?.textColor = .purple
        versionCell.textLabel?.font = UIFont(name: "Gill Sans", size: 17)
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            versionCell.detailTextLabel?.text = "\(version)"
            versionCell.detailTextLabel?.textColor = myPurple
            versionCell.detailTextLabel?.font = UIFont(name: "Gill Sans", size: 17)
            versionCell.selectionStyle = .none
        }
        
        fridgeNotifCell.textLabel?.text = "Fridge"
        fridgeNotifCell.textLabel?.textColor = .purple
        fridgeNotifCell.textLabel?.font = UIFont(name: "Gill Sans", size: 17)
        fridgeNotifCell.selectionStyle = .none
        fridgeNotifCell.accessoryView = fridgeSwitch
        
        fridgeSwitch.addTarget(self, action: #selector(InfoViewController.fridgeSwitchFlipped), for: .valueChanged );
        fridgeSwitch.tag = 0
        
        if UserDefaults.standard.bool(forKey: "fridgeSwitchOn") == true {
            fridgeSwitch.isOn = true
        } else {
            fridgeSwitch.isOn = false
        }
        
        freezerNotifCell.textLabel?.text = "Freezer"
        freezerNotifCell.textLabel?.textColor = .purple
        freezerNotifCell.textLabel?.font = UIFont(name: "Gill Sans", size: 17)
        freezerNotifCell.selectionStyle = .none
        freezerNotifCell.accessoryView = freezerSwitch
        
        freezerSwitch.addTarget(self, action: #selector(InfoViewController.freezerSwitchFlipped), for: .valueChanged );
        freezerSwitch.tag = 1
        
        if UserDefaults.standard.bool(forKey: "freezerSwitchOn") == true {
            freezerSwitch.isOn = true
        } else {
            freezerSwitch.isOn = false
        }
        
        preFreqNeverCell.textLabel?.text = "Never"
        preFreqNeverCell.textLabel?.textColor = .purple
        preFreqNeverCell.textLabel?.font = UIFont(name: "Gill Sans", size: 17)
        if UserDefaults.standard.bool(forKey: "preFreqNeverTicked") == true {
            preFreqNeverCell.accessoryType = .checkmark
        }
        
        preFreq2WeekCell.textLabel?.text = "2 Weeks Before"
        preFreq2WeekCell.textLabel?.textColor = .purple
        preFreq2WeekCell.textLabel?.font = UIFont(name: "Gill Sans", size: 17)
        if UserDefaults.standard.bool(forKey: "preFreq2WeekTicked") == true {
            preFreq2WeekCell.accessoryType = .checkmark
        }
        
        preFreq1WeekCell.textLabel?.text = "1 Week Before"
        preFreq1WeekCell.textLabel?.textColor = .purple
        preFreq1WeekCell.textLabel?.font = UIFont(name: "Gill Sans", size: 17)
        if UserDefaults.standard.bool(forKey: "preFreq1WeekTicked") == true {
            preFreq1WeekCell.accessoryType = .checkmark
        }
        
        preFreq2DayCell.textLabel?.text = "2 Days Before"
        preFreq2DayCell.textLabel?.textColor = .purple
        preFreq2DayCell.textLabel?.font = UIFont(name: "Gill Sans", size: 17)
        if UserDefaults.standard.bool(forKey: "preFreq2DayTicked") == true {
            preFreq2DayCell.accessoryType = .checkmark
        }
        
        soundCell.textLabel?.text = "Disable Sound Effects"
        soundCell.textLabel?.textColor = .purple
        soundCell.textLabel?.font = UIFont(name: "Gill Sans", size: 17)
        soundCell.selectionStyle = .none
        soundCell.accessoryView = soundSwitch
        
        soundSwitch.addTarget(self, action: #selector(InfoViewController.soundSwitchFlipped), for: .valueChanged );
        soundSwitch.tag = 2
        
        if UserDefaults.standard.bool(forKey: "soundSwitchOn") == true {
            soundSwitch.isOn = true
        } else {
            soundSwitch.isOn = false
        }
        
        //Specify which cell goes where.
        
        if indexPath.section == 0 {
            return howCell
        } else if indexPath.section == 1 {
            if indexPath.row == 0 {
                return aboutCell
            } else {
                return feedbackCell
            }
        } else if indexPath.section == 2 {
            if indexPath.row == 0 {
                return fridgeNotifCell
            } else {
                return freezerNotifCell
            }
        } else if indexPath.section == 3 {
            if indexPath.row == 0 {
                return preFreqNeverCell
            } else if indexPath.row == 1 {
                return preFreq2WeekCell
            } else if indexPath.row == 2 {
                return preFreq1WeekCell
            } else {
                return preFreq2DayCell
            }
        } else if indexPath.section == 4 {
            return soundCell
        } else {
            return versionCell
        }
    }
    
    //Specify what happens when a cell is tapped.
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //What happens when the about cell is tapped - send the email.
        
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                performSegue(withIdentifier: "aboutSegue", sender: nil)
            } else {
                
                //What happens when the feedback cell is tapped - send the email.
                
                let mailComposeViewController = self.configuredMailComposeViewController()
                if MFMailComposeViewController.canSendMail() {
                    self.present(mailComposeViewController, animated: true, completion: nil)
                } else {
                    self.showSendMailErrorAlert()
                }
            }
            
        } else if indexPath.section == 0 {
            
            //What happens when the video cell is tapped - play the video.
            
            self.present(playerViewController, animated: true) {
                
                self.playerViewController.player?.play()
            }
            
            //What happens when the preFreq cells are tapped - tick them and set UserDefaults.
            
        } else if indexPath.section == 3 {
            if indexPath.row == 0 {
                
                let cell = tableView.cellForRow(at: indexPath)!
                if (cell.isSelected) {
                    cell.isSelected = false
                    
                    if (cell.accessoryType == .none) {
                        cell.accessoryType = .checkmark
                        UserDefaults.standard.set(true, forKey: "preFreqNeverTicked")
                        //
                        UserDefaults.standard.set(false, forKey: "preFreq2WeekTicked")
                        UserDefaults.standard.set(false, forKey: "preFreq1WeekTicked")
                        UserDefaults.standard.set(false, forKey: "preFreq2DayTicked")
                        
                        
                        
                    } else {
                        cell.accessoryType = .none
                        UserDefaults.standard.set(false, forKey: "preFreqNeverTicked")
                    }
                }
            } else if indexPath.row == 1 {
                let cell = tableView.cellForRow(at: indexPath)!
                if (cell.isSelected) {
                    cell.isSelected = false
                    
                    if (cell.accessoryType == .none) {
                        cell.accessoryType = .checkmark
                        UserDefaults.standard.set(true, forKey: "preFreq2WeekTicked")
                        //
                        UserDefaults.standard.set(false, forKey: "preFreqNeverTicked")
                        
                    } else {
                        cell.accessoryType = .none
                        UserDefaults.standard.set(false, forKey: "preFreq2WeekTicked")
                    }
                }
            } else if indexPath.row == 2 {
                let cell = tableView.cellForRow(at: indexPath)!
                if (cell.isSelected) {
                    cell.isSelected = false
                    
                    if (cell.accessoryType == .none) {
                        cell.accessoryType = .checkmark
                        UserDefaults.standard.set(true, forKey: "preFreq1WeekTicked")
                        //
                        UserDefaults.standard.set(false, forKey: "preFreqNeverTicked")
                        
                    } else {
                        cell.accessoryType = .none
                        UserDefaults.standard.set(false, forKey: "preFreq1WeekTicked")
                    }
                }
            } else {
                let cell = tableView.cellForRow(at: indexPath)!
                if (cell.isSelected) {
                    cell.isSelected = false
                    
                    if (cell.accessoryType == .none) {
                        cell.accessoryType = .checkmark
                        UserDefaults.standard.set(true, forKey: "preFreq2DayTicked")
                        //
                        UserDefaults.standard.set(false, forKey: "preFreqNeverTicked")
                        
                    } else {
                        cell.accessoryType = .none
                        UserDefaults.standard.set(false, forKey: "preFreq2DayTicked")
                    }
                }
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //Setup mail feeback.
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients(["jack@blueinkcode.com"])
        mailComposerVC.setSubject("Freezr Feedback")
        mailComposerVC.setMessageBody("*You can use this email to inform us of any bugs or let us know about any feature requests.\n", isHTML: false)
        
        return mailComposerVC
    }
    
    //Setup mail alerts.
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertController(title: "Well this sucks.", message: "We couldn't prepare your email. Please check your mail settings and then try again.", preferredStyle: .alert)
        let cont = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        sendMailErrorAlert.addAction(cont)
        self.present(sendMailErrorAlert, animated: true, completion: nil)
    }
    
    //Dismiss the mail ViewController.
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        //Set back button text in the AboutViewController.
        let backButton = UIBarButtonItem()
        backButton.title = "Done"
        navigationItem.backBarButtonItem = backButton
    }
    
    
    func fridgeSwitchFlipped(sender: AnyObject) {
        
        let fridgeSwitch = sender as! UISwitch
        if fridgeSwitch.tag == 0 {
            
            if UserDefaults.standard.bool(forKey: "fridgeSwitchOn") == true {
                
                UserDefaults.standard.set(false, forKey: "fridgeSwitchOn")
                print(UserDefaults.standard.bool(forKey: "fridgeSwitchOn"))
                
                
            } else {
                
                UserDefaults.standard.set(true, forKey: "fridgeSwitchOn")
                print(UserDefaults.standard.bool(forKey: "fridgeSwitchOn"))
                
            }
            
        }
    }
    
    func freezerSwitchFlipped(sender: AnyObject) {
        
        let freezerSwitch = sender as! UISwitch
        if freezerSwitch.tag == 1 {
            
            if UserDefaults.standard.bool(forKey: "freezerSwitchOn") == true {
                
                UserDefaults.standard.set(false, forKey: "freezerSwitchOn")
                print(UserDefaults.standard.bool(forKey: "freezerSwitchOn"))
                
            } else {
                
                UserDefaults.standard.set(true, forKey: "freezerSwitchOn")
                print(UserDefaults.standard.bool(forKey: "freezerSwitchOn"))
                
            }
            
        }
    }
    
    func soundSwitchFlipped(sender: AnyObject) {
        
        let soundSwitch = sender as! UISwitch
        if soundSwitch.tag == 2 {
            
            if UserDefaults.standard.bool(forKey: "soundSwitchOn") == true {
                
                UserDefaults.standard.set(false, forKey: "soundSwitchOn")
                print(UserDefaults.standard.bool(forKey: "soundSwitchOn"))
                
                
            } else {
                
                UserDefaults.standard.set(true, forKey: "soundSwitchOn")
                print(UserDefaults.standard.bool(forKey: "soundSwitchOn"))
                
            }
            
        }
    }
    
    //Final-ish declaration:
}

//Custom class for making the video player landscape.

class LandscapeAVPlayerController: AVPlayerViewController {
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }
}
