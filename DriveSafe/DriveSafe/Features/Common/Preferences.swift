//
//  Preferences.swift
//  DriveSafe
//
//  Created by Denis Mullaraj on 04/03/2025.
//

import SwiftUI

/// A structure for storing user preferences.
enum Preferences {
    /// The maximum duration (in seconds) that eyes can remain closed before triggering an alarm.
    @AppStorage("maxTimeEyesCanBeClosed")
    static var maxTimeEyesCanBeClosed: Int = 2
}
