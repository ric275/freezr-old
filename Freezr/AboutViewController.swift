//
//  AboutViewController.swift
//  Freezr
//
//  Created by Jack Taylor on 13/10/2016.
//  Copyright © 2016 Jack Taylor. All rights reserved.
//

import UIKit
import MessageUI

class AboutViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    //Custom colours.
    
    let myPurple:UIColor = UIColor(red: 105/255.0, green: 94/255.0, blue: 133/255.0, alpha: 1.0)
    
    //Outlets - loads of label outlets because I'm too lazy to change the text colour in the storyboard.
    
    @IBOutlet var aboutView: UIView!
    
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var label4: UILabel!
    @IBOutlet weak var label5: UILabel!
    @IBOutlet weak var label6: UILabel!
    
    @IBOutlet weak var img4: UIButton!
    
    @IBOutlet weak var feedbackButton: UIButton!
    
    //Variables.
    
    var tapCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        aboutView.backgroundColor = myPurple
        label1.textColor = .white
        label2.textColor = .white
        label3.textColor = .white
        label4.textColor = .white
        label5.textColor = .white
        label6.textColor = .white
        feedbackButton.tintColor = .white
        
    }
    
    @IBAction func easterEggTapped(_ sender: AnyObject) {
        
        tapCount = tapCount + 1
        
        if tapCount == 7 {
            label1.text = "Meow Meow"
            label2.text = "Meow Meow"
            label3.text = "Meow Meow"
            label4.text = "Meow Meow"
            label5.text = "Meow Meow"
            label6.text = "🐱🐱🐱"
            aboutView.backgroundColor = UIColor(patternImage: UIImage(named: "tigger")!)
            img4.isHidden = true
            feedbackButton.isHidden = true
            
        } else {}
        
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
    
    //What happens when the feedback button is tapped - send the email.
    
    @IBAction func sendFeedbackTapped(_ sender: Any) {
        
        let mailComposeViewController = self.configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
            
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    //Orientation setup.
    
    override func viewDidAppear(_ animated: Bool) {
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        appdelegate.shouldSupportAllOrientation = false
    }

    //Final declaration:
    
}
