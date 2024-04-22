import UIKit

class SettingsViewModel: BaseViewModel {
    var name: String?
    var email: String?
    var phoneNumber: String?
    var address: String?
    
    var profileImage: UIImage?
    var selectedImage: UIImage?
    
    func fetchUserDetails() {
        guard let profile = AppInstance.shared.userProfile else {
            return
        }
        name = profile.name ?? ""
        email = profile.email
        phoneNumber = profile.phoneNumber
        //address = profile.address
        //profileImage = profile.profilePicture
        self.reloadTableViewClosure?()
    }
}


//MARK: Update Details
extension SettingsViewModel {
    
    func updateEmail(_ email: String?, complition: CompletionVoid? = nil) {
        guard let email = email?.trimmed, !email.isEmpty else {
            self.validationErrorMessage = AlertMessage.EMPTY_EMAIL
            return
        }
        guard email.isValidEmail else {
            self.validationErrorMessage = AlertMessage.INVALID_EMAIL
            return
        }
        self.email = email
        complition?()
    }
    
    func updatePassword(oldPassword: String?, newPassword: String?, confirmPassword: String?, complition: CompletionVoid? = nil) {
        guard let oldPassword = oldPassword,
              let newPassword = newPassword,
              let confirmPassword = confirmPassword,
              oldPassword.count >= LimitCount.minimumPasswordLength,
              newPassword.count >= LimitCount.minimumPasswordLength else {
            
            let message = String(format: AlertMessage.NO_PASSWORD, LimitCount.minimumPasswordLength)
            self.validationErrorMessage = message
            return
        }
        
        if newPassword != confirmPassword {
            self.validationErrorMessage = AlertMessage.MISMATCH_PASSWORD
            return
        }
        
        complition?()
    }
    
    func updateAddress(_ address: String?, complition: CompletionVoid? = nil) {
        guard let address = address?.trimmed, !address.isEmpty else {
            self.validationErrorMessage = AlertMessage.INVALID_ADDRESS
            return
        }
        
        self.address = address
        complition?()
    }
}
