import Foundation


class SubmitFeedbackViewModel: BaseViewModel {
        
    var overallExperience: Int?
    var inputFeedback: String?
    var scanFeedback: Int?
    var fitSatisfaction: Int?
    var appRating: Int?
    
    var userID: Int? {
        return AppInstance.shared.userProfile?.id
    }
    
    
    func submitFeedback(complition: @escaping CompletionVoid) {
        let feedback = Feedback(id: nil, userId: userID, appRating: appRating, scanFeedback: scanFeedback, fitSatisfaction: fitSatisfaction, overallExperience: overallExperience, inputFeedback: inputFeedback)
        
        self.isLoading = true
        APIManager.shared.submitFeedback(feedback) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let feedback):
                    print("\n---------- FeedBack Submitted: -------------\n\(String(describing: feedback))")
                    complition()
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
