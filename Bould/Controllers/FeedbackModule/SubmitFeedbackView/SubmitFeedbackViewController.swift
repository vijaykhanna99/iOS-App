import UIKit


class SubmitFeedbackViewController: BaseViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    private var isGradientAdded: Bool = false
    
    lazy var viewModel: SubmitFeedbackViewModel = {
        let vwModel = SubmitFeedbackViewModel()
        self.baseVwModel = vwModel
        return vwModel
    }()
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if !isGradientAdded {
            isGradientAdded.toggle()
            view.addGradient()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
        
    @IBAction func submitButtonPressed(_ sender: Any) {
        submitFeedback()
    }
    
    
    private func setupScreenLayout() {
        titleLabel.font = UIFont(name: Fonts.interBold, size: 32)
        descriptionLabel.font = UIFont(name: Fonts.interSemiBold, size: 16)
        submitButton.titleLabel?.font = UIFont(name: Fonts.brunoAceRegular, size: 14)
        submitButton.layer.cornerRadius = 7.0
    }
    
    private func submitFeedback() {
        viewModel.submitFeedback { [weak self] in
            DispatchQueue.main.async {
                UIAlertController.showAlert(
                    title: "",
                    message: AlertMessage.FEEDBACK_SUBMITTED,
                    actions: .OK) { _ in
                        self?.navigationController?.popToRootViewController(animated: true)
                        //SceneDelegate.sceneDelegate?.updateRootController()
                    }
            }
        }
    }
}
