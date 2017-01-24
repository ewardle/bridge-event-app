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

class ViewControllerEventDetails: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    // @TODO: Get IBOutlets from the fields
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // @TODO: register Event Details cell type, or else treat the view as a monolithic one; get details passed in from initial event summary
    }
    

    
}

extension UIColor {
    convenience init(colorWithHexValue value: Int, alpha:CGFloat = 1.0){
        self.init(
            red: CGFloat((value & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((value & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(value & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
}
