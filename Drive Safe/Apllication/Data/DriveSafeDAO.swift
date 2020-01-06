//
//  DriveSafeDAO.swift
//  Drive Safe
//
//  Created by Denis Mullaraj on 06/01/2020.
//  Copyright © 2020 Denis Mullaraj. All rights reserved.
//

import Foundation

protocol DriveSafeDAO {
    var userDefaults: UserDefaultsProtocol { get set }
    
    func persistEyeClosedLimitInSeconds(from value: String?)
    func getEyeClosedLimitInSeconds() -> Int
    func getDefaultEyeClosedLimitInSeconds() -> Int
}
