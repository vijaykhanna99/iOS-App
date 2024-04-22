import UIKit


class NeumorphicCheckboxTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var checkboxButton: UIButton!    
    @IBOutlet weak var neumorphicView: NeumorphicView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        /*neumorphicView.intensity = 10
        neumorphicView.shapeType = 3
        neumorphicView.directionType = 3
        neumorphicView.cornerRadius = 20
        neumorphicView.shadowRadius = 20
        neumorphicView.opacity = 1
        neumorphicView.offset = 2*/
    }
    
    func checkBoxSelect(_ isSelect: Bool) {
        if !isSelect {
            checkboxButton.setImage(nil, for: .normal)
            return
        }
        checkboxButton.setImage(UIImage(named: "right-check-mark"), for: .normal)
    }
}
