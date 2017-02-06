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
        self.eventTitle.text = "\(curr.eventTitle)"
        self.eventDescription.text = "\(curr.description)"
        self.location.text = "Location: \(curr.location)"
        
        // Start and end times
        var minuteStart = String(curr.eventStart!.minute)
        var minuteEnd = String(curr.eventEnd!.minute)
        if(minuteStart == "0") {
            minuteStart = "00"
        }
        if(minuteEnd == "0") {
            minuteEnd = "00"
        }
        self.startTime.text = "\(curr.eventStart!.hour):\(minuteStart)"
        self.endTime.text = "-\(curr.eventEnd!.hour):\(minuteEnd)"
        

        if let newColor = locationColors[curr.location] {
            self.divider.backgroundColor = newColor
        }
        else { // unrecognized location
            self.divider.backgroundColor = gray
        }
    }
    
}
