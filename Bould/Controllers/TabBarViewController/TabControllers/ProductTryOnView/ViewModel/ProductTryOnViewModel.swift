import Foundation


class ProductTryOnViewModel: BaseViewModel {
    
    var productGroups: [ProductGroup] = []
    var categories: [ProductCategory] = []
    var selectedCategory: ProductCategory?
    var selectedTryOnProductId: Int?
    
    //binding to communicate with ViewController
    var onFetchedProductCategories: CompletionVoid?
    var onFetchedProducts: ((_ isEmptyData: Bool) -> Void)?
    var onFetchedUser3DModel: CompletionURL?
    
    private var isGotUser3DModelError: Bool = false
    
    var selectedModelFileName: String {
        return "try_on_product_\(selectedTryOnProductId ?? -1).usdz"
    }
    
    var userHeight: Float? {
        return AppInstance.shared.userProfile?.measurements?.height
    }
    
    func selectedCategoryIndex() -> Int? {
        return productGroups.firstIndex(where: { $0.category.id == selectedCategory?.id })
    }
    
    func selectedCategoryProducts() -> [Product]? {
        return productGroups.first(where: { $0.category.id == selectedCategory?.id })?.products
    }
    
    func productsOf(_ category: ProductCategory?) -> [Product]? {
        guard let categoryId = category?.id ?? selectedCategory?.id else {
            return nil
        }
        return productGroups.first(where: { $0.category.id == categoryId })?.products
    }
    
    func productCount() -> Int {
        return selectedCategoryProducts()?.count ?? 0
    }
    
    func productAt(_ index: Int) -> Product? {
        return selectedCategoryProducts()?[index]
    }
    
    func selectCategoryAt(_ index: Int) {
        selectedCategory = categories[index]
        if selectedCategoryIndex() == nil {
            fetchProducts()
        } else {
            onFetchedProducts?(false)
        }
    }
}


//MARK: User 3d Model Functionality
extension ProductTryOnViewModel {
    
    func fetchUser3DModel() {
        guard let userId = AppInstance.shared.userProfile?.id else {
            return
        }
        APIManager.shared.fetchUser3DModel(userId) { [weak self] result in
            switch result {
            case .success(let fileURL):
                UserDefaults.user3DFileUrl = fileURL
                self?.onFetchedUser3DModel?(fileURL)
                
            case .failure(let error):
                //Case: User 3D model not found
                if self?.isGotUser3DModelError == false, error.code == 404 {
                    //To stopped recursion / Stopped to call same fun again
                    self?.isGotUser3DModelError = true
                    self?.generateUserBody3DModel()
                    return
                }
                self?.errorMessage = error.localizedDescription
            }
        }
    }
    
    private func generateUserBody3DModel() {
        guard let profile = AppInstance.shared.userProfile else {
            return
        }
        APIManager.shared.generateUser3DModel(
            age: profile.calcAge() ?? 0,
            gender: profile.gender?.rawValue ?? Gender.Male.rawValue,
            waist: profile.measurements?.waist ?? 0.0,
            chest: profile.measurements?.chest ?? 0.0,
            height: profile.measurements?.height ?? 0.0) { [weak self] error in
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                    return
                }
                self?.fetchUser3DModel()
            }
    }
}

//MARK: Products Functionality
extension ProductTryOnViewModel {
    
    func fetchProductCategories(isReload: Bool = false) {
        if isReload {
            categories = []
            productGroups = []
            selectedCategory = nil
        }
        APIManager.shared.fetchProductCategories { [weak self] result in
            switch result {
            case .success(let categories):
                self?.categories = categories
                self?.selectedCategory = categories.first
                self?.onFetchedProductCategories?()
                self?.fetchProducts(isReload: isReload)
                print("\nTotal ProductCategories: \(categories.count)\n")
                
            case .failure(let error):
                self?.errorMessage = error.localizedDescription
            }
        }
    }
    
    func fetchProducts(isReload: Bool = false) {
        guard let category = selectedCategory else {
            return
        }
        let index = selectedCategoryIndex()
        if isReload, let _index = index {
            productGroups[_index].isNoMoreProducts = false
            productGroups[_index].page = 1
            productGroups[_index].products = []
        }
        APIManager.shared.fetchProducts(
            page: index==nil ? 1 : productGroups[index!].page,
            category: (index==nil ? category.name : productGroups[index!].category.name) ?? ""
        ) { [weak self] result in
            guard let strongSelf = self else {
                return
            }
            switch result {
            case .success(let products):
                if let _index = index {
                    if products.isEmpty && !strongSelf.productGroups[_index].products.isEmpty {
                        strongSelf.productGroups[_index].isNoMoreProducts = true
                    }
                    strongSelf.productGroups[_index].page += 1
                    strongSelf.productGroups[_index].products.append(contentsOf: products)
                } else {
                    let productGroup = ProductGroup(category: category, products: products, page: 2, isNoMoreProducts: false)
                    strongSelf.productGroups.append(productGroup)
                }
                strongSelf.onFetchedProducts?(false)
                print("\nTotal Products Fetched: \(products.count)\n")
                
            case .failure(_):
                strongSelf.onFetchedProducts?(true)
                //strongSelf.errorMessage = error.localizedDescription
            }
        }
    }
}


//MARK: Product Try-On Functionalities
extension ProductTryOnViewModel {
    
    func fetchProductTryOnResult(complition: @escaping CompletionVoid) {
        guard APIManager.shared.isLoggedIn() else {
            complition()
            return
        }
        guard let productId = selectedTryOnProductId else {
            complition()
            return
        }
        APIManager.shared.fetchProductTryOnResult(productId) { [weak self] result in
            switch result {
            case .success(let productTryOnURL):
                guard let urlString = productTryOnURL else {
                    complition()
                    return
                }
                self?.download3DTryOnModel(urlString, complition: complition)
                return
            case .failure(let error):
                complition()
                print("\nTry-On API Error: \(error.localizedDescription)")
                if error.code == 400 {
                    self?.validationErrorMessage = error.localizedDescription
                }
                return
            }
        }
    }
    
    private func download3DTryOnModel(_ tryProductURL: String?, complition: @escaping CompletionVoid) {
        guard let urlString = tryProductURL else {
            complition()
            return
        }
        if let storedFileURL = AppFileManager.shared.getDocDirFileURL(filename: selectedModelFileName) {
            onFetchedUser3DModel?(storedFileURL)
            complition()
            return
        }
        APIManager.shared.downloadFile(urlString, fileName: selectedModelFileName) { [weak self] result in
            switch result {
            case .success(let storedFileURL):
                self?.onFetchedUser3DModel?(storedFileURL)
            case .failure(let error):
                print("\nTry-On 3d Model Download Error: \(error.localizedDescription)")
            }
            complition()
        }
    }
}
