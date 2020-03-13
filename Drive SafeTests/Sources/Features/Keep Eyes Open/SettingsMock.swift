//
//  MockSettings.swift
//  Drive SafeTests
//
//  Created by Denis Mullaraj on 29/02/2020.
//  Copyright © 2020 dmullaraj. All rights reserved.
//

@testable import Drive_Safe

class SettingsMock: SettingsProtocol {
    var userDefaults: UserDefaultsProtocol {
        get {
            fatalError("\(self) has not been implemented!")
        }
        set {
            fatalError("\(self) has not been implemented!")
        }
    }
    
    func persistEyeClosedLimitInSeconds(from value: String?) {
        fatalError("\(self) has not been implemented!")
    }
    
    func getEyeClosedLimitInSeconds() -> Int {
        fatalError("\(self) has not been implemented!")
    }
    
    func getDefaultEyeClosedLimitInSeconds() -> Int {
        fatalError("\(self) has not been implemented!")
    }
}
