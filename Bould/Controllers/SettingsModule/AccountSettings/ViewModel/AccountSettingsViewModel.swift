import UIKit


class AccountSettingsViewModel: BaseViewModel {
    //Account Settings Options
    var accountSettings: [AccountSettings] = AccountSettings.allCases
    
    
    func clickedOnSetting(_ setting: AccountSettings) {
        switch setting {
        case .phoneSettings:
            Utility.openAppSettings()
            break
        case .deleteAccount:
            //Start Delete Account Process
            accountDeletionConfirmation()
            break
        }
    }
}

//MARK: Delete Process
extension AccountSettingsViewModel {
    
    private func accountDeletionConfirmation() {
        UIAlertController.showAlert(
            title: Strings.accountDeletionConfirmation,
            message: AlertMessage.ACCOUNT_DELETE_CONFIRMATION,
            actions: .Delete, .Cancel) { [weak self] action in
                if action == .Delete {
                    self?.deleteUserAccount()
                }
            }
    }
    
    private func deleteUserAccount() {
        isLoading = true
        APIManager.shared.deleteUserAccount { [weak self] error in
            self?.isLoading = false
            
            if let _error = error {
                self?.errorMessage = _error.localizedDescription
                return
            }
            //Delete User's Local Credentials and Logout
            AppInstance.shared.clearSessionData()
            SceneDelegate.sceneDelegate?.updateRootController()
        }
    }
}
