import Foundation

class LogInViewModel: BaseViewModel {
    
    var email: String?
    var password: String?
    
    func validateData() -> Bool {
        
        guard let emailId = self.email?.trimmed, !emailId.isEmpty else {
            self.validationErrorMessage = AlertMessage.EMPTY_EMAIL
            return false
        }
        if !emailId.isValidEmail {
            self.validationErrorMessage = AlertMessage.INVALID_EMAIL
            return false
        }
        guard let enteredPassword = self.password,
              enteredPassword.count >= LimitCount.minimumPasswordLength else {
            
            let message = String(format: AlertMessage.NO_PASSWORD, LimitCount.minimumPasswordLength)
            self.validationErrorMessage = message
            return false
        }
        self.email = emailId
        self.password = enteredPassword
        return true
    }
    
    func logInUser(complition: @escaping CompletionBool) {
        guard validateData() else {
            return
        }
        self.isLoading = true
        APIManager.shared.loginUser(
            email: self.email ?? "",
            password: self.password ?? ""
        ) { [weak self] error in
            
            if let error = error {
                DispatchQueue.main.async {
                    self?.isLoading = false
                    self?.errorMessage = error.localizedDescription
                    complition(false)
                }
                return
            }
            self?.fetchUserProfile(complition: complition)
        }
    }
    
    private func fetchUserProfile(complition: @escaping CompletionBool) {
        APIManager.shared.fetchUserProfile { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                    
                case .success(let profile):
                    UserDefaults.emailId = self?.email
                    UserDefaults.password = self?.password
                    AppInstance.shared.userProfile = profile
                    complition(true)
                    
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    complition(false)
                }
            }
        }
    }
}
