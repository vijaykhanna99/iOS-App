import UIKit
import AVFoundation
import CoreVideo
import MLImage
import MLKit


class ScanningMeasurementViewController: UIViewController {
    
    @IBOutlet weak var topDetailsView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var rotateButton: UIButton!
    @IBOutlet weak var captureButton: UIButton!
    @IBOutlet weak var layoutButton: UIButton!
    
    var userHeight: Double?
    var detectBodyPose: BodyPose = .frontProfile
    private var poseDetector: PoseDetector?
    private var frontImage: UIImage?
    
    private var isGradientAdded: Bool = false
    private var imageTimerSeconds = 0
    private var imageCaptureTimer: Timer?
    
    private var isUsingFrontCamera = true
    private var previewLayer: AVCaptureVideoPreviewLayer?
    private lazy var captureSession = AVCaptureSession()
    private lazy var sessionQueue = DispatchQueue(label: MLModelConstants.sessionQueueLabel)
    private var lastFrame: CMSampleBuffer?
    //private var deviceInput: AVCaptureDeviceInput?
    private var photoOutput: AVCapturePhotoOutput?
    
    private lazy var previewOverlayView: UIImageView = {
        precondition(isViewLoaded)
        let previewOverlayView = UIImageView(frame: .zero)
        previewOverlayView.contentMode = UIView.ContentMode.scaleAspectFill
        previewOverlayView.translatesAutoresizingMaskIntoConstraints = false
        return previewOverlayView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addBackButton()
        setupLayout()
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer?.videoGravity = .resizeAspectFill
        setUpPreviewOverlayView()
        setUpCaptureSessionInput()
        setUpCaptureSessionOutput()
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !isGradientAdded {
            isGradientAdded.toggle()
            setTopDetailsViewLayout()
        }
        startSession()
        validateUserHeight()
        // Disable auto-lock while the camera view is active
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        stopSession()
        resetCapturedImageData()
        // Enable auto-lock when the camera view is not active
        UIApplication.shared.isIdleTimerDisabled = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        previewLayer?.frame = cameraView.frame
    }
    
    @IBAction func changeCameraButtonPressed(_ sender: Any) {
        isUsingFrontCamera = !isUsingFrontCamera
        setUpCaptureSessionInput()
    }
    
    @IBAction func capturePhotoButtonPressed(_ sender: Any) {
        //self.capturePhoto()
        
        //MARK: Testing Purpose - TODO - Remove before production ----
        stopSession()
        invalidateImageCaptureTimer()
        ImagePickerManager().pickImage(self, true) {[weak self] (image) in
            self?.confirmCapturedImage(image)
        }
    }
    
    private func setupLayout() {
        rotateButton.isHidden = false
        captureButton.isHidden = true
        layoutButton.isHidden = true        
        titleLabel.font = UIFont(name: Fonts.brunoAceRegular, size: 12)
        descriptionLabel.font = UIFont(name: Fonts.brunoAceRegular, size: 10)
    }
    
    private func setTopDetailsViewLayout() {
        let layer = CAGradientLayer()
        layer.frame = topDetailsView.bounds
        layer.colors = [UIColor(rgba: "#80808033").cgColor, UIColor(rgba: "#0d0d0d").cgColor]
        layer.startPoint = CGPoint(x: 0.5, y: 0.0)
        layer.endPoint = CGPoint(x: 0.5, y: 0.6)
        //layer.frame = topDetailsView.bounds
        layer.cornerRadius = 10
        topDetailsView.layer.shadowOffset = CGSize(width: 0, height: 2)
        topDetailsView.layer.shadowOpacity = 0.3
        topDetailsView.layer.shadowRadius = 3.0
        topDetailsView.layer.shadowColor = UIColor.darkGray.cgColor
        topDetailsView.layer.masksToBounds = false
        
        topDetailsView.layer.insertSublayer(layer, at: 0)
    }
    
    private func setUpPreviewOverlayView() {
        cameraView.addSubview(previewOverlayView)
        NSLayoutConstraint.activate([
            previewOverlayView.topAnchor.constraint(equalTo: cameraView.topAnchor),
            previewOverlayView.bottomAnchor.constraint(equalTo: cameraView.bottomAnchor),
            previewOverlayView.leadingAnchor.constraint(equalTo: cameraView.leadingAnchor),
            previewOverlayView.trailingAnchor.constraint(equalTo: cameraView.trailingAnchor),
            
        ])
    }
    
    private func validateUserHeight() {
        guard userHeight ?? 0.0 < 1.0 else {
            return
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            UIAlertController.showAlert(title: "", message: AlertMessage.INVALID_HEIGHT, actions: .OK) { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }
}


//MARK: AVCapture
extension ScanningMeasurementViewController {
    
    private func captureDevice(forPosition position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        if #available(iOS 10.0, *) {
            let discoverySession = AVCaptureDevice.DiscoverySession(
                deviceTypes: [.builtInWideAngleCamera],
                mediaType: .video,
                position: .unspecified
            )
            return discoverySession.devices.first { $0.position == position }
        }
        return nil
    }
    
    private func setUpCaptureSessionOutput() {
        weak var weakSelf = self
        sessionQueue.async {
            guard let strongSelf = weakSelf else {
                print("Self is nil!")
                return
            }
            strongSelf.captureSession.beginConfiguration()
            // When performing latency tests to determine ideal capture settings,
            // run the app in 'release' mode to get accurate performance metrics
            strongSelf.captureSession.sessionPreset = AVCaptureSession.Preset.medium
            
            //MARK: Video for ML model purpose
            let videoDataOutput = AVCaptureVideoDataOutput()
            videoDataOutput.videoSettings = [
                (kCVPixelBufferPixelFormatTypeKey as String): kCVPixelFormatType_32BGRA
            ]
            videoDataOutput.alwaysDiscardsLateVideoFrames = true
            let outputQueue = DispatchQueue(label: MLModelConstants.videoDataOutputQueueLabel)
            videoDataOutput.setSampleBufferDelegate(strongSelf, queue: outputQueue)
            guard strongSelf.captureSession.canAddOutput(videoDataOutput) else {
                print("Failed to add capture session output.")
                return
            }
            strongSelf.captureSession.addOutput(videoDataOutput)
            
            //MARK: Photo for capture purpose
            let photoOutput = AVCapturePhotoOutput()
            photoOutput.isHighResolutionCaptureEnabled = true
            photoOutput.maxPhotoQualityPrioritization = .quality
            /*if let largestDimesnion = self.deviceInput?.device.activeFormat.supportedMaxPhotoDimensions.last {
                photoOutput.maxPhotoDimensions = largestDimesnion
            }*/
            guard strongSelf.captureSession.canAddOutput(photoOutput) else {
                print("Failed to add photo capture session output.")
                return
            }
            strongSelf.captureSession.addOutput(photoOutput)
            self.photoOutput = photoOutput
            
            strongSelf.captureSession.commitConfiguration()
        }
    }
    
    private func setUpCaptureSessionInput() {
        weak var weakSelf = self
        sessionQueue.async {
            guard let strongSelf = weakSelf else {
                print("Self is nil!")
                return
            }
            let cameraPosition: AVCaptureDevice.Position = strongSelf.isUsingFrontCamera ? .front : .back
            guard let device = strongSelf.captureDevice(forPosition: cameraPosition) else {
                print("Failed to get capture device for camera position: \(cameraPosition)")
                return
            }
            do {
                strongSelf.captureSession.beginConfiguration()
                let currentInputs = strongSelf.captureSession.inputs
                for input in currentInputs {
                    strongSelf.captureSession.removeInput(input)
                }
                
                let input = try AVCaptureDeviceInput(device: device)
                guard strongSelf.captureSession.canAddInput(input) else {
                    print("Failed to add capture session input.")
                    return
                }
                strongSelf.captureSession.addInput(input)
                //strongSelf.deviceInput = input
                strongSelf.captureSession.commitConfiguration()
            } catch {
                print("Failed to create capture device input: \(error.localizedDescription)")
            }
        }
    }
    
    private func startSession() {
        resetCapturedImageData()
        imageView.isHidden = false
        weak var weakSelf = self
        sessionQueue.async {
            guard let strongSelf = weakSelf else {
                print("Self is nil!")
                return
            }
            strongSelf.captureSession.startRunning()
        }
    }
    
    private func stopSession() {
        imageView.isHidden = true
        weak var weakSelf = self
        sessionQueue.async {
            guard let strongSelf = weakSelf else {
                print("Self is nil!")
                return
            }
            strongSelf.captureSession.stopRunning()
        }
    }
}

//MARK: Detect Pose
extension ScanningMeasurementViewController {
    
    private func detectPose(in image: MLImage, width: CGFloat, height: CGFloat) {
        if let poseDetector = self.poseDetector {
            var poses: [Pose] = []
            var detectionError: Error?
            do {
                poses = try poseDetector.results(in: image)
            } catch let error {
                detectionError = error
            }
            weak var weakSelf = self
            DispatchQueue.main.sync {
                guard let strongSelf = weakSelf else {
                    print("Self is nil!")
                    return
                }
                strongSelf.updatePreviewOverlayViewWithLastFrame()
                if let detectionError = detectionError {
                    print("Failed to detect poses with error: \(detectionError.localizedDescription).")
                    return
                }
                guard !poses.isEmpty else {
                    self.imageView.image = UIImage(named: self.detectBodyPose.image)?.withRenderingMode(.alwaysOriginal)
                    print("Pose detector returned no results.")
                    return
                }
                //Monitor Pose Result
                let poseResult = PoseClassifier.isCorrect(pose: poses[0], type: detectBodyPose)
                self.showPoseResult(poseResult)
                if poseResult {
                    if imageCaptureTimer == nil {
                        self.startPhotoCaptureTimer()
                    }
                } else {
                    if imageCaptureTimer != nil {
                        self.invalidateImageCaptureTimer()
                    }
                }
            }
        }
    }
    
    private func updatePreviewOverlayViewWithLastFrame() {
        guard let lastFrame = lastFrame,
              let imageBuffer = CMSampleBufferGetImageBuffer(lastFrame)
        else {
            return
        }
        self.updatePreviewOverlayViewWithImageBuffer(imageBuffer)
    }
    
    private func updatePreviewOverlayViewWithImageBuffer(_ imageBuffer: CVImageBuffer?) {
        guard let imageBuffer = imageBuffer else {
            return
        }
        let orientation: UIImage.Orientation = isUsingFrontCamera ? .leftMirrored : .right
        let image = PoseClassifier.createUIImage(from: imageBuffer, orientation: orientation)
        previewOverlayView.image = image
    }
    
    
    /* Resets detector instance which use a conventional lifecycle paradigm. This method is
     expected to be invoked on the AVCaptureOutput queue - the same queue on which detection is
     run.*/
    private func resetManagedLifecycleDetectors() {
        // Clear the old detector
        self.poseDetector = nil
        // Initialize the new detector || The `options.detectorMode` defaults to `.stream`
        let options = PoseDetectorOptions()
        self.poseDetector = PoseDetector.poseDetector(options: options)
    }
    
    private func showPoseResult(_ isCorrectPose: Bool) {
        imageView.image = imageView.image?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = isCorrectPose ? .systemGreen : .systemRed
    }
}


//MARK: CaptureTimer
extension ScanningMeasurementViewController {
    
    private func startPhotoCaptureTimer() {
        print("Timer Started")
        self.imageCaptureTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.imageTimerSeconds += 1
            if (self?.imageTimerSeconds ?? 0) >= 4 {
                self?.capturePhoto()
            }
        }
    }
    
    private func invalidateImageCaptureTimer() {
        self.imageCaptureTimer?.invalidate()
        self.imageCaptureTimer = nil
        self.imageTimerSeconds = 0
    }
}


// MARK: AVCapturePhotoCaptureDelegate
extension ScanningMeasurementViewController: AVCapturePhotoCaptureDelegate {
    
    private func resetCapturedImageData() {
        invalidateImageCaptureTimer()
        self.imageView.image = UIImage(named: self.detectBodyPose.image)?.withRenderingMode(.alwaysOriginal)
    }
    
    private func capturePhoto() {
        invalidateImageCaptureTimer()
        let settings = AVCapturePhotoSettings()
        settings.isHighResolutionPhotoEnabled = true
        settings.photoQualityPrioritization = .quality
        photoOutput?.capturePhoto(with: settings, delegate: self)
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let imageData = photo.fileDataRepresentation(), var capturedImage = UIImage(data: imageData) {
            self.stopSession()
            print("\n******** Photo Captured **********\n")
            //Fix Captured Photo Orientation
            if let cgImage = capturedImage.cgImage {
                let orientation: UIImage.Orientation = isUsingFrontCamera ? .leftMirrored : .right
                capturedImage = UIImage(cgImage: cgImage, scale: capturedImage.scale, orientation: orientation)
            }
            self.confirmCapturedImage(capturedImage)
        }
    }
}


// MARK: AVCaptureVideoDataOutputSampleBufferDelegate
extension ScanningMeasurementViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func captureOutput(
        _ output: AVCaptureOutput,
        didOutput sampleBuffer: CMSampleBuffer,
        from connection: AVCaptureConnection
    ) {
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            print("Failed to get image buffer from sample buffer.")
            return
        }
        resetManagedLifecycleDetectors()
        
        lastFrame = sampleBuffer
        let visionImage = VisionImage(buffer: sampleBuffer)
        let orientation = PoseClassifier.imageOrientation(
            fromDevicePosition: isUsingFrontCamera ? .front : .back
        )
        visionImage.orientation = orientation
        
        guard let inputImage = MLImage(sampleBuffer: sampleBuffer) else {
            print("Failed to create MLImage from sample buffer.")
            return
        }
        inputImage.orientation = orientation
        
        let imageWidth = CGFloat(CVPixelBufferGetWidth(imageBuffer))
        let imageHeight = CGFloat(CVPixelBufferGetHeight(imageBuffer))
        
        detectPose(in: inputImage, width: imageWidth, height: imageHeight)
    }
}


//MARK: ConfirmImageProtocol
extension ScanningMeasurementViewController: ConfirmImageProtocolDelegate {
    
    private func confirmCapturedImage(_ image: UIImage) {
        guard let vc = Storyboard.Scanning.instantiateVC(type: ConfirmImageViewController.self) else {
            return
        }
        vc.delegate = self
        vc.setInitialData(image, frontImage: frontImage, userHeight: userHeight)
        navigationController?.pushViewController(vc, animated: false)
    }
    
    private func setUpBodyPose(_ pose: BodyPose = .frontProfile) {
        detectBodyPose = pose
        titleLabel.text = detectBodyPose.title
        imageView.image = UIImage(named: detectBodyPose.image)?.withRenderingMode(.alwaysOriginal)
    }
    
    func imageConfirmed(_ image: UIImage?) {
        print("\nUser Confirmed the Image.")
        frontImage = image
        setUpBodyPose(.sideProfile)
    }
    
    func retakeImage() {
        print("\nRetake Image.")
        setUpBodyPose(frontImage == nil ? .frontProfile : .sideProfile)
    }
    
    func resetBodyPoses() {
        frontImage = nil
        setUpBodyPose()
    }
}
