import Foundation

enum HttpType: String {
    case GET
    case POST
    case PUT
    case DELETE
}


enum APIService {
    
    case login(_ param: [String: Any])
    case register(_ param: [String: Any])
    case forgotPassword(_ param: [String: Any])
    case phoneVerification(_ param: [String: Any])
    case verifyOTP(_ param: [String: Any])
    case bodyMeasurements(_ param: [String: Any], headers: [String: Any])
    case updateAccountDetails(_ param: [String: Any], headers: [String: Any])
    case fetchProducts(headers: [String: Any])
    case addProduct(_ param: [String: Any], headers: [String: Any])
    
}

extension APIService {
    
    private var _basePath: String {
        return "https://4de2-2401-4900-1c2b-44eb-b48f-d6d9-7bd0-5592.ngrok-free.app"
    }
    
    private var _apiVersion: String {
        return "/api/"
    }
    
    private var _module: String {
        switch self {
        case .login, .register, .forgotPassword, .phoneVerification, .verifyOTP:
            return "/auth/"
        case .bodyMeasurements, .updateAccountDetails:
            return "/user/"
        case .fetchProducts, .addProduct:
            return "/products/"
        }
    }
    
    var url: String {
        return _basePath + _apiVersion + _module + _urlPath
    }
}

extension APIService {
    
    fileprivate var _urlPath: String {
        switch self {
        case .login:
            return "login/"
            
        case .register:
            return "signup/"
            
        case .forgotPassword:
            return "forgotpassword/"
            
        case .phoneVerification:
            return "phone_verification/"
            
        case .verifyOTP:
            return "verify_otp/"
            
        case .bodyMeasurements:
            return "body-measurements/"
            
        case .updateAccountDetails:
            return "update-account"
            
        case .fetchProducts:
            return "get/"
            
        case .addProduct:
            return "add/"
        }
    }
}

extension APIService {
    
    var parameters: [String: Any] {
        switch self {
        case .login(let params), .register(let params), .forgotPassword(let params):
            return params
        case .phoneVerification(let params), .verifyOTP(let params):
            return params
        case .bodyMeasurements(let params, _):
            return params
        case .updateAccountDetails(let param, _):
            return param
        case .addProduct(let param, _):
            return param
        default:
            return [:]
        }
    }
    
    var headerParameter: [String: Any] {
        switch self {
        case .login, .register, .forgotPassword, .phoneVerification, .verifyOTP:
            var headers: [String: Any] = [:]
            headers[HTTPHeaderKey.contentType] = HTTPHeaderValue.contentType
            return headers
        case .bodyMeasurements(_, let headers), .updateAccountDetails(_, let headers), .addProduct(_, let headers):
            var allHeaders = headers
            allHeaders[HTTPHeaderKey.contentType] = HTTPHeaderValue.contentType
            return allHeaders
        case .fetchProducts(headers: let headers):
            var allHeaders = headers
            allHeaders[HTTPHeaderKey.contentType] = HTTPHeaderValue.contentType
            return allHeaders
        }
    }
    
    private var authToken: String {
        return "Bearer "
    }
}

extension APIService {
    
    var method: HttpType {
        switch self {
        case .login, .register, .forgotPassword, .phoneVerification, .verifyOTP, .bodyMeasurements:
            return .POST
        case .updateAccountDetails:
            return .PUT
        default:
            return .GET
        }
    }
}


//MARK: HTTPHeader
struct HTTPHeaderKey {
    static let authorization = "Authorization"
    static let contentType = "Content-Type"
}

struct HTTPHeaderValue {
    static let contentType = "application/json"
    static let multipartFormdata = "multipart/form-data"
}

struct ContenType {
    static let imagePng = "image/png"
    static let imageJpeg = "image/jpeg"
    static let imageGif = "image/gif"
    static let imagePjpeg = "image/pjpeg"
}
