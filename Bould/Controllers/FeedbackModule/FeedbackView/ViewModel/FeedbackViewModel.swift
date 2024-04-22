import Foundation


class FeedbackViewModel: BaseViewModel {
    
    var feedbackOptions: [FeedbackOptions]? {
        return AppInstance.shared.feedbackOptionsData?.feedbackOptions
    }
    
    var isShowOptions: Bool {
        return feedbackOptions != nil
    }
    
    func feedbackOptionAt(_ index: Int) -> String? {
        return feedbackOptions?[index].option
    }
    
    func feedbackValueAt(_ index: Int) -> Int? {
        return feedbackOptions?[index].id
    }
}

extension FeedbackViewModel {
    
    func checkFeedbackOptionsAvailability(complition: @escaping CompletionVoid) {
        if feedbackOptions != nil {
            complition()
            return
        }
        fetchFeedbackOptions(complition: complition)
    }
    
    private func fetchFeedbackOptions(complition: @escaping CompletionVoid) {
        APIManager.shared.fetchFeedbackOptions { [weak self] feedbackOptions in
            guard let _feedbackOptions = feedbackOptions else {
                self?.errorMessage = AlertMessage.UNKNOWN_ERROR
                return
            }
            AppInstance.shared.feedbackOptionsData = _feedbackOptions
            complition()
        }
    }
}
