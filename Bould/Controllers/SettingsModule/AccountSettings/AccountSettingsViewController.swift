import UIKit


class AccountSettingsViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    private var isGradientAdded: Bool = false
    
    private lazy var viewModel: AccountSettingsViewModel = {
        let vwModel = AccountSettingsViewModel()
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
}


//MARK: UITableViewDataSource & UITableViewDelegate
extension AccountSettingsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.accountSettings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.className, for: indexPath) as? SettingsTableViewCell else {
            return UITableViewCell()
        }
        cell.topConstraint.constant = 30
        tableView.separatorStyle = .none
        cell.separatorInset = UIEdgeInsets.zero
        cell.titleLabel.text = viewModel.accountSettings[indexPath.row].title
        cell.descLabel.text = viewModel.accountSettings[indexPath.row].description
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // The selected cell is tapped again, deselect it
        if let selectedIndexPath = tableView.indexPathForSelectedRow, selectedIndexPath == indexPath {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        viewModel.clickedOnSetting(viewModel.accountSettings[indexPath.row])
    }
}
