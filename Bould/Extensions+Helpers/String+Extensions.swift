import Foundation


extension String {
    
    var trimmed: String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    //To check text field or String is blank or not
    var isBlank: Bool {
        get {
            return self.trimmed.isEmpty
        }
    }
    
    //Validate Email
    var isValidEmail: Bool {
        do {
            let regex = try NSRegularExpression(pattern: ValidationRegex.email, options: .caseInsensitive)
            return regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count)) != nil
        } catch {
            return false
        }
    }
    
    var isAlphanumeric: Bool {
        return !isEmpty && range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
    }
    
    var isNumeric: Bool {
        return !isEmpty && range(of: "[^+0-9]", options: .regularExpression) == nil
    }
    
    func isValidValue(_ validationRegex: String?) -> Bool {
        guard let _validationRegex = validationRegex else {
            return true
        }
        return !isEmpty && range(of: _validationRegex, options: .regularExpression) != nil
    }
    
    func camelCaseToNormal() -> String {
        var newValue = ""
        for (index, subString) in self.enumerated() {
            if index == 0 {
                newValue += "\(subString)".uppercased()
            } else {
                newValue += subString.isUppercase ? " \(subString)" : "\(subString)"
            }
        }
        return newValue
    }
    
    func snakeCaseToSentence() -> String {
        let words = self.replacingOccurrences(of: "_", with: " ")
        return words.capitalized
    }
}
