//
//  Utility.swift
//  Bould
//
//  Created by Naveen on 17/10/23.
//

import UIKit

class Utility: NSObject {
    
    static private func openExternalURL(_ url: URL, completion: CompletionBool?) {
        UIApplication.shared.open(url, options: [:]) { isOpened in
            completion?(isOpened)
        }
    }
    
    static func openExternalLink(_ urlString: String, completion: CompletionBool? = nil) {
        guard let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) else {
            completion?(false)
            return
        }
        openExternalURL(url, completion: completion)
    }
    
    static func openAppSettings(completion: CompletionBool? = nil) {
        openExternalLink(UIApplication.openSettingsURLString, completion: completion)
    }
    
    static func phoneNumberEndingDigits(_ phoneNumber: String?) -> String? {
        guard let phoneNo = phoneNumber?.trimmed,
              phoneNo.isNumeric,
              phoneNo.count >= LimitCount.minimumPhoneNoLength  else {
            return nil
        }
        let startIndex = phoneNo.index(phoneNo.endIndex, offsetBy: -4)
        let lastFourDigits = phoneNo[startIndex...]
        return String(lastFourDigits)
    }
    
    static func securePhoneNumber(_ phoneNumber: String?) -> String {
        guard let phoneNo = Utility.phoneNumberEndingDigits(phoneNumber) else {
            return "****"
        }
        return "***\(phoneNo)"
    }
    
    static func currentUIOrientation() -> UIDeviceOrientation {
        let deviceOrientation = { () -> UIDeviceOrientation in
            switch UIApplication.shared.statusBarOrientation {
            case .landscapeLeft:
                return .landscapeRight
            case .landscapeRight:
                return .landscapeLeft
            case .portraitUpsideDown:
                return .portraitUpsideDown
            case .portrait, .unknown:
                return .portrait
            @unknown default:
                fatalError()
            }
        }
        guard Thread.isMainThread else {
            var currentOrientation: UIDeviceOrientation = .portrait
            DispatchQueue.main.sync {
                currentOrientation = deviceOrientation()
            }
            return currentOrientation
        }
        return deviceOrientation()
    }
    
    static func fixImageOrientation(_ image: UIImage, orientation: UIImage.Orientation) -> UIImage {
        guard image.imageOrientation != orientation else {
            return image
        }
        let renderer = UIGraphicsImageRenderer(size: image.size, format: image.imageRendererFormat)
        let fixedImage = renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: image.size))
        }
        return fixedImage
    }
}
