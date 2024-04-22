import Foundation


class MeasurementUpdateViewModel: BaseViewModel {
    
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
    
    
    func getMeasurements() {
        guard let measurements  = AppInstance.shared.userProfile?.measurements else {
            return
        }
        height          = measurements.height
        neck            = measurements.neck
        hip             = measurements.hip
        waist           = measurements.waist
        chest           = measurements.chest
        sleeve          = measurements.sleeve
        shoulder        = measurements.shoulder
        frontChest      = measurements.frontChest
        backWidth       = measurements.backWidth
        waistToHip      = measurements.waistToHip
        shoulderToWaist = measurements.shoulderToWaist
        insideLeg       = measurements.insideLeg
        outsideLeg      = measurements.outsideLeg
        //Now reload views with updated values
        reloadTableViewClosure?()
    }
    
    private func invalidValue(_ forkey: Measurements.CodingKeys) {
        self.validationErrorMessage = String(format: AlertMessage.INVALID_MEASUREMENT_VALUE, forkey.rawValue.snakeCaseToSentence())
    }
    
    private func validate() -> Measurements? {
        guard let _height = height, _height > 0 else {
            invalidValue(.height)
            return nil
        }
        guard let _neck = neck, _neck > 0 else {
            invalidValue(.neck)
            return nil
        }
        guard let _hip = hip, _hip > 0 else {
            invalidValue(.hip)
            return nil
        }
        guard let _waist = waist, _waist > 0 else {
            invalidValue(.waist)
            return nil
        }
        guard let _chest = chest, _chest > 0 else {
            invalidValue(.chest)
            return nil
        }
        guard let _sleeve = sleeve, _sleeve > 0 else {
            invalidValue(.sleeve)
            return nil
        }
        guard let _shoulder = shoulder, _shoulder > 0 else {
            invalidValue(.shoulder)
            return nil
        }
        guard let _frontChest = frontChest, _frontChest > 0 else {
            invalidValue(.frontChest)
            return nil
        }
        guard let _backWidth = backWidth, _backWidth > 0 else {
            invalidValue(.backWidth)
            return nil
        }
        guard let _waistToHip = waistToHip, _waistToHip > 0 else {
            invalidValue(.waistToHip)
            return nil
        }
        guard let _shoulderToWaist = shoulderToWaist, _shoulderToWaist > 0 else {
            invalidValue(.shoulderToWaist)
            return nil
        }
        guard let _insideLeg = insideLeg, _insideLeg > 0 else {
            invalidValue(.insideLeg)
            return nil
        }
        guard let _outsideLeg = outsideLeg, _outsideLeg > 0 else {
            invalidValue(.outsideLeg)
            return nil
        }
        return Measurements(id: nil, height: _height, neck: _neck, hip: _hip, waist: _waist, chest: _chest, sleeve: _sleeve, shoulder: _shoulder, frontChest: _frontChest, backWidth: _backWidth, waistToHip: _waistToHip, shoulderToWaist: _shoulderToWaist, insideLeg: _insideLeg, outsideLeg: _outsideLeg, createdAt: nil, updatedAt: nil)
    }
}


//MARK: Update Functionality
extension MeasurementUpdateViewModel {
    
    func updateUserMeasurement(successComplition: @escaping CompletionVoid) {
        guard let measurements = validate() else {
            return
        }
        guard APIManager.shared.isLoggedIn() else {
            return
        }
        isLoading = true
        APIManager.shared.updateUserMeasurements(measurements) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let profile):
                    AppInstance.shared.userProfile = profile
                    let _ = AppFileManager.shared.deleteDocumentDirectoryFiles("usdz")
                    //Now Update user 3d model
                    self?.updateUserBody3DModel(measurements, successComplition: successComplition)
                case .failure(let error):
                    self?.isLoading = false
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    private func updateUserBody3DModel(_ measurements: Measurements, successComplition: @escaping CompletionVoid) {
        guard let profile = AppInstance.shared.userProfile else {
            return
        }
        APIManager.shared.generateUser3DModel(
            age: profile.calcAge() ?? 0,
            gender: profile.gender?.rawValue ?? Gender.Male.rawValue,
            waist: measurements.waist ?? 0.0,
            chest: measurements.chest ?? 0.0,
            height: measurements.height ?? 0.0
        ) { [weak self] error in
            self?.isLoading = false
            successComplition()
        }
    }
}
