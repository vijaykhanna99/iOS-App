import UIKit
import CountryPickerView


protocol PhoneNumberTextFieldDelegate {
    func startSelectingCountry()
}


@IBDesignable
class PhoneNumberTextField: UITextField {
    
    @IBInspectable var padding: UIEdgeInsets = UIEdgeInsets(top: 9, left: 10, bottom: 9, right: 10) {
        didSet {
        }
    }

    var countryCode: String = ""
    var countryCodePicker: CountryPickerView?
    
    var protocolDelegate: PhoneNumberTextFieldDelegate?
    
    private var textLeftPadding: CGFloat {
        switch countryCode.count {
        case ...1:
            return 60
        case 2:
            return 70
        case 3:
            return 80
        case 4:
            return 85
        case 5...:
            return 105
        default:
            return 35
        }
    }
    
    private var finalPadding: UIEdgeInsets {
        return UIEdgeInsets(top: padding.top, left: padding.left + textLeftPadding, bottom: padding.bottom, right: padding.right)
    }
    
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: finalPadding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: finalPadding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: finalPadding)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let codePicker = CountryPickerView()
        codePicker.textColor = textColor ?? .white
        codePicker.showCountryCodeInView = false
        codePicker.delegate = self
        codePicker.font = self.font ?? UIFont.systemFont(ofSize: 12)
        codePicker.translatesAutoresizingMaskIntoConstraints = false
        
        let leftView = UIView()
        leftView.backgroundColor = .clear
        leftView.addSubview(codePicker)
        
         NSLayoutConstraint.activate([
             codePicker.leadingAnchor.constraint(equalTo: leftView.leadingAnchor, constant: padding.left),
             codePicker.trailingAnchor.constraint(equalTo: leftView.trailingAnchor),
             codePicker.centerYAnchor.constraint(equalTo: leftView.centerYAnchor),
             codePicker.heightAnchor.constraint(equalToConstant: frame.height - (padding.top + padding.bottom))
         ])
        
        self.leftView = leftView
        self.leftViewMode = .always
        countryCodePicker = codePicker
        
        countryCode = codePicker.selectedCountry.phoneCode
    }
    
    func setFont(_ font: UIFont, placeholderColor: UIColor? = nil) {
        if let placeholder = self.placeholder {
            let attributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: placeholderColor ?? UIColor(rgba: "#3B3B3B"),
                .font: font
            ]
            attributedPlaceholder = NSAttributedString(string: placeholder, attributes: attributes)
        }
        self.font = font
        countryCodePicker?.font = font
    }
}


//MARK: Country Code related functionality
extension PhoneNumberTextField {
    
    func setPhoneCode(_ code: String?) {
        let phoneCode = "+" + (code ?? "1")
        countryCodePicker?.setCountryByPhoneCode(phoneCode)
    }
    
    func setCountryByCode(countryShortName: String) {
        countryCodePicker?.setCountryByCode(countryShortName)
    }
    
    func setCountryByName(name: String) {
        countryCodePicker?.setCountryByName(name)
    }
    
    func setCountry(name: String?=nil, phoneCode: String?=nil) {
        if var _phoneCode = phoneCode, ((_phoneCode != "1") && (_phoneCode != "+1")) {
            if !(_phoneCode.contains("+")) {
                _phoneCode = ("+" + _phoneCode)
            }
            countryCodePicker?.setCountryByPhoneCode(_phoneCode)
            return
        }
        if let countryName = name {
            countryCodePicker?.setCountryByName(countryName)
            return
        }
        countryCodePicker?.setCountryByPhoneCode("+1")
    }
    
    func getPhoneCodeByCountryShortName(countryShortName: String) -> String? {
        return countryCodePicker?.countries.first(where: {$0.code == countryShortName})?.phoneCode
    }
    
    func seperatePhoneAndDialCode(phoneNumber: String) -> [String: String] {
        var dict = [String: String]()
        guard let country = countryCodePicker?.countries.last(where: {phoneNumber.contains($0.phoneCode)}) else {
            return dict
        }
        dict["country"] = country.name
        dict["code"] = String(phoneNumber[..<country.phoneCode.endIndex])
        dict["phone"] = String(phoneNumber[country.phoneCode.endIndex...])
        return dict
    }
    
    func seperatePhoneAndDialCode(country: String, phoneNumber: String) -> [String: String] {
        var dict = [String: String]()
        guard let country = (country.count==2) ? (countryCodePicker?.getCountryByCode(country.uppercased())) : (countryCodePicker?.getCountryByName(country)) else {
            let data = self.seperatePhoneAndDialCode(phoneNumber: phoneNumber)
            return data
        }
        dict["country"] = country.name
        dict["code"] = country.phoneCode
        dict["phone"] = String(phoneNumber[country.phoneCode.endIndex...])
        return dict
    }
}


//MARK: Implemented CountryPickerViewDelegate
extension PhoneNumberTextField: CountryPickerViewDelegate {
    
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        countryCode = country.phoneCode.replacingOccurrences(of: "+", with: "")
        DispatchQueue.main.async {
            self.setNeedsLayout()
        }
    }
    
    func showPhoneCodeInList(in countryPickerView: CountryPickerView) -> Bool {
        return true
    }
    
    func countryPickerView(_ countryPickerView: CountryPickerView, willShow viewController: CountryPickerViewController) {
        protocolDelegate?.startSelectingCountry()
    }
    
    func preferredCountries(in countryPickerView: CountryPickerView) -> [Country] {
        guard let country1 = countryPickerView.getCountryByCode("US"),
              let country2 = countryPickerView.getCountryByCode("CA") else { return [] }
        return [country1, country2]
    }
    
    func sectionTitleForPreferredCountries(in countryPickerView: CountryPickerView) -> String? {
        "Suggested:"
    }
}
