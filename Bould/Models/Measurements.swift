import Foundation


struct Measurements: Codable {
    
    let id: Int?
    var height: Float?
    var neck: Float?
    var hip: Float?
    var waist: Float?
    var chest: Float?
    var sleeve: Float?
    var shoulder: Float?
    
    var frontChest: Float?
    var backWidth: Float?
    var waistToHip: Float?
    var shoulderToWaist: Float?
    var insideLeg: Float?
    var outsideLeg: Float?
    
    let createdAt: String?
    let updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case height, neck, hip, shoulder
        case sleeve, waist, chest
        case frontChest         = "front_chest"
        case backWidth          = "back_width"
        case waistToHip         = "waist_to_hip"
        case shoulderToWaist    = "shoulder_to_waist"
        case insideLeg          = "inside_leg"
        case outsideLeg         = "outside_leg"
        case createdAt          = "created_at"
        case updatedAt          = "updated_at"
    }
}

//MARK: Iterate properties
extension Measurements {
    
    static let measurementKeys: [CodingKeys] = [
        .height, .neck, .shoulder, .sleeve, .frontChest, .backWidth, .chest,
        .shoulderToWaist, .waistToHip, .waist, .hip, .insideLeg, .outsideLeg
    ]
    
    func value(for key: Measurements.CodingKeys) -> Float? {
        switch key {
        case .height:
            return height
        case .neck:
            return neck
        case .hip:
            return hip
        case .waist:
            return waist
        case .chest:
            return chest
        case .sleeve:
            return sleeve
        case .shoulder:
            return shoulder
        case .frontChest:
            return frontChest
        case .backWidth:
            return backWidth
        case .waistToHip:
            return waistToHip
        case .shoulderToWaist:
            return shoulderToWaist
        case .insideLeg:
            return insideLeg
        case .outsideLeg:
            return outsideLeg
        default: return nil
        }
    }
    
    mutating func setValue(for key: Measurements.CodingKeys, value: Float) {
        switch key {
        case .height:
            height = value
        case .neck:
            neck = value
        case .hip:
            hip = value
        case .waist:
            waist = value
        case .chest:
            chest = value
        case .sleeve:
            sleeve = value
        case .shoulder:
            shoulder = value
        case .frontChest:
            frontChest = value
        case .backWidth:
            backWidth = value
        case .waistToHip:
            waistToHip = value
        case .shoulderToWaist:
            shoulderToWaist = value
        case .insideLeg:
            insideLeg = value
        case .outsideLeg:
            outsideLeg = value
        default: break
        }
    }
}
/*
struct Height: Codable {
    let feet: Int?
    let inch: Int?
    let cms: Float?
    
    enum CodingKeys: String, CodingKey {
        case feet, inch
        case cms
    }
}*/
