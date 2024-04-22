import UIKit


protocol QuickOptionsProtocol: AnyObject {
    func quickOptionSelected(_ option: Int?)
}


class QuickOptionsViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var closeButton: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    private let tableCellHeight: CGFloat = 56.0
    private let tableCellVSpace: CGFloat = 12.0
    private var selectedCellIndex: Int?
    weak var delegate: QuickOptionsProtocol?
    var screenTitle: String?
    var screenDescription: String?
    
    private var feedbackOptions: [FeedbackOptions]? {
        return AppInstance.shared.feedbackOptionsData?.feedbackOptions
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScreenLayout()
        titleLabel.text = screenTitle
        descriptionLabel.text = screenDescription
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        screenCloseButtonPressed()
    }
    
    
    private func setupScreenLayout() {
        titleLabel.font = UIFont(name: Fonts.interBlack, size: 24)
        descriptionLabel.font = UIFont(name: Fonts.laoSansProRegular, size: 16)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        tableView?.register(UINib(nibName: NeumorphicCheckboxTableViewCell.className, bundle: Bundle.main), forCellReuseIdentifier: NeumorphicCheckboxTableViewCell.className)
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        tableView.rowHeight = tableCellHeight + tableCellVSpace
    }
    
    private func screenCloseButtonPressed() {
        if let selectedIndex = selectedCellIndex {
            self.navigationController?.dismiss(animated: true)
            let selectedOption = feedbackOptions?[selectedIndex].id
            delegate?.quickOptionSelected(selectedOption)
            return
        }
        UIAlertController.showAlert(self, title: "", message: AlertMessage.INVALID_SELECTION)
    }
}


//MARK: UITableViewDataSource & UITableViewDelegate
extension QuickOptionsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedbackOptions?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NeumorphicCheckboxTableViewCell.className, for: indexPath) as? NeumorphicCheckboxTableViewCell else {
            return UITableViewCell()
        }
        cell.checkBoxSelect(selectedCellIndex == indexPath.row)
        cell.titleLabel.text = feedbackOptions?[indexPath.row].option
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCellIndex = indexPath.row
        tableView.reloadData()
    }
}
