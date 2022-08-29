//
//  KeepEyesOpenViewModel.swift
//  Drive Safe
//
//  Created by Denis Mullaraj on 29.8.22.
//  Copyright © 2022 dmullaraj. All rights reserved.
//

import Foundation

struct KeepEyesOpenViewModel {
    let preferences: PreferencesService
    
    init(preferences: PreferencesService) {
        self.preferences = preferences
    }
}
