//
//  ViewControllerTabBarViewController.swift
//  CalendarViewApp
//
//  Created by Amrit on 2017-01-31.
//  Copyright © 2017 Amrit. All rights reserved.
//

import UIKit

class ViewControllerTabBar: UITabBarController {
    
    @IBOutlet weak var TabBar: UITabBar!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        TabBar.barTintColor = UIColor.purple
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}



