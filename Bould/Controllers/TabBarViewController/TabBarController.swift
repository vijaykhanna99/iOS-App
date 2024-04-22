//
//  TabBarController.swift
//  Bould
//
//  Created by Jacob Marillion on 8/2/23.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBar.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        let border = CALayer()
        border.frame = CGRectMake(0.0, 0.0, self.view.frame.size.width, 0.5)
        border.backgroundColor = UIColor.lightGray.cgColor
        self.tabBar.layer.addSublayer(border)
        
        self.tabBar.tintColor = UIColor.systemGray6
        self.tabBar.barTintColor = UIColor.black
    }
    
} //End of class
