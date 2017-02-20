//
//  SettingsTableTableViewController.swift
//  testCal
//
//  Created by Becca Hembling on 2017-01-30.
//  Copyright © 2017 com.example. All rights reserved.
//

import UIKit
import UserNotifications

class SettingsTableTableViewController: UITableViewController {

    //outlets for filtering
    @IBOutlet weak var kelownaSwitch: UISwitch!
    @IBOutlet weak var peachlandSwitch: UISwitch!
    
    //user defaults
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //asks permission if not already granted
        //this can get taken out if it is found elsewhere in the code
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert])
            { (granted, error) in
                if granted == true{
                    NSLog("Granted")
                    UIApplication.shared.registerForRemoteNotifications()
                }
                if let error = error {
                    NSLog("Error: \(error)")
                }
            }
        } else {
            // Fallback on earlier versions
        }
        
        defaultFilterSettings()
        locationfilterAction()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //set filtering defaults for saving
    func defaultFilterSettings() {
        //sets values to true if there are none
        defaults.register(defaults: ["kelownaFilter" : true])
        defaults.register(defaults: ["peachlandFilter" : true])
    }
    
    
    
    //checks the user's previous preferences and sets the switches appropriately
    func locationfilterAction() {
        let val = defaults.bool(forKey: "kelownaFilter")
        let val2 = defaults.bool(forKey: "peachlandFilter")

        
        if kelownaSwitch != nil {
            kelownaSwitch.setOn(val, animated: false)
        }
        
        if peachlandSwitch != nil {
            peachlandSwitch.setOn(val2, animated: false)
        }
    }
    
    // MARK: - Table view data source


    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //exit settings page
    @IBAction func doneAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //open notifications settings
    @IBAction func notificationAction(_ sender: Any) {
        let settingsUrl = NSURL(string:UIApplicationOpenSettingsURLString) as! URL
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(settingsUrl, options: [:], completionHandler: nil)
        } else {
            // Fallback on earlier versions
        }
    }
    
    //open bridge site in web browser
    @IBAction func urlAction(_ sender: Any) {
        let url = URL(string: "http://www.thebridgeservices.ca/calendars")
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url!)
        }
    }
    
    //saves setting for Kelowna filtering
    //TODO: add in code for the actual filtering
    @IBAction func kelownaAction(_ sender: Any) {
        let val = kelownaSwitch.isOn
        defaults.set(val, forKey:"kelownaFilter")
        
        
    }
    
    //saves setting for Peachland filtering
    //TODO: add in code for the actual filtering
    @IBAction func peachlandAction(_ sender: Any) {
        let val = peachlandSwitch.isOn
        defaults.set(val, forKey:"peachlandFilter")
        
        

    }
}
