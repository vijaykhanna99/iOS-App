//
//  ModelBeginViewController.swift
//  Bould
//
//  Created by Jacob Marillion on 7/28/23.
//

import UIKit

class ModelBeginViewController: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var continueButton: UIButton!
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
        addBackButton()
        continueButton.layer.cornerRadius = 7
        continueButton.titleLabel?.font = UIFont(name: Fonts.brunoAceRegular, size: 14)
        titleLabel.font = UIFont(name: Fonts.brunoAceRegular, size: 15)
        descriptionLabel.font = UIFont(name: Fonts.brunoAceRegular, size: 11)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    //MARK: - Helper Functions
    @IBAction func continueButtonPressed(_ sender: Any) {
        goToCreateModelInstructionsScreen()
    }
    

    private func goToCreateModelInstructionsScreen() {
        DispatchQueue.main.async {
            guard let vc = Storyboard.Scanning.instantiateVC(type: ScanningInstructionsViewController.self) else {
                return
            }
            vc.shouldNavBarShow = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
} //End of class
