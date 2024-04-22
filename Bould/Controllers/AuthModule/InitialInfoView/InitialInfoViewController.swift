//
//  InitialInfoViewController.swift
//  Bould
//
//  Created by Jacob Marillion on 7/21/23.
//

import UIKit

class InitialInfoViewController: BaseViewController {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var genderTextField: BouldRoundedTextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var thirdLabel: UILabel!
    @IBOutlet weak var firstPasswordTextField: BouldRoundedTextField!
    @IBOutlet weak var secondPasswordTextField: BouldRoundedTextField!
    
    private var isGradientAdded: Bool = false
    private var pickerView = UIPickerView()
    
    private lazy var viewModel: InitialInfoViewModel = {
        let vwModel = InitialInfoViewModel()
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        /*_ = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { timer in
            self.firstNameTextField.becomeFirstResponder()
        }*/
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        //Set delegate
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        emailTextField.delegate = self
        firstPasswordTextField.delegate = self
        secondPasswordTextField.delegate = self
        
        setDummyData() //MARK: Testing Purpose - TODO - Remove before production ----
    }
    
    @IBAction func continueButtonPressed(_ sender: UIButton) {
        viewModel.registerUser(dob: datePicker.date) { [weak self] isEmailAlreadyExists in
            if isEmailAlreadyExists {
                self?.goToLoginVC()
            } else {
                self?.goToPhoneNumberVC()
            }
        }
    }
    
    private func setupLayout() {
        datePicker.setValue(UIColor.lightGray, forKey: "textColor")
        datePicker.maximumDate = Calendar.current.date(byAdding: .year, value: -18, to: Date())
        datePicker.minimumDate = Calendar.current.date(byAdding: .year, value: -111, to: Date())
        
        firstNameTextField.attributedPlaceholder = NSAttributedString(string: "FIRST NAME", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white.withAlphaComponent(0.4)])
        lastNameTextField.attributedPlaceholder = NSAttributedString(string: "LAST NAME", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white.withAlphaComponent(0.4)])
        genderTextField.attributedPlaceholder = NSAttributedString(string: "GENDER", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white.withAlphaComponent(0.4)])
        emailTextField.attributedPlaceholder = NSAttributedString(string: "EMAIL", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white.withAlphaComponent(0.4)])
        firstPasswordTextField.attributedPlaceholder = NSAttributedString(string: "PASSWORD", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white.withAlphaComponent(0.4)])
        secondPasswordTextField.attributedPlaceholder = NSAttributedString(string: "CONFIRM PASSWORD", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white.withAlphaComponent(0.4)])
        
        firstLabel.font = UIFont(name: Fonts.brunoAceRegular, size: 14)
        secondLabel.font = UIFont(name: Fonts.brunoAceRegular, size: 12)
        thirdLabel.font = UIFont(name: Fonts.brunoAceRegular, size: 9)
        
        firstNameTextField.font = UIFont(name: Fonts.brunoAceRegular, size: 12)
        lastNameTextField.font = UIFont(name: Fonts.brunoAceRegular, size: 12)
        genderTextField.font = UIFont(name: Fonts.brunoAceRegular, size: 12)
        emailTextField.font = UIFont(name: Fonts.brunoAceRegular, size: 12)
        firstPasswordTextField.font = UIFont(name: Fonts.brunoAceRegular, size: 12)
        secondPasswordTextField.font = UIFont(name: Fonts.brunoAceRegular, size: 12)
        
        continueButton.layer.cornerRadius = 7
        continueButton.titleLabel?.font = UIFont(name: Fonts.brunoAceRegular, size: 14)
        
        pickerView.delegate = self
        pickerView.backgroundColor = UIColor(rgba: "#1E1E1E")
        pickerView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        genderTextField.inputView = pickerView
        genderTextField.keyboardToolbar.backgroundColor = .black
        genderTextField.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(self.btnDoneTap(_:)))
        
        navigationController?.navigationBar.tintColor = .lightGray
    }
    
    private func goToPhoneNumberVC() {
        DispatchQueue.main.async {
            guard let vc = Storyboard.Auth.instantiateVC(type: PhoneNumberViewController.self) else {
                return
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    private func goToLoginVC() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            guard let vc = Storyboard.Auth.instantiateVC(type: LogInViewController.self) else {
                return
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
} //End of class


//MARK: Confirm to UITextFieldDelegate
extension InitialInfoViewController: UITextFieldDelegate {
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        self.setViewModelData(textField, textField.text)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text as NSString? {
            let finalText = text.replacingCharacters(in: range, with: string)
            self.setViewModelData(textField, finalText)
        }
        return true
    }
    
    private func setViewModelData(_ textField: UITextField, _ text: String?) {
        switch textField {
        case firstNameTextField:
            viewModel.firstName = text ?? textField.text
        case lastNameTextField:
            viewModel.lastName = text ?? textField.text
        case emailTextField:
            viewModel.email = text ?? textField.text
        case firstPasswordTextField:
            viewModel.password = text ?? textField.text
        case secondPasswordTextField:
            viewModel.confirmPassword = text ?? textField.text
        default: break
        }
    }
}


//MARK: Confirm to UIPickerViewDataSource, UIPickerViewDelegate
extension InitialInfoViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        viewModel.genderOptions.count
    }
    
    /*func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return viewModel.genderOptions[row]
    }*/
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: viewModel.genderOptions[row], attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let gender = viewModel.genderOptions[row]
        genderTextField.text = gender
        viewModel.gender = gender
    }
    
    @objc private func btnDoneTap(_ sender: Any) {
        guard let textField = sender as? UITextField else { return }
        switch textField {
        case genderTextField:
            if (viewModel.gender == nil) || (viewModel.gender?.isEmpty == true) {
                genderTextField.text = viewModel.genderOptions[0]
                viewModel.gender = viewModel.genderOptions[0]
            }
            genderTextField.resignFirstResponder()
        default: break
        }
    }
}


//MARK: Testing Purpose - TODO - Remove before production
extension InitialInfoViewController {
    
    private func setDummyData() {
        firstNameTextField.text = "Test"
        lastNameTextField.text = "User"
        emailTextField.text = "testuser@yopmail.com"
        firstPasswordTextField.text = "123456"
        secondPasswordTextField.text = "123456"
        
        viewModel.firstName = firstNameTextField.text
        viewModel.lastName = lastNameTextField.text
        viewModel.email = emailTextField.text
        viewModel.password = firstPasswordTextField.text
        viewModel.confirmPassword = secondPasswordTextField.text
    }
}
