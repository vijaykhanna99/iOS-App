//
//  SMSCodeViewController.swift
//  Bould
//
//  Created by Jacob Marillion on 7/21/23.
//

import UIKit

class SMSCodeViewController: BaseViewController {
    
    @IBOutlet weak var firstNumberTextField: BouldTextField!
    @IBOutlet weak var secondNumberTextField: BouldTextField!
    @IBOutlet weak var thirdNumberTextField: BouldTextField!
    @IBOutlet weak var fourthNumberTextField: BouldTextField!
    @IBOutlet weak var fifthNumberTextField: BouldTextField!
    @IBOutlet weak var sixthNumberTextField: BouldTextField!
    
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var goBackButton: UIButton!
    //In case user directly navigate from LaunchScreen
    var isVerifyPhoneNoOnly: Bool = false
    private var isGradientAdded: Bool = false
    
    lazy var viewModel: SMSCodeViewModel = {
        let vwModel = SMSCodeViewModel()
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
        setupLayout()
        //Set delegates
        firstNumberTextField.delegate = self
        secondNumberTextField.delegate = self
        thirdNumberTextField.delegate = self
        fourthNumberTextField.delegate = self
        
        _ = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { timer in
            self.firstNumberTextField.becomeFirstResponder()
        }
        
        viewModel.clearOTPFields = { [weak self] in
            DispatchQueue.main.async {
                self?.firstNumberTextField.text = ""
                self?.secondNumberTextField.text = ""
                self?.thirdNumberTextField.text = ""
                self?.fourthNumberTextField.text = ""
                self?.fifthNumberTextField.text = ""
                self?.sixthNumberTextField.text = ""
            }
        }
    }
    
    
    //MARK: - Helper Functions
    @IBAction func goBackButtonPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func resendButtonPressed(_ sender: UIButton) {
        viewModel.resendOTP { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    //MARK: Textfields Functionalities
    @IBAction func firstNumberTextFieldEditingDidBegin(_ sender: Any) {
        firstNumberTextField.selectAll(nil)
    }
    
    @IBAction func firstNumberTextFieldChanged(_ sender: Any) {
        if firstNumberTextField.text?.count == 1 {
            secondNumberTextField.becomeFirstResponder()
            secondNumberTextField.selectAll(nil)
        }
    }
    
    @IBAction func secondNumberTextFieldEditingDidBegin(_ sender: Any) {
        secondNumberTextField.selectAll(nil)
    }
    
    @IBAction func secondNumberTextFieldChanged(_ sender: Any) {
        if secondNumberTextField.text?.count == 1 {
            thirdNumberTextField.becomeFirstResponder()
            thirdNumberTextField.selectAll(nil)
        }
    }
    
    @IBAction func thirdNumberTextFieldEditingDidBegin(_ sender: Any) {
        thirdNumberTextField.selectAll(nil)
    }
    
    @IBAction func thirdNumberTextFieldChanged(_ sender: Any) {
        if thirdNumberTextField.text?.count == 1 {
            fourthNumberTextField.becomeFirstResponder()
            fourthNumberTextField.selectAll(nil)
        }
    }
    
    @IBAction func fourthNumberTextFieldEditingDidBegin(_ sender: Any) {
        fourthNumberTextField.selectAll(nil)
    }
    
    @IBAction func fourthNumberTextFieldChanged(_ sender: Any) {
        if fourthNumberTextField.text?.count == 1 {
            //fourthNumberTextField.resignFirstResponder()
            fifthNumberTextField.becomeFirstResponder()
            fifthNumberTextField.selectAll(nil)
        }
    }
    
    @IBAction func fifthNumberTextFieldEditingDidBegin(_ sender: Any) {
        fifthNumberTextField.selectAll(nil)
    }
    
    @IBAction func fifthNumberTextFieldChanged(_ sender: Any) {
        if fifthNumberTextField.text?.count == 1 {
            sixthNumberTextField.becomeFirstResponder()
            sixthNumberTextField.selectAll(nil)
        }
    }
    
    @IBAction func sixthNumberTextFieldEditingDidBegin(_ sender: Any) {
        sixthNumberTextField.selectAll(nil)
    }
    
    @IBAction func sixthNumberTextFieldChanged(_ sender: Any) {
        if sixthNumberTextField.text?.count == 1 {
            sixthNumberTextField.resignFirstResponder()
        }
    }
    
    
    @IBAction func continueButtonPressed(_ sender: UIButton) {
        self.verifyOTP()
    }
    
    
    private func setupLayout() {
        for textfield in [firstNumberTextField, secondNumberTextField, thirdNumberTextField, fourthNumberTextField, fifthNumberTextField, sixthNumberTextField] {
            
            textfield?.attributedPlaceholder = NSAttributedString(string: "0", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white.withAlphaComponent(0.4)])
            
            textfield?.font = UIFont(name: Fonts.brunoAceRegular, size: 22)
        }
        firstLabel.font = UIFont(name: Fonts.brunoAceRegular, size: 14)
        continueButton.layer.cornerRadius = 7
        continueButton.titleLabel?.font = UIFont(name: Fonts.brunoAceRegular, size: 14)
        goBackButton.titleLabel?.font = UIFont(name: Fonts.brunoAceRegular, size: 12)
        
        navigationController?.navigationBar.tintColor = .lightGray
    }
    
    private func verifyOTP() {
        guard let enteredOTP = viewModel.validateData(
            first: firstNumberTextField.text,
            second: secondNumberTextField.text,
            third: thirdNumberTextField.text,
            fourth: fourthNumberTextField.text,
            fifth: fifthNumberTextField.text,
            sixth: sixthNumberTextField.text) else {
            return
        }
        //Now verify entered Code
        viewModel.verifyOTP(enteredOTP) { [weak self] in
            DispatchQueue.main.async {
                self?.handleNavigation()
            }
        }
    }
    
    private func handleNavigation() {
        if isVerifyPhoneNoOnly {
            SceneDelegate.sceneDelegate?.updateRootController()
            return
        }
        guard let vc = Storyboard.Scanning.instantiateVC(type: ScanAccessViewController.self) else {
            return
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
} //End of class


//MARK: Confirm to UITextFieldDelegate
extension SMSCodeViewController: UITextFieldDelegate {
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if !string.isEmpty, Int(string) == nil {
            return false
        }
        return true
    }
}
