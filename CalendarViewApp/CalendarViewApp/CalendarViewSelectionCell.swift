//
//  CalendarViewSelectionCell.swift
//  CalendarViewApp
//
//  Created by Cosc499Capstone on 2017-01-16.
//  Copyright © 2017 Amrit. All rights reserved.
//

import UIKit

class CalendarViewSelectionCell: UITableViewCell {
    
    @IBOutlet weak var CalendarEventDay: UILabel!
    @IBOutlet weak var CalendarEventLocation: UILabel!
    @IBOutlet weak var CalendarEventTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        //self.CalendarEventDay.backgroundColor = UIColor.green
    }

}
