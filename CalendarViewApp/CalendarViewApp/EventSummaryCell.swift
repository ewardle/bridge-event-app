//
//  EventSummaryCell.swift
//  CalendarViewApp
//
//  Created by Eliana on 2017-01-22.
//  Copyright © 2017 Amrit. All rights reserved.
//

import UIKit

class EventSummaryCell: UITableViewCell {
    
    // Parts of cell
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var eventDescription: UILabel!
    @IBOutlet weak var startTime: UILabel!
    @IBOutlet weak var endTime: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var divider: UIView!

    
    // Event that we got the data for this cell from
    var contents: Event? = nil
    
    let locationColors: [String: UIColor] = ["Peachland": UIColor(colorWithHexValue: 0xFF9999), "Kelowna": UIColor(colorWithHexValue: 0x99CCFF)] //placeholders until we can get the place names programmatically
    let gray = UIColor.gray
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    // Populate cell with the data and store the event that it comes from
    func fillData(curr: Event) {
        contents = curr
        
        // Title, description, location
        if contents!.eventTitle != "" {
            self.eventTitle.text = "\(contents!.eventTitle)"
        } else {
            self.eventTitle.text = "No Title"
        }
        if contents!.description != "null" {
            self.eventDescription.text = "\(contents!.description)"
        } else {
            self.eventDescription.text = "No Details"
        }
        if contents!.location != "" {
            self.location.text = "\(contents!.location)"
            if let color = locationColors[(contents!.location)] {
                self.divider.backgroundColor = color
            }
            else { // unrecognized location
                self.divider.backgroundColor = gray
            }
        } else {
            self.location.text = "Unknown Location"
        }
        
        // Start and end times
        if let es = contents!.eventStart {
            var minuteStart = String(es.minute)
            if(minuteStart == "0") {
                minuteStart = "00"
            }
            self.startTime.text = "\(contents!.eventStart!.hour):\(minuteStart)"
        } else {
            self.startTime.text = "All Day"
        }
        if let ee = contents!.eventEnd {
            var minuteEnd = String(ee.minute)
            if(minuteEnd == "0") {
                minuteEnd = "00"
            }
            self.endTime.text = "-\(contents!.eventEnd!.hour):\(minuteEnd)"
        } else {
            self.endTime.text = ""
        }
        
    }
    
}
