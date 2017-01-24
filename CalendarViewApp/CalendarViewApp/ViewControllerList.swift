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
    //@IBOutlet weak var Sync: UIButton!
    
    let now = DateInRegion()
    var calendarListEvent: [Int: [Event]]? = nil
    var calendarListEvent2: [Int: [Event]]? = nil
    var calendarListEventKeys: [Int]? = nil
    let daysOfTheWeek = ["Monday","Tuesday","Wednesday","Thursday","Friday"]
    let week = DateInRegion().previousWeekend
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //"Event List" UITable Header
        self.Events.text = "Calendar Events"
        self.Events.textAlignment = NSTextAlignment.center
        
        //Reloads calendar list with new event list when pressed
        //Sync.addTarget(self, action: #selector(updateListOfEvents(button:)), for: .touchUpInside)
        
        //let week = self.now.previousWeekend
        
        //print(week?.endDate.day ?? "NO WEEKEND DATE")
        
        
        
        
        //Make call to server
        getEvents()
    }
    
    func tableView(_ EventList: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = EventList.dequeueReusableCell(withIdentifier: "com.CalendarViewApp.CalendarPrototypeCell", for: indexPath as IndexPath) as! CalendarPrototypeCell
        //Get event array list for current section header and display all event titles for that header section
        //let displayEventDay = self.calendarListEvent?[self.calendarListEventKeys![indexPath.section]]
        //let displayEventTitle = displayEventDay?[indexPath.row].eventTitle
        
        //cell.EventDay.text = displayEventTitle
        let sectionDate = self.week?.endDate.day
        if let dateExists = self.calendarListEvent?[sectionDate!+indexPath.section+1] {
            cell.EventDay.text = dateExists[indexPath.row].eventTitle
        }
        else {
            cell.EventDay.text = "No events for today"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        //print("header section called")
        let headerSection = EventList.dequeueReusableCell(withIdentifier: "com.CalendarViewApp.CalendarPrototypeHeader") as! CalendarCellHeader
        
        //Use key as date for header sections in UITable
        //let displayEventHeaderDay = Int((self.calendarListEventKeys?[section])!)
        //headerSection.CalendarDay.text = "\(now.monthName) \(String(describing: displayEventHeaderDay)),  \(now.year)"
        
        //var dayInWeek = self.week?.endDate
        headerSection.CalendarDay.text = "\(self.daysOfTheWeek[section]) \(now.monthName) \((week?.endDate.day)!+section+1)"
        
        return headerSection
    }
    
    func tableView(_ EventList: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print("number of rows in section")
        //print(self.calendarListEvent?[self.calendarListEventKeys![section]]!.count ?? 0)
        //return self.calendarListEvent![self.calendarListEventKeys![section]]!.count
        
        let sectionDateR = self.week?.endDate.day
        if let eventRow = self.calendarListEvent?[sectionDateR!+section+1] {
            return eventRow.count
        }
        else {
            return 1
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        //print("number of sections in table view:")
        //print(self.calendarListEvent?.count ?? 0)
        //return self.calendarListEvent!.count
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        //return UITableViewAutomaticDimension
        return 30
    }
    
    //Use completion handler to make call to server using Alamofire
    func getEvents() {
        
        print("Getting events")
        
        self.calendarListEvent = Bcalendar().getBCalListEvents()
        self.setDataSource()
        //let testDate = self.calendarListEvent2?[19]
        //print(testDate?[0].eventTitle ?? "No events for test date")
        
        /*Bcalendar().getEvents{ (responseObject, responseObject2) in
            self.calendarListEvent = responseObject2
            //load list view
            self.setDataSource()
        }*/
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
        //self.EventList.estimatedRowHeight = 100
        self.EventList.rowHeight = UITableViewAutomaticDimension
        //self.displayEvents()
    }
    
    //Update calendarListEvent and reload UITableView
    //No longer used****
    func updateListOfEvents(button: UIButton) {
        Bcalendar().getEvents{ (responseObject, responseObject2) in
            self.calendarListEvent = responseObject2
            //load list view
            self.setDataSource()
            self.EventList.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //print("Calendar List View appeared")
        
        //check if CalendarEventList was updated
        if(Bcalendar().updated() == true) {
            print("ViewControllerList check: calendar was updated")
            Bcalendar().setListUpdated(updated: false)
            self.calendarListEvent = Bcalendar().getBCalListEvents()
            self.setDataSource()
            self.EventList.reloadData()
        }
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

