import Foundation


class SettingViewModel: BaseViewModel {
    
    var settings: [SettingOption] = SettingOption.allCases
    
    func downloadUserBodyMeasurementPDF(completion: @escaping CompletionURL) {
        APIManager.shared.fetchUserBodyMeasurementPDF { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let fileURL):
                    completion(fileURL)
                    print("\nDownloaded User Body Measurement File At: \n\(String(describing: fileURL))")
                case .failure(let error):
                    //completion(nil)
                    self?.errorMessage = error.localizedDescription
                    print("\nDownloaded User Body Measurement File Error: \n\(error.localizedDescription)")
                }
            }
        }
    }
    
    func logout() {
        guard APIManager.shared.isAuthenticated else {
            return
        }
        self.isLoading = true
        APIManager.shared.logout { [weak self] error in
            DispatchQueue.main.async {
                self?.isLoading = false
                if let _error = error {
                    self?.errorMessage = _error.localizedDescription
                    return
                }
                AppInstance.shared.clearSessionData()
                SceneDelegate.sceneDelegate?.updateRootController()
            }
        }
    }
}
