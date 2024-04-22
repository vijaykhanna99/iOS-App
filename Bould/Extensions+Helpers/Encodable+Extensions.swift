import Foundation


extension Encodable {
    
    func toDictionary() -> [String: Any]? {
        do {
            let jsonEncoder = JSONEncoder()
            let jsonData = try jsonEncoder.encode(self)
            if let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                return jsonObject
            }
        } catch {
            print("\nError converting model to dictionary: \n\(error)\n")
            return nil
        }
        return nil
    }
}
