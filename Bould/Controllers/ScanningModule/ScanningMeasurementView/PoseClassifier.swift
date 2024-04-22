//import MLKit
import AVFoundation
import CoreVideo
import MLKit
import UIKit


struct PoseClassifier {
    
    static func angle(
        firstLandmark: PoseLandmark,
        midLandmark: PoseLandmark,
        lastLandmark: PoseLandmark
    ) -> CGFloat {
        let radians: CGFloat =
        atan2(lastLandmark.position.y - midLandmark.position.y,
              lastLandmark.position.x - midLandmark.position.x) -
        atan2(firstLandmark.position.y - midLandmark.position.y,
              firstLandmark.position.x - midLandmark.position.x)
        var degrees = radians * 180.0 / .pi
        degrees = abs(degrees) // Angle should never be negative
        if degrees > 180.0 {
            degrees = 360.0 - degrees // Always get the acute representation of the angle
        }
        return degrees
    }
    
    static func isCorrect(pose: Pose, type: BodyPose) -> Bool {
        //Right of Body
        let rElbowAngle = PoseClassifier.angle(
            firstLandmark: pose.landmark(ofType: .rightWrist),
            midLandmark: pose.landmark(ofType: .rightElbow),
            lastLandmark: pose.landmark(ofType: .rightShoulder)
        )
        let rShoulderAngle = PoseClassifier.angle(
            firstLandmark: pose.landmark(ofType: .rightElbow),
            midLandmark: pose.landmark(ofType: .rightShoulder),
            lastLandmark: pose.landmark(ofType: .rightHip)
        )
        let rHipAngle = PoseClassifier.angle(
            firstLandmark: pose.landmark(ofType: .rightShoulder),
            midLandmark: pose.landmark(ofType: .rightHip),
            lastLandmark: pose.landmark(ofType: .rightKnee)
        )
        let rKneeAngle = PoseClassifier.angle(
            firstLandmark: pose.landmark(ofType: .rightHip),
            midLandmark: pose.landmark(ofType: .rightKnee),
            lastLandmark: pose.landmark(ofType: .rightHeel)
        )
        let rFootAngle = PoseClassifier.angle(
            firstLandmark: pose.landmark(ofType: .rightKnee),
            midLandmark: pose.landmark(ofType: .rightAnkle),
            lastLandmark: pose.landmark(ofType: .rightToe)
        )
        
        //Left Side of Body
        let lElbowAngle = PoseClassifier.angle(
            firstLandmark: pose.landmark(ofType: .leftWrist),
            midLandmark: pose.landmark(ofType: .leftElbow),
            lastLandmark: pose.landmark(ofType: .leftShoulder)
        )
        let lShoulderAngle = PoseClassifier.angle(
            firstLandmark: pose.landmark(ofType: .leftElbow),
            midLandmark: pose.landmark(ofType: .leftShoulder),
            lastLandmark: pose.landmark(ofType: .leftHip)
        )
        let lHipAngle = PoseClassifier.angle(
            firstLandmark: pose.landmark(ofType: .leftShoulder),
            midLandmark: pose.landmark(ofType: .leftHip),
            lastLandmark: pose.landmark(ofType: .leftKnee)
        )
        let lKneeAngle = PoseClassifier.angle(
            firstLandmark: pose.landmark(ofType: .leftHip),
            midLandmark: pose.landmark(ofType: .leftKnee),
            lastLandmark: pose.landmark(ofType: .leftHeel)
        )
        let lFootAngle = PoseClassifier.angle(
            firstLandmark: pose.landmark(ofType: .leftKnee),
            midLandmark: pose.landmark(ofType: .leftAnkle),
            lastLandmark: pose.landmark(ofType: .leftToe)
        )
        
        switch type {
        case .frontProfile:
            return PoseClassifier.isCorrectFrontPoseAngles(rElbow: rElbowAngle, rShoulder: rShoulderAngle, rHip: rHipAngle, rKnee: rKneeAngle, rFoot: rFootAngle, lElbow: lElbowAngle, lShoulder: lShoulderAngle, lHip: lHipAngle, lKnee: lKneeAngle, lFoot: lFootAngle)
        case .sideProfile:
            return PoseClassifier.isCorrectSidePoseAngles(rElbow: rElbowAngle, rShoulder: rShoulderAngle, rHip: rHipAngle, rKnee: rKneeAngle, rFoot: rFootAngle, lElbow: lElbowAngle, lShoulder: lShoulderAngle, lHip: lHipAngle, lKnee: lKneeAngle, lFoot: lFootAngle)
        case .standingPose:
            return PoseClassifier.isCorrectStandingPoseAngles(rElbow: rElbowAngle, rShoulder: rShoulderAngle, rHip: rHipAngle, rKnee: rKneeAngle, rFoot: rFootAngle, lElbow: lElbowAngle, lShoulder: lShoulderAngle, lHip: lHipAngle, lKnee: lKneeAngle, lFoot: lFootAngle)
        }
    }
}


//MARK: Classify Pose
extension PoseClassifier {
    
    static func isCorrectStandingPoseAngles(rElbow: CGFloat, rShoulder: CGFloat, rHip: CGFloat, rKnee: CGFloat, rFoot: CGFloat, lElbow: CGFloat, lShoulder: CGFloat, lHip: CGFloat, lKnee: CGFloat, lFoot: CGFloat) -> Bool {
        // Define angle thresholds for standing
        let minRightElbowAngle = 159.5//162.0
        let maxRightShoulderAngle = 20.5//18.0
        let minRightHipAngle = 166.5//169.0
        let minRightKneeAngle = 162.5//165.0
        
        let minLeftElbowAngle = 156.5//159.0
        let maxLeftShoulderAngle = 21.5//19.0
        let minLeftHipAngle = 165.5//168.0
        let minLeftKneeAngle = 168.5//171.0
        
        let minFootAngle = 153.5//156.0
        
        // Check if all angles are within the standing thresholds
        let rElbowCorrect = rElbow >= minRightElbowAngle
        let rShoulderCorrect = rShoulder <= maxRightShoulderAngle
        let rHipCorrect = rHip >= minRightHipAngle
        let rKneeCorrect = rKnee >= minRightKneeAngle
        let rFootCorrect = rFoot >= minFootAngle
        
        let lElbowCorrect = lElbow >= minLeftElbowAngle
        let lShoulderCorrect = lShoulder <= maxLeftShoulderAngle
        let lHipCorrect = lHip >= minLeftHipAngle
        let lKneeCorrect = lKnee >= minLeftKneeAngle
        let lFootCorrect = lFoot >= minFootAngle
        
        // A person is considered standing if all angles are within the thresholds
        let isRightSideBodyWithThreshold = rElbowCorrect && rShoulderCorrect && rHipCorrect && rKneeCorrect && rFootCorrect
        let isLeftSideBodyWithThreshold = lElbowCorrect && lShoulderCorrect && lHipCorrect && lKneeCorrect && lFootCorrect
        
        return isRightSideBodyWithThreshold && isLeftSideBodyWithThreshold
    }
    
    static func isCorrectFrontPoseAngles(rElbow: CGFloat, rShoulder: CGFloat, rHip: CGFloat, rKnee: CGFloat, rFoot: CGFloat, lElbow: CGFloat, lShoulder: CGFloat, lHip: CGFloat, lKnee: CGFloat, lFoot: CGFloat) -> Bool {
        // Define angle thresholds for standing
        let minRightShoulderAngle = 8.0     //12.0   //16.0
        let maxRightShoulderAngle = 62.0    //58.0   //53.0
        let minRightHipAngle = 151.0        //155.0  //160.0
        let maxRightHipAngle = 180.0        //178.0  //172.0
        
        let minRightElbowAngle = 150.0      //154.0  //159.0
        let minRightKneeAngle = 158.0       //162.0  //167.0
        let minRightFootAngle = 149.0       //153.0  //158.0
        
        let minLeftShoulderAngle = 7.0      //11.0   //16
        let maxLeftShoulderAngle = 64.0     //60.0   //55.0
        let minLeftHipAngle = 151.0         //155.0  //160.0
        let maxLeftHipAngle = 172.0         //168.0  //173.0
        let minLeftFootAngle = 145.0        //149.0  //154.0
        let maxLeftFootAngle = 179.0        //175.0  //169.0
        
        let minLeftElbowAngle = 157.0       //161.0  //166.0
        let minLeftKneeAngle = 158.0        //162.0  //167.0
        
        // Check if all angles are within the standing thresholds
        let rElbowCorrect = rElbow > minRightElbowAngle
        let rShoulderCorrect = rShoulder > minRightShoulderAngle && rShoulder < maxRightShoulderAngle
        let rHipCorrect = rHip > minRightHipAngle && rHip < maxRightHipAngle
        let rKneeCorrect = rKnee > minRightKneeAngle
        let rFootCorrect = rFoot > minRightFootAngle
        
        let lElbowCorrect = lElbow > minLeftElbowAngle
        let lShoulderCorrect = lShoulder > minLeftShoulderAngle && lShoulder < maxLeftShoulderAngle
        let lHipCorrect = lHip > minLeftHipAngle && lHip < maxLeftHipAngle
        let lKneeCorrect = lKnee > minLeftKneeAngle
        let lFootCorrect = lFoot > minLeftFootAngle && lFoot < maxLeftFootAngle
        
        // Considered front side pose if all angles are within the thresholds
        let isRightSideBodyWithThreshold = rElbowCorrect && rShoulderCorrect && rHipCorrect && rKneeCorrect && rFootCorrect
        let isLeftSideBodyWithThreshold = lElbowCorrect && lShoulderCorrect && lHipCorrect && lKneeCorrect && lFootCorrect
        
        return isRightSideBodyWithThreshold && isLeftSideBodyWithThreshold
    }
    
    static func isCorrectSidePoseAngles(rElbow: CGFloat, rShoulder: CGFloat, rHip: CGFloat, rKnee: CGFloat, rFoot: CGFloat, lElbow: CGFloat, lShoulder: CGFloat, lHip: CGFloat, lKnee: CGFloat, lFoot: CGFloat) -> Bool {
        
        // Check if all angles are within the standing thresholds
        let rElbowCorrect = rElbow >= 139       //143  //148
        let rKneeCorrect = rKnee >= 149         //153  //158
        let rFootCorrect = rFoot > 85 && rFoot < 130   //foot > 89 && foot < 125    //foot > 94 && foot < 120
        
        let lElbowCorrect = lElbow > 143        //147  //152
        let lKneeCorrect = lKnee >= 159         //163  //168
        let lFootCorrect = lFoot > 91 && lFoot < 134   //foot > 95 && foot < 129   //foot > 100 && foot < 124
        
        let hipCorrect = rHip >= 159            //163  //168
        let shoulderCorrect = rShoulder >= 0 && rShoulder < 19 //shoulder >= 0 && shoulder < 15   //shoulder >= 0 && shoulder < 10
        
        // Considered profile 'side' pose if all angles are within the thresholds
        let isRightSideBodyWithThreshold = rElbowCorrect && shoulderCorrect && hipCorrect && rKneeCorrect && rFootCorrect
        let isLeftSideBodyWithThreshold = lElbowCorrect && shoulderCorrect && hipCorrect && lKneeCorrect && lFootCorrect
        
        return isRightSideBodyWithThreshold && isLeftSideBodyWithThreshold
    }
}


//MARK: ML-Model Utilities
extension PoseClassifier {
    /// Converts an image buffer to a `UIImage`.
    ///
    /// @param imageBuffer The image buffer which should be converted.
    /// @param orientation The orientation already applied to the image.
    /// @return A new `UIImage` instance.
    public static func createUIImage(
        from imageBuffer: CVImageBuffer,
        orientation: UIImage.Orientation
    ) -> UIImage? {
        let ciImage = CIImage(cvPixelBuffer: imageBuffer)
        let context = CIContext(options: nil)
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else { return nil }
        return UIImage(cgImage: cgImage, scale: MLModelConstants.originalScale, orientation: orientation)
    }
    
    public static func imageOrientation(
        fromDevicePosition devicePosition: AVCaptureDevice.Position = .back
    ) -> UIImage.Orientation {
        var deviceOrientation = UIDevice.current.orientation
        if deviceOrientation == .faceDown || deviceOrientation == .faceUp
            || deviceOrientation
            == .unknown
        {
            deviceOrientation = Utility.currentUIOrientation()
        }
        switch deviceOrientation {
        case .portrait:
            return devicePosition == .front ? .leftMirrored : .right
        case .landscapeLeft:
            return devicePosition == .front ? .downMirrored : .up
        case .portraitUpsideDown:
            return devicePosition == .front ? .rightMirrored : .left
        case .landscapeRight:
            return devicePosition == .front ? .upMirrored : .down
        case .faceDown, .faceUp, .unknown:
            return .up
        @unknown default:
            fatalError()
        }
    }
    
}
