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

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var Events: UILabel!
    @IBOutlet weak var EventList: UITableView!
    
    var eventRequest : String? = ""
    var numberOfEvents: Int? = 0
    var eventSummary = [String]()
    var eventStartDate = [String]()
    var convertedStartDate = [DateInRegion]()
    var dateFor: DateFormatter = DateFormatter()
    
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
        self.Events.textAlignment = NSTextAlignment.center
        
        self.EventList.dataSource = self
        //self.EventList.delegate = self
        self.EventList.estimatedRowHeight = 100
        self.EventList.rowHeight = UITableViewAutomaticDimension
        
        getEvents()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ EventList: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = EventList.dequeueReusableCell(withIdentifier: "com.CalendarViewApp.CalendarPrototypeCell", for: indexPath as IndexPath) as! CalendarPrototypeCell
        
        let cityState = data[indexPath.row].components(separatedBy: ", ")
        cell.EventDay.text = cityState.first
        //cell.EventDay.text = eventRequest
        return cell
    }
    
    func tableView(_ EventList: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return data.count
        return 1
    }
    
    func getEvents() {
        
        let url = "http://138.197.141.224/events/"
        
        Alamofire.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                for (key,subJson):(String, JSON) in json {
                    self.eventSummary.append(String(describing: subJson["summary"]))
                    self.eventStartDate.append(String(describing: subJson["start"]["dateTime"]))
                    
                    let date4 = try! DateInRegion(string: self.eventStartDate[self.numberOfEvents!], format: .iso8601(options: .withInternetDateTime))
                    self.convertedStartDate.append(date4)
                    //print(date4.year)
                    
                    print(self.eventSummary[self.numberOfEvents!])
                    print(self.eventStartDate[self.numberOfEvents!])
                    self.numberOfEvents! += 1
                }
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
    
    
}

