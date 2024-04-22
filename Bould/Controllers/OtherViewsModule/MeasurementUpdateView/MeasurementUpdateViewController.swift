import UIKit


class MeasurementUpdateViewController: BaseViewController {
    //Top View Outlets
    @IBOutlet weak var screenTitleLabel: UILabel!
    @IBOutlet weak var screenDescLabel: UILabel!
    
    //Measurement related Outlets
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var heightTextfield: FormTextField!
    
    @IBOutlet weak var neckLabel: UILabel!
    @IBOutlet weak var neckTextfield: FormTextField!
    
    @IBOutlet weak var shoulderLabel: UILabel!
    @IBOutlet weak var shoulderTextfield: FormTextField!
    
    @IBOutlet weak var sleeveLabel: UILabel!
    @IBOutlet weak var sleeveTextfield: FormTextField!
    
    @IBOutlet weak var frontChestLabel: UILabel!
    @IBOutlet weak var frontChestTextfield: FormTextField!
    
    @IBOutlet weak var backWidthLabel: UILabel!
    @IBOutlet weak var backWidthTextfield: FormTextField!
    
    @IBOutlet weak var chestLabel: UILabel!
    @IBOutlet weak var chestTextfield: FormTextField!
    
    @IBOutlet weak var shoulderToWaistLabel: UILabel!
    @IBOutlet weak var shoulderToWaistTextfield: FormTextField!
    
    @IBOutlet weak var waistToHipLabel: UILabel!
    @IBOutlet weak var waistToHipTextfield: FormTextField!
    
    @IBOutlet weak var waistLabel: UILabel!
    @IBOutlet weak var waistTextfield: FormTextField!
    
    @IBOutlet weak var hipLabel: UILabel!
    @IBOutlet weak var hipTextfield: FormTextField!
    
    @IBOutlet weak var insideLegLabel: UILabel!
    @IBOutlet weak var insideLegTextfield: FormTextField!
    
    @IBOutlet weak var outsideLegLabel: UILabel!
    @IBOutlet weak var outsideLegTextfield: FormTextField!
    
    @IBOutlet weak var updateButton: UIButton!
    private var isGradientAdded: Bool = false
    
    private lazy var viewModel: MeasurementUpdateViewModel = {
        let vwModel = MeasurementUpdateViewModel()
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
        title = "Update Measurements"
        setupScreenLayout()
        initViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.getMeasurements()
    }
    
    
    @IBAction func updateButtonPressed(_ sender: Any) {
        viewModel.updateUserMeasurement { [weak self] in
            DispatchQueue.main.async {
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    
    private func setupScreenLayout() {
        updateButton.layer.cornerRadius = 7
        updateButton.titleLabel?.font = UIFont(name: Fonts.brunoAceRegular, size: 14)
        screenDescLabel.font = UIFont(name: Fonts.laoSansProRegular, size: 14)
        screenTitleLabel.font = UIFont(name: Fonts.laoSansProRegular, size: 18)
        let textFieldFont = UIFont(name: Fonts.laoSansProRegular, size: 12) ?? .systemFont(ofSize: 12)
        
        for label in [heightLabel,neckLabel,shoulderLabel,sleeveLabel,frontChestLabel,backWidthLabel,chestLabel,shoulderToWaistLabel,waistToHipLabel,waistLabel,hipLabel,insideLegLabel,outsideLegLabel] {
            label?.font = UIFont(name: Fonts.laoSansProRegular, size: 15)
        }
        for textfield in [heightTextfield,neckTextfield,shoulderTextfield,sleeveTextfield,frontChestTextfield,backWidthTextfield,chestTextfield,shoulderToWaistTextfield,waistToHipTextfield,waistTextfield,hipTextfield,insideLegTextfield,outsideLegTextfield] {
            textfield?.keyboardType = .decimalPad
            textfield?.placeholderFont = textFieldFont
            textfield?.font = textFieldFont
            textfield?.delegate = self
        }
    }
    
    private func initViewModel() {
        viewModel.reloadTableViewClosure = { [weak self] in
            self?.updateScreenData()
        }
    }
    
    private func updateScreenData() {
        if let height = viewModel.height {
            heightTextfield.text = "\(height)"
        }
        if let neck = viewModel.neck {
            neckTextfield.text = "\(neck)"
        }
        if let shoulder = viewModel.shoulder {
            shoulderTextfield.text = "\(shoulder)"
        }
        if let sleeve = viewModel.sleeve {
            sleeveTextfield.text = "\(sleeve)"
        }
        if let frontChest = viewModel.frontChest {
            frontChestTextfield.text = "\(frontChest)"
        }
        if let backWidth = viewModel.backWidth {
            backWidthTextfield.text = "\(backWidth)"
        }
        if let chest = viewModel.chest {
            chestTextfield.text = "\(chest)"
        }
        if let shoulderToWaist = viewModel.shoulderToWaist {
            shoulderToWaistTextfield.text = "\(shoulderToWaist)"
        }
        if let waistToHip = viewModel.waistToHip {
            waistToHipTextfield.text = "\(waistToHip)"
        }
        if let waist = viewModel.waist {
            waistTextfield.text = "\(waist)"
        }
        if let hip = viewModel.hip {
            hipTextfield.text = "\(hip)"
        }
        if let insideLeg = viewModel.insideLeg {
            insideLegTextfield.text = "\(insideLeg)"
        }
        if let outsideLeg = viewModel.outsideLeg {
            outsideLegTextfield.text = "\(outsideLeg)"
        }
    }
}


//MARK: UITextFieldDelegate
extension MeasurementUpdateViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.setViewModelData(textField, textField.text)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text as NSString? {
            let finalText = text.replacingCharacters(in: range, with: string)
            if !string.isEmpty {
                if Float(finalText) == nil {
                    return false
                }
                let components = finalText.components(separatedBy: ".")
                if components.count >= LimitCount.maximumDecimalPlaces
                    && components[1].count > LimitCount.maximumDecimalPlaces {
                    return false
                }
            }
            //self.setViewModelData(textField, finalText)
        }
        return true
    }
    
    private func setViewModelData(_ textField: UITextField, _ text: String?) {
        var value: Float?
        if let str = text ?? textField.text, !str.isBlank {
            value = Float(str)
        }
        switch textField {
        case heightTextfield:
            viewModel.height = value
            break
        case neckTextfield:
            viewModel.neck = value
            break
        case shoulderTextfield:
            viewModel.shoulder = value
            break
        case sleeveTextfield:
            viewModel.sleeve = value
            break
        case frontChestTextfield:
            viewModel.frontChest = value
            break
        case backWidthTextfield:
            viewModel.backWidth = value
            break
        case chestTextfield:
            viewModel.chest = value
            break
        case shoulderToWaistTextfield:
            viewModel.shoulderToWaist = value
            break
        case waistToHipTextfield:
            viewModel.waistToHip = value
            break
        case waistTextfield:
            viewModel.waist = value
            break
        case hipTextfield:
            viewModel.hip = value
            break
        case insideLegTextfield:
            viewModel.insideLeg = value
            break
        case outsideLegTextfield:
            viewModel.outsideLeg = value
            break
        default: break
        }
    }
}
