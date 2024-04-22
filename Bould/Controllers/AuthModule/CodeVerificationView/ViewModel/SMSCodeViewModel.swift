
import UIKit

class SMSCodeViewModel: BaseViewModel {
    
    var countryCode: String?
    var phoneNumber: String?
    var clearOTPFields: CompletionVoid?
    
    func validateData(first: String?, second: String?, third: String?, fourth: String?, fifth: String?, sixth: String?) -> String? {
        
        guard let first = first?.trimmed, !first.isEmpty,
              let second = second?.trimmed, !second.isEmpty,
              let third = third?.trimmed, !third.isEmpty,
              let fourth = fourth?.trimmed, !fourth.isEmpty,
              let fifth = fifth?.trimmed, !fifth.isEmpty,
              let sixth = sixth?.trimmed, !sixth.isEmpty else {
            self.clearOTPFields?()
            self.validationErrorMessage = AlertMessage.MISSING_OTP
            return nil
        }
        let enteredCode = first + second + third + fourth + fifth + sixth
        guard enteredCode.isNumeric else {
            self.clearOTPFields?()
            self.validationErrorMessage = AlertMessage.INVALID_OTP
            return nil
        }
        return enteredCode
    }
}


//MARK: Verify Phone Number
extension SMSCodeViewModel {
    
    func verifyOTP(_ enteredOTP: String?, successComplition: @escaping CompletionVoid) {
        guard let enteredCode = enteredOTP else {
            return
        }
        self.isLoading = true
        
        APIManager.shared.verifyOTP(enteredCode) { [weak self] error in
            DispatchQueue.main.async {
                self?.clearOTPFields?()
                self?.isLoading = false
                
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                    return
                }
                AppInstance.shared.userProfile?.isPhoneNoVerified = true
                successComplition()
            }
        }
    }
}


//MARK: Resend OTP
extension SMSCodeViewModel {
    
    func resendOTP(goBackComplition: CompletionVoid?) {
        guard let _countryCode = countryCode, let _phoneNumber = phoneNumber else {
            goBackComplition?()
            return
        }
        self.isLoading = true
        
        APIManager.shared.phoneVerification(_phoneNumber, countryCode: _countryCode) { [weak self] error in
            DispatchQueue.main.async {
                self?.clearOTPFields?()
                self?.isLoading = false
                
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                    return
                }
                UIAlertController.showAlert(
                    nil,
                    title: Strings.otpReSent,
                    message: String(format: AlertMessage.PHONE_OTP_RESEND, Utility.securePhoneNumber(_phoneNumber))
                )
            }
        }
    }
}
