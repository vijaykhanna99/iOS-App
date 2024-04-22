import UIKit


class SettingsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = .clear
        titleLabel.font = UIFont(name: Fonts.poppinsMedium, size: 14)
        descLabel.font = UIFont(name: Fonts.poppinsRegular, size: 12)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    func setData(_ setting: SettingOption) {
        titleLabel.text = setting.title
        descLabel.text = setting.description
    }
}
