//
//  GetEvents.swift
//  CalendarViewApp
//
//  Created by Cosc499Capstone on 2017-01-10.
//  Copyright © 2017 Amrit. All rights reserved.
//

import Foundation
import Alamofire
import SwiftDate
import SwiftyJSON
//MUST STILL ADJUST URL TO BRING BACK CURRENT MONTH'S AND NEXT MONTH'S EVENTS******************
public class Bcalendar {
    
    private let url: String
    private let url2: String
    private var setUrl: String?
    private let now: Date
    private var numberOfEvents: Int?
    private static var sCalendarListEvent = [Int: [Event]]()
    private static var listUpdated = false
    private static var nextMonth = false
    
    init() {
        now = Date()
        //Url for Spring Server hosting the google calendar api
        url = "http://138.197.129.140:8080/calendar/events?calendarName=bridgekelowna@gmail.com&min=\(now.year)-\(now.month)-01T10:00:31-08:00&max=\(now.year)-\(now.month)-\(now.monthDays)T11:00:31-08:00"
        url2 = "http://138.197.129.140:8080/calendar/events?calendarName=bridgekelowna@gmail.com&min=\(now.year)-\(now.month+1)-01T10:00:31-08:00&max=\(now.year)-\(now.month+1)-28T11:00:31-08:00"
        numberOfEvents = 0
    }
    
    func getEvents(completionHandler: @escaping (_ responseObject: String?, _ responseObject2: [Int:[Event]]) -> ()){
        updateEvents(completionHandler: completionHandler)
    }
    
    func updateEvents(completionHandler: @escaping (_ responseObject: String?, _ responseObject2: [Int:[Event]]) -> ()) {
        
        //print(self.setUrl ?? "Not see from Bcal")
        
        if(Bcalendar.nextMonth == false) {
            self.setUrl = self.url
        }
        else {
            self.setUrl = self.url2
        }
        
        Alamofire.request(self.setUrl!, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let dictionaryOfEvents = self.parseEvents(events: json)
                completionHandler("Retrieved Events", dictionaryOfEvents)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func parseEvents(events: JSON) -> [Int: [Event]] {
        
        var calendarListEvent = [Int: [Event]]()
                
        //Loop through JSON from server to parse events into components
        for (_, subJson):(String, JSON) in events["eventItems"] {
            
            //Get event summary, description and UNIX start and end date for event
            let eventTitle = String(describing: subJson["summary"])
            let getStartDate = subJson["start"]["dateTime"]["value"].doubleValue
            let getEndDate = subJson["end"]["dateTime"]["value"].doubleValue
            let description = String(describing: subJson["description"])
            
            //Convert UNIX date into Date object
            let convertUnixStartDate = Date(timeIntervalSince1970: getStartDate/1000)
            let convertUnixEndDate = Date(timeIntervalSince1970: getEndDate/1000)
            
            //Send components to Event.swift to create Event object
            let currEventObject = Event(eT: eventTitle, eS: convertUnixStartDate, eE: convertUnixEndDate, desc: description)
            
            //If date key does not exist in dictionary then initialize array with new date key
            //before adding new event object
            if calendarListEvent[(currEventObject.eventStart?.day)!] != nil {
                calendarListEvent[(currEventObject.eventStart?.day)!]?.append(currEventObject)
            }
            else {
                calendarListEvent[(currEventObject.eventStart?.day)!] = [Event]()
                calendarListEvent[(currEventObject.eventStart?.day)!]?.append(currEventObject)
            }
            
            self.numberOfEvents! += 1
        }
        
        Bcalendar.sCalendarListEvent = calendarListEvent
        
        return calendarListEvent
    }
    
    func keySort(_ s1: Int, _ s2: Int) -> Bool {
        return s1 < s2
    }
    
    func getBCalListEvents() -> [Int: [Event]] {
        return Bcalendar.sCalendarListEvent
    }
    
    //method to check if list was updated by pressing sync button on calendar view
    func updated() -> Bool {
        return Bcalendar.listUpdated
    }
    
    //method to set listUpdated back to false once viewControllerList updates UITableView
    func setListUpdated(updated: Bool) {
        Bcalendar.listUpdated = updated
    }
    
    //Switch between getting current or next month's events
    func setMonth(nextMonthSet: Bool) {
        Bcalendar.nextMonth = nextMonthSet
    }
}
