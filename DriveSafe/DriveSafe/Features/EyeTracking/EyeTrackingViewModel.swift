//
//  EyeTrackingViewModel.swift
//  DriveSafe
//
//  Created by Denis on 25/02/2025.
//

import SwiftUI

/// A view model for handling eye tracking UI updates.
final class EyeTrackingViewModel: ObservableObject {
    /// The background color of the UI, changing based on eye tracking status.
    @Published var backgroundColor: Color = .blue
    
    /// The animation applied when the alarm is triggered.
    @Published var animation: Animation = .default

    private let eyeTracker: EyeTracker

    /// Initializes the view model with an `EyeTracker` instance.
    /// - parameter eyeTracker: The eye tracker to be used for monitoring.
    init(eyeTracker: EyeTracker) {
        self.eyeTracker = eyeTracker
        self.eyeTracker.delegate = self
    }

    /// Starts eye tracking.
    func startTracking() {
        eyeTracker.schedule()
    }

    /// Stops eye tracking.
    func stopTracking() {
        eyeTracker.invalidate()
    }
}

/// Conformance to `EyeTrackerDelegate` to handle alarm events.
extension EyeTrackingViewModel: EyeTrackerDelegate {
    /// Handles the event when the eye tracker triggers an alarm.
    /// - parameter eyeTracker: The eye tracker that triggered the alarm.
    func eyeTrackerDidTriggerAlarm(_ eyeTracker: any EyeTrackerProtocol) {
        backgroundColor = Color.red
        animation = .easeInOut(duration: 0.3).repeatForever(autoreverses: true)
    }
    
    /// Handles the event when the eye tracker stops the alarm.
    /// - parameter eyeTracker: The eye tracker that stopped the alarm.
    func eyeTrackerDidStopAlarm(_ eyeTracker: any EyeTrackerProtocol) {
        backgroundColor = Color.blue
        animation = .default
    }
}
