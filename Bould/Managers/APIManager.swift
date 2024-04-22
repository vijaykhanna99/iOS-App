import UIKit
import Alamofire


class APIManager: NSObject {
    
    static let shared = APIManager()
    private override init() {}
    
    private var apiAuthToken: String?
    private let pageLimit: Int = 20
    
    private var defaultError: Error {
        return NSError(domain: "", code: 502, userInfo: [NSLocalizedDescriptionKey: AlertMessage.UNKNOWN_ERROR])
    }
 
    var authToken: String {
        if let token = apiAuthToken {
            return "Bearer \(token)"
        }
        return ""
    }
    
    var isAuthenticated: Bool {
        return !(apiAuthToken?.isBlank ?? true)
    }
    
    func isLoggedIn() -> Bool {
        return isAuthenticated && AppInstance.shared.isUserProfileExists
    }
    
    func cleanSessionData() {
        apiAuthToken = nil
    }
}


//MARK: Download Functionality
extension APIManager {
    
    func fetchUser3DModel(_ id: Int, complition: @escaping CompletionURLResult) {
        let url = ServerConfig.baseURL + ServerConfig.fetchUser3DModel + "model_\(id).usdz"
        downloadFile(url, fileName: "user3dmodel.usdz", complition: complition)
    }
    
    func fetchUserBodyMeasurementPDF(complition: @escaping CompletionURLResult) {
        let url = ServerConfig.serverURL + ServerConfig.bodyMeasurementsPDF
        downloadFile(url, fileName: "BodyMeasurementsPDF.pdf", complition: complition)
    }
}


//MARK: - Auth functions
extension APIManager {
    
    func registerUser(firstName: String,
                      lastName: String,
                      dob: Date,
                      gender: String,
                      email: String,
                      password: String,
                      complition: @escaping CompletionError) {
        let url = ServerConfig.register
        let userDOB = dob.stringFromDate(DateFormats.yyyy_MM_dd)
        
        let dict:[String : Any] = [
            "first_name": firstName,
            "last_name": lastName,
            "email": email,
            "gender": gender,
            "dob": userDOB,
            "password": password
        ]
        httpRequest(api: url, type: ApiResponse<AuthModel>.self, method: .post, parameters: dict, encoding: JSONEncoding.default) { [weak self] (response, error) in
            guard let response = response,
            response.haveValidStatus() == true else {
                complition(error ?? NSError.generate(code: response?.code, message: response?.message))
                return
            }
            self?.apiAuthToken = response.data?.authToken
            complition(nil)
        }
    }
    
    func loginUser(email: String, password: String, complition: @escaping CompletionError) {
        let url = ServerConfig.login
        let dict:[String : Any] = ["email": email, "password": password]
        
        httpRequest(api: url, type: ApiResponse<AuthModel>.self, method: .post, parameters: dict, encoding: JSONEncoding.default) { [weak self] (response, error) in
            guard let response = response,
            response.haveValidStatus() == true else {
                complition(error ?? NSError.generate(code: response?.code, message: response?.message))
                return
            }
            self?.apiAuthToken = response.data?.authToken
            complition(nil)
        }
    }
    
    func logout(complition: CompletionError? = nil) {
        httpRequest(
            api: ServerConfig.logout,
            type: ApiResponse<AuthModel>.self,
            method: .post,
            parameters: nil,
            encoding: JSONEncoding.default
        ) { (response, error) in
            guard let response = response,
                  response.haveValidStatus() == true else {
                complition?(error ?? NSError.generate(code: response?.code, message: response?.message))
                return
            }
            complition?(nil)
        }
    }
    
    func forgotPassword(email: String, complition: @escaping CompletionError) {
        let url = ServerConfig.forgotPassword
        httpRequest(api: url, type: ApiResponse<AuthModel>.self, method: .post, parameters: ["email": email], encoding: JSONEncoding.default) { (response, error) in
            guard let response = response,
            response.haveValidStatus() == true else {
                complition(error ?? NSError.generate(code: response?.code, message: response?.message))
                return
            }
            complition(nil)
        }
    }
    
    func phoneVerification(_ phoneNumber: String, countryCode: String, complition: @escaping CompletionError) {
        let url = ServerConfig.phoneVerification
        let dict:[String : Any] = ["phone": phoneNumber, "country_code": countryCode]
        
        httpRequest(api: url, type: ApiResponse<AuthModel>.self, method: .post, parameters: dict, encoding: JSONEncoding.default) { (response, error) in
            guard let response = response,
            response.haveValidStatus() == true else {
                complition(error ?? NSError.generate(code: response?.code, message: response?.message))
                return
            }
            complition(nil)
        }
    }
    
    func verifyOTP(_ OTPCode: String, complition: @escaping CompletionError) {
        let url = ServerConfig.verifyOTP
        httpRequest(api: url, type: ApiResponse<AuthModel>.self, method: .post, parameters: ["otp": OTPCode], encoding: JSONEncoding.default) { (response, error) in
            guard let response = response,
            response.haveValidStatus() == true else {
                complition(error ?? NSError.generate(code: response?.code, message: response?.message))
                return
            }
            complition(nil)
        }
    }
    
    func deleteUserAccount(complition: @escaping CompletionError) {
        httpRequest(
            api: ServerConfig.deleteUserAccount,
            type: ApiResponse<AuthModel>.self,
            method: .delete,
            encoding: JSONEncoding.default
        ) { (response, error) in
            guard let response = response,
                  response.haveValidStatus() == true else {
                complition(error ?? NSError.generate(code: response?.code, message: response?.message))
                return
            }
            complition(nil)
        }
    }
}


//MARK: User Functionalities
extension APIManager {
    
    func fetchUserProfile(complition: @escaping CompletionUserProfile) {
        httpRequest(api: ServerConfig.userProfile,
                    type: ApiResponse<UserProfile>.self,
                    method: .get,
                    encoding: JSONEncoding.default) { (response, error) in
            guard let response = response,
            response.haveValidStatus() == true else {
                complition(.failure(error ?? NSError.generate(code: response?.code, message: response?.message)))
                return
            }
            complition(.success(response.data))
        }
    }
    
    func updateUserMeasurements(_ measurements: Measurements, complition: @escaping CompletionUserProfile) {
        let parameters: [String: Any?] = [
            "measurements": measurements.toDictionary()?.compactMapValues({$0})
        ]
        httpRequest(
            api: ServerConfig.userProfile,
            type: ApiResponse<UserProfile>.self,
            method: .put,
            parameters: parameters.compactMapValues({$0}),
            encoding: JSONEncoding.default
        ) { (response, error) in
            guard let response = response,
                  response.haveValidStatus() == true else {
                complition(.failure(error ?? NSError.generate(code: response?.code, message: response?.message)))
                return
            }
            complition(.success(response.data))
        }
    }
    
    func updateUserProfile(_ profile: UserProfile, image: UIImage?, complition: @escaping CompletionUserProfile) {
        let parameters: [String: Any?] = [
            "first_name": profile.firstName,
            "last_name": profile.lastName,
            "email": profile.email,
            "gender": profile.gender,
            "date_of_birth": profile.dateOfBirth,
            "country_code": profile.countryCode,
            "phone_number": profile.phoneNumber,
            "company_name": profile.companyName,
            "address":  profile.address?.toDictionary(),
            "measurements": profile.measurements?.toDictionary()
        ]
        multipartRequest(
            method: .put,
            api: ServerConfig.userProfile,
            type: ApiResponse<UserProfile>.self,
            parameters: parameters.compactMapValues({$0}),
            imageNames: ["profile_picture"],
            images: [image]
        ) { (response, error) in
            guard let response = response,
                  response.haveValidStatus() == true else {
                complition(.failure(error ?? NSError.generate(code: response?.code, message: response?.message)))
                return
            }
            complition(.success(response.data))
        }
    }
    
    func addBodyMeasurements(frontImage: UIImage, sideImage: UIImage, height: Double, complition: @escaping CompletionMeasurements) {
        let url = ServerConfig.bodyMeasurements
        multipartRequest(api: url, type: ApiResponse<Measurements>.self, parameters: ["height": height], imageNames: ["frontImage", "sideImage"], images: [frontImage, sideImage]) { (response, error) in
            
            guard let response = response,
                  response.haveValidStatus() == true else {
                complition(.failure(error ?? NSError.generate(code: response?.code, message: response?.message)))
                return
            }
            AppInstance.shared.userProfile?.measurements = response.data
            print("\nBody Measurements API Response: \n\(String(describing: response.data))\n")
            complition(.success(response.data))
        }
    }
    
    func generateUser3DModel(age: Int, gender: String, waist: Float, chest: Float, height: Float, complition: @escaping CompletionError) {
        let url = ServerConfig.generateHuman3DModel
        let dict:[String : Any] = [
            "gender": gender,
            "age": age,
            "waist": waist,
            "chest": chest,
            "height": height
        ]
        httpRequest(api: url, type: ApiResponse<AuthModel>.self, method: .post, parameters: dict, encoding: JSONEncoding.default) { (response, error) in
            guard let response = response,
            response.haveValidStatus() == true else {
                complition(error ?? NSError.generate(code: response?.code, message: response?.message))
                return
            }
            complition(nil)
        }
    }
}


//MARK: Product Functionalities
extension APIManager {
    
    func fetchProductCategories(complition: @escaping (Result<[ProductCategory], Error>) -> Void) {
        httpRequest(api: ServerConfig.fetchProductCategories,
                    type: ApiResponse<[ProductCategory]>.self,
                    method: .get,
                    encoding: JSONEncoding.default) { (response, error) in
            guard let response = response,
            response.haveValidStatus() == true else {
                complition(.failure(error ?? NSError.generate(code: response?.code, message: response?.message)))
                return
            }
            complition(.success(response.data ?? []))
        }
    }
    
    func fetchProducts(page: Int = 1, category: String, complition: @escaping CompletionProducts) {
        httpRequest(api: ServerConfig.fetchProducts + "?page=\(page)&category=\(category)",
                    type: ApiResponse<[Product]>.self,
                    method: .get,
                    encoding: JSONEncoding.default) { (response, error) in
            guard let response = response,
            response.haveValidStatus() == true else {
                complition(.failure(error ?? NSError.generate(code: response?.code, message: response?.message)))
                return
            }
            complition(.success(response.data ?? []))
        }
    }
    
    func fetchProduct(id: Int, complition: @escaping CompletionProduct) {
        httpRequest(api: ServerConfig.fetchProducts + "\(id)/",
                    type: ApiResponse<Product>.self,
                    method: .get,
                    encoding: JSONEncoding.default) { (response, error) in
            guard let response = response,
            response.haveValidStatus() == true else {
                complition(.failure(error ?? NSError.generate(code: response?.code, message: response?.message)))
                return
            }
            complition(.success(response.data))
        }
    }
    
    func fetchProductImages(id: Int, complition: @escaping (Result<[String]?, Error>) -> Void) {
        httpRequest(api: ServerConfig.productImages + "\(id)/",
                    type: ApiResponse<[String]>.self,
                    method: .get,
                    encoding: JSONEncoding.default) { (response, error) in
            guard let response = response,
            response.haveValidStatus() == true else {
                complition(.failure(error ?? NSError.generate(code: response?.code, message: response?.message)))
                return
            }
            complition(.success(response.data))
        }
    }
    
    func addProduct(_ product: Product, complition: @escaping CompletionProduct) {
        httpRequest(
            api: ServerConfig.addProduct,
            type: ApiResponse<Product>.self,
            method: .post,
            parameters: product.toDictionary(),
            encoding: JSONEncoding.default
        ) { (response, error) in
            guard let response = response,
            response.haveValidStatus() == true else {
                complition(.failure(error ?? NSError.generate(code: response?.code, message: response?.message)))
                return
            }
            complition(.success(response.data))
        }
    }
}


//MARK: Product Try-On Functionalities
extension APIManager {
    
    func fetchProductTryOnResult(_ productId: Int, complition: @escaping CompletionStringResult) {
        let url = ServerConfig.productTryOnResult + "?product=\(productId)"
        
        httpRequest(api: url, type: ApiResponse<String>.self, method: .get) { (response, error) in
            guard let response = response,
                  response.haveValidStatus() == true else {
                let errorMessage = error?.localizedDescription ?? response?.message
                complition(.failure(NSError.generate(code: response?.code, message: errorMessage)))
                return
            }
            complition(.success(response.data))
        }
    }
}


//MARK: Feedback Functionalities
extension APIManager {
    
    func fetchFeedbackOptions(complition: @escaping CompletionFeedbackOptions) {
        httpRequest(api: ServerConfig.feedback,
                    type: ApiResponse<FeedbackOptionsResponse>.self,
                    method: .get,
                    encoding: JSONEncoding.default) { (response, error) in
            guard let response = response,
                  response.haveValidStatus() == true else {
                complition(nil)
                return
            }
            complition(response.data)
        }
    }
    
    func submitFeedback(_ feedback: Feedback, complition: @escaping CompletionFeedback) {
        httpRequest(
            api: ServerConfig.feedback,
            type: ApiResponse<Feedback>.self,
            method: .post,
            parameters: feedback.toDictionary(),
            encoding: JSONEncoding.default
        ) { (response, error) in
            guard let response = response,
                  response.haveValidStatus() == true else {
                complition(.failure(error ?? NSError.generate(code: response?.code, message: response?.message)))
                return
            }
            complition(.success(response.data))
        }
    }
}
