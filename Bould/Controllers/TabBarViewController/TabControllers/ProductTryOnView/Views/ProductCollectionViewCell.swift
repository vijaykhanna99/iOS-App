import UIKit


class ProductCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tryButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code  
        imageView.image = UIImage(named: "image-placeholder")
    }
}
