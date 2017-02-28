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

    @IBOutlet weak var ListHeader: UILabel!
    @IBOutlet weak var EventList: UITableView!
    
    let now = DateInRegion()
    var calendarListEvent: [Int: [Event]]? = nil
    var calendarListEvent2: [Int: [Event]]? = nil
    var calendarListEventKeys: [Int]? = nil
    let daysOfTheWeek = ["Monday","Tuesday","Wednesday","Thursday","Friday"]
    let week = DateInRegion().previousWeekend
    
    var selectedListCellEvent: Event? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register event summary cell type for event list
        EventList.register(UINib.init(nibName: "EventSummaryCell", bundle: nil), forCellReuseIdentifier: "EventSummaryCell")
        //Make call to server
        getEvents()
    }
    
    func tableView(_ EventList: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        

        
        //Get event array list for current section header and display all event titles for that header section
        var listToPullFrom = self.calendarListEvent
        let dayinWeek = self.week?.endDate
        var sectionDay = (dayinWeek?.day)! + indexPath.section + 1
        
        if sectionDay > (dayinWeek?.monthDays)! && dayinWeek?.month == now.month {
            sectionDay = sectionDay - (dayinWeek?.monthDays)!
            listToPullFrom = self.calendarListEvent2
        }
        else if sectionDay > (dayinWeek?.monthDays)! {
            sectionDay = sectionDay - (dayinWeek?.monthDays)!
        }
        
        if let dateExists = listToPullFrom?[sectionDay] {
            // Use event summary cell
            let cell = EventList.dequeueReusableCell(withIdentifier: "EventSummaryCell", for: indexPath as IndexPath) as! EventSummaryCell
            
            let currEvent = dateExists[indexPath.row]
            
            /*
            var minuteStart = String(describing: (dateExists[indexPath.row].eventStart?.minute)!)
            var minuteEnd = String(describing: (dateExists[indexPath.row].eventEnd?.minute)!)
            if minuteStart == "0" {
                minuteStart = "00"
            }
            if minuteEnd == "0" {
                minuteEnd = "00"
            }
            cell.EventTitle.text = "\(currEvent.eventTitle)"
            cell.EventLocation.text = "Location: \(currEvent.location)"
            cell.EventTime.text = "\(currEvent.eventStart!.hour):\(minuteStart)-\(currEvent.eventEnd!.hour):\(minuteEnd)"
            */
            
            // Let the cell handle its own display setup
            cell.fillData(curr: currEvent)
            return cell
        }
        else {
            // Use prototype cell
            let cell = EventList.dequeueReusableCell(withIdentifier: "com.CalendarViewApp.ListEvent", for: indexPath as IndexPath) as! ListCell
            cell.EventTitle.text = "No events for date"
            cell.EventLocation.text = " "
            cell.EventTime.text = " "
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerSection = EventList.dequeueReusableCell(withIdentifier: "com.CalendarViewApp.ListEventHeader") as! ListCellHeader
        
        let dayinWeek = self.week?.endDate
        var headerDay = (dayinWeek?.day)! + section + 1
        var monthOfDate = (dayinWeek?.monthName)!
        if headerDay > (dayinWeek?.monthDays)! {
            headerDay = headerDay - (dayinWeek?.monthDays)!
            monthOfDate = (dayinWeek?.nextMonth.monthName)!
        }
        
        headerSection.DateHeader.text = "  \(self.daysOfTheWeek[section]), \(monthOfDate) \(headerDay)"
        
        return headerSection
    }
    
    func tableView(_ EventList: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var listToPullFromR = self.calendarListEvent
        let dayinWeek = self.week?.endDate
        var sectionDayR = (dayinWeek?.day)! + section + 1
        
        if sectionDayR > (dayinWeek?.monthDays)! && dayinWeek?.month == now.month {
            sectionDayR = sectionDayR - (dayinWeek?.monthDays)!
            listToPullFromR = self.calendarListEvent2
        }
        else if sectionDayR > (dayinWeek?.monthDays)! {
            sectionDayR = sectionDayR - (dayinWeek?.monthDays)!
        }

        if let eventRow = listToPullFromR?[sectionDayR] {
            return eventRow.count
        }
        else {
            return 1
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        //return UITableViewAutomaticDimension
        return 55
    }
    
    //use completion handler to make call to server using Alamofire
    func getEvents() {
        
        print("Getting events")
        self.calendarListEvent = Bcalendar().getBCalListEvents()
        self.calendarListEvent2 = Bcalendar().getBCalListEvents2()
        self.setDataSource()
        
    }
    
    //load the list view
    func setDataSource() {
        /* create a list of keys(dates for events) for use with uitableview methods
         * keys sorted by ascending date
         */
        self.calendarListEventKeys = self.calendarListEvent?.keys.sorted { (_ key1: Int, _ key2: Int) -> Bool in
            return key1 < key2
        }
        
        //load data source and delegate
        self.EventList.dataSource = self
        self.EventList.delegate = self
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
            self.calendarListEvent2 = Bcalendar().getBCalListEvents2()
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
    
    // Go to event details (trigger segue) when event list row selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let rowIndex = tableView.indexPathForSelectedRow!
        if let selectedListCell = tableView.cellForRow(at:rowIndex) as? EventSummaryCell {
            selectedListCellEvent = selectedListCell.contents
            performSegue(withIdentifier: "EventDetails", sender: self)
        }
    }
    // Send current event when viewing details
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EventDetails" {
            let destination = segue.destination as? ViewControllerEventDetails
            destination!.contents = selectedListCellEvent
        }
    }
    
    
    @IBAction func unwindFromEventDetails(segue: UIStoryboardSegue) {
    }
}

