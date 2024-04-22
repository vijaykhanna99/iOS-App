import Foundation


class AuthModel: Decodable {
    
    let firstName, lastName, email: String?
    
    let tokens: [String]?
    var authToken: String? {
        return tokens?.first
    }
    
    enum CodingKeys: String, CodingKey {
        case email
        case firstName = "first_name"
        case lastName = "last_name"
        case tokens = "token"
    }
}
