import UIKit


@IBDesignable
class FormTextField: UITextField {
    
    private var isLayoutSetup: Bool = false
    var textPadding = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
    
    
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
    
    @IBInspectable var placeholderColor: UIColor = UIColor(rgba: "#3B3B3B") {
        didSet {
            updatePlaceholder()
        }
    }
    
    @IBInspectable var placeholderFont: UIFont? {
        didSet {
            updatePlaceholder()
        }
    }
    
    override var placeholder: String? {
        didSet {
            updatePlaceholder()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Customize the text field
        layer.cornerRadius = cornerRadius
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
        updatePlaceholder()
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if !isLayoutSetup {
            isLayoutSetup.toggle()
            setupTextfieldLayout()
        }
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }
    
    private func setupTextfieldLayout() {
        // Add border layer
        let borderLayer = CAShapeLayer()
        borderLayer.frame = bounds
        borderLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius).cgPath
        borderLayer.fillColor = UIColor.white.withAlphaComponent(0.01).cgColor
        layer.addSublayer(borderLayer)
    }
    
    private func updatePlaceholder() {
        if let placeholder = self.placeholder {
            let attributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: placeholderColor,
                .font: placeholderFont ?? UIFont.systemFont(ofSize: 12)
            ]
            attributedPlaceholder = NSAttributedString(string: placeholder, attributes: attributes)
        }
    }
}
