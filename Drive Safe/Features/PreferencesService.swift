//
//  Preferences.swift
//  Drive Safe
//
//  Created by Denis Mullaraj on 29.8.22.
//  Copyright © 2022 dmullaraj. All rights reserved.
//

import Foundation

final class PreferencesService {
    static let defaultMaxTimeEyesCanBeClosed: Int = 2
    
    @UserDefaultWrapper(key: "maxTimeEyesCanBeClosed", defaultValue: defaultMaxTimeEyesCanBeClosed)
    var maxTimeEyesCanBeClosed: Int
}
