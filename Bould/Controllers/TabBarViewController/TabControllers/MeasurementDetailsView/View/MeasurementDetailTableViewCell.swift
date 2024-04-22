import UIKit


class MeasurementDetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var keyLabel: UILabel!    
    @IBOutlet weak var valueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        keyLabel.font = UIFont(name: Fonts.poppinsMedium, size: 12)
        valueLabel.font = UIFont(name: Fonts.poppinsMedium, size: 12)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    /*func setData(_ dict: [String: Float]) {
        keyLabel.text = "N/A"
        valueLabel.text = "N/A"
        if let key: String = dict.keys.first {
            keyLabel.text = key
            valueLabel.text = String(describing: dict[key] ?? 0.0)
        }
    }*/
}
