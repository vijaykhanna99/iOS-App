//
//  RecoverPasswordViewController.swift
//  Bould
//
//  Created by Jacob Marillion on 7/24/23.
//

import UIKit

class RecoverPasswordViewController: BaseViewController {
    //MARK: - Outlets
    @IBOutlet weak var emailTextField: BouldRoundedTextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var firstLabel: UILabel!
    private var isGradientAdded: Bool = false
    
    lazy var viewModel: RecoverPasswordViewModel = {
        let vwModel = RecoverPasswordViewModel()
        self.baseVwModel = vwModel
        return vwModel
    }()
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait  // Return the allowed orientation(s) for this view controller
    }
    
    //MARK: - Lifecycle Functions
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
        setupLayout()
        _ = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { timer in
            self.emailTextField.becomeFirstResponder()
        }
        if let emailId = viewModel.email {
            emailTextField.text = emailId
        }
    }
    
    //MARK: - Helper Functions
    @IBAction func continueButtonPressed(_ sender: UIButton) {
        viewModel.recoverUserPassword { [weak self] in
            DispatchQueue.main.async {
                UIAlertController.showAlert(self,
                                            title: Strings.emailSent,
                                            message: AlertMessage.PASS_RESET_EMAIL_SENT, actions: .OK) { _ in
                    self?.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    private func setupLayout() {
        emailTextField.attributedPlaceholder = NSAttributedString(string: "EMAIL", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white.withAlphaComponent(0.4)])
        emailTextField.font = UIFont(name: Fonts.brunoAceRegular, size: 13)

        firstLabel.font = UIFont(name: Fonts.brunoAceRegular, size: 14)
        sendButton.titleLabel?.font = UIFont(name: Fonts.brunoAceRegular, size: 14)
        sendButton.layer.cornerRadius = 7
        
        navigationController?.navigationBar.tintColor = .lightGray
    }
    
} //End of class


//MARK: Confirm to UITextFieldDelegate
extension RecoverPasswordViewController: UITextFieldDelegate {
    
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
        default: break
        }
    }
}
