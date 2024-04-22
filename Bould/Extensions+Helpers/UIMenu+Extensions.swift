import UIKit


typealias MenuOptionHandler = (_ action: MenuOption) -> Void

enum MenuOption: String {
    case updateMeasurement
    case redoBodyScan
    case rename
    case move
    
    var title: String {
        self.rawValue.camelCaseToNormal()
    }
    
    var image: String {
        switch self {
        case .updateMeasurement:
            return "arrow.triangle.2.circlepath.icloud"
        case .redoBodyScan:
            return "arrow.counterclockwise"
        case .rename:
            return "pencil"
        case .move:
            return "folder"
        }
    }
}


extension UIMenu {
    
    static func create(title: String = "", image: UIImage? = nil, actions: MenuOption..., handler: MenuOptionHandler?) -> UIMenu {
        var children: [UIMenuElement] = []
        for action in actions {
            children.append(UIAction(title: action.title, image: UIImage(systemName: action.image), handler: { _ in
                handler?(action)
            }))
        }
        return UIMenu(title: title, image: image, children: children)
    }
}
