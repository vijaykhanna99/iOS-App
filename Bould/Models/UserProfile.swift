//
//  UserProfile.swift
//  Bould
//
//  Created by Naveen on 17/10/23.
//

import UIKit

class UserProfile: Codable {

    var id: Int?
    var firstName: String?
    var lastName: String?
    
    var email: String?
    var gender: Gender?
    var dateOfBirth: String?
    
    var countryCode: String?
    var phoneNumber: String?
    var isPhoneNoVerified: Bool?
    
    var companyName: String?
    var profilePicture: String?
    
    var createdAt: String?
    var updatedAt: String?    
    var deletedAt: String?
    
    var address: Address?
    var measurements: Measurements?
    
    var name: String? {
        guard let _firstName = firstName else {
            return nil
        }
        guard let _lastName = lastName else {
            return _firstName
        }
        return "\(_firstName) \(_lastName)"
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case gender
        case email
        case firstName = "first_name"
        case lastName = "last_name"
        case dateOfBirth = "date_of_birth"
        case countryCode = "country_code"
        case phoneNumber = "phone_number"
        case isPhoneNoVerified = "phone_is_verified"
        case companyName = "company_name"
        case profilePicture = "profile_picture"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case deletedAt = "deleted_at"
        case measurements
        case address
    }
    
    init(id: Int? = nil, firstName: String? = nil, lastName: String? = nil, email: String? = nil, gender: Gender? = nil, dateOfBirth: String? = nil, countryCode: String? = nil, phoneNumber: String? = nil, isPhoneNoVerified: Bool? = nil, companyName: String? = nil, profilePicture: String? = nil, createdAt: String? = nil, updatedAt: String? = nil, deletedAt: String? = nil, address: Address? = nil, measurements: Measurements? = nil) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.gender = gender
        self.dateOfBirth = dateOfBirth
        self.countryCode = countryCode
        self.phoneNumber = phoneNumber
        self.isPhoneNoVerified = isPhoneNoVerified
        self.companyName = companyName
        self.profilePicture = profilePicture
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.deletedAt = deletedAt
        self.address = address
        self.measurements = measurements
    }
    
    func calcAge() -> Int? {
        guard let dob = Date.dateFromString(dateOfBirth, format: DateFormats.yyyy_MM_dd) else {
            return nil
        }
        let ageComponents = Calendar.current.dateComponents([.year], from: dob, to: Date())
        return ageComponents.year
    }
}


class Address: Codable {
    var street: String?
    var city: String?
    var state: String?
    var postalCode: String?
    var country: String?
    var phoneNumber: String?
    
    private enum CodingKeys: String, CodingKey {
        case street, city, state, country
        case postalCode = "postal_code"
        case phoneNumber = "phone_number"
    }
}
