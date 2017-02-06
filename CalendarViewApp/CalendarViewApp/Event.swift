//
//  Event.swift
//  CalendarViewApp
//
//  Created by Cosc499Capstone on 2017-01-01.
//  Copyright © 2017 Amrit. All rights reserved.
//

import Foundation

public class Event {
    
    var eventTitle = ""
    var eventStart: Date? = nil
    var eventEnd: Date? = nil
    var location = ""
    var description = ""
    
    init(eT: String, eS: Date, eE: Date, desc: String, loc: String){
        self.eventTitle = eT
        self.eventStart = eS
        self.eventEnd = eE
        self.description = desc
        self.location = loc
    }
}
