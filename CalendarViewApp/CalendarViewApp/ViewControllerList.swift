//
//  ViewController.swift
//  CalendarViewApp
//
//  Created by Cosc499Capstone on 2016-12-27.
//  Copyright © 2016 Amrit. All rights reserved.
//

import UIKit
import SwiftDate
import Foundation

class ViewControllerList: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var Events: UILabel!
    @IBOutlet weak var EventList: UITableView!
    @IBOutlet weak var Sync: UIButton!
    
    let now = DateInRegion()
    var calendarListEvent: [Int: [Event]]? = nil
    var calendarListEventKeys: [Int]? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //"Event List" UITable Header
        self.Events.text = "Calendar Events"
        self.Events.textAlignment = NSTextAlignment.center
        
        // Register event summary cell type for event list
        tableView.registerClass(EventSummaryCell.self, forCellReuseIdentifier: "summaryCell")
        
        //Reloads calendar list with new event list when pressed
        Sync.addTarget(self, action: #selector(updateListOfEvents(button:)), for: .touchUpInside)
        
        //Make call to server
        getEvents()
    }
    
    func tableView(_ EventList: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /* Default: generate prototype cell
        let cell = EventList.dequeueReusableCell(withIdentifier: "com.CalendarViewApp.CalendarPrototypeCell", for: indexPath as IndexPath) as! CalendarPrototypeCell
        */
        // Generate event summary cell
        let cell = EventList.dequeueReusableCell(withIdentifier: "summaryCell", for: indexPath as IndexPath) as! EventSummaryCell
        
        /*
        //Get event array list for current section header and display all event titles for that header section
        let displayEventDay = self.calendarListEvent?[self.calendarListEventKeys![indexPath.section]]
        let displayEventTitle = displayEventDay?[indexPath.row].eventTitle
        
        cell.EventDay.text = displayEventTitle
        */
        
        // Get event array list for current section header and initialize each cell's details
        let eventArray = self.calendarListEvent?[self.calendarListEventKeys![indexPath.section]]
        let curr = eventArray?[indexPath.row]
        cell.fillData(curr)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        print("header section called")
        let headerSection = EventList.dequeueReusableCell(withIdentifier: "com.CalendarViewApp.CalendarPrototypeHeader") as! CalendarCellHeader
        
        //Use key as date for header sections in UITable
        let displayEventHeaderDay = Int((self.calendarListEventKeys?[section])!)
        headerSection.CalendarDay.text = "\(now.monthName) \(String(describing: displayEventHeaderDay)),  \(now.year)"
        
        return headerSection
    }
    
    func tableView(_ EventList: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return 4
        print("number of rows in section")
        print(self.calendarListEvent?[self.calendarListEventKeys![section]]!.count ?? 0)
        return self.calendarListEvent![self.calendarListEventKeys![section]]!.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        print("number of sections in table view:")
        print(self.calendarListEvent?.count ?? 0)
        return self.calendarListEvent!.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        //return UITableViewAutomaticDimension
        return 30
    }
    
    //Use completion handler to make call to server using Alamofire
    func getEvents() {
        Bcalendar().getEvents{ (responseObject, responseObject2) in
            self.calendarListEvent = responseObject2
            //load list view
            self.setDataSource()
        }
    }
    
    //load the list view
    func setDataSource() {
        //Create a list of keys(dates for events) for use with uitableview methods
        //Keys sorted by ascending date
        self.calendarListEventKeys = self.calendarListEvent?.keys.sorted { (_ key1: Int, _ key2: Int) -> Bool in
            return key1 < key2
        }
        
        //load data source and delegate
        self.EventList.dataSource = self
        self.EventList.delegate = self
        self.EventList.estimatedRowHeight = 100
        self.EventList.rowHeight = UITableViewAutomaticDimension
        self.displayEvents()
    }
    
    //Update calendarListEvent and reload UITableView
    func updateListOfEvents(button: UIButton) {
        Bcalendar().getEvents{ (responseObject, responseObject2) in
            self.calendarListEvent = responseObject2
            //load list view
            self.setDataSource()
            self.EventList.reloadData()
        }
    }
    
    func testClick(button: UIButton) {
        print("Button pressed!")
    }
    
    //For testing purposes. Prints events and keys in event array to console
    func displayEvents() {
        for (_, eventInDay) in self.calendarListEvent! {
            for singleEvent in eventInDay{
                print(singleEvent.eventTitle)
            }
        }
        print("Keys in calendar List Event:")
        for keyDay in self.calendarListEventKeys! {
            print(keyDay)
        }
    }
    
    
}

extension UIColor {
    convenience init(colorWithHexValue value: Int, alpha:CGFloat = 1.0){
        self.init(
            red: CGFloat((value & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((value & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(value & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
}
