import Foundation


extension Int {
    
    func isInRange(_ range: ClosedRange<Int>) -> Bool {
        return range.contains(self)
    }
}
