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
    @IBOutlet weak var testEventTitle: UILabel!
    
    var calendarListEvent: [Int: [Event]]? = nil
    var calendarListEventKeys: [Int]? = nil
    
    let white = UIColor(colorWithHexValue: 0xECEAED)
    let darkPurple = UIColor(colorWithHexValue: 0x3A284C)
    let dimPurple = UIColor(colorWithHexValue: 0x574865)
    
    let lightGrey = UIColor(colorWithHexValue: 0xB3B3B3)

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        calendarView.dataSource = self
        calendarView.delegate = self
        calendarView.registerCellViewXib(file: "CellView") // Registering your cell is manditory
        
        // Add this new line
        calendarView.cellInset = CGPoint(x: 0, y: 0)
        
        // Register the calendar header view (month 1 & month 2)
        //calendarView.registerHeaderView(xibFileNames: ["CalendarHeaderView"])
        calendarView.registerHeaderView(xibFileNames: ["CalendarHeaderView", "CalendarHeaderView2"])
        
        // Get list of events from Google Calendar
        Bcalendar().getEvents{ (responseObject, responseObject2) in
            self.calendarListEvent = responseObject2
            print("Calendar Events Received")
        }
    }

    /*
    @IBAction func resize(_ sender: UIButton) {
        calendarView.frame = CGRect(
            x: calendarView.frame.origin.x,
            y: calendarView.frame.origin.y,
            width: calendarView.frame.width,
            height: calendarView.frame.height - 50
            
        )
    */
    
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
            myCustomCell.dayLabel.textColor = darkPurple
        } else {
            if cellState.dateBelongsTo == .thisMonth {
                myCustomCell.dayLabel.textColor = dimPurple
            } else {
                myCustomCell.dayLabel.textColor = lightGrey
            }
        }
        
        let keyExists = calendarListEvent?[cellState.date.day]
        //display event for selected date here
        if keyExists != nil {
            let displayEventDay = self.calendarListEvent?[cellState.date.day]
            
            if displayEventDay?[0].eventStart?.month == cellState.date.month {
                self.testEventTitle.text = displayEventDay?[0].eventTitle
            }
            else {
                self.testEventTitle.text = "No events for selected day"
            }
            
            
        }
        else {
            self.testEventTitle.text = "No events for selected day"
        }
        
    }
    
    // Function to handle the calendar selection
    func handleCellSelection(view: JTAppleDayCellView?, cellState: CellState) {
        guard let myCustomCell = view as? CellView  else {
            return
        }
        if cellState.isSelected {
            myCustomCell.selectedView.layer.cornerRadius =  25
            myCustomCell.selectedView.isHidden = false
        } else {
            myCustomCell.selectedView.isHidden = true
        }
    }
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplayCell cell: JTAppleDayCellView, date: Date, cellState: CellState) {
        let myCustomCell = cell as! CellView
        
        // Setup Cell text
        myCustomCell.dayLabel.text = cellState.text
        
        /*
        // Setup text color
        if cellState.dateBelongsTo == .thisMonth {
            myCustomCell.dayLabel.textColor = UIColor(colorWithHexValue: 0x000000)
        } else {
            myCustomCell.dayLabel.textColor = UIColor(colorWithHexValue: 0xb3b3b3)
        }
         */
        
        handleCellTextColor(view: cell, cellState: cellState)
        handleCellSelection(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleDayCellView?, cellState: CellState) {
        
        /*
        let myCustomCell = cell as! CellView
        
        // Let's make the view have rounded corners. Set corner radius to 25
        myCustomCell.selectedView.layer.cornerRadius =  25
        
        if cellState.isSelected {
            myCustomCell.selectedView.isHidden = false
        }
         */
        
        handleCellSelection(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleDayCellView?, cellState: CellState) {
        
        /*
        let myCustomCell = cell as! CellView
        myCustomCell.selectedView.isHidden = true
         */
        
        handleCellSelection(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
    }
    
    // This sets the height of your header
    func calendar(_ calendar: JTAppleCalendarView, sectionHeaderSizeFor range: (start: Date, end: Date), belongingTo month: Int) -> CGSize {
        return CGSize(width: 200, height: 50)
    }
    
    // This setups the display of your header
    func calendar(_ calendar: JTAppleCalendarView, willDisplaySectionHeader header: JTAppleHeaderView, range: (start: Date, end: Date), identifier: String) {
        
        if(identifier=="CalendarHeaderView"){
            let headerCell = (header as? CalendarHeaderView)
            headerCell?.title.text = Date().monthName
        } else {
            let headerCell2 = (header as? CalendarHeaderView2)
            headerCell2?.title2.text = Calendar.current.date(byAdding: .month, value: 1, to: Date())?.monthName
        }
        
    }
    
    func calendar(_ calendar: JTAppleCalendarView, sectionHeaderIdentifierFor range: (start: Date, end: Date), belongingTo month: Int) -> String {
        if month % 2 > 0 {
            return "CalendarHeaderView"
        }
        return "CalendarHeaderView2"
    }
    
    //Update calendarListEvent and reload UITableView
    func updateListOfEvents(button: UIButton) {
        Bcalendar().getEvents{ (responseObject, responseObject2) in
            self.calendarListEvent = responseObject2
            //load list view
            //self.setDataSource()
            //self.EventList.reloadData()
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


