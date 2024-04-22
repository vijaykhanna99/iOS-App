import UIKit


class AppFileManager: NSObject {
    
    static let shared = AppFileManager()
    private override init() {}
    
    private var defaultError: Error {
        return NSError(domain: "", code: -0, userInfo: [NSLocalizedDescriptionKey: AlertMessage.UNKNOWN_ERROR])
    }    
    
}


//MARK: File Permissions
extension AppFileManager {
    
    func checkAndRequestFilePermissions(vc viewController: UIViewController? = nil, at url: URL? = nil, complition: @escaping CompletionBool) {
        let fileManager = FileManager.default
        let documentsDirectory = url ?? fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        // Check if the app has write permissions to the Documents directory
        if fileManager.isWritableFile(atPath: documentsDirectory.path) || fileManager.isReadableFile(atPath: documentsDirectory.path) {
            print("File reading/writing is allowed.")
            complition(true)
        } else {
            requestFileWritingPermission(vc: viewController, complition: complition)
        }
    }
    
    func requestFileWritingPermission(vc viewController: UIViewController? = nil, at url: URL? = nil, complition: @escaping CompletionBool) {
        
        UIAlertController.showAlert(viewController,title: "Permission Required", message: "Bould requires permission to write files.", actions: .Allow, .Cancel) { action in
            if action == .Allow {
                Utility.openAppSettings { isSuccess in
                    complition(isSuccess)
                }
            } else {
                complition(false)
            }
        }
    }
}


//MARK: Access/Fetch Saved File
extension AppFileManager {
    
    func getDocDirFileURL(filename: String) -> URL? {
        // Get the document directory URL
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        // Append the filename to the document directory URL
        let fileURL = documentsDirectory.appendingPathComponent(filename)
        //Now check file exists or not at that URL
        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            return nil
        }
        return fileURL
    }
}


//MARK: Share any file to others
extension AppFileManager {
    
    func shareFile(vc viewController: UIViewController? = nil, fileURL: URL, sourceView: UIView? = nil, completionHandler: UIActivityViewController.CompletionWithItemsHandler? = nil) {
        shareSomething(vc: viewController, shareable: [fileURL], sourceView: sourceView, completionHandler: completionHandler)
    }
    
    func shareSomething(vc viewController: UIViewController? = nil, shareable: [Any], sourceView: UIView? = nil, completionHandler: UIActivityViewController.CompletionWithItemsHandler? = nil) {
        
        let targetVC = viewController ?? UIApplication.topViewController()
        // Create an activity view controller
        let activityViewController = UIActivityViewController(activityItems: shareable, applicationActivities: nil)
        //Set source view to popover presentation
        activityViewController.popoverPresentationController?.sourceView = sourceView ?? targetVC?.view
        // Set up a completion handler for the activity view controller
        activityViewController.completionWithItemsHandler = completionHandler
        // Present the activity view controller
        targetVC?.present(activityViewController, animated: true, completion: nil)
    }
}


//MARK: Save any file to local file storage
extension AppFileManager {
    
    func saveFileToDevice(vc viewController: UIViewController? = nil, filePath : String, complition: @escaping CompletionError) {
        saveFileToDevice(vc: viewController, fileURL: URL(string: filePath), complition: complition)
    }
    
    func saveFileToDevice(vc viewController: UIViewController? = nil, fileURL: URL?, complition: @escaping CompletionError) {
        guard let fileURL = fileURL else {
            complition(NSError.generate(message: "URL not found"))
            return
        }
        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            complition(NSError.generate(message: "File does not exist"))
            return
        }
        let targetVC = viewController ?? UIApplication.topViewController()
        let url = URL(fileURLWithPath: fileURL.path)
        
        let activityViewController: UIActivityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = targetVC?.view
        //If user on iPad
        if UIDevice.current.userInterfaceIdiom == .pad {
            if activityViewController.responds(to: #selector(getter: UIViewController.popoverPresentationController)) {
            }
        }
        targetVC?.present(activityViewController, animated: true, completion: nil)
        /*activityViewController.dismiss(animated: true) {
            complition(nil)
        }*/
        complition(nil)
    }
}


//MARK: Delete Saved Files
extension AppFileManager {
    
    func deleteDocumentDirectoryFiles(_ withExtension: String? = nil) -> Bool {
        guard let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return false
        }
        do {
            let fileURLs = try FileManager.default.contentsOfDirectory(at: documentsUrl,
                                                                       includingPropertiesForKeys: nil,
                                                                       options: .skipsHiddenFiles)
            if let fileExtension = withExtension {
                for fileURL in fileURLs where fileURL.pathExtension == fileExtension {
                    try FileManager.default.removeItem(at: fileURL)
                }
            } else {
                for fileURL in fileURLs {
                    try FileManager.default.removeItem(at: fileURL)
                }
            }
            print("\nDocument directory files with extension \(withExtension ?? "all files") deleted successfully.")
            return true
        } catch {
            print("\nError deleting document directory files with extension \(withExtension ?? "all files"): \(error)")
            return false
        }
    }
}
