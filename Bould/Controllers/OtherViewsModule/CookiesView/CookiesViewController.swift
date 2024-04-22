//
//  CookiesViewController.swift
//  Bould
//
//  Created by Jacob Marillion on 7/21/23.
//

import UIKit
import AdSupport
import AppTrackingTransparency

class CookiesViewController: UIViewController {
    
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var thirdLabel: UILabel!
    private var isGradientAdded: Bool = false
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait  // Return the allowed orientation(s) for this view controller
    }
    
    //MARK: - Lifecycle Functions
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
        setupLayout()
    }
    
    //MARK: - Helper Functions
    @IBAction func continueButtonPressed(_ sender: UIButton) {
        self.checkTrackingPermission()
    }
    
    private func setupLayout() {
        firstLabel.font = UIFont(name: Fonts.brunoAceRegular, size: 15)
        secondLabel.font = UIFont(name: Fonts.brunoAceRegular, size: 12)
        thirdLabel.font = UIFont(name: Fonts.brunoAceRegular, size: 9)
        
        continueButton.layer.cornerRadius = 7
        continueButton.titleLabel?.font = UIFont(name: Fonts.brunoAceRegular, size: 14)
        
        navigationController?.navigationBar.tintColor = .lightGray
    }
    
    private func checkTrackingPermission() {
        ATTrackingManager.requestTrackingAuthorization { [weak self] status in
            switch status {
            case .authorized:
                let advertisingIdentifier = ASIdentifierManager.shared().advertisingIdentifier
                print("\nAdvertising Identifier (IDFA): \(advertisingIdentifier)")
                self?.goToAccountDetailScreen()
                
            case .denied, .restricted:
                self?.askPermissionAgain(title: Strings.deniedORRestricted)
                
            case .notDetermined:
                self?.askPermissionAgain(title: Strings.permissionNotDetermined)
                
            @unknown default:
                self?.askPermissionAgain(title: Strings.trackingAccessRequired)
            }
        }
    }
    
    private func askPermissionAgain(title: String) {
        DispatchQueue.main.async {
            UIAlertController.showAlert(self, title: title, message: AlertMessage.TRACKING_ACCESS_PERMISSION, actions: .OK, .Cancel) { action in
                if action == .OK {
                    Utility.openAppSettings()
                }
            }
        }
    }
    
    private func goToAccountDetailScreen() {
        DispatchQueue.main.async {
            guard let vc = Storyboard.Auth.instantiateVC(type: InitialInfoViewController.self) else {
                return
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }    
} //End of class
