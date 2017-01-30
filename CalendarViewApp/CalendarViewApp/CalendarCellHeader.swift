//
//  CalendarCellHeader.swift
//  CalendarViewApp
//
//  Created by Cosc499Capstone on 2017-01-02.
//  Copyright © 2017 Amrit. All rights reserved.
//

import UIKit

class CalendarCellHeader: UITableViewCell {

    @IBOutlet weak var CalendarDay: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //self.CalendarDay.backgroundColor = UIColor.lightGray
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
