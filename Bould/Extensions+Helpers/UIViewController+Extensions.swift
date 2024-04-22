import UIKit


extension UIViewController {
    
    func addBackButton() {
        //let backButtonImage = UIImage(named: "back-button-icon") ?? UIImage(systemName: "chevron.backward")
        let backButton = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(backButtonTapped)
        )
        //backButton.imageInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        navigationItem.leftBarButtonItem = backButton
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    func removeBackButton() {
        navigationItem.leftBarButtonItem = nil
    }
    
    func addNavBarMenuButton(title: String? = nil, image: UIImage? = UIImage(systemName: "ellipsis"), menu: UIMenu) {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: title, image: image, menu: menu)
    }
}
