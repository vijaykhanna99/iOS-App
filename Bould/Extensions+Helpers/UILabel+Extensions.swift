import UIKit


extension UILabel {
    
    func makeCircularLabel() {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = self.bounds.width / 2
        self.backgroundColor = .black
    }
}
