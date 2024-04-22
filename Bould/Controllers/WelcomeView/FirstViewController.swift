//
//  ViewController.swift
//  Bould
//
//  Created by Jacob Marillion on 7/21/23.
//

import UIKit

class FirstViewController: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var appNameLabel: UILabel!
    private var isGradientAdded: Bool = false
    
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
        appNameLabel.font = UIFont(name: Fonts.ammonite, size: 55)
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        guard let vc = Storyboard.Auth.instantiateVC(type: LogInViewController.self) else {
            return
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func signupButtonPressed(_ sender: Any) {
        guard let vc = Storyboard.Other.instantiateVC(type: CookiesViewController.self) else {
            return
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
} //End of class

