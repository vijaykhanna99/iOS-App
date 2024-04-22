import Foundation

extension Error {
    
    static func generate(code: Int? = nil, message: String? = AlertMessage.UNKNOWN_ERROR) -> NSError {
        var userInfo: [String: Any] = [:]
        if let code = code {
            userInfo[NSLocalizedFailureReasonErrorKey] = "\(code)"
        }
        userInfo[NSLocalizedDescriptionKey] = message

        return NSError(domain: "", code: code ?? 0, userInfo: userInfo)
    }
}
