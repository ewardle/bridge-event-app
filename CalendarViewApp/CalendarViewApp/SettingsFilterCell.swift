//
//  SettingsFilterCell.swift
//  CalendarViewApp
//
//  Created by Eliana on 2017-03-20.
//  Copyright © 2017 Amrit. All rights reserved.
//

import UIKit

class SettingsFilterCell: UITableViewCell {
    
    @IBOutlet weak var locationSwitch: UISwitch!

    @IBOutlet weak var locationName: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func filterAction(_ sender: AnyObject) {
        let val = locationSwitch.isOn
        UserDefaults.standard.set(val, forKey:"\(locationName.text?.lowercased())Filter")
    }
}
