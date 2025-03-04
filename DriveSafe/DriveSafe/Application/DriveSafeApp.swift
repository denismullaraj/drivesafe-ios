//
//  DriveSafeApp.swift
//  DriveSafe
//
//  Created by Denis Mullaraj on 04/03/2025.
//

import SwiftUI

@main
struct DriveSafeApp: App {
    @StateObject var eyeTracker = EyeTracker(maxTimeEyesCanBeClosed: Preferences.maxTimeEyesCanBeClosed)

    var body: some Scene {
        WindowGroup {
            HomeView(eyeTracker: eyeTracker)
        }
    }
}
