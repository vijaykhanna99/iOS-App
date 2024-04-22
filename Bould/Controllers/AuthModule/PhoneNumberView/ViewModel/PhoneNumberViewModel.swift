//
//  PhoneNumberViewModel.swift
//  Bould
//
//  Created by Naveen on 17/10/23.
//

import Foundation

class PhoneNumberViewModel: BaseViewModel {
    
    var countryCode: String?
    var phoneNumber: String?
    
    func validateData(_ countryCode: String?) -> Bool {
        guard let code = countryCode?.trimmed, !code.isEmpty else {
            self.validationErrorMessage = AlertMessage.INVALID_COUNTRY_CODE
            return false
        }
        guard let phoneNo = phoneNumber?.trimmed,
              phoneNo.isNumeric,
              phoneNo.count >= LimitCount.minimumPhoneNoLength  else {
            self.validationErrorMessage = AlertMessage.INVALID_PHONE_NUMBER
            return false
        }
        self.countryCode = code
        self.phoneNumber = phoneNo
        return true
    }
}


//MARK: Verify Phone Number
extension PhoneNumberViewModel {
    
    func verifyPhoneNumber(_ countryCode: String?, successComplition: @escaping CompletionVoid) {
        guard validateData(countryCode) else {
            return
        }
        self.isLoading = true
        
        APIManager.shared.phoneVerification(phoneNumber ?? "", countryCode: countryCode ?? "") { [weak self] error in
            DispatchQueue.main.async {
                self?.isLoading = false
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                    return
                }
                successComplition()
            }
        }
    }
}
