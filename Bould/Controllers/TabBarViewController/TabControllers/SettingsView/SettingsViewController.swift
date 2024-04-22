//
//  SettingsViewController.swift
//  Bould
//
//  Created by Jacob Marillion on 7/27/23.
//

import UIKit

class SettingsViewController: BaseViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var emailButton: UIButton!
    @IBOutlet weak var passwordButton: UIButton!
    @IBOutlet weak var phoneButton: UIButton!
    @IBOutlet weak var addressButton: UIButton!
    private var isGradientAdded: Bool = false
    
    private lazy var viewModel: SettingsViewModel = {
        let vwModel = SettingsViewModel()
        self.baseVwModel = vwModel
        return vwModel
    }()
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.tintColor = .black        
        setUserDetails()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setDummyData() //Testing Purpose ----
        viewModel.reloadTableViewClosure = { [weak self] in
            self?.setUserDetails()
        }
        viewModel.fetchUserDetails()
    }

    //MARK: - Helper Functions
    @IBAction func profileImageButtonPressed(_ sender: UIButton) {
        ImagePickerManager().pickImage(self, true) {[weak self] (image) in
            self?.profileImage.image = image
            self?.viewModel.selectedImage = image
        }
    }
    
    @IBAction func emailButtonPressed(_ sender: UIButton) {
        UIAlertController.showInputAlert(self,
                                         title: Strings.newEmail,
                                         message: nil,
                                         inputPlaceholders: [Strings.email],
                                         actions: .Confirm, .Cancel)
        { [weak self] action, texts in
            guard action == .Confirm else {
                return
            }
            self?.viewModel.updateEmail(texts.first, complition: {
                self?.setUserDetails()
                self?.alertOnUpdated()
            })
        }
    }
    //ccccc
    
    @IBAction func passwordButtonPressed(_ sender: UIButton) {
        UIAlertController.showInputAlert(self,
                                         title: Strings.changePassword,
                                         message: nil,
                                         inputPlaceholders: [
                                            Strings.oldPassword,
                                            Strings.newPassword,
                                            Strings.confirmNewPassword
                                         ],
                                         actions: .Confirm, .Cancel)
        { [weak self] action, texts in
            guard action == .Confirm else {
                return
            }
            self?.viewModel.updatePassword(oldPassword: texts[0], newPassword: texts[1], confirmPassword: texts[2], complition: {
                self?.alertOnUpdated()
            })
        }
    }
    
    @IBAction func phoneButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func addressButtonPressed(_ sender: UIButton) {
        UIAlertController.showInputAlert(self,
                                         title: Strings.newAddress,
                                         message: nil,
                                         inputPlaceholders: [Strings.address],
                                         actions: .Confirm, .Cancel)
        { [weak self] action, texts in
            guard action == .Confirm else {
                return
            }
            self?.viewModel.updateEmail(texts.first, complition: {
                self?.setUserDetails()
                self?.alertOnUpdated()
            })
        }
    }
    
    private func setupLayout() {
        profileImage.layer.cornerRadius = 10
        profileImage.clipsToBounds = true
        
        emailButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        passwordButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        phoneButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        addressButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
    }
    
    private func alertOnUpdated() {
        DispatchQueue.main.async {
            UIAlertController.showAlert(self, title: nil, message: Strings.updated)
        }
    }
    
    private func setUserDetails() {
        DispatchQueue.main.async {
            self.nameLabel.text = self.viewModel.name
            self.emailButton.setTitle(self.viewModel.email, for: .normal)
            self.passwordButton.setTitle("***************", for: .normal)
            self.phoneButton.setTitle(self.viewModel.phoneNumber, for: .normal)
            self.addressButton.setTitle(self.viewModel.address, for: .normal)
        }
    }

} //End of class


//MARK: Testing Purpose - TODO - Remove before production
extension SettingsViewController {
    
    private func setDummyData() {
        viewModel.name = "Brodie Rubin"
        viewModel.email = "brodierubin@email.com"
        viewModel.phoneNumber = "07 5672 2871"
        viewModel.address = "25 Treasure Island Avenue, ROBINA QLD 4226, Australia"
    }
}
