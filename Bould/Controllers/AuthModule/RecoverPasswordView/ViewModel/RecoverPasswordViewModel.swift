import Foundation

class RecoverPasswordViewModel: BaseViewModel {
    var email: String?
    
    func validateDetails() -> Bool {
        guard let emailId = self.email?.trimmed, !emailId.isEmpty else {
            self.validationErrorMessage = AlertMessage.EMPTY_EMAIL
            return false
        }
        if !emailId.isValidEmail {
            self.validationErrorMessage = AlertMessage.INVALID_EMAIL
            return false
        }
        self.email = emailId
        return true
    }
    
    func recoverUserPassword(successComplition: @escaping CompletionVoid) {
        guard validateDetails() else {
            return
        }
        self.isLoading = true
        APIManager.shared.forgotPassword(email: email ?? "") { [weak self] error in
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
