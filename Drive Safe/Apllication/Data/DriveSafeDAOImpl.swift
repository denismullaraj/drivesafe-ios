//
//  DriveSafeDAOImpl.swift
//  Drive Safe
//
//  Created by Denis Mullaraj on 06/01/2020.
//  Copyright © 2020 Denis Mullaraj. All rights reserved.
//

import Foundation

class DriveSafeDAOImpl: DriveSafeDAO {
    
    var userDefaults: UserDefaultsProtocol = UserDefaults.standard
    
    func persistEyeClosedLimitInSeconds(from value: String?) {
        var limitInSecondsToPersist = getDefaultEyeClosedLimitInSeconds()
        if let secondsText = value, let seconds = Int(secondsText) {
            limitInSecondsToPersist = seconds
        }
        userDefaults.set(limitInSecondsToPersist, forKey: DriveSafeConfig.SHARED_PREF_EYECLOSED_SECONDS_LIMIT)
    }
    
    func getEyeClosedLimitInSeconds() -> Int {
        var eyeClosedLimitInSeconds = userDefaults.integer(forKey: DriveSafeConfig.SHARED_PREF_EYECLOSED_SECONDS_LIMIT)
        if eyeClosedLimitInSeconds == 0 {
            eyeClosedLimitInSeconds = getDefaultEyeClosedLimitInSeconds()
        }
        return eyeClosedLimitInSeconds
    }
    
    func getDefaultEyeClosedLimitInSeconds() -> Int {
        return DriveSafeConfig.DEFAULT_EYECLOSED_SECONDS_LIMIT
    }
}
