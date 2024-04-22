//
//  InitialInfoViewModel.swift
//  Bould
//
//  Created by Naveen on 17/10/23.
//

import Foundation

class InitialInfoViewModel: BaseViewModel {
    
    var firstName: String?
    var lastName: String?
    var gender: String?
    var email: String?
    var birthDate: Date?
    var password: String?
    var confirmPassword: String?
    
    let genderOptions = Gender.allCases.map({$0.rawValue})
    
    func validateDetails(_ birthDate: Date?) -> Bool {
        
        guard let fName = firstName?.trimmed, !fName.isEmpty else {
            self.validationErrorMessage = AlertMessage.INVALID_FIRST_NAME
            return false
        }
        
        guard let lName = lastName?.trimmed, !lName.isEmpty else {
            self.validationErrorMessage = AlertMessage.INVALID_LAST_NAME
            return false
        }
        
        guard let gender = self.gender?.trimmed, !gender.isEmpty else {
            self.validationErrorMessage = AlertMessage.INVALID_GENDER
            return false
        }
        
        guard let emailId = self.email?.trimmed, !emailId.isEmpty else {
            self.validationErrorMessage = AlertMessage.EMPTY_EMAIL
            return false
        }
        
        guard let dob = birthDate, !Date().isSameDay(dob) else {
            self.validationErrorMessage = AlertMessage.INVALID_DOB
            return false
        }
        
        if !emailId.isValidEmail {
            self.validationErrorMessage = AlertMessage.INVALID_EMAIL
            return false
        }
        
        guard let enteredPassword = self.password, enteredPassword.count >= LimitCount.minimumPasswordLength else {
            let message = String(format: AlertMessage.NO_PASSWORD, LimitCount.minimumPasswordLength)
            self.validationErrorMessage = message
            return false
        }
        
        if enteredPassword != self.confirmPassword {
            self.validationErrorMessage = AlertMessage.MISMATCH_PASSWORD
            return false
        }
        
        self.firstName = fName
        self.lastName = lName
        self.gender = gender
        self.email = emailId
        self.birthDate = dob
        self.password = enteredPassword
        return true
    }
}


//MARK: Registration
extension InitialInfoViewModel {
    
    func registerUser(dob: Date?, successComplition: @escaping ((_ isEmailAlreadyExists: Bool) -> Void)) {
        guard validateDetails(dob), let birthDate = birthDate else {
            return
        }
        self.isLoading = true
        APIManager.shared.registerUser(
            firstName: firstName ?? "",
            lastName: lastName ?? "",
            dob: birthDate,
            gender: gender ?? "",
            email: email ?? "",
            password: password ?? ""
        ) { [weak self] error in
            
            DispatchQueue.main.async {
                self?.isLoading = false
                if let error = error as? NSError {
                    self?.errorMessage = error.localizedDescription
                    if error.code == 400 {
                        successComplition(true)
                    }
                    return
                }
                successComplition(false)
            }
        }
    }
}
