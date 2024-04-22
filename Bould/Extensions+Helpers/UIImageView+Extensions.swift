import UIKit
import AVFoundation
import AlamofireImage


extension UIImageView {
    
    func roundedCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}


extension UIImageView {
    
    func setProfileImage(_ url: String?) {
        guard let urlString = url else {
            return
        }
        let finalURL = ServerConfig.baseURL + urlString
        setImage(with: finalURL, placeholder: UIImage(systemName: "person.circle")?.withTintColor(.white, renderingMode: .alwaysTemplate))
    }
    
    func setImage(with urlString: String? , placeholder: UIImage? = UIImage(named: "image-placeholder"), completion: CompletionImage? = nil) {
        guard let urlString = urlString, let url = URL(string: urlString) else {
            completion?(nil, NSError.generate(message: "Incorrect Url"))
            return
        }
        if completion == nil {
            self.af.setImage(withURL: url, placeholderImage: placeholder)
            return
        }
        self.af.setImage(withURL: url, placeholderImage: placeholder, completion: { response in
            switch response.result {
            case .success(let image):
                completion?(image, nil)
            case .failure(let error):
                completion?(nil, error)
            }
        })
    }
    
    private func generateThumbnailFromVideoUrl(_ url: URL, _ completed: CompletionImage? = nil) {
        let asset = AVAsset(url: url)
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true
        let time = CMTimeMakeWithSeconds(3.0, preferredTimescale: 600)
        
        generator.generateCGImagesAsynchronously(forTimes: [NSValue(time: time)]) { (time, thumbnail, cmtime, result, error) in
            DispatchQueue.main.async {
                if (thumbnail != nil) {
                        self.image = UIImage(cgImage: thumbnail!)
                        completed?(UIImage(cgImage: thumbnail!), nil)
                } else {
                    completed?(nil, error)
                }
            }
        }
    }
}
