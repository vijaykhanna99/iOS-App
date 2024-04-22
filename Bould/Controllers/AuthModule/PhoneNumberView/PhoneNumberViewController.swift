//
//  EnterPhoneNumberViewController.swift
//  Bould
//
//  Created by Jacob Marillion on 7/21/23.
//

import UIKit
import CountryPickerView

class PhoneNumberViewController: BaseViewController {
    
    @IBOutlet weak var phoneContainerView: UIView!
    @IBOutlet weak var cpv: CountryPickerView!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var thirdLabel: UILabel!
    //In case user directly navigate from LaunchScreen
    var isVerifyPhoneNoOnly: Bool = false
    private var isGradientAdded: Bool = false
    
    private lazy var viewModel: PhoneNumberViewModel = {
        let vwModel = PhoneNumberViewModel()
        self.baseVwModel = vwModel
        return vwModel
    }()
    
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait  // Return the allowed orientation(s) for this view controller
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if !isGradientAdded {
            isGradientAdded.toggle()
            view.addGradient()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cpv.delegate = self
        cpv.dataSource = self
        phoneNumberTextField.delegate = self
        setupLayout()
        
        _ = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { timer in
            self.phoneNumberTextField.becomeFirstResponder()
        }
        //MARK: Testing Purpose - TODO - Remove before production ----
        phoneNumberTextField.text = "9876543210"
        viewModel.phoneNumber = phoneNumberTextField.text
    }

    //MARK: - Helper Functions
    @IBAction func continueButtonPressed(_ sender: UIButton) {
        viewModel.verifyPhoneNumber(cpv.selectedCountry.phoneCode) { [weak self] in
            DispatchQueue.main.async {
                self?.goToOTPVerificationScreen()
            }
        }
    }
    
    
    private func setupLayout() {
        phoneContainerView.layer.cornerRadius = phoneContainerView.frame.size.height / 2
        phoneContainerView.clipsToBounds = true
        phoneContainerView.layer.borderWidth = 2
        phoneContainerView.layer.borderColor = UIColor.gray.withAlphaComponent(0.15).cgColor
        
        phoneNumberTextField.borderStyle = .none
        
        cpv.textColor = .white
        cpv.flagSpacingInView = 4
        cpv.font = UIFont(name: Fonts.brunoAceRegular, size: 13) ?? .systemFont(ofSize: 13)
        //MARK: - TODO - Uncomment line below?
        //cpv.showCountryCodeInView = false
        
        firstLabel.font = UIFont(name: Fonts.brunoAceRegular, size: 15)
        secondLabel.font = UIFont(name: Fonts.brunoAceRegular, size: 11)
        thirdLabel.font = UIFont(name: Fonts.brunoAceRegular, size: 9)
        phoneNumberTextField.font = UIFont(name: Fonts.brunoAceRegular, size: 13)
        
        continueButton.layer.cornerRadius = 7
        continueButton.titleLabel?.font = UIFont(name: Fonts.brunoAceRegular, size: 14)
        
        navigationController?.navigationBar.tintColor = .lightGray
    }
    
    private func goToOTPVerificationScreen() {
        let message = String(format: AlertMessage.PHONE_OTP_VERIFICATION, Utility.securePhoneNumber(viewModel.phoneNumber))
        
        UIAlertController.showAlert(title: Strings.otpSent, message: message, actions: .OK) { [weak self] _ in
            guard let vc = Storyboard.Auth.instantiateVC(type: SMSCodeViewController.self) else {
                return
            }
            vc.viewModel.countryCode = self?.viewModel.countryCode
            vc.viewModel.phoneNumber = self?.viewModel.phoneNumber
            vc.isVerifyPhoneNoOnly = self?.isVerifyPhoneNoOnly ?? false
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
} //End of class


//MARK: - Country Picker View Handling
extension PhoneNumberViewController: CountryPickerViewDelegate, CountryPickerViewDataSource {
    
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
    }
    
    func preferredCountries(in countryPickerView: CountryPickerView) -> [Country] {
        guard let country1 = countryPickerView.getCountryByCode("US"),
              let country2 = countryPickerView.getCountryByCode("CA") else { return [] }
        return [country1, country2]
    }
    
    func sectionTitleForPreferredCountries(in countryPickerView: CountryPickerView) -> String? {
        "Suggested:"
    }
    
} //End of extension


//MARK: Confirm to UITextFieldDelegate
extension PhoneNumberViewController: UITextFieldDelegate {
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        self.setViewModelData(textField, textField.text)
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
         if let text = textField.text as NSString? {
            let finalText = text.replacingCharacters(in: range, with: string)
            self.setViewModelData(textField, finalText)
        }
        return true
    }
    
    private func setViewModelData(_ textField: UITextField, _ text: String?) {
        if textField == phoneNumberTextField {
            viewModel.phoneNumber = text ?? textField.text
        }
    }
}
