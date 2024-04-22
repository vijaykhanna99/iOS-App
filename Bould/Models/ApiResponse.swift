import Foundation


struct ApiResponse<T: Decodable>: Decodable {
    let data: T?
    let message: String?
    let code: Int?

    private enum CodingKeys: String, CodingKey {
        case data
        case message
        case code
    }
    
    func haveValidStatus() -> Bool {
        return self.code?.isInRange(200...299) ?? false
    }
}
