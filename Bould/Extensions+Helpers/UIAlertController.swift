//
//  UIAlertController.swift
//  Bould
//
//  Created by Naveen on 17/10/23.
//

import Foundation
import UIKit

enum AlertAction:String {
    case OK
    case Allow
    case Cancel
    case Delete
    case Yes
    case No
    case Camera
    case Gallery
    case Confirm
    case Restart
    case Logout

    var title:String {
        return self.rawValue
    }
    
    var style:UIAlertAction.Style {
        switch self {
        case .Cancel:
            return .cancel
        case .Delete, .Logout:
            return .destructive
        default:
            return .default
        }
    }
}

typealias AlertHandler = (_ action: AlertAction) -> Void
typealias AlertInputHandler = (_ action: AlertAction, _ texts: [String]) -> Void

extension UIAlertController {
    
    class func showAlert(_ controller: UIViewController?, title: String?, message: String?) {
        
        showAlert(controller, title: title, message: message, preferredStyle: .alert, sender: nil, actions: .OK, handler: nil)
    }
    
    class func showAlert(_ controller: UIViewController? = nil, title: String?, message: String?, preferredStyle: UIAlertController.Style = .alert, sender: AnyObject? = nil, actions: AlertAction..., handler: AlertHandler?) {
        
        let target = controller ?? UIApplication.topViewController()
        let alertController = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        for arg in actions {
            let action = UIAlertAction(title: arg.title, style: arg.style, handler: { (action) in
                handler?(arg)
            })
            alertController.addAction(action)
        }
        if let presenter = alertController.popoverPresentationController {
            presenter.sourceView = target?.view;
            presenter.permittedArrowDirections = .any
            presenter.sourceRect = sender?.bounds ?? .zero
        }
        target?.present(alertController, animated: true, completion: nil)
    }
    
    class func showInputAlert(_ controller: UIViewController?, title: String?, message: String?, inputPlaceholders: [String]? = nil, inputTexts: [String]? = nil, preferredStyle: UIAlertController.Style = .alert, sender: AnyObject? = nil, actions: AlertAction..., handler: AlertInputHandler?) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        
        for (indx, placeholdr) in (inputPlaceholders ?? []).enumerated() {
            alertController.addTextField(configurationHandler: { (txtField) in
                txtField.placeholder = placeholdr
                if let text = inputTexts?[indx] {
                    txtField.text = text
                }
            })
        }
        for arg in actions {
            let action = UIAlertAction(title: arg.title, style: arg.style, handler: { (action) in
                var inputTexts = [String]()
                for txtFld in alertController.textFields ?? [] {
                    inputTexts.append(txtFld.text?.trimmed ?? "")
                }
                handler?(arg, inputTexts)
            })
            alertController.addAction(action)
        }
        if let presenter = alertController.popoverPresentationController {
            presenter.sourceView = controller?.view
            presenter.permittedArrowDirections = .any
            presenter.sourceRect =  sender?.bounds ?? .zero
        }
        controller?.present(alertController, animated: true, completion: nil)
    }
    
}
