import Foundation


//MARK: Submit Feedback Model
struct Feedback: Codable {
    
    let id: Int?
    let userId: Int?
    let appRating: Int?
    let scanFeedback: Int?
    let fitSatisfaction: Int?
    let overallExperience: Int?
    let inputFeedback: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId             = "user"
        case appRating          = "app_rating"
        case scanFeedback       = "scan_feedback"
        case fitSatisfaction    = "fit_satisfaction"
        case overallExperience  = "overall_experience"
        case inputFeedback      = "input_feedback"
    }
}


//MARK: Provide options to user
struct FeedbackOptions: Codable {
    let id: Int?
    let option: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case option
    }
}

//MARK: To fetch options from server
struct FeedbackOptionsResponse: Codable {
    let feedbackOptions: [FeedbackOptions]?
    let appRatingOptions: [FeedbackOptions]?
    
    enum CodingKeys: String, CodingKey {
        case feedbackOptions    = "feedback_options"
        case appRatingOptions   = "app_rating_options"
    }
}


