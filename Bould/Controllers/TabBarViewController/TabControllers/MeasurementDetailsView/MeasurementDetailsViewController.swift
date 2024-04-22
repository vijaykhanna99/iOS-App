import UIKit


class MeasurementDetailsViewController: BaseViewController {
    
    @IBOutlet weak var subHeadingLabel: UILabel!
    @IBOutlet weak var headingLabel: UILabel!
    //@IBOutlet weak var filterByLabel: UILabel!
    @IBOutlet weak var bottomHeadingLabel: UILabel!
    @IBOutlet weak var measurementTableView: UITableView!
    
    //Measurements Details Views/Labels
    @IBOutlet weak var shoulderView: UIView!
    @IBOutlet weak var shoulderLabel: UILabel!
    
    @IBOutlet weak var neckView: UIView!
    @IBOutlet weak var neckLabel: UILabel!
    
    @IBOutlet weak var outsideLegView: UIView!
    @IBOutlet weak var outsideLegLabel: UILabel!
   
    @IBOutlet weak var insideLegView: UIView!
    @IBOutlet weak var insideLegLabel: UILabel!
    
    @IBOutlet weak var sleeveView: UIView!
    @IBOutlet weak var sleeveLabel: UILabel!
    
    @IBOutlet weak var backWidthView: UIView!
    @IBOutlet weak var backWidthLabel: UILabel!
    
    @IBOutlet weak var frontChestView: UIView!
    @IBOutlet weak var frontChestLabel: UILabel!
    
    @IBOutlet weak var shoulderToWaistView: UIView!
    @IBOutlet weak var shoulderToWaistLabel: UILabel!
    
    @IBOutlet weak var waistView: UIView!
    @IBOutlet weak var waistLabel: UILabel!
    
    @IBOutlet weak var hipView: UIView!
    @IBOutlet weak var hipLabel: UILabel!
    
    @IBOutlet weak var waistToHipView: UIView!
    @IBOutlet weak var waistToHipLabel: UILabel!
    
    @IBOutlet weak var bustView: UIView!
    @IBOutlet weak var bustLabel: UILabel!
    
    @IBOutlet weak var heightView: UIView!
    @IBOutlet weak var heightLabel: UILabel!
    
    private var isGradientAdded: Bool = false
    
    private lazy var viewModel: MeasurementDetailsViewModel = {
        let vwModel = MeasurementDetailsViewModel()
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
        title = "Fittings"
        setupScreenLayout()
        
        measurementTableView.dataSource = self
        measurementTableView.delegate = self
        initViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        removeBackButton()
        measurementTableView.reloadData()
    }
    
    
    /*@IBAction func uploadButtonPressed(_ sender: Any) {
        //goToCreateModelInstructionsScreen()
        AppInstance.shared.isRedo3dBodyScan = true
        SceneDelegate.sceneDelegate?.updateRootController()
    }
    @IBAction func searchButtonPressed(_ sender: Any) {
    }
    @IBAction func nextButtonPressed(_ sender: Any) {
    }*/
    
    
    private func setupScreenLayout() {
        //Add menu options in right side of nav-bar
        addNavBarMenuButton(menu: UIMenu.create(actions: .redoBodyScan, .updateMeasurement, handler: navBarMenuButtonPressed))
        
        //subHeadingLabel.font = UIFont(name: Fonts.laoSansProRegular, size: 12)
        headingLabel.font = UIFont(name: Fonts.laoSansProRegular, size: 18)
        //filterByLabel.font = UIFont(name: Fonts.laoSansProRegular, size: 14)
        bottomHeadingLabel.font = UIFont(name: Fonts.laoSansProRegular, size: 16)
        measurementTableView.rowHeight = 52.0        
        //Measurement details layout
        hideAllMeasurementViews()
        for label in [shoulderLabel, neckLabel, outsideLegLabel, insideLegLabel, sleeveLabel, backWidthLabel, frontChestLabel, shoulderToWaistLabel, waistLabel, hipLabel, waistToHipLabel, bustLabel, heightLabel] {
            label?.font = UIFont(name: Fonts.interSemiBold, size: 10)
        }
    }
    
    private func navBarMenuButtonPressed(_ action: MenuOption) {
        switch action {
        case .redoBodyScan:
            AppInstance.shared.isRedo3dBodyScan = true
            SceneDelegate.sceneDelegate?.updateRootController()
            break
        case .updateMeasurement:
            goToMeasurementUpdateScreen()
            break
        default: break
        }
    }
    
    private func hideAllMeasurementViews(_ isHide: Bool = true) {
        for view in [shoulderView, neckView, outsideLegView, insideLegView, sleeveView, backWidthView, frontChestView, shoulderToWaistView, waistView, hipView, waistToHipView, bustView, heightView] {
            view?.isHidden = isHide
            view?.layer.cornerRadius = 3
        }
    }
    
    private func showSelectedMeasurement(for key: Measurements.CodingKeys) {
        let value = viewModel.measurementValue(for: key)
        hideAllMeasurementViews()
        switch key {
        case .height:
            heightLabel.text = value
            heightView.isHidden = false
            return
        case .neck:
            neckLabel.text = value
            neckView.isHidden = false
            return
        case .hip:
            hipLabel.text = value
            hipView.isHidden = false
            return
        case .shoulder:
            shoulderLabel.text = value
            shoulderView.isHidden = false
            return
        case .sleeve:
            sleeveLabel.text = value
            sleeveView.isHidden = false
            return
        case .waist:
            waistLabel.text = value
            waistView.isHidden = false
            return
        case .chest:
            bustLabel.text = value
            bustView.isHidden = false
            return
        case .frontChest:
            frontChestLabel.text = value
            frontChestView.isHidden = false
            return
        case .backWidth:
            backWidthLabel.text = value
            backWidthView.isHidden = false
            return
        case .waistToHip:
            waistToHipLabel.text = value
            waistToHipView.isHidden = false
            return
        case .shoulderToWaist:
            shoulderToWaistLabel.text = value
            shoulderToWaistView.isHidden = false
            return
        case .insideLeg:
            insideLegLabel.text = value
            insideLegView.isHidden = false
            return
        case .outsideLeg:
            outsideLegLabel.text = value
            outsideLegView.isHidden = false
            return
        default: return
        }
    }
    
    private func initViewModel() {
        viewModel.reloadTableViewClosure = { [weak self] in
            self?.measurementTableView.reloadData()
        }
        //viewModel.getMeasurements()
    }
    
    private func goToMeasurementUpdateScreen() {
        DispatchQueue.main.async {
            guard let vc = Storyboard.Other.instantiateVC(type: MeasurementUpdateViewController.self) else {
                return
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    /*private func goToCreateModelInstructionsScreen() {
        DispatchQueue.main.async {
            guard let vc = UIStoryboard.main.instantiateVC(type: ScanningInstructionsViewController.self) else {
                return
            }
            vc.shouldNavBarShow = false
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }*/
}


//MARK: UITableViewDataSource & UITableViewDelegate
extension MeasurementDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.measurementsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MeasurementDetailTableViewCell.className, for: indexPath) as? MeasurementDetailTableViewCell else {
            return UITableViewCell()
        }
        tableView.separatorStyle = .none
        cell.separatorInset = UIEdgeInsets.zero
        cell.keyLabel.text = viewModel.measurementKey(at: indexPath.row).rawValue.snakeCaseToSentence()
        cell.valueLabel.text = viewModel.measurementValue(at: indexPath.row)
        //cell.setData(viewModel.measurements[indexPath.row])
        cell.backgroundColor = (indexPath.row % 2 == 0) ? UIColor(rgba: "#0D0B0B") : UIColor(rgba: "#1E1C1D")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // The selected cell is tapped again, deselect it
        if let selectedIndexPath = tableView.indexPathForSelectedRow, selectedIndexPath == indexPath {
            tableView.deselectRow(at: indexPath, animated: false)
        }
        showSelectedMeasurement(for: viewModel.measurementKey(at: indexPath.row))
    }
    
    /*MARK: Functionality Changed - Commented - 13/02/2024 ----
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let editAction = UIContextualAction(style: .normal, title: Strings.edit) { [weak self] (action:UIContextualAction, view:UIView, completion:CompletionBool) in
            self?.viewModel.selectedMeasurementAtIndex = indexPath.row
            //Open value update screen
            self?.openEditOptionScreen(
                fieldName: self?.viewModel.measurementKey(at: indexPath.row).rawValue.snakeCaseToSentence(),
                value: self?.viewModel.measurementValue(at: indexPath.row)
            )
            completion(true)
        }
        editAction.backgroundColor = .systemGreen
        // Set performsFirstActionWithFullSwipe to false to limit the width of the swipe action button
        let swipeActions = UISwipeActionsConfiguration(actions: [editAction])
        swipeActions.performsFirstActionWithFullSwipe = false
        return swipeActions
    }*/
}

/*MARK: Functionality Changed - Commented - 13/02/2024 ----
//MARK: EditOptionsProtocol / Measurement Update Functionality
extension MeasurementDetailsViewController: EditOptionsProtocol {
    
    func requestToUpdateValue(_ value: String?) {
        guard let _value = value, let updatedValue = Float(_value) else {
            return
        }
        self.viewModel.updateUserMeasurement(updatedValue)
    }
    
    private func openEditOptionScreen(fieldName: String?, value: String?) {
        DispatchQueue.main.async { [weak self] in
            guard let vc = Storyboard.Other.instantiateVC(type: EditOptionViewController.self) else {
                return
            }
            vc.delegate = self
            vc.validationRegex = #"^\d+(\.\d+)?$"#
            vc.currentValue = value
            if let _fieldName = fieldName {
                vc.labelText = _fieldName
                vc.screenTitle = "\(Strings.edit) \(_fieldName)"
                vc.textfieldPlaceholderText = _fieldName.uppercased()
            }
            self?.navigationController?.present(vc, animated: true)
        }
    }
}*/
