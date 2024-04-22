//
//  BaseViewModel.swift
//  Bould
//
//  Created by Naveen on 17/10/23.
//

import Foundation

class BaseViewModel: NSObject {

    var isLoading: Bool = false {
        didSet {
            self.updateLoadingStatus?(isLoading)
        }
    }
    
    var errorMessage: String? {
        didSet {
            self.showAlertClosure?(true)
        }
    }
    
    var validationErrorMessage: String? {
        didSet {
            self.showValidationErrorClosure?()
        }
    }

    var showAlertClosure: ((_ isError: Bool)->())?
    var showValidationErrorClosure: (()->())?
    var updateLoadingStatus: ((_ show: Bool)->())?
    var reloadTableViewClosure: (()->())?
}
