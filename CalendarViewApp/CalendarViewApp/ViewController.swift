//
//  ViewController.swift
//  CalendarViewApp
//
//  Created by Cosc499Capstone on 2016-12-27.
//  Copyright © 2016 Amrit. All rights reserved.
//

import UIKit
import Alamofire
//import Gloss
import SwiftyJSON
import SwiftDate
import Foundation

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var Events: UILabel!
    @IBOutlet weak var EventList: UITableView!
    
    var eventRequest : String? = ""
    var numberOfEvents: Int? = 0
    var eventSummary = [String]()
    var eventStartDate = [Double]()
    var convertedStartDate = [Date]()
    var dateFor: DateFormatter = DateFormatter()
    let now = DateInRegion()
    var calendarListEvent = [Int: [Event]]()
    var calendarListEventKeys: [Int]? = nil
    
    let data = ["New York, NY", "Los Angeles, CA", "Chicago, IL", "Houston, TX",
                "Philadelphia, PA", "Phoenix, AZ", "San Diego, CA", "San Antonio, TX",
                "Dallas, TX", "Detroit, MI", "San Jose, CA", "Indianapolis, IN",
                "Jacksonville, FL", "San Francisco, CA", "Columbus, OH", "Austin, TX",
                "Memphis, TN", "Baltimore, MD", "Charlotte, ND", "Fort Worth, TX"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.dateFor.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        self.dateFor.dateStyle = .short
        self.dateFor.timeStyle = .short
        
        self.Events.text = "Calendar Events"
        //self.Events.sizeToFit()
        self.Events.textAlignment = NSTextAlignment.center
        
        //self.EventList.delegate = self
        //self.EventList.dataSource = self
        //self.EventList.estimatedRowHeight = 100
        //self.EventList.rowHeight = UITableViewAutomaticDimension
        
        getEvents()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ EventList: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = EventList.dequeueReusableCell(withIdentifier: "com.CalendarViewApp.CalendarPrototypeCell", for: indexPath as IndexPath) as! CalendarPrototypeCell
        
        //let cityState = data[indexPath.row].components(separatedBy: ", ")
        //let displayEventSummary = self.eventSummary[indexPath.row]
        //cell.EventDay.text = cityState.first
        //cell.EventDay.text = displayEventSummary
        //cell.EventDay.text = eventRequest
        
        let displayEventDay = self.calendarListEvent[self.calendarListEventKeys![indexPath.section]]
        let displayEventTitle = displayEventDay?[indexPath.row].eventTitle
        
        cell.EventDay.text = displayEventTitle
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        print("header section called")
        let headerSection = EventList.dequeueReusableCell(withIdentifier: "com.CalendarViewApp.CalendarPrototypeHeader") as! CalendarCellHeader
        
        let displayEventHeaderDay = Int((self.calendarListEventKeys?[section])!)
        
        headerSection.CalendarDay.text = "\(now.monthName) \(String(describing: displayEventHeaderDay)),  \(now.year)"
        
        //let headerSection2 = headerSection as TableSectionHeader
        //headerSection.CalendarDay.text = "Test"
        
        return headerSection
    }
    
    func tableView(_ EventList: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return 4
        print("number of rows in section")
        print(self.calendarListEvent[self.calendarListEventKeys![section]]!.count)
        return self.calendarListEvent[self.calendarListEventKeys![section]]!.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        //return 1
        print("number of sections in table view:")
        print(self.calendarListEvent.count)
        return self.calendarListEvent.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        //return UITableViewAutomaticDimension
        return 30
    }
    
    func getEvents() {
        
        //let url = "http://138.197.141.224/events/"
        let url = "http://138.197.129.140:8080/calendar/events?calendarName=bridgekelowna@gmail.com&min=\(now.year)-\(now.month)-01T10:00:31-08:00&max=\(now.year)-\(now.month)-\(now.monthDays)T11:00:31-08:00"
        
        Alamofire.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                for (_, subJson):(String, JSON) in json["eventItems"] {
                
                    let eventTitle = String(describing: subJson["summary"])
                    let getStartDate = subJson["start"]["dateTime"]["value"].doubleValue
                    let getEndDate = subJson["end"]["dateTime"]["value"].doubleValue
                    let description = String(describing: subJson["description"])
                    
                    //self.eventStartDate.append(getStartDate)
                    
                    //let date4 = try! DateInRegion(string: self.eventStartDate[self.numberOfEvents!], format: .iso8601(options: .withInternetDateTime))
                    //self.convertedStartDate.append(date4)
                    //print(date4.year)
                    
                    //print(self.eventStartDate[self.numberOfEvents!])
                    let convertUnixDateStart = Date(timeIntervalSince1970: getStartDate/1000)
                    let convertedStartDate = convertUnixDateStart
                    
                    let convertUnixDateEnd = Date(timeIntervalSince1970: getEndDate/1000)
                    let convertedEndDate = convertUnixDateEnd
                    
                    let currEventObject = Event(eT: eventTitle, eS: convertedStartDate, eE: convertedEndDate, desc: description)
                    
                    if self.calendarListEvent[(currEventObject.eventStart?.day)!] != nil {
                        self.calendarListEvent[(currEventObject.eventStart?.day)!]?.append(currEventObject)
                    }
                    else {
                        self.calendarListEvent[(currEventObject.eventStart?.day)!] = [Event]()
                        self.calendarListEvent[(currEventObject.eventStart?.day)!]?.append(currEventObject)
                    }
                    
                    //print(self.eventSummary[self.numberOfEvents!])
                    //print(self.eventStartDate[self.numberOfEvents!])
                    //print(self.convertedStartDate[self.numberOfEvents!].year)
                    self.numberOfEvents! += 1
                }
                
                //Create a list of keys(dates for events) for use with uitableview methods
                self.calendarListEventKeys = [Int](self.calendarListEvent.keys)
                
                self.EventList.dataSource = self
                self.EventList.delegate = self
                self.EventList.estimatedRowHeight = 100
                self.EventList.rowHeight = UITableViewAutomaticDimension
                self.displayEvents()
            case .failure(let error):
                print(error)
            }
        }
        
        /*Alamofire.request("http://138.197.141.224/events/")
            .responseString { response in
                //print(response.result.value)
                self.testing(eventToGet: response.result.value!)
            }*/
    }
    
    func eventParsed(eventToGet: String) {
        self.eventRequest = eventToGet
        //print(self.eventRequest)
        
        
        if let dataFromString = self.eventRequest!.data(using: .utf8, allowLossyConversion: false) {
            let json = JSON(data: dataFromString)
            
            //print(json[0]["summary"])
            
            
            for anItem in json {
                print(anItem)
                self.numberOfEvents! += 1
            }
            
            
            
        }
        print("HERE LOOK: \(numberOfEvents)")
    }
    
    func displayEvents() {
        //print("Looky")
        //print(self.calendarListEvent.count)
        //print(self.calendarListEvent[2]?.count ?? "No events for this day")
        for (_, eventInDay) in self.calendarListEvent {
            for singleEvent in eventInDay{
                print(singleEvent.eventTitle)
            }
        }
        print("Keys in calenadr List Event:")
        for keyDay in self.calendarListEventKeys! {
            print(keyDay)
        }
    }
    
    
}

