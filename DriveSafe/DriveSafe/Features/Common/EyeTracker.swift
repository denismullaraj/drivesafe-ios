//
//  EyeTracker.swift
//  DriveSafe
//
//  Created by Denis Mullaraj on 04/03/2025.
//

import ARKit

/// A delegate protocol for handling eye tracker events.
protocol EyeTrackerDelegate: AnyObject {
    /// Called when the eye tracker triggers an alarm.
    /// - parameter eyeTracker: The instance of the eye tracker that triggered the alarm.
    func eyeTrackerDidTriggerAlarm(_ eyeTracker: EyeTrackerProtocol)
    
    /// Called when the eye tracker stops the alarm.
    /// - parameter eyeTracker: The instance of the eye tracker that stopped the alarm.
    func eyeTrackerDidStopAlarm(_ eyeTracker: EyeTrackerProtocol)
}

/// A protocol defining the basic functionality of an eye tracker.
protocol EyeTrackerProtocol {
    /// Starts the eye tracking session.
    func schedule()
    
    /// Stops the eye tracking session and resets its state.
    func invalidate()
}

/// An `ObservableObject` that tracks eye activity using ARKit.
final class EyeTracker: NSObject, ObservableObject, EyeTrackerProtocol {
    
    /// The current tracking status.
    @Published var status: TrackingStatus = .available
    
    /// Indicates if eye tracking is not supported on the device.
    var isNotSupported: Bool {
        get { status == .unavailable }
        set { }
    }
    
    /// Indicates if the eye tracker is currently active.
    var isTracking: Bool {
        get { status == .active }
        set {
            if newValue {
                schedule()
            } else {
                invalidate()
            }
        }
    }

    /// The delegate responsible for handling alarm events.
    weak var delegate: EyeTrackerDelegate?
    
    /// The maximum duration (in seconds) that eyes can remain closed before triggering an alarm.
    private let maxTimeEyesCanBeClosed: Int
    
    /// The number of seconds the eyes have been closed.
    private var secondsEyesClosed = 0

    private let session = ARSession()
    private var timer: Timer?
    
    private lazy var audioPlayer: AVAudioPlayer? = {
        guard let url = Bundle.main.url(forResource: "alarm", withExtension: "wav") else { return nil }
        let audioPlayer = try? AVAudioPlayer(contentsOf: url)
        audioPlayer?.prepareToPlay()
        return audioPlayer
    }()
    
    /// Initializes an eye tracker instance.
    /// - parameter maxTimeEyesCanBeClosed: The threshold for triggering an alarm.
    init(maxTimeEyesCanBeClosed: Int) {
        status = ARFaceTrackingConfiguration.isSupported ? .available : .unavailable
        self.maxTimeEyesCanBeClosed = maxTimeEyesCanBeClosed
        super.init()
        self.session.delegate = self
    }
    
    /// Starts eye tracking if available.
    func schedule() {
        guard status == .available else { return }
        status = .active
        let configuration = ARFaceTrackingConfiguration()
        session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(processSeconds), userInfo: nil, repeats: true)
    }
    
    /// Stops eye tracking and resets the state.
    func invalidate() {
        status = .available
        session.pause()
        timer?.invalidate()
        stopAlarm()
    }
    
    @objc private func processSeconds() {
        secondsEyesClosed += 1
        guard secondsEyesClosed >= maxTimeEyesCanBeClosed else { return }
        triggerAlarm()
    }
    
    private func triggerAlarm() {
        audioPlayer?.play()
        
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            delegate?.eyeTrackerDidTriggerAlarm(self)
        }
    }
    
    private func stopAlarm() {
        secondsEyesClosed = 0
        audioPlayer?.stop()
        audioPlayer?.currentTime = 0
        
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            delegate?.eyeTrackerDidStopAlarm(self)
        }
    }
}

/// Conformance to `ARSessionDelegate` to handle face tracking updates.
extension EyeTracker: ARSessionDelegate {
    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        guard let faceAnchor = anchors.first as? ARFaceAnchor else { return }
        
        let blendShapes = faceAnchor.blendShapes
        guard let eyeBlinkLeft = blendShapes[.eyeBlinkLeft]?.doubleValue,
              let eyeBlinkRight = blendShapes[.eyeBlinkRight]?.doubleValue else { return }
        
        switch (eyeBlinkLeft, eyeBlinkRight) {
        case (..<0.025, ..<0.025):
            // Eyes open - reset timer
            secondsEyesClosed = 0
            stopAlarm()
        default:
            // Eyes closed - timer continues running
            break
        }
    }
}

/// An enumeration defining the possible states of the eye tracker.
extension EyeTracker {
    enum TrackingStatus {
        /// System supports eye tracking and is ready.
        case available
        /// Device doesn't support eye tracking.
        case unavailable
        /// Currently tracking eyes.
        case active
    }
}
