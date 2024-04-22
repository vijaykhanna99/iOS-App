import UIKit


class ProfileSettingsViewModel: BaseViewModel {
    //Minimum age required for register user.
    private let minimumUserAge: Int = 13
    private let maximumUserAge: Int = 80
    
    //DOB related properties
    var selectedDay: Int?
    var selectedMonth: Int?
    var selectedYear: Int?
    var selectedPickerOption: DatePickerOption = .Month
    
    //User profile properties
    var fullName: String?
    var gender: String?
    var email: String?
    var countryCode: String?
    var phoneNumber: String?
    var profileImageURL: String?
    
    //var isImageChange: Bool = false
    var country: String?
    var selectedImage: UIImage?
    let genderOptions = Gender.allCases.map({$0.rawValue})
    
    
    private func setUserProfileData(_ profile: UserProfile) {
        fullName = profile.name
        email = profile.email
        gender = profile.gender?.rawValue
        country = profile.address?.country
        countryCode = profile.countryCode
        phoneNumber = profile.phoneNumber
        profileImageURL = profile.profilePicture
        
        if let dobString = profile.dateOfBirth,
           let dob = Date.dateFromString(dobString, format: DateFormats.yyyy_MM_dd) {
            selectedDay = dob.getDateComponent(.day)
            selectedMonth = dob.getDateComponent(.month)
            selectedYear = dob.getDateComponent(.year)
        }
        //Now reload date to screen view
        reloadTableViewClosure?()
    }
    
    private func validateDetails() -> UserProfile? {
        
        guard let nameComponents = fullName?.trimmed.components(separatedBy: " "),
                nameComponents.count >= 2 else {
            self.validationErrorMessage = AlertMessage.INVALID_NAME
            return nil
        }
        
        guard let email = email?.trimmed, !email.isEmpty else {
            self.validationErrorMessage = AlertMessage.EMPTY_EMAIL
            return nil
        }
        
        if !email.isValidEmail {
            self.validationErrorMessage = AlertMessage.INVALID_EMAIL
            return nil
        }
        
        guard let code = countryCode?.trimmed, !code.isEmpty else {
            self.validationErrorMessage = AlertMessage.INVALID_COUNTRY_CODE
            return nil
        }
        
        guard let phoneNo = phoneNumber?.trimmed,
              phoneNo.isNumeric,
              phoneNo.count >= LimitCount.minimumPhoneNoLength  else {
            self.validationErrorMessage = AlertMessage.INVALID_PHONE_NUMBER
            return nil
        }
        
        guard let dobDay = selectedDay, let dobMonth = selectedMonth, let dobYear = selectedYear else {
            self.validationErrorMessage = AlertMessage.INVALID_DOB
            return nil
        }
        
        guard let genderString = gender?.trimmed, !genderString.isEmpty,
              let gender = Gender(rawValue: genderString) else {
            self.validationErrorMessage = AlertMessage.INVALID_GENDER
            return nil
        }
        //MARK: Comment below Code if profile picture is not mandatory
        guard (selectedImage != nil) || (profileImageURL != nil) else {
            validationErrorMessage = AlertMessage.EMPTY_IMAGE_FIELD
            return nil
        }
        
        var lastName = ""
        for (index, word) in nameComponents.enumerated() {
            if index != 0 {
                lastName += " \(word)"
            }
        }
        let dateOfBirth = "\(dobMonth)/\(dobDay)/\(dobYear)" //04/20/2010"
        
        return UserProfile(firstName: nameComponents[0], lastName: lastName, email: email, gender: gender, dateOfBirth: dateOfBirth, countryCode: code, phoneNumber: phoneNo)
    }
}


//MARK: Custom DOB picker functionalities
extension ProfileSettingsViewModel {
    
    func selectedMonthType() -> MonthPickerOption? {
        if let _selectedMonth = selectedMonth {
            return MonthPickerOption(rawValue: _selectedMonth)
        }
        return nil
    }
    
    func dayPickerOptions() -> [Int] {
        let totalDays = selectedMonthType()?.numberOfDays() ?? 31
        return Array(1...totalDays)
    }
    
    func yearPickerOptions() -> [Int] {
        let maximumYear = Date.getPreviousYearByDifference(minimumUserAge)
        let minimumYear = maximumYear - maximumUserAge
        return Array(minimumYear...maximumYear)
    }
    
    func datePickerDataArray() -> [String] {
        switch selectedPickerOption {
        case .Day:
            return dayPickerOptions().map({ "\($0)" })
        case .Month:
            return MonthPickerOption.allCases.map({ $0.title })
        case .Year:
            return yearPickerOptions().map({ "\($0)" })
        }
    }
}


//MARK: Fetch User Profile
extension ProfileSettingsViewModel {
    
    func fetchUserProfile(isReload: Bool = false) {
        if !isReload, let profile = AppInstance.shared.userProfile {
            setUserProfileData(profile)
        } else {
            fetchProfileFromServer()
        }
    }
    
    private func fetchProfileFromServer() {
        guard APIManager.shared.isLoggedIn() else {
            return
        }
        isLoading = true
        APIManager.shared.fetchUserProfile { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                    
                case .success(let profile):
                    AppInstance.shared.userProfile = profile
                    if let _profile = profile {
                        self?.setUserProfileData(_profile)
                    }
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
}


//MARK: Update User Profile
extension ProfileSettingsViewModel {
    
    func updateUserProfile(countryCode: String?, successComplition: @escaping CompletionVoid) {
        self.countryCode = countryCode
        guard APIManager.shared.isLoggedIn(), let profile = validateDetails() else {
            return
        }
        isLoading = true
        APIManager.shared.updateUserProfile(profile, image: selectedImage) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let profile):
                    AppInstance.shared.userProfile = profile
                    successComplition()
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
