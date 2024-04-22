import Foundation


//MARK: Fetch/Store Data
extension UserDefaults {
    
    private enum Keys {
        static let emailId = "emailId"
        static let password = "password"
        static let user3DFileUrl = "user3DFileUrl"
    }
    
    class var emailId: String? {
        get {
            return UserDefaults.standard.string(forKey: Keys.emailId)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.emailId)
        }
    }
    class var password: String? {
        get {
            return UserDefaults.standard.string(forKey: Keys.password)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.password)
        }
    }
    class var user3DFileUrl: URL? {
        get {
            return UserDefaults.standard.url(forKey: Keys.user3DFileUrl)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.user3DFileUrl)
        }
    }
}

//MARK: Clear All Data
extension UserDefaults {
    
    static func resetDefaults() {
        if let bundleID = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundleID)
            UserDefaults.standard.synchronize()
        }
    }
    
    static func clearAllData() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        for key in dictionary.keys {
            defaults.removeObject(forKey: key)
        }
    }
}

