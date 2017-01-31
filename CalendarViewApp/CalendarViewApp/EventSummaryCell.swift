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
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var description: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var startTime: UILabel!
    @IBOutlet weak var endTime: UILabel!
    @IBOutlet weak var divider: UIView!
    
    // Event that we got the data for this cell from
    var contents: Event? = nil
    
    // The controller that will let us segue to details view
    var delegate: EventDetailsDelegate?
    
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
        self.title.text = curr.eventTitle
        self.description.text = curr.description
        self.startTime.text = curr.eventStart
        if let endTime = curr.eventEnd {
            self.endTime.text = curr.eventEnd
        }
        else { // no end time (all-day event)
            self.endTime.text = ""
        }
        if let newColor = locationColors[curr.location] {
            self.divider.backgroundColor = newColor
        }
        else { // unrecognized location
            self.divider.backgroundColor = gray
        }
    }
    
}


// For switching to summary cell
public protocol EventDetailsDelegate {
    func goToDetails(content: Event)
}
