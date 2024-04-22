import UIKit


class ScanningInstructionsViewController: UIViewController {
    
    enum Instruction: Int, CaseIterable {
        case placePhone = 0
        case frontPose
        case sidePose
        
        var imageName: String {
            switch self {
            case .placePhone: return "phone-place-instruction"
            case .frontPose: return "front-pose-instruction"
            case .sidePose: return "side-pose-instruction"
            }
        }
        
        var title: String {
            switch self {
            case .placePhone: return "Quick Self-Scan Setup"
            case .frontPose: return "A-Pose Capture"
            case .sidePose: return "Profile Pose Capture"
            }
        }
        
        var description: String {
            switch self {
            case .placePhone:
                return "Place your phone on a flat surface with the screen facing you. Ensure the camera is directed toward your posing area. Maintain a 6-foot distance."
            case .frontPose:
                return "Step back until the outline turns green, ensuring your entire body is in view. Stand still for 3 seconds, and the picture will be captured automatically."
            case .sidePose:
                return "Turn to the side for a profile view. Keep your body straight, facing forward. Repeat the same process as before!"
            }
        }
    }
    
    @IBOutlet weak var topViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var loadingStackView: UIStackView!
    @IBOutlet weak var continueButton: UIButton!
    
    private var isGradientAdded: Bool = false
    private var instruction: Instruction = .placePhone
    var shouldNavBarShow: Bool = false
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if !isGradientAdded {
            isGradientAdded.toggle()
            view.addGradient()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addBackButton()
        setupScreenLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        topViewConstraint.constant = shouldNavBarShow ? 28 : 70
        navigationController?.setNavigationBarHidden(!shouldNavBarShow, animated: true)
        instruction = Instruction(rawValue: 0) ?? .placePhone
        animateScreenViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func setRichTextForFrontPoseDescription() {
        let formattedString = NSMutableAttributedString()
        let font: UIFont = UIFont(name: Fonts.brunoAceRegular, size: 11) ?? .systemFont(ofSize: 11)        
        let normalAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(rgba: "#7C7C7C"),
            .font: font
        ]
        let highlightedAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .font: font
        ]
        formattedString.append(NSAttributedString(string: "Step back ", attributes: normalAttributes))
        formattedString.append(NSAttributedString(string: "until the outline turns green", attributes: highlightedAttributes))
        formattedString.append(NSAttributedString(string: ", ensuring your entire body is in view. ", attributes: normalAttributes))
        formattedString.append(NSAttributedString(string: "Stand still for 3 seconds", attributes: highlightedAttributes))
        formattedString.append(NSAttributedString(string: ", and the picture will be captured automatically.", attributes: normalAttributes))
        // Set the attributed text to the label
        descriptionLabel.attributedText = formattedString
    }
    
    /*private func setRichTextForPlacePhoneDescription() {
        let formattedString = NSMutableAttributedString()
        let font: UIFont = UIFont(name: Fonts.brunoAceRegular, size: 11) ?? .systemFont(ofSize: 11)
        
        let normalText = "Place your phone on a table or flat surface. Ensure the camera faces the area where you'll pose. Make sure to keep a "
        let highlightedText = "distance of 5 to 6 feet away"
        
        let normalAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(rgba: "#7C7C7C"),
            .font: font
        ]
        let highlightedAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .font: font
        ]
        formattedString.append(NSAttributedString(string: normalText, attributes: normalAttributes))
        formattedString.append(NSAttributedString(string: highlightedText, attributes: highlightedAttributes))
        formattedString.append(NSAttributedString(string: ".", attributes: highlightedAttributes))
        // Set the attributed text to the label
        descriptionLabel.attributedText = formattedString
    }*/
    
    private func setupScreenLayout() {
        //Fixed:- Navigation Bar changes its background color when scroll the view
        //navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        //navigationController?.navigationBar.shadowImage = UIImage()
        titleLabel.font = UIFont(name: Fonts.brunoAceRegular, size: 12)
        continueButton.layer.cornerRadius = 7
        continueButton.titleLabel?.font = UIFont(name: Fonts.brunoAceRegular, size: 14)
        
        //Setup loading animations
        var delay: TimeInterval = 0.0
        for subView in loadingStackView.subviews {
            subView.layer.masksToBounds = true
            subView.layer.cornerRadius = 2
            subView.layer.borderWidth = 1
            subView.layer.borderColor = UIColor.white.cgColor
            subView.backgroundColor = loadingStackView.subviews.first == subView ? .white : .clear
            UIView.animate(withDuration: 1.5, delay: delay, options: [.autoreverse, .repeat], animations: {
                subView.transform = CGAffineTransform(scaleX: 1, y: -1)
            }, completion: nil)
            delay += 0.2
        }
    }
    
    private func updateProgress() {
        for (index, view) in loadingStackView.subviews.enumerated() {
            view.backgroundColor = index == instruction.rawValue ? .white : .clear
        }
    }
    
    private func updateScreenData() {
        titleLabel.text = instruction.title
        descriptionLabel.text = instruction.description
        imageView.image = UIImage(named: instruction.imageName)
    }
    
    @IBAction func continueButtonPressed(_ sender: Any) {
        nextInstruction()
    }
    
    private func nextInstruction() {
        if (instruction.rawValue + 1) >= Instruction.allCases.count {
            //instruction = Instruction(rawValue: 0) ?? .placePhone
            goToStartMeasurementScreen()
        } else {
            instruction = Instruction(rawValue: instruction.rawValue + 1) ?? .placePhone
        }
        animateScreenViews()
    }
    
    private func animateScreenViews() {
        var delay: Double = 0.0
        for view in [titleLabel, descriptionLabel, imageView] {
            view?.isHidden = true
            //Start position of view from right side of the screen
            view?.transform = CGAffineTransform(translationX: view?.bounds.width ?? 0.0, y: 0)
            //Run each animation after some delay
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                view?.isHidden = false
                //Animate view upto its original position
                UIView.animate(withDuration: 1.5, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.0, animations: {
                    view?.transform = .identity
                })
            }
            //Now set delay for next view
            delay += 0.5
        }
        self.updateProgress()
        self.updateScreenData()
        if instruction.rawValue == 1 {
            setRichTextForFrontPoseDescription()
        } else {
            descriptionLabel.font = UIFont(name: Fonts.brunoAceRegular, size: 11)
        }
    }
    
    private func goToStartMeasurementScreen() {
        DispatchQueue.main.async {
            guard let vc = Storyboard.Scanning.instantiateVC(type: StartMeasurementViewController.self) else {
                return
            }
            vc.shouldNavBarShow = self.shouldNavBarShow
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

