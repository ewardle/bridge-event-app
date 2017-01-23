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
    
    func fillData(curr: Event) {
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
