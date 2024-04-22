import UIKit


class ConfirmImageViewModel: BaseViewModel {
    
    var userHeight: Double?
    
    var image: UIImage?
    var frontImage: UIImage?
    var sideProfileImage: UIImage?
    
    func startMeasurement(complition: @escaping CompletionError) {
        guard let userHeight = userHeight,
              let frontImage = frontImage,
              let sideImage = sideProfileImage else {
            return
        }
        APIManager.shared.addBodyMeasurements(
            frontImage: Utility.fixImageOrientation(frontImage, orientation: .up),
            sideImage: Utility.fixImageOrientation(sideImage, orientation: .up),
            height: userHeight
        ) { [weak self] result in
            switch result {
            case .success(let measurements):
                if let _measurements = measurements {
                    self?.generateUserBody3DModel(_measurements, complition: complition)
                }
            case .failure(let error):
                complition(error)
            }
        }
    }
    
    private func generateUserBody3DModel(_ measurements: Measurements, complition: @escaping CompletionError) {
        guard let profile = AppInstance.shared.userProfile else {
            return
        }
        APIManager.shared.generateUser3DModel(
            age: profile.calcAge() ?? 0,
            gender: profile.gender?.rawValue ?? Gender.Male.rawValue,
            waist: measurements.waist ?? 0.0,
            chest: measurements.chest ?? 0.0,
            height: measurements.height ?? 0.0,
            complition: complition
        )
    }
}
