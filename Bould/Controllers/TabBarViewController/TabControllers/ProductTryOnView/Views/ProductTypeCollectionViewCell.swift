import UIKit


class ProductTypeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var underlineView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        titleLabel.textColor = UIColor(rgba: "#C7C7C7")
        underlineView.backgroundColor = UIColor(rgba: "#878787")
    }
    
    func isSelected(_ isSelect: Bool) {
        titleLabel.textColor = isSelect ? UIColor(rgba: "#878787") : UIColor(rgba: "#C7C7C7")
        underlineView.isHidden = !isSelect
    }
}
