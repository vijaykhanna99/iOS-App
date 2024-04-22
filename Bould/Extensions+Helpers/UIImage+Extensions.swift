import UIKit


extension UIImage {
    
    func toBase64() -> String? {
        let imageData = self.pngData()
        return imageData?.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
    }
}
