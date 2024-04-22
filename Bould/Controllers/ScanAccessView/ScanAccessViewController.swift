//
//  ScanAccessViewController.swift
//  Bould
//
//  Created by Jacob Marillion on 7/23/23.
//

import UIKit
import AVFoundation

class ScanAccessViewController: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var thirdLabel: UILabel!
    private var isGradientAdded: Bool = false
    var shouldNavBarShow: Bool = false
    
    //MARK: - Properties
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
        //addBackButton()
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = !shouldNavBarShow
        navigationController?.setNavigationBarHidden(!shouldNavBarShow, animated: true)
    }
    
    //MARK: - Helper Functions
    @IBAction func continueButtonPressed(_ sender: UIButton) {
        //Check camera permission
        AVCaptureDevice.requestAccess(for: .video) { [weak self] isGranted in
            if isGranted {
                self?.goToCreateModelInfoScreen()
            } else {
                self?.askPermissionAgain()
            }
        }
    }
    
    private func setupLayout() {
        firstLabel.font = UIFont(name: Fonts.brunoAceRegular, size: 12)
        secondLabel.font = UIFont(name: Fonts.brunoAceRegular, size: 11)
        thirdLabel.font = UIFont(name: Fonts.brunoAceRegular, size: 9)
        
        continueButton.layer.cornerRadius = 7
        continueButton.titleLabel?.font = UIFont(name: Fonts.brunoAceRegular, size: 14)
        
        navigationController?.navigationBar.tintColor = .lightGray
    }
    
    private func askPermissionAgain() {
        DispatchQueue.main.async {
            UIAlertController.showAlert(self, title: Strings.cameraAccessRequired, message: AlertMessage.CAMERA_ACCESS_PERMISSION, actions: .OK, .Cancel) { action in
                if action == .OK {
                    Utility.openAppSettings()
                }
            }
        }
    }
    
    private func goToCreateModelInfoScreen() {
        DispatchQueue.main.async {
            guard let vc = Storyboard.Scanning.instantiateVC(type: ModelBeginViewController.self) else {
                return
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

} //End of class
