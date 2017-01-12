//
//  CalendarPrototypeCell.swift
//  CalendarViewApp
//
//  Created by Cosc499Capstone on 2016-12-28.
//  Copyright © 2016 Amrit. All rights reserved.
//

import UIKit

class CalendarPrototypeCell: UITableViewCell {

    @IBOutlet weak var EventDay: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
