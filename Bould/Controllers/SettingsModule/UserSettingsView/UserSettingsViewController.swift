import UIKit


class UserSettingsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private var isGradientAdded: Bool = false
    private var userSettings: [UserSettings] = UserSettings.allCases
    
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func setupScreenLayout() {
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView?.register(UINib(nibName: SettingsTableViewCell.className, bundle: Bundle.main), forCellReuseIdentifier: SettingsTableViewCell.className)
    }
    
    private func clickedOnSetting(_ setting: UserSettings) {
        var viewController: UIViewController?
        //Check which screen to navigate to
        switch setting {
        case .profileSettings:
            viewController = Storyboard.Setting.instantiateVC(type: ProfileSettingsViewController.self)
            viewController?.hidesBottomBarWhenPushed = true
            break
        case .notificationSettings:
            viewController = Storyboard.Setting.instantiateVC(type: NotificationSettingsViewController.self)
            viewController?.hidesBottomBarWhenPushed = true
            break
        case .accountSettings:
            viewController = Storyboard.Setting.instantiateVC(type: AccountSettingsViewController.self)
            break
        //default: break
        }
        //Just push view controller if not nil
        if let vc = viewController {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}


//MARK: UITableViewDataSource & UITableViewDelegate
extension UserSettingsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        userSettings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.className, for: indexPath) as? SettingsTableViewCell else {
            return UITableViewCell()
        }
        cell.topConstraint.constant = 30
        tableView.separatorStyle = .none
        cell.titleLabel.text = userSettings[indexPath.row].title
        cell.descLabel.text = userSettings[indexPath.row].description
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // The selected cell is tapped again, deselect it
        if let selectedIndexPath = tableView.indexPathForSelectedRow, selectedIndexPath == indexPath {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        clickedOnSetting(userSettings[indexPath.row])
    }
}
