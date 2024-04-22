import UIKit


enum Storyboard: String {
    case Welcome
    case Feedback
    case Auth
    case Help
    case Other
    case Home
    case Scanning
    case Setting
}


extension Storyboard {

    var instance: UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }
    
    func instantiateVC<T: UIViewController>(type: T.Type) -> T? {
        return instance.instantiateViewController(withIdentifier: type.className) as? T
    }
}
