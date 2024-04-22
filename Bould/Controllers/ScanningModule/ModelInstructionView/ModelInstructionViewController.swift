//
//  ModelInstructionViewController.swift
//  Bould
//
//  Created by Jacob Marillion on 7/28/23.
//

import UIKit

//MARK: - TODO - trigger nav bar to show when segue comes from redo button

class ModelInstructionViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var firstInstTitleLabel: UILabel!
    @IBOutlet weak var firstInstDescLabel: UILabel!
    @IBOutlet weak var secondInstTitleLabel: UILabel!
    @IBOutlet weak var secondInstDescLabel: UILabel!
    @IBOutlet weak var thirdInstTitleLabel: UILabel!
    @IBOutlet weak var thirdInstDescLabel: UILabel!
    @IBOutlet weak var fourthInstTitleLabel: UILabel!    
    @IBOutlet weak var fourthInstDescLabel: UILabel!
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var oneLabel: UILabel!
    @IBOutlet weak var twoLabel: UILabel!
    @IBOutlet weak var threeLabel: UILabel!
    @IBOutlet weak var fourLabel: UILabel!
    
    var shouldNavBarShow: Bool = false
    private var isGradientAdded: Bool = false
    
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
        addBackButton()
        //Fixed:- Navigation Bar changes its background color when scroll the view
        //navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        //navigationController?.navigationBar.shadowImage = UIImage()
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(!shouldNavBarShow, animated: true)
        navigationController?.navigationBar.tintColor = .lightGray
    }
    
    //MARK: - Helper Functions
    @IBAction func startButtonPressed(_ sender: Any) {
        goToStartMeasurementScreen()
    }
    
    private func setupLayout() {
        [oneLabel, twoLabel, threeLabel, fourLabel].forEach { label in
            label?.makeCircularLabel()
            label?.font = UIFont(name: Fonts.brunoAceRegular, size: 12)
        }
        startButton.layer.cornerRadius = 7
        startButton.titleLabel?.font = UIFont(name: Fonts.brunoAceRegular, size: 14)
        titleLabel.font = UIFont(name: Fonts.brunoAceRegular, size: 15)
        descriptionLabel.font = UIFont(name: Fonts.brunoAceRegular, size: 11)
        
        [firstInstTitleLabel, secondInstTitleLabel, thirdInstTitleLabel, fourthInstTitleLabel].forEach { label in
            label?.font = UIFont(name: Fonts.brunoAceRegular, size: 12)
        }
        [firstInstDescLabel, secondInstDescLabel, thirdInstDescLabel, fourthInstDescLabel].forEach { label in
            label?.font = UIFont(name: Fonts.brunoAceRegular, size: 8)
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
} //End of class
