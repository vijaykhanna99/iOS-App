import UIKit
import ActionSheetPicker_3_0


class ProfileSettingsViewController: BaseViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var addPhotoButton: UIButton!
    
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var nameTextfield: FormTextField!
    
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var phoneNumberTextfield: PhoneNumberTextField!
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailTextfield: FormTextField!
    
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var genderTextfield: FormTextField!
    
    @IBOutlet weak var birthdayLabel: UILabel!
    @IBOutlet weak var monthButton: FormDateButton!
    @IBOutlet weak var dayButton: FormDateButton!
    @IBOutlet weak var yearButton: FormDateButton!
    
    @IBOutlet weak var updateProfileButton: UIButton!
    
    private var isGradientAdded: Bool = false
    private var pickerView = UIPickerView()
    
    private lazy var viewModel: ProfileSettingsViewModel = {
        let vwModel = ProfileSettingsViewModel()
        self.baseVwModel = vwModel
        return vwModel
    }()
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if !isGradientAdded {
            isGradientAdded.toggle()
            view.addGradient()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScreenLayout()
        updateDOBData()
        initializeViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    @IBAction func addPhotoButtonPressed(_ sender: Any) {
        onImageSelectionClick()
    }
    
    @IBAction func datePickerButtonPressed(_ sender: Any) {
        dateOfBirthButtonPressed(sender as? UIButton)
    }
    
    @IBAction func updateProfileButtonPressed(_ sender: Any) {
        viewModel.updateUserProfile(countryCode: phoneNumberTextfield.countryCode) { [weak self] in
            DispatchQueue.main.async {
                UIAlertController.showAlert(
                    title: Strings.profileUpdated,
                    message: AlertMessage.PROFILE_UPDATED,
                    actions: .OK) { [weak self] _ in
                        self?.navigationController?.popViewController(animated: true)
                    }
            }
        }
    }
    
    
    private func setupScreenLayout() {
        navigationController?.setNavigationBarHidden(false, animated: true)
        let textFieldFont = UIFont(name: Fonts.laoSansProRegular, size: 12) ?? .systemFont(ofSize: 12)
        
        nameTextfield.delegate = self
        emailTextfield.delegate = self
        phoneNumberTextfield.delegate = self
        //Setup phone number view
        phoneNumberTextfield.layer.cornerRadius = 16
        phoneNumberTextfield.layer.borderWidth = 1
        phoneNumberTextfield.setFont(textFieldFont)
        phoneNumberTextfield.layer.borderColor = UIColor.white.withAlphaComponent(0.07).cgColor
        // Add border layer
        let borderLayer = CAShapeLayer()
        borderLayer.frame = phoneNumberTextfield.bounds
        borderLayer.path = UIBezierPath(roundedRect: phoneNumberTextfield.bounds, cornerRadius: phoneNumberTextfield.layer.cornerRadius).cgPath
        borderLayer.fillColor = UIColor.white.withAlphaComponent(0.01).cgColor
        phoneNumberTextfield.layer.addSublayer(borderLayer)
        
        
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
        profileImageView.clipsToBounds = true
        profileImageView.isUserInteractionEnabled = true
        let tapController = UITapGestureRecognizer(target: self, action: #selector(onImageSelectionClick))
        profileImageView.addGestureRecognizer(tapController)
        addPhotoButton.titleLabel?.font =  UIFont(name: Fonts.poppinsSemiBold, size: 18)
        
        pickerView.delegate = self
        pickerView.backgroundColor = UIColor(rgba: "#1E1E1E")
        pickerView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        genderTextfield.inputView = pickerView
        genderTextfield.keyboardToolbar.backgroundColor = .black
        genderTextfield.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(self.btnDoneTap(_:)))
        
        for label in [fullNameLabel, phoneNumberLabel, emailLabel, genderLabel, birthdayLabel] {
            label?.font = UIFont(name: Fonts.laoSansProRegular, size: 15)
        }
        for textfield in [nameTextfield, emailTextfield, genderTextfield] {
            textfield?.placeholderFont = textFieldFont
            textfield?.font = textFieldFont
        }
        for button in [monthButton, dayButton, yearButton] {
            button?.titleLabel?.font = UIFont(name: Fonts.laoSansProRegular, size: 12) ?? .systemFont(ofSize: 12)
        }
        updateProfileButton.layer.cornerRadius = 7
        updateProfileButton.titleLabel?.font = UIFont(name: Fonts.brunoAceRegular, size: 14)
    }
    
    private func initializeViewModel() {
        // Naive binding
        viewModel.reloadTableViewClosure = { [weak self] () in
            DispatchQueue.main.async {
                self?.updateScreenUI()
            }
        }
        viewModel.fetchUserProfile(isReload: false)
    }
    
    private func updateScreenUI() {
        if let imageURL = viewModel.profileImageURL {
            profileImageView.setProfileImage(imageURL)
        }
        nameTextfield.text = viewModel.fullName
        emailTextfield.text = viewModel.email
        genderTextfield.text = viewModel.gender
        phoneNumberTextfield.text = viewModel.phoneNumber
        phoneNumberTextfield.setCountry(name: viewModel.country, phoneCode: viewModel.countryCode)
        updateDOBData()
    }
    
    @objc private func onImageSelectionClick() {
        ImagePickerManager().pickImage(self, true) {[weak self] (image) in
            //self?.viewModel.isImageChange = true
            self?.profileImageView.image = image
            self?.viewModel.selectedImage = image
        }
    }
}


//MARK: Confirm to UIPickerViewDataSource, UIPickerViewDelegate
extension ProfileSettingsViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        viewModel.genderOptions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: viewModel.genderOptions[row], attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let gender = viewModel.genderOptions[row]
        genderTextfield.text = gender
        viewModel.gender = gender
    }
    
    @objc private func btnDoneTap(_ sender: Any) {
        guard let textField = sender as? UITextField else { return }
        switch textField {
        case genderTextfield:
            if (viewModel.gender == nil) || (viewModel.gender?.isEmpty == true) {
                genderTextfield.text = viewModel.genderOptions[0]
                viewModel.gender = viewModel.genderOptions[0]
            }
            genderTextfield.resignFirstResponder()
        default: break
        }
    }
}


//MARK: Custom DOB picker functionalities
extension ProfileSettingsViewController {
    
    private func updateDOBData() {
        let titleColor = UIColor(rgba: "#3B3B3B")
        dayButton.setTitle(viewModel.selectedDay == nil ? "DAY" : "\(viewModel.selectedDay ?? 0)", for: .normal)
        dayButton.setTitleColor(viewModel.selectedDay == nil ? titleColor : .white, for: .normal)
        
        monthButton.setTitle(viewModel.selectedMonth == nil ? "MONTH" : viewModel.selectedMonthType()?.title ?? "", for: .normal)
        monthButton.setTitleColor(viewModel.selectedMonth == nil ? titleColor : .white, for: .normal)
        
        yearButton.setTitle(viewModel.selectedYear == nil ? "YEAR" : "\(viewModel.selectedYear ?? 0)", for: .normal)
        yearButton.setTitleColor(viewModel.selectedYear == nil ? titleColor : .white, for: .normal)
    }
    
    private func dateOfBirthButtonPressed(_ button: UIButton?) {
        viewModel.selectedPickerOption = DatePickerOption(rawValue: button?.tag ?? 0) ?? .Month
        button?.setImage(UIImage(systemName: "chevron.up")?.withRenderingMode(.alwaysTemplate), for: .normal)
        
        ActionSheetMultipleStringPicker.show(
            withTitle: "Select DOB \(viewModel.selectedPickerOption.title)",
            rows: [viewModel.datePickerDataArray()],
            initialSelection: [1],
            doneBlock: { picker, indexes, values in
                if let index = indexes?.first as? Int {
                    self.datePickerSelectedIndex(index)
                }
                return
            },
            cancel: { ActionMultipleStringCancelBlock in return },
            origin: button
        )
    }
    
    private func datePickerSelectedIndex(_ index: Int) {
        let image = UIImage(systemName: "chevron.down")?.withRenderingMode(.alwaysTemplate)
        
        switch viewModel.selectedPickerOption {
        case .Day:
            dayButton.setImage(image, for: .normal)
            viewModel.selectedDay = viewModel.dayPickerOptions()[index]
            break
        case .Month:
            monthButton.setImage(image, for: .normal)
            viewModel.selectedMonth = MonthPickerOption.allCases[index].rawValue
            break
        case .Year:
            yearButton.setImage(image, for: .normal)
            viewModel.selectedYear = viewModel.yearPickerOptions()[index]
            break
        }
        updateDOBData()
    }
}


//MARK: Confirm to UITextFieldDelegate
extension ProfileSettingsViewController: UITextFieldDelegate {
    
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
        let value = text ?? textField.text
        
        switch textField {
        case nameTextfield:
            viewModel.fullName = value
        case phoneNumberTextfield:
            viewModel.phoneNumber = value
            break
        case emailTextfield:
            viewModel.email = value
        default: break
        }
    }
}
