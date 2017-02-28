//
//  ViewControllerCalendar.swift
//  CalendarViewApp
//
//  Created by Cosc499Capstone on 2017-01-03.
//  Copyright © 2017 Amrit. All rights reserved.
//

import UIKit
import JTAppleCalendar

class ViewControllerCalendar: UIViewController {
    
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var EventListCalendar: UITableView!
    @IBOutlet weak var syncCalendarButton: UIButton!
    
    var calendarListEvent: [Int: [Event]]? = nil
    var calendarListEventNext: [Int: [Event]]? = nil
    var calendarListEventDay: [Event]? = nil
    let now = Date()

    var selectedListCellEvent: Event? = nil
    
    let darkPurple = UIColor(colorWithHexValue: 0x3A284C)
    let dimPurple = UIColor(colorWithHexValue: 0x574865)
    let lightGrey = UIColor(colorWithHexValue: 0xB3B3B3)
    let green = UIColor(colorWithHexValue: 0x437519)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set view appearance characteristics
        self.EventListCalendar.backgroundColor = UIColor.white
        self.calendarView.backgroundColor = UIColor.white
        //self.calendarView.layer.borderColor = dimPurple.cgColor
        //self.calendarView.layer.borderWidth = 1
        
        //first retrieve next mont's events
        self.retrieveNextMonthEvents()
        
        
        // Register event summary cell type for event list section
        EventListCalendar.register(UINib.init(nibName: "EventSummaryCell", bundle: nil), forCellReuseIdentifier: "EventSummaryCell")
        
        //load CalendarView after retrieving list from Server
        self.loadCalendarView()
    }
    
    //load calendar view after calendar list events are received
    func loadCalendarView() {
        //do any additional setup after loading the view.
        calendarView.dataSource = self
        calendarView.delegate = self
        calendarView.registerCellViewXib(file: "CellView") // Registering your cell is manditory
        
        
        //add this new line
        calendarView.cellInset = CGPoint(x: 0, y: 0)
        
        //register the calendar header view (month 1 & month 2)
        calendarView.registerHeaderView(xibFileNames: ["CalendarHeaderView", "CalendarHeaderView2"])
        
        //Reloads calendar list with new event list when pressed
        syncCalendarButton.addTarget(self, action: #selector(updateListOfEvents(button:)), for: .touchUpInside)
        
    }
    
    func retrieveCurrentMonthEvents() {
        //get list of events from Google Calendar
        Bcalendar().getEvents{ (responseObject, responseObject2) in
            self.calendarListEvent = responseObject2
            print("Current Month Calendar Events Received")
            
            //Select current date as default date when calendar view loads
            self.calendarView.selectDates([NSDate() as Date])
        }
        
        //reload calendar view
        self.calendarView.reloadData()
    }
    
    func retrieveNextMonthEvents() {
        //switch url to retrieve next month's events
        Bcalendar().setMonth(nextMonthSet: true)
        
        //get list of events from Google Calendar for next month
        Bcalendar().getEvents{ (responseObject, responseObject2) in
            self.calendarListEventNext = responseObject2
            print("Next Month Calendar Events Received")
            Bcalendar().setMonth(nextMonthSet: false)
            self.retrieveCurrentMonthEvents()
        }

    }
    
}

extension ViewControllerCalendar: JTAppleCalendarViewDataSource, JTAppleCalendarViewDelegate {
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MM dd"
        
        let startDate = Date() // You can use date generated from a formatter
        let endDate = Calendar.current.date(byAdding: .month, value: 1, to: Date())!                                    // You can also use dates created from this function
        let parameters = ConfigurationParameters(startDate: startDate,
                                                 endDate: endDate,
                                                 numberOfRows: 6, // Only 1, 2, 3, & 6 are allowed
            calendar: Calendar.current,
            generateInDates: .forAllMonths,
            generateOutDates: .tillEndOfGrid,
            firstDayOfWeek: .sunday)
        return parameters
    }
    
    func handleCellTextColor(view: JTAppleDayCellView?, cellState: CellState) {
        
        guard let myCustomCell = view as? CellView  else {
            return
        }
        
        if cellState.isSelected {
            myCustomCell.dayLabel.textColor = UIColor.white
        } else {
            if cellState.dateBelongsTo == .thisMonth {
                myCustomCell.dayLabel.textColor = dimPurple
            } else {
                myCustomCell.dayLabel.textColor = lightGrey
            }
        }
        
        //reload TableView with events for selected date
        selectedNewDate(dateSelected: cellState.date.day, monthOfSelected: cellState.date.month)
        
    }
    
    //function to handle the calendar selection
    func handleCellSelection(view: JTAppleDayCellView?, cellState: CellState) {
        guard let myCustomCell = view as? CellView  else {
            return
        }
        if cellState.isSelected {
            myCustomCell.selectedView.layer.cornerRadius =  20
            myCustomCell.selectedView.isHidden = false
        } else {
            myCustomCell.selectedView.isHidden = true
        }
    }
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplayCell cell: JTAppleDayCellView, date: Date, cellState: CellState) {
        let myCustomCell = cell as! CellView
        
        //cell date text
        myCustomCell.dayLabel.text = cellState.text
        
        handleCellTextColor(view: cell, cellState: cellState)
        handleCellSelection(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleDayCellView?, cellState: CellState) {
        handleCellSelection(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleDayCellView?, cellState: CellState) {
        handleCellSelection(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
    }
    
    // This sets the height of your header
    func calendar(_ calendar: JTAppleCalendarView, sectionHeaderSizeFor range: (start: Date, end: Date), belongingTo month: Int) -> CGSize {
        return CGSize(width: 200, height: 50)
    }
    
    // This setups the display of your header
    func calendar(_ calendar: JTAppleCalendarView, willDisplaySectionHeader header: JTAppleHeaderView, range: (start: Date, end: Date), identifier: String) {
        
        //print("Identifier: \(identifier)");
        
        if(identifier=="CalendarHeaderView"){
            let headerCell = (header as? CalendarHeaderView)
            headerCell?.title.text = Date().monthName
        } else {
            let headerCell2 = (header as? CalendarHeaderView2)
            headerCell2?.title2.text = Calendar.current.date(byAdding: .month, value: 1, to: Date())?.monthName
        }
    }
    
    func calendar(_ calendar: JTAppleCalendarView, sectionHeaderIdentifierFor range: (start: Date, end: Date), belongingTo month: Int) -> String {
        if month == now.month {
            return "CalendarHeaderView"
        }
        return "CalendarHeaderView2"
    }
    
    func filteredEventList(list: [Event]) -> [Event]? {

        // Create new empty list and copy items in that aren't filtered out
        var calendarFilteredEventList: [Event] = [Event]()
        let defaults = UserDefaults.standard
        // Go through list to see if any exist and pass through filter
        for eventInfo in list as [Event] {
            let isUnfiltered: Bool? = defaults.bool(forKey: "\(eventInfo.location.lowercased())Filter")
            // Event row will be shown if not explicitly filtered out
            if isUnfiltered == nil || isUnfiltered == true {
                calendarFilteredEventList.append(eventInfo)
            }
        }
        if calendarFilteredEventList.count > 0 {
            return calendarFilteredEventList
        }
        else {
            return nil
        }
    }
    
    func selectedNewDate(dateSelected: Int, monthOfSelected: Int) {
        // Set calendarListEventDay to nil in order to check if unfiltered events exist for newly selected date
        self.calendarListEventDay = nil
        
        // If event list for selected date exists, and unfiltered events exist, set calendarListEventDay to that list
        if (self.calendarListEvent?[dateSelected]) != nil && self.calendarListEvent?[dateSelected]?[0].eventStart?.month == monthOfSelected {
            /*
            // Create new empty list and copy items in that aren't filtered out
            var calendarFilteredEventList: [Event] = [Event]()
            let defaults = UserDefaults.standard
            // Go through list to see if any exist and pass through filter
            for eventInfo in self.calendarListEvent![dateSelected]! as [Event] {
                let isUnfiltered: Bool? = defaults.bool(forKey: "\(eventInfo.location.lowercased())Filter")
                // Event row will be shown if not explicitly filtered out
                if isUnfiltered == nil || isUnfiltered == true {
                    calendarFilteredEventList.append(eventInfo)
                }
            }
            if calendarFilteredEventList.count > 0 {
                self.calendarListEventDay = calendarFilteredEventList
            }
            */
            self.calendarListEventDay = filteredEventList(list: self.calendarListEvent![dateSelected]!)
            
        }
        // If the month of event start is next month, use that list instead and filter similarly
        else if (self.calendarListEventNext?[dateSelected]) != nil && self.calendarListEventNext?[dateSelected]?[0].eventStart?.month == monthOfSelected {
            
            /* self.calendarListEventDay = self.calendarListEventNext?[dateSelected] */
            self.calendarListEventDay = filteredEventList(list: self.calendarListEventNext![dateSelected]!)
            
        }
        // Otherwise, leave calendarListEventDay nil.
        
        //reload TableView to show events for newly selected date if they exist
        self.EventListCalendar.dataSource = self
        self.EventListCalendar.delegate = self
        self.EventListCalendar.reloadData()
    }
    
    //Update calendarListEvent and reload UITableView
    func updateListOfEvents(button: UIButton) {
        
        //call linked calendarEventList methods
        self.retrieveNextMonthEvents()
        
        print("Reloading calendar view")
        
        //ViewControllerList will reload UITableView if set to true
        Bcalendar().setListUpdated(updated: true)
    }
}

extension ViewControllerCalendar: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ EventListCalendar: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Traverse through calendarListEventDay list
        if self.calendarListEventDay != nil {

            // Use event summary cell
            let cell = EventListCalendar.dequeueReusableCell(withIdentifier: "EventSummaryCell", for: indexPath as IndexPath) as! EventSummaryCell
            let eventInfo = calendarListEventDay?[indexPath.row]
            
            /*
            cell.CalendarEventDay.text = "\(eventInfo!.eventTitle)"
            cell.CalendarEventLocation.text = "Location: \(eventInfo!.location)"
            var minuteStart = String(eventInfo!.eventStart!.minute)
            var minuteEnd = String(eventInfo!.eventEnd!.minute)
            if(minuteStart == "0") {
                minuteStart = "00"
            }
            if(minuteEnd == "0") {
                minuteEnd = "00"
            }
            cell.CalendarEventTime.text = "\(eventInfo!.eventStart!.hour):\(minuteStart)-\(eventInfo!.eventEnd!.hour):\(minuteEnd)"
            */
            
            // Let the cell handle its own display setup
            cell.fillData(curr: eventInfo!)
            return cell
        }
        else {
            // Use prototype cell
            let cell = EventListCalendar.dequeueReusableCell(withIdentifier: "com.CalendarViewApp.CalendarViewSelectionCell", for: indexPath as IndexPath) as! CalendarViewSelectionCell
            cell.CalendarEventDay.text = "No events for date"
            cell.CalendarEventLocation.text = " "
            cell.CalendarEventTime.text = " "
            return cell
        }
    }
    
    func tableView(_ EventListCalendar: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.calendarListEventDay != nil {
            return self.calendarListEventDay!.count
        }
        else {
            return 1
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
