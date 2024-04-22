import UIKit


class FormDateButton: UIButton {
    private var isLayoutSetup: Bool = false
    
    @IBInspectable var cornerRadius: CGFloat = 16 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 1 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.white.withAlphaComponent(0.07) {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if !isLayoutSetup {
            isLayoutSetup.toggle()
            setupButtonLayout()
        }
    }
    
    private func setupButtonLayout() {
        layer.cornerRadius = cornerRadius
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
        // Add border layer
        let borderLayer = CAShapeLayer()
        borderLayer.frame = bounds
        borderLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius).cgPath
        borderLayer.fillColor = UIColor.white.withAlphaComponent(0.01).cgColor
        layer.addSublayer(borderLayer)
    }
}
