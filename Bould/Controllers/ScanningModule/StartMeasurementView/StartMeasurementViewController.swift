import UIKit


class StartMeasurementViewController: UIViewController {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    
    @IBOutlet weak var oneLabel: UILabel!
    @IBOutlet weak var heightFeetTextField: UITextField!
    @IBOutlet weak var ftFormatLabel: UILabel!
    
    @IBOutlet weak var twoLabel: UILabel!
    @IBOutlet weak var heightInchesTextField: UITextField!
    @IBOutlet weak var inFormatLabel: UILabel!
    
    @IBOutlet weak var startButton: UIButton!
    
    var shouldNavBarShow: Bool = false
    private let maxHeightDigitCount: Int = 2
    private var userHeight: Double?
    private var isGradientAdded: Bool = false
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if !isGradientAdded {
            isGradientAdded.toggle()
            view.addGradient()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addBackButton()
        setupLayout()
        heightFeetTextField.delegate = self
        heightInchesTextField.delegate = self
        //MARK: Testing Purpose - TODO - Remove before production ----
        heightFeetTextField.text = "5"
        heightInchesTextField.text = "9"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(!shouldNavBarShow, animated: true)
        navigationController?.navigationBar.tintColor = .lightGray
    }
    
    @IBAction func startButtonPressed(_ sender: Any) {
        goToScanningForModelScreen()
    }
    
    private func setupLayout() {
        titleLabel.font = UIFont(name: Fonts.brunoAceRegular, size: 15)
        descriptionLabel.font = UIFont(name: Fonts.brunoAceRegular, size: 11)
        titleLabel.font = UIFont(name: Fonts.brunoAceRegular, size: 15)
        heightLabel.font = UIFont(name: Fonts.brunoAceRegular, size: 12)
        
        ftFormatLabel.font = UIFont(name: Fonts.brunoAceRegular, size: 12)
        inFormatLabel.font = UIFont(name: Fonts.brunoAceRegular, size: 12)
        heightFeetTextField.font = UIFont(name: Fonts.brunoAceRegular, size: 12)
        heightInchesTextField.font = UIFont(name: Fonts.brunoAceRegular, size: 12)
        
        startButton.layer.cornerRadius = 7
        startButton.titleLabel?.font = UIFont(name: Fonts.brunoAceRegular, size: 14)
        [oneLabel, twoLabel].forEach { label in
            label?.makeCircularLabel()
            label?.font = UIFont(name: Fonts.brunoAceRegular, size: 12)
        }
        
        heightFeetTextField.attributedPlaceholder = NSAttributedString(
            string: Strings.feet,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        )
        heightInchesTextField.attributedPlaceholder = NSAttributedString(
            string: Strings.inches,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        )
    }
    
    private func heightInCentimeters(feet: Double, inches: Double) -> Double {
        // Convert feet to centimeters
        let feetInCentimeters = feet * 30.48
        // Convert inches to centimeters
        let inchesInCentimeters = inches * 2.54
        // Calculate total height in centimeters
        return (feetInCentimeters + inchesInCentimeters).rounded(toPlaces: 2)
    }
    
    private func isValidUserHeight() -> Bool {
        guard let feetText = heightFeetTextField.text,
              !feetText.isBlank,
              let heightInFeet = Double(feetText) else {
            UIAlertController.showAlert(self, title: "", message: AlertMessage.INVALID_HEIGHT)
            return false
        }
        guard let inchesText = heightInchesTextField.text,
              !inchesText.isBlank,
              let heightInInches = Double(inchesText) else {
            UIAlertController.showAlert(self, title: "", message: AlertMessage.INVALID_HEIGHT)
            return false
        }
        self.userHeight = heightInCentimeters(feet: heightInFeet, inches: heightInInches)
        return true
    }
    
    private func goToScanningForModelScreen() {
        guard isValidUserHeight() else {
            return
        }
        DispatchQueue.main.async {
            guard let vc = Storyboard.Scanning.instantiateVC(type: ScanningMeasurementViewController.self) else {
                return
            }
            vc.userHeight = self.userHeight
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}


//MARK: UITextFieldDelegate
extension StartMeasurementViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == heightFeetTextField || textField == heightInchesTextField {
            return validateHeightTextFieldData(textField: textField, range: range, string: string)
        }
        return true
    }
    
    private func validateHeightTextFieldData(textField: UITextField, range: NSRange, string: String) -> Bool {
        if let text = textField.text as NSString? {
            let finalText = text.replacingCharacters(in: range, with: string)
            
            var maxDigitCount = maxHeightDigitCount
            let formatLabelColor: UIColor = finalText.isEmpty ? .clear : .lightGray
            if textField == heightFeetTextField {
                ftFormatLabel.textColor = formatLabelColor
            } else {
                maxDigitCount += 1
                inFormatLabel.textColor = formatLabelColor
            }
            
            if !string.isEmpty {
                if Double(finalText) == nil {
                    return false
                }
                let components = finalText.components(separatedBy: ".")
                if components.count > 1 {
                    if components[0].count > maxDigitCount {
                        return false
                    }
                    if components[1].count > 2 {
                        return false
                    }
                }
                else if finalText.count > maxDigitCount {
                    return false
                }
            }
        }
        return true
    }
}
