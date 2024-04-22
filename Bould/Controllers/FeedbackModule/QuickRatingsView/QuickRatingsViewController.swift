import UIKit


class QuickRatingsViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    private var isGradientAdded: Bool = false
    private var scanFeedback: Int?
    private var fitSatisfaction: Int?
    private var appRating: Int?
    var overallExperience: Int?
    var inputFeedback: String?
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if !isGradientAdded {
            isGradientAdded.toggle()
            view.addGradient()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScreenLayout()
        presentBottomSheet()
    }
    
    
    private func setupScreenLayout() {
        addBackButton()
        titleLabel.font = UIFont(name: Fonts.interBold, size: 32)
        descriptionLabel.font = UIFont(name: Fonts.interSemiBold, size: 15)
    }
        
    private func goToSubmitFeedbackScreen() {
        DispatchQueue.main.async { [weak self] in
            guard let vc = Storyboard.Feedback.instantiateVC(type: SubmitFeedbackViewController.self) else {
                return
            }
            vc.viewModel.overallExperience = self?.overallExperience
            vc.viewModel.inputFeedback = self?.inputFeedback
            vc.viewModel.scanFeedback = self?.scanFeedback
            vc.viewModel.fitSatisfaction = self?.fitSatisfaction
            vc.viewModel.appRating = self?.appRating
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}


//MARK: Bottom-Sheet Implementation
extension QuickRatingsViewController {
    
    private func presentScreenAsBottomSheet() -> UIViewController? {
        if (scanFeedback == nil) || (fitSatisfaction == nil) {
            guard let _vc = Storyboard.Feedback.instantiateVC(type: QuickOptionsViewController.self) else {
                return nil
            }
            _vc.delegate = self
            _vc.screenTitle = (scanFeedback == nil) ? Strings.scanFeedback : Strings.fitSatisfactionSurvey
            _vc.screenDescription = (scanFeedback == nil) ? Strings.scanFeedbackDesc : Strings.fitSatisfactionSurveyDesc
            return _vc
        }
        let vc = Storyboard.Feedback.instantiateVC(type: AppRatingOptionsViewController.self)
        vc?.delegate = self
        return vc
    }
    
    private func presentBottomSheet() {
        //Step 1: Instance of Screen
        guard let viewController = presentScreenAsBottomSheet()  else {
            return
        }
        // Step 2: To prevent dismissing on tap outside the sheet
        viewController.isModalInPresentation = true
        //Step 3: Set Screen as initial screen of navigation
        let nav = UINavigationController(rootViewController: viewController)
        // Step 4: Set the modal presentation style to .pageSheet
        nav.modalPresentationStyle = .pageSheet
        // Step 5: Customize the presentation controller for the sheet
        if let sheet = nav.sheetPresentationController {
            // Step 6: Set custom detents for the sheet presentation controller
            sheet.detents = [.large()]
        }
        // Step 7: Present the navigation controller modally
        present(nav, animated: true, completion: nil)
    }
}


//MARK: Implement QuickOptionsProtocol
extension QuickRatingsViewController: QuickOptionsProtocol {
    
    func quickOptionSelected(_ option: Int?) {
        if scanFeedback == nil {
            scanFeedback = option
            presentBottomSheet()
            return
        }
        if fitSatisfaction == nil {
            fitSatisfaction = option
            presentBottomSheet()
            return
        }
        appRating = option
        goToSubmitFeedbackScreen()
    }
}
