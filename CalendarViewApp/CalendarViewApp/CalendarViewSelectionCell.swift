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
    @IBOutlet weak var CalendarEventTimeStart: UILabel!
    @IBOutlet weak var CalendarEventTimeEnd: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
