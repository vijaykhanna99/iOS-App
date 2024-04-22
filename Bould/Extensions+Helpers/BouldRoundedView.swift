//
//  BouldRoundedViews.swift
//  Bould
//
//  Created by Jacob Marillion on 7/27/23.
//

import UIKit

class BouldRoundedView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.addGradient(direction: GradientDirection.downContainer)
        layer.cornerRadius = 20
        clipsToBounds = true
    }
    
} //End of class
