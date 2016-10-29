//
//  TableViewController.swift
//  Freezr
//
//  Created by Jack Taylor on 30/10/2016.
//  Copyright © 2016 Jack Taylor. All rights reserved.
//

import UIKit

class InfoViewController: UITableViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        howCell.textLabel?.text = "How to use"
        howCell.accessoryType =  .disclosureIndicator
        
        aboutCell.textLabel?.text = "About Freezr"
        aboutCell.accessoryType =  .disclosureIndicator
        
        feedbackCell.textLabel?.text = "Send Feedback"
        feedbackCell.accessoryType =  .disclosureIndicator
        
        versionCell.textLabel?.text = "App Version:"
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            versionCell.detailTextLabel?.text = "\(version)" }
        
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
                
            }
        }
        
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    //override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    //}
    
    
}
