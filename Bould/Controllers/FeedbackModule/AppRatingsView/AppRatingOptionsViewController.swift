import UIKit


class AppRatingOptionsViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var selectedCellIndex: Int?
    weak var delegate: QuickOptionsProtocol?
    
    private var appRatingOptions: [FeedbackOptions]? {
        return AppInstance.shared.feedbackOptionsData?.appRatingOptions
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScreenLayout()
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        screenCloseButtonPressed()
    }
    
    
    private func setupScreenLayout() {
        titleLabel.font = UIFont(name: Fonts.robotoBlack, size: 20)
        descriptionLabel.font = UIFont(name: Fonts.robotoMedium, size: 16)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        if let collectionViewFlowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            collectionViewFlowLayout.minimumLineSpacing = 0
            collectionViewFlowLayout.minimumInteritemSpacing = 0
            collectionViewFlowLayout.sectionInset = UIEdgeInsets.zero
        }
    }
    
    private func screenCloseButtonPressed() {
        if let selectedIndex = selectedCellIndex {
            self.navigationController?.dismiss(animated: true)
            let selectedOption = appRatingOptions?[selectedIndex].id
            delegate?.quickOptionSelected(selectedOption)
            return
        }
        UIAlertController.showAlert(self, title: "", message: AlertMessage.INVALID_SELECTION)
    }
}


//MARK: Collection View functionalities
extension AppRatingOptionsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let noOfCellsInRow = 5
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        
        let totalSpace = flowLayout.sectionInset.left
        + flowLayout.sectionInset.right
        + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))
        
        let size = (collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow)
        return CGSize(width: size, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return appRatingOptions?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AppRatingOptionCollectionViewCell.className, for: indexPath) as? AppRatingOptionCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.showSelectionEffect(selectedCellIndex == indexPath.row)
        cell.optionLabel.text = appRatingOptions?[indexPath.row].option
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("\nSelected App Rating: \(indexPath.row)")
        selectedCellIndex = indexPath.row
        collectionView.reloadData()
    }
}
