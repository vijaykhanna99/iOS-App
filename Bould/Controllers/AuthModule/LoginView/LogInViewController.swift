//
//  LogInViewController.swift
//  Bould
//
//  Created by Jacob Marillion on 7/24/23.
//

import UIKit

class LogInViewController: BaseViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var recoverPasswordButton: UIButton!
    private var isGradientAdded: Bool = false
    
    lazy var viewModel: LogInViewModel = {
        let vwModel = LogInViewModel()
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
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        setupLayout()
        setDummyData() //MARK: Testing Purpose - TODO - Remove before production ----
        _ = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { timer in
            self.emailTextField.becomeFirstResponder()
        }
    }

    //MARK: - Helper Functions
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        logInUser()
    }
    
    @IBAction func recoverPasswordButtonPressed(_ sender: Any) {
        guard let vc = Storyboard.Auth.instantiateVC(type: RecoverPasswordViewController.self) else {
            return
        }
        //If user email is valid then forward to next recover password screen
        if let emailId = viewModel.email?.trimmed, !emailId.isEmpty, emailId.isValidEmail {
            vc.viewModel.email = emailId
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func setupLayout() {
        emailTextField.attributedPlaceholder = NSAttributedString(string: "EMAIL", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white.withAlphaComponent(0.4)])
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "PASSWORD", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white.withAlphaComponent(0.4)])
        
        emailTextField.font = UIFont(name: Fonts.brunoAceRegular, size: 13)
        passwordTextField.font = UIFont(name: Fonts.brunoAceRegular, size: 13)
        recoverPasswordButton.titleLabel?.font = UIFont(name: Fonts.brunoAceRegular, size: 12)
        
        loginButton.titleLabel?.font = UIFont(name: Fonts.brunoAceRegular, size: 14)
        loginButton.layer.cornerRadius = 7
        
        navigationController?.navigationBar.tintColor = .lightGray
    }
    
    private func logInUser() {
        viewModel.logInUser { [weak self] isSuccess in
            DispatchQueue.main.async {
                self?.resetTextFields()
                guard isSuccess else {
                    return
                }
                if APIManager.shared.isLoggedIn() {
                    SceneDelegate.sceneDelegate?.updateRootController()
                }
            }
        }
    }
    
    private func resetTextFields() {
        viewModel.email = ""
        viewModel.password = ""
        emailTextField.text = ""
        passwordTextField.text = ""
    }
} //End of class


//MARK: Confirm to UITextFieldDelegate
extension LogInViewController: UITextFieldDelegate {
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        self.updateVMData(textField, textField.text)
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
         if let text = textField.text as NSString? {
            let finalText = text.replacingCharacters(in: range, with: string)
            self.updateVMData(textField, finalText)
        }
        return true
    }
    
    private func updateVMData(_ textField: UITextField, _ text: String?) {
        switch textField {
        case emailTextField:
            viewModel.email = text ?? textField.text
        case passwordTextField:
            viewModel.password = text ?? textField.text
        default: break
        }
    }
}


//MARK: Testing Purpose - TODO - Remove before production
extension LogInViewController {
    
    private func setDummyData() {
        emailTextField.text = "user6@yopmail.com" //"testuser4@yopmail.com"
        passwordTextField.text = "123456" //testuser@1"
        
        viewModel.email = emailTextField.text
        viewModel.password = passwordTextField.text
    }
}
