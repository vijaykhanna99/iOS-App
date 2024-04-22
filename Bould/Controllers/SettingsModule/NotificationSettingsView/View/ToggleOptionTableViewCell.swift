import UIKit


enum ToggleOptionSwitchType {
    case MainSingle
    case First
    case Second
}

protocol ToggleOptionTableCellDelegate: AnyObject {
    func switchStateChangedHandler(_ setting: NotificationSettingsType, type: ToggleOptionSwitchType, isOn: Bool)
}


class ToggleOptionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var singleSwitch: UISwitch!
    
    @IBOutlet weak var separatorTopConstraint: NSLayoutConstraint!
    //Switch Options Related Views
    //First Option Views
    @IBOutlet weak var firstOptionView: UIView!
    @IBOutlet weak var firstOptionLabel: UILabel!
    @IBOutlet weak var firstOptionSwitch: UISwitch!
    //Second Option Views
    @IBOutlet weak var secondOptionView: UIView!
    @IBOutlet weak var secondOptionLabel: UILabel!
    @IBOutlet weak var secondOptionSwitch: UISwitch!
    
    weak var delegate: ToggleOptionTableCellDelegate?
    private var setting: NotificationSettingsType?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        resetAllValues()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    
    @IBAction func switchStateChanged(_ sender: Any) {
        guard let toggleSwitch = sender as? UISwitch, let _setting = setting else {
            return
        }
        switch toggleSwitch {
        case singleSwitch:
            delegate?.switchStateChangedHandler(_setting, type: .MainSingle, isOn: toggleSwitch.isOn)
            break
        case firstOptionSwitch:
            delegate?.switchStateChangedHandler(_setting, type: .First, isOn: toggleSwitch.isOn)
            break
        case secondOptionSwitch:
            delegate?.switchStateChangedHandler(_setting, type: .Second, isOn: toggleSwitch.isOn)
            break
        default: break
        }
    }
    
    
    func updateCellViewFor(_ setting: NotificationSettingsType) {
        resetAllValues()
        self.setting = setting
        descriptionLabel.text = setting.descriptionText
        titleLabel.text = setting.title
        
        switch setting {
        case .enableNotifications:
            singleSwitch.isHidden = false
            separatorTopConstraint.constant = 25
            break
        case .accountNotifications:
            firstOptionView.isHidden = false
            break
        case .orderNotifications:
            firstOptionView.isHidden = false
            secondOptionView.isHidden = false
            break
        case .appUpdates:
            firstOptionView.isHidden = false
            break
        }
    }
    
    private func resetAllValues() {
        singleSwitch.isHidden = true
        firstOptionView.isHidden = true
        secondOptionView.isHidden = true
        separatorTopConstraint.constant = 13
    }
}
