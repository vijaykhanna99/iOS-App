import Foundation


public struct Strings {
    static let am                           = "AM"
    static let pm                           = "PM"
    
    static let okay                         = "Okay"
    static let edit                         = "Edit"
    static let name                         = "Name"
    static let updated                      = "Updated"
    static let profileUpdated               = "Profile Updated"
    static let invalidOTP                   = "Invalid OTP"
    static let deniedORRestricted           = "Denied or Restricted"
    static let permissionNotDetermined      = "Permission not Determined"
    static let cameraAccessRequired         = "Camera Access is Required"
    static let trackingAccessRequired       = "Tracking Access is Required"
    
    static let camera                       = "Camera"
    static let gallary                      = "Gallary"
    static let cancel                       = "Cancel"
    static let warning                      = "Warning"
    static let chooseImage                  = "Choose Image"
    
    static let feet                         = "Feet"
    static let inches                       = "Inches"
    
    static let otpSent                      = "OTP Sent"
    static let otpReSent                    = "OTP Resent"
    
    static let confirm                      = "Confirm"
    static let upload                       = "Upload"
    static let Continue                     = "Continue"
    
    static let email                        = "Email"
    static let newEmail                     = "New Email"
    static let emailSent                    = "Email Sent"
    
    static let address                      = "Address"
    static let newAddress                   = "New Address"
    
    static let oldPassword                  = "Old Password"
    static let newPassword                  = "New Password"
    static let confirmNewPassword           = "Confirm New Password"
    static let changePassword               = "Change password?"
    static let accountDeletionConfirmation  = "Confirm Account Deletion?"
}

extension Strings {
    static let scanFeedback                 = "Scan Feedback"
    static let scanFeedbackDesc             = "We're eager to hear about your recent body scan. How was your experience?"
    
    static let fitSatisfactionSurvey        = "Fit Satisfaction Survey"
    static let fitSatisfactionSurveyDesc    = "Update values with ease. Modify settings effortlessly."
    
    static let editOption                   = "Edit Option"
    static let editOptionDesc               = "Update your preference swiftly. Tap 'Update' to save changes."
}


//MARK: Alert Messages
public struct AlertMessage {
    static let INVALID_VALUE                = "Please enter valid value."
    static let INVALID_NAME                 = "Please enter your full name."
    static let EMPTY_IMAGE_FIELD            = "Please select an image."
    static let INVALID_FIRST_NAME           = "Please enter first name."
    static let INVALID_LAST_NAME            = "Please enter last name."
    static let INVALID_GENDER               = "Please select Gender."
    static let INVALID_DOB                  = "Please select date of birth."
    static let EMPTY_EMAIL                  = "Please enter an email address"
    static let INVALID_EMAIL                = "Please enter a valid email address."
    static let INVALID_ADDRESS              = "Please enter your valid address."
    static let INVALID_COUNTRY_CODE         = "Please select valid country code."
    static let INVALID_PHONE_NUMBER         = "Please enter a valid phone number."
    static let INVALID_HEIGHT               = "Please enter your valid height."
    static let INVALID_SELECTION            = "Kindly choose one option from the available choices."
    static let INVALID_MEASUREMENT_VALUE    = "%@ measurement must be a valid number."
    
    static let NO_PASSWORD                  = "Please enter a minimum %d character password."
    static let OLD_PASSWORD                 = "Please enter old password."
    static let NEW_PASSWORD                 = "Please enter new password."
    static let CONFIRM_PASSWORD             = "Please enter confirm password."
    static let MISMATCH_PASSWORD            = "Password doesn't match with confirm"
    
    static let MISSING_OTP                  = "Please enter the OTP and then continue.."
    static let INVALID_OTP                  = "Invalid OTP. Please try again."
    static let WRONG_OTP                    = "Incorrect OTP. Please try again."
    
    static let UNKNOWN_AUTHORIZATION        = "Unknown authorization status."
    
    static let INVALID_INSTA_WEBPAGE        = "Invalid Instagram website URL."
    static let DEVICE_NOT_SUPPORT_CALL      = "Phone call not available on this device."
    static let DEVICE_NOT_SUPPORT_EMAIL     = "Email service is not available on this device."
        
    static let PHONE_OTP_VERIFICATION       = "We’ve sent a OTP to your registered number ending with %@. Please enter the OTP to complete phone verification."
    static let PHONE_OTP_RESEND             = "We’ve sent a new OTP to your registered number ending with %@. Please enter new OTP to complete the phone verification."
    
    static let EMAIL_FAILED                 = "Email sending failed."
    static let EMAIL_CANCELLED              = "Email cancelled."
    static let EMAIL_SAVED                  = "Email saved as a draft."
    static let EMAIL_SENT                   = "Email sent successfully."
    static let PASS_RESET_EMAIL_SENT        = "Password reset email sent successfully"
    
    static let PROFILE_UPDATED              = "Your profile updated successfully."
    static let FEEDBACK_SUBMITTED           = "Thanks for your feedback! 🌟 We appreciate it. Your input helps us improve. Keep exploring and let us know if you need anything else!"
    
    static let CAMERA_NOT_FOUND             = "Unable to detect camera in device"
    static let CAMERA_ACCESS_PERMISSION     = "Please allow Bould camera access within the settings app."
    static let TRACKING_ACCESS_PERMISSION   = "Please allow Bould tracking access within the settings app."
    
    static let LOGOUT                       = "Do you want to logout?"
    static let UNKNOWN_ERROR                = "Something went wrong, please try again later."
    static let SERVER_NOT_RESPONDING        = "We are facing some issue. Please try after some time."
    static let ACCOUNT_DELETE_CONFIRMATION  = "Are you sure you want to delete your account? Reply 'DELETE' to proceed, or 'CANCEL' to keep your account."
}
