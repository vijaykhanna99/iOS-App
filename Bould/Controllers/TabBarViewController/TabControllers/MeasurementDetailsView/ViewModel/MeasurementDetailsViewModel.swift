import Foundation


class MeasurementDetailsViewModel: BaseViewModel {
    var selectedMeasurementAtIndex: Int?
    //var measurements: [[String: Float]] = []
    
    var measurements: Measurements? {
        return AppInstance.shared.userProfile?.measurements
    }
    
    var measurementsCount: Int {
        return Measurements.measurementKeys.count
    }
    
    func measurementKey(at index: Int) -> Measurements.CodingKeys {
        return Measurements.measurementKeys[index]
    }
    
    func measurementValue(at index: Int) -> String {
        if let measurement = measurements?.value(for: Measurements.measurementKeys[index]) {
            return "\(measurement)"
        }
        return ""
    }
    
    func measurementValue(for key: Measurements.CodingKeys) -> String {
        if let measurement = measurements?.value(for: key) {
            return "\(measurement)"
        }
        return ""
    }
    
    /*MARK: Functionality Changed - Commented - 13/02/2024 ----
    func updateUserMeasurement(_ value: Float) {
        guard APIManager.shared.isLoggedIn() else {
            return
        }
        guard let index = selectedMeasurementAtIndex, var measurements = measurements else {
            return
        }
        measurements.setValue(for: measurementKey(at: index), value: value)
        
        APIManager.shared.updateUserMeasurements(measurements) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let profile):
                    AppInstance.shared.userProfile = profile
                    let _ = AppFileManager.shared.deleteDocumentDirectoryFiles("usdz")
                    self?.reloadTableViewClosure?()
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }*/
}
