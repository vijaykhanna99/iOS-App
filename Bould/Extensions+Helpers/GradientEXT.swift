//
//  GradientExtension.swift
//  Bould
//
//  Created by Jacob Marillion on 7/21/23.
//

import UIKit

enum GradientDirection {
    case downContainer
    case background
} //End of enum

extension UIView {

    func addGradient(direction: GradientDirection = .background) {
        
        let gradientLayer = CAGradientLayer()
        var colors: [CGColor] = [UIColor.clear.cgColor, #colorLiteral(red: 0.3079032513, green: 0.26866068, blue: 0.26866068, alpha: 1)]
        
        switch direction {
        case .downContainer:
            colors = [UIColor.black.cgColor, UIColor.black.cgColor, #colorLiteral(red: 0.1853495896, green: 0.1617266027, blue: 0.1617266027, alpha: 1)]
            
            gradientLayer.frame = bounds
            gradientLayer.colors = colors
            gradientLayer.startPoint = CGPoint(x: 0, y: 1)
            gradientLayer.endPoint = CGPoint(x: 0, y: 0)
            gradientLayer.opacity = 1.0
            
            layer.insertSublayer(gradientLayer, at: 0)
            layer.borderWidth = 0.25
            layer.borderColor = UIColor.lightGray.cgColor
        default:
            colors = [UIColor.clear.cgColor, #colorLiteral(red: 0.3079032513, green: 0.26866068, blue: 0.26866068, alpha: 1)]
            
            gradientLayer.frame = bounds
            gradientLayer.colors = colors
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 0, y: 1)
            gradientLayer.opacity = 0.7
            
            layer.insertSublayer(gradientLayer, at: 0)
        }
    }
    
} //End of extension
