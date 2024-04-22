import UIKit


class InputFeedbackViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var inputTextView: UITextView!
    @IBOutlet weak var nextButton: UIButton!
    
    private var isGradientAdded: Bool = false
    var overallExperience: Int?
    
    
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
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        goToQuickRatingsScreen()
    }
    
    
    private func setupScreenLayout() {
        titleLabel.font = UIFont(name: Fonts.interBold, size: 32)
        descriptionLabel.font = UIFont(name: Fonts.interSemiBold, size: 16)
        inputTextView.font = UIFont(name: Fonts.laoSansProRegular, size: 14)
        inputTextView.placeholderLabel.font = UIFont(name: Fonts.laoSansProRegular, size: 14)
        nextButton.titleLabel?.font = UIFont(name: Fonts.brunoAceRegular, size: 14)
        nextButton.layer.cornerRadius = 7.0
    }
    
    private func goToQuickRatingsScreen() {
        DispatchQueue.main.async { [weak self] in
            guard let vc = Storyboard.Feedback.instantiateVC(type: QuickRatingsViewController.self) else {
                return
            }
            vc.overallExperience = self?.overallExperience
            vc.inputFeedback = self?.inputTextView.text.trimmed
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
