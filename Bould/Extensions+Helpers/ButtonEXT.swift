//
//  BouldRoundedShadedButtons.swift
//  Bould
//
//  Created by Jacob Marillion on 7/27/23.
//

import UIKit

extension UIButton {
    
    func roundAndAddShadow() {
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowRadius = 5
        self.layer.shadowOpacity = 0.3
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.cornerRadius = 10
    }
    
} //End of extension
