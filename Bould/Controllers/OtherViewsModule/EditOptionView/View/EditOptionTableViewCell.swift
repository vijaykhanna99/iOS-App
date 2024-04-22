import UIKit


class EditOptionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var textField: FormTextField!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        nameLabel.font = UIFont(name: Fonts.laoSansProRegular, size: 15)
        textField.font = UIFont(name: Fonts.laoSansProRegular, size: 12) ?? .systemFont(ofSize: 12)
        textField.placeholderFont = textField.font
    }
}
