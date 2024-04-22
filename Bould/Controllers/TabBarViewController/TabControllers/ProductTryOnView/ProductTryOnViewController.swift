import UIKit
import SceneKit


class ProductTryOnViewController: BaseViewController {
    
    //Loading Views
    @IBOutlet weak var sceneLoadingView: UIView!
    @IBOutlet weak var sceneLoadingActivityIndicator: UIActivityIndicatorView!
    //3D view reference
    @IBOutlet weak var sceneView: SCNView!
    //Product Details
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productCategoryLabel: UILabel!
    @IBOutlet weak var productMaterialLabel: UILabel!
    @IBOutlet weak var productMaterialIconImage: UIImageView!
    @IBOutlet weak var productColorView: UIView!
    @IBOutlet weak var addToCartButton: UIButton!
    
    @IBOutlet weak var noProductsImageView: UIImageView!
    
    @IBOutlet weak var productCollectionView: UICollectionView!
    @IBOutlet weak var productTypeCollectionView: UICollectionView!
    private var isGradientAdded: Bool = false
    private var visibleProductCellIndex: Int = 0
    private var previousUserModelNodeName: String?
    
    //3D Scene reference
    private var scene: SCNScene?
    private var cameraNode: SCNNode?
    //private var lightNode: SCNNode?
    
    private lazy var viewModel: ProductTryOnViewModel = {
        let vwModel = ProductTryOnViewModel()
        self.baseVwModel = vwModel
        return vwModel
    }()

    //productMaterialIconImage
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if !isGradientAdded {
            isGradientAdded.toggle()
            view.addGradient()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        productTypeCollectionView.dataSource = self
        productTypeCollectionView.delegate = self
        productCollectionView.dataSource = self
        productCollectionView.delegate = self
        
        generate3DScene()
        initViewModel()
        addSwipeGesture()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        removeBackButton()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)        
    }
    
    private func setupLayout() {
        //Add menu options in right side of nav-bar
        addNavBarMenuButton(menu: UIMenu.create(actions: .redoBodyScan, handler: navBarMenuButtonPressed))
        
        productColorView.layer.cornerRadius = productColorView.frame.height / 2        
        productNameLabel.font = UIFont(name: Fonts.laoSansProRegular, size: 20)
        productCategoryLabel.font = UIFont(name: Fonts.laoSansProRegular, size: 15)
        productMaterialLabel.font = UIFont(name: Fonts.laoSansProRegular, size: 14)
        
        addToCartButton.contentEdgeInsets = UIEdgeInsets(top: 12, left: 20, bottom: 12, right: 20)
        addToCartButton.titleLabel?.font = UIFont(name: Fonts.laoSansProRegular, size: 12)
        addToCartButton.backgroundColor = UIColor(rgba: "#080707")
        addToCartButton.layer.cornerRadius = 16
    }
    
    private func initViewModel() {
        // Naive binding
        viewModel.onFetchedUser3DModel = { [weak self] fileURL in
            DispatchQueue.main.async {
                self?.load3DModel(fileURL)
            }
        }
        viewModel.onFetchedProductCategories = { [weak self] in
            DispatchQueue.main.async {
                self?.productTypeCollectionView.reloadData()
            }
        }
        viewModel.onFetchedProducts = { [weak self] isEmptyData in
            DispatchQueue.main.async {
                self?.isShowProductDetails(!isEmptyData)
                self?.noProductsImageView.isHidden = !isEmptyData
                //MARK: This func good to call to sync with auto selection on scroll
                //self?.showDetailsOf(product: self?.viewModel.selectedCategoryProducts()?.first)
                self?.productCollectionView.reloadData()
            }
        }
        viewModel.fetchUser3DModel()
        viewModel.fetchProductCategories()
    }
    
    private func addSwipeGesture(gestureDirections: [UISwipeGestureRecognizer.Direction] = [.up, .down]) {
        for direction in gestureDirections {
            let gesture = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
            gesture.direction = direction
            self.view.addGestureRecognizer(gesture)
        }
    }
    
    private func navBarMenuButtonPressed(_ action: MenuOption) {
        switch action {
        case .redoBodyScan:
            AppInstance.shared.isRedo3dBodyScan = true
            SceneDelegate.sceneDelegate?.updateRootController()
            break
        default: break
        }
    }
    
    @objc private func respondToSwipeGesture(swipeGesture: UISwipeGestureRecognizer) {
        if swipeGesture.direction == .down {
            print("\nSwiped down")
            tabBarController?.setTabBarHidden(true, animated: true)
        } else {
            print("\nSwiped up")
            tabBarController?.setTabBarHidden(false, animated: true)
        }
        if let gradientLayer = view.layer.sublayers?.first(where: { $0 is CAGradientLayer }) {
            gradientLayer.removeFromSuperlayer()
        }
        view.addGradient()
    }
    
    @IBAction func redoScanButtonPressed(_ sender: Any) {
        AppInstance.shared.isRedo3dBodyScan = true
        SceneDelegate.sceneDelegate?.updateRootController()
    }
    
    private func isShowProductDetails(_ isShow: Bool = true) {
        productNameLabel.text = "N/A"
        productCategoryLabel.text = "N/A"
        productColorView.backgroundColor = .clear
        addToCartButton.isEnabled = isShow
        /*productNameLabel.isHidden = !isShow
        productCategoryLabel.isHidden = !isShow
        productColorView.isHidden = !isShow
        addToCartButton.isHidden = !isShow
        productMaterialLabel.isHidden = !isShow
        productMaterialIconImage.isHidden = !isShow*/
    }
    
    private func showDetailsOf(product: Product?) {
        guard let _product = product else {
            return
        }
        productNameLabel.text = _product.title ?? "N/A"
        productCategoryLabel.text = _product.category?.name ?? "N/A"
        if let colorCode = _product.color {
            productColorView.backgroundColor = UIColor(rgba: colorCode)
        } else {
            productColorView.backgroundColor = .clear
        }
        //productMaterialLabel.text = product.label ?? "N/A"
        //productMaterialIconImage - these values are not coming from server ----
        //Now fetch selected product's 3D model/start try-on ---- remove ----
        sceneViewLoading(true)
        viewModel.selectedTryOnProductId = product?.id
        viewModel.fetchProductTryOnResult { [weak self] in
            DispatchQueue.main.async {
                self?.sceneViewLoading(false)
            }
        }
    }
    
    private func sceneViewLoading(_ isShow: Bool = false) {
        sceneLoadingView.isHidden = !isShow
        sceneLoadingActivityIndicator.isHidden = !isShow
        if isShow {
            sceneLoadingActivityIndicator.startAnimating()
        } else {
            sceneLoadingActivityIndicator.stopAnimating()
        }
    }
}


//MARK: 3D related functionality
extension ProductTryOnViewController {
    
    private func calculateCameraPosition(forPersonHeight height: Float) -> SCNVector3 {
        let tallestHeight: Float = 230.0 //7 ft 6 inch
        let shortestHeight: Float = 150.0 //4 ft 11 inch
        // Corresponding camera positions for tallest and shortest heights
        let tallestPosition = SCNVector3(0, 1.2, 2.4)
        let shortestPosition = SCNVector3(0, 0.7, 2) //z=1.9 min
        // Calculate interpolation factor
        let interpolationFactor = (height - shortestHeight) / (tallestHeight - shortestHeight)
        // Interpolate y and z values
        let interpolatedY = shortestPosition.y + interpolationFactor * (tallestPosition.y - shortestPosition.y)
        let interpolatedZ = shortestPosition.z + interpolationFactor * (tallestPosition.z - shortestPosition.z)
        // Return the final SCNVector3 for camera position
        return SCNVector3(0.0, interpolatedY, interpolatedZ)
    }
    
    /*
     MARK: Testing purpose - Remove before launch ----
     private func calculateLightPosition(_ cameraPosition: SCNVector3) -> SCNVector3 {
     return SCNVector3(x: cameraPosition.x, y: cameraPosition.y + 0.2, z: cameraPosition.z + 1.0)
     }*/
    
    private func generate3DScene() {
        scene = SCNScene()
        // Camera Node
        cameraNode = SCNNode()
        cameraNode?.camera = SCNCamera()
        cameraNode?.position = SCNVector3(0, 0.8, 2)
        scene?.rootNode.addChildNode(cameraNode!)
        /* MARK: Testing purpose - Remove before launch ----
         // Add omni/ambient light
         lightNode = SCNNode()
         lightNode?.light = SCNLight()
         lightNode?.light?.type = .omni
         lightNode?.light?.color = UIColor(white: 1.0, alpha: 1.0)
         //adjust light intensity as needed
         lightNode?.light?.intensity = 45
         //enable/disable shadows as needed
         //lightNode?.light?.castsShadow = true
         scene?.rootNode.addChildNode(lightNode!)*/
        // Allow user to manipulate camera
        sceneView.allowsCameraControl = true
        // Default Lighting
        sceneView.autoenablesDefaultLighting = true
        sceneView.backgroundColor = UIColor.clear
        //last step to add scene to sceneview
        sceneView.scene = scene
    }
    
    private func load3DModel(_ fileURL: URL?) {
        guard let _fileURL = fileURL,// UserDefaults.user3DFileUrl,
              let user3dModelScene = try? SCNScene(url: _fileURL) else {
            return
        }
        //Ensure user's minimum height is 100.0 cm and maximum is 300.0
        if let userHeight = viewModel.userHeight, userHeight > 100.0, userHeight < 300.0 {
            print("\nUser-Height: \(userHeight)")
            cameraNode?.position = calculateCameraPosition(forPersonHeight: userHeight)
            //lightNode?.position  = calculateLightPosition(adjustedCameraPosition)
        }
        //If previous node is available then Find the node by its name
        if let previousNodeName = previousUserModelNodeName,
           let nodeToRemove = scene?.rootNode.childNode(withName: previousNodeName, recursively: true) {
            // Remove the node from the scene
            nodeToRemove.removeFromParentNode()
        }
        print("\n\n********* Fetched URL: \(_fileURL) ***********")
        //Check if 3D model's root node name not exist then set the file name
        if user3dModelScene.rootNode.name?.isBlank ?? true {
            user3dModelScene.rootNode.name = _fileURL.lastPathComponent
        }
        //Store currently displaying node name
        previousUserModelNodeName = user3dModelScene.rootNode.name
        //Now to show this 3d model - add it to the scene as child node
        scene?.rootNode.addChildNode(user3dModelScene.rootNode)
        //sceneView.scene = scene
        rotateUser3DModel()
    }
    
    func rotateUser3DModel() {
        // Retrieve the model node using their respective name
        guard let userModelNodeName = previousUserModelNodeName,
              let userModelNode = sceneView.scene?.rootNode.childNode(
                withName: userModelNodeName,
                recursively: true
              ) else {
            return
        }
        // Rotate the model node continuously
        let rotateAction = SCNAction.rotateBy(x: 0, y: CGFloat.pi * 2, z: 0, duration: 10)
        let repeatAction = SCNAction.repeatForever(rotateAction)
        userModelNode.runAction(repeatAction)
    }
}


//MARK: Collection View functionalities
extension ProductTryOnViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == productCollectionView {
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        }
        let noOfCellsInRow = 3 //collectionView == productCollectionView ? 1 : 4
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        
        let totalSpace = flowLayout.sectionInset.left
        + flowLayout.sectionInset.right
        + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))
        
        let size = (collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow)
        return CGSize(width: size, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView == productTypeCollectionView ? viewModel.categories.count : viewModel.productCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //Case: cell for Product Type/Category
        if collectionView == productTypeCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductTypeCollectionViewCell.className, for: indexPath) as? ProductTypeCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.titleLabel.text = viewModel.categories[indexPath.row].name ?? "N/A"
            cell.isSelected(viewModel.selectedCategory?.id == viewModel.categories[indexPath.row].id)
            return cell
        }
        //Case: cell for actual Product
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.className, for: indexPath) as? ProductCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.tryButton.tag = indexPath.item
        cell.tryButton.addTarget(self, action: #selector(self.tryButtonClicked(_:)), for: .touchUpInside)
        cell.imageView.setImage(with: viewModel.productAt(indexPath.row)?.imageURL)
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //Case: Onclick Product Type/Category
        if collectionView == productTypeCollectionView {
            viewModel.selectCategoryAt(indexPath.row)
            productTypeCollectionView.reloadData()
            return
        }
        //Case: Onclick actual Product
    }
    
    /* MARK: Disabled because we doesn't fetch products and their 3d model on scroll - each model goes upto 20 MB
    //Retrieve index of currently centered cell in ProductCollectionView
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView as? UICollectionView) == productCollectionView {
            //ensure index is different from previous one
            guard let index = productCollectionView.centerCellIndexPath?.row,
                  visibleProductCellIndex != index,
                  index < viewModel.productCount() else {
                return
            }
            visibleProductCellIndex = index
            //Set centered cell product details
            showDetailsOf(product: viewModel.productAt(index))
        }
    }*/
    
    @objc func tryButtonClicked(_ sender: UIButton) {
        guard let product = viewModel.productAt(sender.tag) else {
            return
        }
        showDetailsOf(product: product)
        print("\n\nButton: \(sender.tag)")
    }
}
