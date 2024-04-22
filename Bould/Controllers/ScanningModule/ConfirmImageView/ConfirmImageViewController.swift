import UIKit
import AVKit


protocol ConfirmImageProtocolDelegate: AnyObject {
    func imageConfirmed(_ image: UIImage?)
    func retakeImage()
    func resetBodyPoses()
}

class ConfirmImageViewController: BaseViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var retakeButton: UIButton!
    //Loading Realted Views - Outlets
    @IBOutlet weak var videoContainerView: UIView!
    @IBOutlet weak var blurredEffectView: UIVisualEffectView!
    @IBOutlet weak var loadingStackView: UIStackView!
    @IBOutlet weak var loadingTextLabel: UILabel!
    @IBOutlet weak var page: UIPageControl!
    private var pageTimer: Timer?
    
    private var loadingVideoPlayer: AVPlayer?
    weak var delegate: ConfirmImageProtocolDelegate?
    
    private lazy var viewModel: ConfirmImageViewModel = {
        let vwModel = ConfirmImageViewModel()
        self.baseVwModel = vwModel
        return vwModel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        imageView.image = viewModel.image
        //loadingTextLabel.font = UIFont(name: Fonts.laoSansProRegular, size: 23)
        confirmButton.setTitle(viewModel.frontImage != nil ? Strings.Continue : Strings.confirm, for: .normal)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    deinit {
        releaseResources()
        print("\n******** 3D-Scan Loading Screen: Resources Released ********")
    }
    
    @IBAction func confirmButtonPressed(_ sender: Any) {
        if viewModel.frontImage == nil {
            delegate?.imageConfirmed(viewModel.image)
            navigationController?.popViewController(animated: false)
        } else {
            onImageWorkCompletion()
        }
    }
    
    @IBAction func retakeButtonPressed(_ sender: Any) {
        delegate?.retakeImage()
        navigationController?.popViewController(animated: false)
    }
    
    private func setupLayout() {
        confirmButton.layer.cornerRadius = 10
        retakeButton.layer.cornerRadius = 10
        confirmButton.titleLabel?.font = UIFont(name: Fonts.brunoAceRegular, size: 12)
        retakeButton.titleLabel?.font = UIFont(name: Fonts.brunoAceRegular, size: 12)
    }
    
    func setInitialData(_ newImage: UIImage, frontImage: UIImage?, userHeight: Double?) {
        viewModel.image = newImage
        viewModel.frontImage = frontImage
        viewModel.userHeight = userHeight
    }
}


//MARK: Loading Functionality
extension ConfirmImageViewController {
    
    private func showLoading() {
        page.currentPage = 0
        blurredEffectView.isHidden = false
        loadingStackView.isHidden = false
        blurredEffectView.alpha = 0.15
        showVideoLoading()
        pageTimer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true) { [weak self] _ in
            self?.page.currentPage += 1
            if (self?.page.currentPage ?? 0) > (self?.page.numberOfPages ?? 0) - 2 {
                self?.page.currentPage = 0
            }
        }
    }
    
    private func hideLoading() {
        //First Hide Video Loading
        videoContainerView.isHidden = true
        blurredEffectView.isHidden = true
        loadingStackView.isHidden = true
        page.currentPage = 0
        pageTimer?.invalidate()
        pageTimer = nil
    }
    
    private func showVideoLoading() {
        guard let videoURL = Bundle.main.url(forResource: "loading_video", withExtension: "mp4") else {
            return
        }
        videoContainerView.isHidden = false
        if loadingVideoPlayer == nil {
            loadingVideoPlayer = AVPlayer(url: videoURL)
            let playerLayer = AVPlayerLayer(player: loadingVideoPlayer)
            playerLayer.videoGravity = .resizeAspectFill
            playerLayer.frame = videoContainerView.bounds
            videoContainerView.layer.addSublayer(playerLayer)
            // Loop the video
            NotificationCenter.default.addObserver(
                forName: .AVPlayerItemDidPlayToEndTime,
                object: loadingVideoPlayer?.currentItem,
                queue: .main) { [weak self] _ in
                    self?.loadingVideoPlayer?.seek(to: .zero)
                    self?.loadingVideoPlayer?.play()
                }
        }
        loadingVideoPlayer?.play()
    }
    
    private func releaseResources() {
        for subview in videoContainerView.subviews {
            subview.removeFromSuperview()
        }
        hideLoading()
        loadingVideoPlayer = nil
        NotificationCenter.default.removeObserver(self)
    }
}


//MARK: User Body Measurement
extension ConfirmImageViewController {
    
    private func onImageWorkCompletion() {
        if let image = viewModel.image {
            viewModel.sideProfileImage = image
        }
        showLoading()
        viewModel.image = nil
        startMeasurement()
    }
    
    private func startMeasurement() {
        viewModel.startMeasurement { [weak self] error in
            DispatchQueue.main.async {
                self?.hideLoading()
                if let error = error {
                    self?.onBodyMeasurementError(error)
                    return
                }
                SceneDelegate.sceneDelegate?.updateRootController()
            }
        }
    }
    
    private func onBodyMeasurementError(_ error: Error) {
        UIAlertController.showAlert(title: "", message: error.localizedDescription, actions: .OK, .Restart) { [weak self] action in
            if action == .Restart {
                self?.delegate?.resetBodyPoses()
                self?.navigationController?.popViewController(animated: false)
            }
        }
    }
}
