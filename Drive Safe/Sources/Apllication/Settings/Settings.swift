//
//  Settings.swift
//  Drive Safe
//
//  Created by Denis Mullaraj on 06/01/2020.
//  Copyright © 2020 Denis Mullaraj. All rights reserved.
//

import Foundation

protocol SettingsProtocol {
    var userDefaults: UserDefaultsProtocol { get set }
    func persistEyeClosedLimitInSeconds(from value: String?)
    func getEyeClosedLimitInSeconds() -> Int
    func getDefaultEyeClosedLimitInSeconds() -> Int
}

class Settings: SettingsProtocol {
    var userDefaults: UserDefaultsProtocol = UserDefaults.standard
    
    func persistEyeClosedLimitInSeconds(from value: String?) {
        var limitInSecondsToPersist = getDefaultEyeClosedLimitInSeconds()
        if let secondsText = value, let seconds = Int(secondsText) {
            limitInSecondsToPersist = seconds
        }
        userDefaults.set(limitInSecondsToPersist, forKey: DriveSafeConfig.PREFERENCES_EYECLOSED_SECONDS_LIMIT)
    }
    
    func getEyeClosedLimitInSeconds() -> Int {
        var eyeClosedLimitInSeconds = userDefaults.integer(forKey: DriveSafeConfig.PREFERENCES_EYECLOSED_SECONDS_LIMIT)
        if eyeClosedLimitInSeconds == 0 {
            eyeClosedLimitInSeconds = getDefaultEyeClosedLimitInSeconds()
        }
        return eyeClosedLimitInSeconds
    }
    
    func getDefaultEyeClosedLimitInSeconds() -> Int {
        return DriveSafeConfig.DEFAULT_EYECLOSED_SECONDS_LIMIT
    }
}
