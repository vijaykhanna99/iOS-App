//
//  LaunchViewController.swift
//  Bould
//
//  Created by Jacob Marillion on 7/21/23.
//

import UIKit

class LaunchViewController: UIViewController {
    
    @IBOutlet weak var appNameLabel: UILabel!
    private var isGradientAdded: Bool = false
    var loginVM: LogInViewModel?
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait  // Return the allowed orientation(s) for this view controller
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
        appNameLabel.font = UIFont(name: Fonts.ammonite, size: 60)
        
        handleNavigation()
    }
    
    private func handleNavigation() {
        //Check Is User Already Logged-In
        guard let emailId = UserDefaults.emailId,
              let password = UserDefaults.password else {
            
            _ = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { [weak self] timer in
                self?.performSegue(withIdentifier: "toFirstVC", sender: self)
            }
            return
        }
        loginUsingCredentials(email: emailId, password: password)
    }
    
    private func loginUsingCredentials(email: String, password: String) {
        if loginVM == nil {
            loginVM = LogInViewModel()
        }
        loginVM?.email = email
        loginVM?.password = password
        
        loginVM?.logInUser { [weak self] isSuccess in
            DispatchQueue.main.async {
                if isSuccess {
                    SceneDelegate.sceneDelegate?.updateRootController()
                } else {
                    self?.performSegue(withIdentifier: "toFirstVC", sender: self)
                }
            }
        }
    }
} //End of class
