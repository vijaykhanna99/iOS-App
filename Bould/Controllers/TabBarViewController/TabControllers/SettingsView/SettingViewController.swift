import UIKit


class SettingViewController: BaseViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var joinedAtLabel: UILabel!
    
    //@IBOutlet weak var transcationLabel: UILabel!
    @IBOutlet weak var personalFitTitleLabel: UILabel!
    @IBOutlet weak var personalFitDescLabel: UILabel!
    
    @IBOutlet weak var downloadButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    
    @IBOutlet weak var settingsLabel: UILabel!
    @IBOutlet weak var settingsTableView: UITableView!
    private var isGradientAdded: Bool = false
    
    private lazy var viewModel: SettingViewModel = {
        let vwModel = SettingViewModel()
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
        title = "Settings"
        setupScreenLayout()
        
        settingsTableView.dataSource = self
        settingsTableView.delegate = self
        settingsTableView.showsVerticalScrollIndicator = false
        settingsTableView?.register(UINib(nibName: SettingsTableViewCell.className, bundle: Bundle.main), forCellReuseIdentifier: SettingsTableViewCell.className)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        removeBackButton()
        updateData()
    }
    
    private func setupScreenLayout() {
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
        nameLabel.font = UIFont(name: Fonts.poppinsSemiBold, size: 18)
        locationLabel.font = UIFont(name: Fonts.poppinsRegular, size: 12)
        joinedAtLabel.font = UIFont(name: Fonts.poppinsRegular, size: 12)
        
        //transcationLabel.font = UIFont(name: Fonts.poppinsRegular, size: 12)
        personalFitTitleLabel.font = UIFont(name: Fonts.laoSansProRegular, size: 14)
        personalFitDescLabel.font = UIFont(name: Fonts.laoSansProRegular, size: 12)
        settingsLabel.font = UIFont(name: Fonts.poppinsSemiBold, size: 16)
        
        downloadButton.titleLabel?.font = UIFont(name: Fonts.laoSansProRegular, size: 14)
        downloadButton.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        downloadButton.layer.cornerRadius = 8
        
        settingsTableView.separatorStyle = .none
        settingsTableView.layoutMargins = UIEdgeInsets.zero
        settingsTableView.separatorInset = UIEdgeInsets.zero
        settingsTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 24, right: 0)
    }
    
    private func updateData() {
        guard let profile = AppInstance.shared.userProfile else {
            return
        }
        nameLabel.text = profile.name ?? ""
        profileImageView.setProfileImage(profile.profilePicture)
        
        if let joinedAtDate = Date.dateFromString(profile.createdAt) {
            let year = Calendar.current.component(.year, from: joinedAtDate)
            joinedAtLabel.text = "Joined \(year)"
        }
    }
    
    @IBAction func downloadPersonalFitButtonPressed(_ sender: Any) {
        viewModel.downloadUserBodyMeasurementPDF { [weak self] fileURL in
            //self?.saveMeasurementPDF(fileURL)
            guard let strongSelf = self else {
                return
            }
            UIAlertController.showAlert(
                strongSelf,
                title: "",
                message: "Measurement details file saved successfully."
            )
        }
    }
    
    @IBAction func sharePersonalFitButtonPressed(_ sender: Any) {
        viewModel.downloadUserBodyMeasurementPDF { fileURL in
            guard let fileURL = fileURL else {
                return
            }
            AppFileManager.shared.shareFile(fileURL: fileURL)
        }
    }
    
    private func saveMeasurementPDF(_ fileURL: URL?) {
        AppFileManager.shared.checkAndRequestFilePermissions(vc: self) { isSuccess in
            guard isSuccess, let _fileURL = fileURL else {
                return
            }
            AppFileManager.shared.saveFileToDevice(fileURL: _fileURL) { error in
                var message = "Your measurement details file successfully saved."
                if let _error = error {
                    message = _error.localizedDescription
                }
                UIAlertController.showAlert(nil, title: "", message: message)
            }
        }
    }
    
    private func clickedOnSetting(_ setting: SettingOption) {//UserSettingsViewController
        if setting == .logout {
            logoutUser()
            return
        }
        //If not logout; Navigate to respective screen
        var viewController: UIViewController?
        //Check which screen to go to
        switch setting {
        case .accountSettings:
            viewController = Storyboard.Setting.instantiateVC(type: UserSettingsViewController.self)
            break
        case .feedback:
            viewController = Storyboard.Feedback.instantiateVC(type: FeedbackViewController.self)
            break
        case .help:
            viewController = Storyboard.Help.instantiateVC(type: HelpViewController.self)
            break
        default: break
        }
        //Just push view controller if not nil
        if let vc = viewController {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    private func logoutUser() {
        UIAlertController.showAlert(
            title: nil,
            message: AlertMessage.LOGOUT,
            actions: .Logout, .Cancel) { [weak self] action in
                if action == .Logout {
                    self?.viewModel.logout()
                }
            }
    }
}


//MARK: UITableViewDataSource & UITableViewDelegate
extension SettingViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.settings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.className, for: indexPath) as? SettingsTableViewCell else {
            return UITableViewCell()
        }
        cell.topConstraint.constant = 24
        tableView.separatorStyle = .none
        cell.separatorInset = UIEdgeInsets.zero
        cell.setData(viewModel.settings[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // The selected cell is tapped again, deselect it
        if let selectedIndexPath = tableView.indexPathForSelectedRow, selectedIndexPath == indexPath {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        clickedOnSetting(viewModel.settings[indexPath.row])
    }
}
