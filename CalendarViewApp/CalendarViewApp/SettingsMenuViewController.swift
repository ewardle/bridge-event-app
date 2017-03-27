//
//  SettingsMenuViewController.swift
//  CalendarViewApp
//
//  Created by Eliana on 2017-03-26.
//  Copyright © 2017 Amrit. All rights reserved.
//

import UIKit
import UserNotifications

class SettingsMenuViewController: UITableViewController {
    
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
        
        //changes top navigation bar to a darker color, in order to see the white status bar better
        navigationController?.navigationBar.barTintColor = UIColor.init(colorWithHexValue: 0x336600)
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        navigationController?.navigationBar.tintColor = UIColor.white;
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

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

    // Exit settings page
    @IBAction func doneAction(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // Open notifications settings
    @IBAction func notificationAction(_ sender: AnyObject) {
        let settingsUrl = NSURL(string:UIApplicationOpenSettingsURLString) as! URL
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(settingsUrl, options: [:], completionHandler: nil)
        } else {
            // Fallback on earlier versions
        }
    }
    
    // Open Bridge site in web browser
    @IBAction func urlAction(_ sender: AnyObject) {
        let url = URL(string: "http://www.thebridgeservices.ca/calendars")
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url!)
        }
    }
    
    
}
