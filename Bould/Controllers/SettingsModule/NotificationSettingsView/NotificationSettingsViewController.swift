import UIKit


class NotificationSettingsViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    private var isGradientAdded: Bool = false
    
    private lazy var viewModel: NotificationSettingsViewModel = {
        let vwModel = NotificationSettingsViewModel()
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
        setupScreenLayout()
        initializeViewModel()
    }
    
    
    private func setupScreenLayout() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = false
        tableView?.register(UINib(nibName: ToggleOptionTableViewCell.className, bundle: Bundle.main), forCellReuseIdentifier: ToggleOptionTableViewCell.className)
    }
    
    private func initializeViewModel() {
        // Naive binding
        viewModel.reloadTableViewClosure = { [weak self] () in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        viewModel.fetchNotificationSettings()
    }
}


//MARK: UITableViewDataSource & UITableViewDelegate
extension NotificationSettingsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.settings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ToggleOptionTableViewCell.className, for: indexPath) as? ToggleOptionTableViewCell else {
            return UITableViewCell()
        }
        let setting = viewModel.settings[indexPath.row]
        cell.updateCellViewFor(setting)
        //Set Notification Settings Data
        switch setting {
        case .enableNotifications:
            cell.singleSwitch.isOn = !viewModel.isDNDOn
            break
        case .accountNotifications:
            cell.firstOptionSwitch.isOn = viewModel.isAccountNotificationsEmailOn
            break
        case .orderNotifications:
            cell.firstOptionSwitch.isOn = viewModel.isOrderNotificationsEmailOn
            cell.secondOptionSwitch.isOn = viewModel.isOrderNotificationsSmsOn
            break
        case .appUpdates:
            cell.firstOptionSwitch.isOn = viewModel.isAppUpdatesOn
            break
        }
        //Update DND Mode        
        cell.firstOptionSwitch.isEnabled = !viewModel.isDNDOn
        cell.secondOptionSwitch.isEnabled = !viewModel.isDNDOn
        
        cell.delegate = self
        return cell
    }
}


//MARK: Implement ToggleOptionTableCellDelegate
extension NotificationSettingsViewController: ToggleOptionTableCellDelegate {
    
    func switchStateChangedHandler(_ setting: NotificationSettingsType, type: ToggleOptionSwitchType, isOn: Bool) {
        switch setting {
        case .enableNotifications:
            viewModel.notificationSettings?.isDNDOn = !isOn
            tableView.reloadData()
            break
        case .accountNotifications:
            viewModel.notificationSettings?.accountNotificationSettings?.isEmailOn = isOn
            break
        case .orderNotifications:
            if type == .Second {
                viewModel.notificationSettings?.orderNotificationSettings?.isSmsOn = isOn
            } else {
                viewModel.notificationSettings?.orderNotificationSettings?.isEmailOn = isOn
            }
            break
        case .appUpdates:
            viewModel.notificationSettings?.isAppUpdatesOn = isOn
            break
        }
        viewModel.updateNotificationSettings()
    }
}

