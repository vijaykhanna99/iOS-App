import UIKit


protocol EditOptionsProtocol: AnyObject {
    func requestToUpdateValue(_ value: String?)
}


class EditOptionViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var textfieldTitleLabel: UILabel!
    @IBOutlet weak var textfield: FormTextField!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    
    weak var delegate: EditOptionsProtocol?
    var validationRegex: String?
    var screenTitle: String?
    var screenDescription: String?
    var currentValue: String?
    var labelText: String?
    var textfieldPlaceholderText: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScreenLayout()
        titleLabel.text = screenTitle ?? Strings.editOption
        descriptionLabel.text = screenDescription ?? Strings.editOptionDesc
        textfield.placeholder = textfieldPlaceholderText ?? Strings.name.uppercased()
        textfieldTitleLabel.text = labelText ?? Strings.name
        textfield.text = currentValue
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submitButtonPressed(_ sender: Any) {
        onSubmitButtonPress()
    }
    
    
    private func setupScreenLayout() {
        submitButton.layer.cornerRadius = 7
        submitButton.titleLabel?.font = UIFont(name: Fonts.brunoAceRegular, size: 14)
        titleLabel.font = UIFont(name: Fonts.interBlack, size: 22)
        descriptionLabel.font = UIFont(name: Fonts.laoSansProRegular, size: 16)
        
        textfieldTitleLabel.font = UIFont(name: Fonts.laoSansProRegular, size: 15)
        textfield.font = UIFont(name: Fonts.laoSansProRegular, size: 12) ?? .systemFont(ofSize: 12)
        textfield.placeholderFont = textfield.font
    }
    
    private func onSubmitButtonPress() {
        guard (textfield.text ?? "").isValidValue(validationRegex) else {
            textfield.text = currentValue
            UIAlertController.showAlert(self, title: "", message: AlertMessage.INVALID_VALUE)
            return
        }
        self.dismiss(animated: true, completion: nil)
        delegate?.requestToUpdateValue(textfield.text)
    }
}
