//
//  BouldRoundedTextField.swift
//  Bould
//
//  Created by Jacob Marillion on 7/22/23.
//

import UIKit

class BouldRoundedTextField: UITextField {
    
    override func draw(_ rect: CGRect) {
        layer.cornerRadius = frame.size.height / 2
        clipsToBounds = true
        layer.borderWidth = 2
        layer.borderColor = UIColor.gray.withAlphaComponent(0.2).cgColor
    }
    
} //End of class

class BouldTextField: UITextField {
    
    override func draw(_ rect: CGRect) {
        layer.cornerRadius = 10
        clipsToBounds = true
        layer.borderWidth = 2
        layer.borderColor = UIColor.gray.withAlphaComponent(0.2).cgColor
    }
    
} //End of class
