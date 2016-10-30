//
//  TableViewController.swift
//  Freezr
//
//  Created by Jack Taylor on 30/10/2016.
//  Copyright © 2016 Jack Taylor. All rights reserved.
//

import UIKit
import MessageUI
import AVKit
import AVFoundation



class InfoViewController: UITableViewController, MFMailComposeViewControllerDelegate {
    
    //Custom colours.
    
    let myPurple:UIColor = UIColor(red: 105/255.0, green: 94/255.0, blue: 133/255.0, alpha: 1.0)
    
    var playerViewController = LandscapeAVPlayerController()
    var playerView = AVPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let urlPathString:String? = Bundle.main.path(forResource: "Freezr Demo", ofType: "mp4")
        
        if let urlPath = urlPathString {
            
            let fileURL = NSURL(fileURLWithPath: urlPath)
            
            playerView = AVPlayer(url: fileURL as URL)
            playerViewController.player = playerView
        }
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return 2
        } else {
            return 1
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let howCell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        let aboutCell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        let feedbackCell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        let versionCell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        
        howCell.textLabel?.text = "Video: How to use Freezr"
        howCell.textLabel?.textColor = .purple
        howCell.accessoryType =  .disclosureIndicator
        
        aboutCell.textLabel?.text = "About Freezr"
        aboutCell.textLabel?.textColor = .purple
        aboutCell.accessoryType =  .disclosureIndicator
        
        feedbackCell.textLabel?.text = "Send Feedback"
        feedbackCell.textLabel?.textColor = .purple
        feedbackCell.accessoryType =  .disclosureIndicator
        
        versionCell.textLabel?.text = "App Version:"
        versionCell.textLabel?.textColor = .purple
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            versionCell.detailTextLabel?.text = "\(version)"
            versionCell.detailTextLabel?.textColor = myPurple
        }
        
        if indexPath.section == 0 {
            return howCell
        } else if indexPath.section == 1 {
            
            if indexPath.row == 0 {
                return aboutCell
            } else {
                return feedbackCell
            }
        }
        
        return versionCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
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
        
    
    
    
    
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    //override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    //}
    
    
}

class LandscapeAVPlayerController: AVPlayerViewController {
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }
}
