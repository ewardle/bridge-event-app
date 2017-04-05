//
//  SettingsTableTableViewController.swift
//  testCal
//
//  Created by Becca Hembling on 2017-01-30.
//  Copyright © 2017 com.example. All rights reserved.
//

import UIKit
import UserNotifications

class SettingsFilterViewController: UITableViewController {

    //outlets for filtering
    @IBOutlet weak var kelownaSwitch: UISwitch!
    @IBOutlet weak var peachlandSwitch: UISwitch!
    
    //Event data from calendar
    var calendarListEvent: [Int: [Event]]? = nil
    var calendarListEventNext: [Int: [Event]]? = nil
    var locationList: [String]? = nil

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
        
        // Populate list of locations to use
        self.setupLocationList()
        
        //changes top navigation bar to a darker color, in order to see the white status bar better
        navigationController?.navigationBar.barTintColor = UIColor.init(colorWithHexValue: 0x336600)
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        navigationController?.navigationBar.tintColor = UIColor.white;



        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
    }

    // MARK: Data Setup Functions
    
    func setupLocationList() {
        // Get events first
        self.getEvents()
        
        let locationSet = NSMutableOrderedSet.init()
        // Find locations mentioned in this month's events
        for (key, list) in calendarListEvent! {
            if calendarListEvent?[key] != nil {
                for eventInfo in list as [Event] {
                    // Only unique locations actually get added
                    locationSet.add(eventInfo.location)
                }
            }
        }
        // Include locations from next month's events
        for (key, list) in calendarListEventNext! {
            if calendarListEvent?[key] != nil {
                for eventInfo in list as [Event] {
                    // Only unique locations actually get added
                    locationSet.add(eventInfo.location)
                }
            }
        }
        // Sort alphabetically
        let sortDescriptor = NSSortDescriptor(key: "", ascending: true)
        locationSet.sort(using: [sortDescriptor])
        
        // Represent as array
        locationList = locationSet.array as? [String]
    }
    
    //use completion handler to make call to server using Alamofire
    func getEvents() {
        
        print("Getting events...")
        self.calendarListEvent = Bcalendar().getBCalListEvents()
        self.calendarListEventNext = Bcalendar().getBCalListEvents2()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Static list version of filter assignment (obsolete, moved to cellForRowAt)
    /*
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
    */
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationList!.count
    }
    
    // Populate table with cells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Make a cell for each unique listed location (list gets populated on view load)
        let location = locationList![indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationFilteringCell", for: indexPath as IndexPath) as! LocationFilteringCell
        cell.locationName.text = location
            
        // Check user's previous preferences and set the switches appropriately
        var value = UserDefaults.standard.object(forKey: "\(location.lowercased())Filter")
        print("Location: \(location.lowercased())Filter; \(value)")
        if (value == nil) {
            // Register locations that aren't previously assigned; events from there show by default
            UserDefaults.standard.register(defaults: ["\(location.lowercased())Filter" : true])
            value = true
        }
        cell.locationSwitch.setOn(value as! Bool, animated: false)
        
        return cell
    }
    
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
    
    // Individual functions for saving settings in static list
    // (moved to cell subclass in dynamic version)
    /*
    //saves setting for Kelowna filtering
    //Filtering is done from calendar and list views
    @IBAction func kelownaAction(_ sender: Any) {
        let val = kelownaSwitch.isOn
        defaults.set(val, forKey:"kelownaFilter")
        // Indicate that the calendar list has changed
        //Bcalendar().setListUpdated(updated: true)
    }
    
    //saves setting for Peachland filtering
    //Filtering is done from calendar and list views
    @IBAction func peachlandAction(_ sender: Any) {
        let val = peachlandSwitch.isOn
        defaults.set(val, forKey:"peachlandFilter")
        // Indicate that the calendar list has changed
        //Bcalendar().setListUpdated(updated: true)
    }
    */
}
