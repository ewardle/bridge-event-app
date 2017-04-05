//
//  TableViewCell.swift
//  CalendarViewApp
//
//  Created by Eliana on 2017-03-26.
//  Copyright © 2017 Amrit. All rights reserved.
//

import UIKit

class LocationFilteringCell: UITableViewCell {

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
        UserDefaults.standard.set(val, forKey:"\(locationName.text!.lowercased())Filter")
        print("Setting default for \(locationName.text) to \(val)")
        let value = UserDefaults.standard.object(forKey: "\(locationName.text!.lowercased())Filter")
        print("Location: \(locationName.text!.lowercased())Filter; \(value)")
    }
    
    
}
