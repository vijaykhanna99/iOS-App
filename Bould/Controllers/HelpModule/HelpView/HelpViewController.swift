import UIKit
import MessageUI


class HelpViewController: UIViewController {
    
    @IBOutlet weak var helpDetailsLabel: UILabel!
    //Card Customer Support SubViews Outlets
    @IBOutlet weak var customerSupportLabel: UILabel!
    @IBOutlet weak var contactNumberLabel: UILabel!
    @IBOutlet weak var phoneNumberButton: UIButton!
    
    @IBOutlet weak var emailAddressLabel: UILabel!
    @IBOutlet weak var emailButton: UIButton!
    
    //Card Social Media SubViews Outlets
    @IBOutlet weak var socialMediaLabel: UILabel!
    @IBOutlet weak var instagramLabel: UILabel!
    @IBOutlet weak var instagramIDButton: UIButton!
    
    private var isGradientAdded: Bool = false
    private var userName: String? {
        return AppInstance.shared.userProfile?.name
    }
    
    
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
    
    
    private func setupScreenLayout() {
        helpDetailsLabel.font = UIFont(name: Fonts.poppinsRegular, size: 10)
        //Card Customer Support SubViews
        customerSupportLabel.font = UIFont(name: Fonts.laoSansProRegular, size: 14)
        contactNumberLabel.font = UIFont(name: Fonts.laoSansProRegular, size: 10)
        phoneNumberButton.titleLabel?.font = UIFont(name: Fonts.laoSansProRegular, size: 15)
        phoneNumberButton.setTitle(AppSupport.phoneNumber, for: .normal)
        
        let emailUnderlineAttribute: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,
            NSAttributedString.Key.font: UIFont(name: Fonts.laoSansProRegular, size: 15) ?? .systemFont(ofSize: 15)
        ]
        let emailUnderlineAttributedString = NSAttributedString(string: AppSupport.email, attributes: emailUnderlineAttribute)
        emailButton.setAttributedTitle(emailUnderlineAttributedString, for: .normal)
        emailAddressLabel.font = UIFont(name: Fonts.laoSansProRegular, size: 10)
        
        //Card Social Media SubViews Outlets
        socialMediaLabel.font = UIFont(name: Fonts.laoSansProRegular, size: 14)
        instagramLabel.font = UIFont(name: Fonts.laoSansProRegular, size: 10)
        instagramIDButton.titleLabel?.font = UIFont(name: Fonts.laoSansProRegular, size: 15)
        instagramIDButton.setTitle("@\(AppSupport.instagramID)", for: .normal)
    }
    
    
    @IBAction func phoneNumberButtonPressed(_ sender: Any) {
        callToSupportTeam()
    }
    
    @IBAction func emailButtonPressed(_ sender: Any) {
        sendEmailToSupportTeam()
    }
    
    @IBAction func instagramIDButtonPressed(_ sender: Any) {
        openInstagramPage()
    }
    
    
    private func callToSupportTeam() {
        Utility.openExternalLink("tel://\(AppSupport.phoneNumber)") { [weak self] isSuccess in
            if !isSuccess {
                UIAlertController.showAlert(self, title: "", message: AlertMessage.DEVICE_NOT_SUPPORT_CALL)
            }
        }
    }
    
    private func openInstagramPage() {
        // Check if the Instagram app is installed
        Utility.openExternalLink("instagram://user?username=\(AppSupport.instagramID)") { isSuccess in
            //Handle Case: If Instagram is not installed
            guard !isSuccess else {
                return
            }
            //Now open instagram page in safari
            let instagramWebPageURL = "https://www.instagram.com/\(AppSupport.instagramID)/"
            Utility.openExternalLink(instagramWebPageURL) { [weak self] isSuccess in
                // Handle the case where the Instagram website URL is not valid
                guard !isSuccess else {
                    return
                }
                UIAlertController.showAlert(self, title: "", message: AlertMessage.INVALID_INSTA_WEBPAGE)
            }
        }
    }
}


//MARK: Mail Delegate
extension HelpViewController: MFMailComposeViewControllerDelegate {
    
    private func sendEmailToSupportTeam() {
        if MFMailComposeViewController.canSendMail() {
            let mailComposeViewController = MFMailComposeViewController()
            mailComposeViewController.mailComposeDelegate = self
            
            // Set the email recipient(s), subject, and body
            let messageBody = "\(AppSupport.supportEmailMessageBody)\n\(userName ?? "")"
            mailComposeViewController.setToRecipients([AppSupport.email])
            mailComposeViewController.setSubject(AppSupport.supportEmailSubject)
            mailComposeViewController.setMessageBody(messageBody, isHTML: false)
            
            // Present the mail compose view controller
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            // Handle the case where the device cannot send emails
            UIAlertController.showAlert(self, title: "", message: AlertMessage.DEVICE_NOT_SUPPORT_EMAIL)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
        // Handle the result of the email sending process if needed
        var message: String = ""
        switch result {
        case .cancelled:
            message = AlertMessage.EMAIL_CANCELLED
        case .saved:
            message = AlertMessage.EMAIL_SAVED
        case .sent:
            message = AlertMessage.EMAIL_SENT
        case .failed:
            message = AlertMessage.EMAIL_FAILED
        @unknown default:
            message = AlertMessage.EMAIL_FAILED
        }
        UIAlertController.showAlert(self, title: "", message: message)
    }
}
