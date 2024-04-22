import UIKit


class AppRatingOptionCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var optionLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        mainView.backgroundColor = .clear
        mainView.layer.cornerRadius = bounds.height / 2
        mainView.layer.borderWidth = 2
    }
    
    
    func showSelectionEffect(_ isShow: Bool) {
        mainView.layer.borderColor = isShow ? UIColor.white.cgColor : UIColor.clear.cgColor
    }
}
