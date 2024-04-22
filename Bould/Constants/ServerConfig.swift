import Foundation


struct ServerConfig {
    // static let baseURL              = "https://api.bouldhq.com/"
    // static let serverURL            = "https://api.bouldhq.com/api/"
    static let baseURL              = "https://51.20.40.126/"
    static let serverURL            = "https://51.20.40.126/"

    static let login                = "auth/login/"
    static let logout               = "auth/logout/"
    static let register             = "auth/signup/"
    static let forgotPassword       = "auth/forgotpassword/"
    static let phoneVerification    = "auth/phone_verification/"
    static let verifyOTP            = "auth/verify_otp/"
    static let userProfile          = "auth/profile/"
    
    static let uploadVideoFor3DModel    = "user/upload-video/" //----
    static let bodyMeasurements         = "user/body-measurements/"
    static let bodyMeasurementsPDF      = "user/body-measurements/pdf/"
    static let generateHuman3DModel     = "user/human-3d/"
    
    static let fetchUser3DModel         = "media/models/"
    static let feedback                 = "user/feedback/"
    static let deleteUserAccount        = "user/delete/"
    
    static let productTryOnResult       = "user/try-on/"
    
    static let fetchProductCategories   = "products/categories/"
    static let fetchProducts            = "products/get/"
    static let productImages            = "products/3d/" //----
    static let addProduct               = "products/add/" //----
    
    /*static func getUser3DModel(_ id: Int) -> String {
        return "http://16.171.223.32/media/models/model_\(id).obj"
    }*/
}
