import UIKit


class FeedbackViewController: BaseViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nextButton: UIButton!
    
    private let tableCellHeight: CGFloat = 56.0
    private let tableCellVSpace: CGFloat = 12.0
    private var isGradientAdded: Bool = false
    private var selectedCellIndex: Int?
    
    private lazy var viewModel: FeedbackViewModel = {
        let vwModel = FeedbackViewModel()
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
        initViewModel()
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        if selectedCellIndex == nil {
            UIAlertController.showAlert(self, title: "", message: AlertMessage.INVALID_SELECTION)
            return
        }
        goToInputFeedbackScreen()
    }
    
    
    private func setupScreenLayout() {
        titleLabel.font = UIFont(name: Fonts.interBold, size: 32)
        descriptionLabel.font = UIFont(name: Fonts.interSemiBold, size: 16)
        nextButton.titleLabel?.font = UIFont(name: Fonts.brunoAceRegular, size: 14)
        nextButton.layer.cornerRadius = 7
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView?.register(UINib(nibName: NeumorphicCheckboxTableViewCell.className, bundle: Bundle.main), forCellReuseIdentifier: NeumorphicCheckboxTableViewCell.className)
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        tableView.rowHeight = tableCellHeight + tableCellVSpace
    }
    
    private func initViewModel() {
        viewModel.checkFeedbackOptionsAvailability { [weak self] in
            DispatchQueue.main.async {
                guard let selfStrong = self else {
                    return
                }
                selfStrong.tableView.isHidden = !selfStrong.viewModel.isShowOptions
                selfStrong.nextButton.isHidden = !selfStrong.viewModel.isShowOptions
                if selfStrong.viewModel.isShowOptions {
                    selfStrong.tableView.reloadData()
                }
            }
        }
    }
    
    private func goToInputFeedbackScreen() {
        DispatchQueue.main.async { [weak self] in
            guard let vc = Storyboard.Feedback.instantiateVC(type: InputFeedbackViewController.self),
                  self?.viewModel.isShowOptions == true else {
                return
            }
            if let index = self?.selectedCellIndex {
                vc.overallExperience = self?.viewModel.feedbackValueAt(index)
            }
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}


//MARK: UITableViewDataSource & UITableViewDelegate
extension FeedbackViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.feedbackOptions?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NeumorphicCheckboxTableViewCell.className, for: indexPath) as? NeumorphicCheckboxTableViewCell else {
            return UITableViewCell()
        }
        cell.titleLabel.text = viewModel.feedbackOptionAt(indexPath.row)
        cell.checkBoxSelect(selectedCellIndex == indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCellIndex = indexPath.row
        tableView.reloadData()
    }
}
