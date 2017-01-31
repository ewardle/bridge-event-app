//
//  ViewControllerEventDetails.swift
//  CalendarViewApp
//
//  Created by Eliana on 2017-01-23.
//  Copyright © 2017 Amrit. All rights reserved.
//

import UIKit
import SwiftDate
import Foundation

class ViewControllerEventDetails: UIViewController {
    
    
    // Parts of cell
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var description: UITextView!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var startTime: UILabel!
    @IBOutlet weak var endTime: UILabel!
    @IBOutlet weak var divider: UIView!
    
    // Event that we get the data for this view from
    var contents: Event? = nil
    
    let locationColors: [String: UIColor] = ["Peachland": UIColor(colorWithHexValue: 0xFF9999), "Kelowna": UIColor(colorWithHexValue: 0x99CCFF)] //placeholders until we can get the place names programmatically
    let gray = UIColor.gray
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fillData(contents!) // contents variable filled when preparing for segue
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


