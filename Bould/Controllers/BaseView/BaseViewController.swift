//
//  BaseViewController.swift
//  Bould
//
//  Created by Naveen on 17/10/23.
//

import UIKit
import MBProgressHUD
import Toast

class BaseViewController: UIViewController {
    
    var baseVwModel: BaseViewModel? {
        didSet {
            initializeViewModel()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addBackButton()
    }
    
    func showLoadingIndicator() {
        MBProgressHUD.showAdded(to: self.view.window ?? self.view, animated: true)
    }
    
    func hideLoadingIndicator() {
        MBProgressHUD.hide(for: self.view.window ?? self.view, animated: true)
    }
    
    private func initializeViewModel() {
        baseVwModel?.showValidationErrorClosure = { [weak self] () in
            DispatchQueue.main.async {
                if let message = self?.baseVwModel?.validationErrorMessage {
                    self?.view.makeToast(message)
                }
            }
        }
        
        baseVwModel?.showAlertClosure = { [weak self] (_ isError:Bool) in
            DispatchQueue.main.async {
                if let message = self?.baseVwModel?.errorMessage {
                    UIAlertController.showAlert(self, title: "", message: message)
                }
            }
        }
                
        baseVwModel?.updateLoadingStatus = { [weak self] (_ isShow: Bool) in
            DispatchQueue.main.async {
                if isShow {
                    self?.showLoadingIndicator()
                } else {
                    self?.hideLoadingIndicator()
                }
            }
        }
    }
}
