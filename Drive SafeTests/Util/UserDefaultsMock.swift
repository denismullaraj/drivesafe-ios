//
//  UserDefaultsMock.swift
//  Drive SafeTests
//
//  Created by Denis Mullaraj on 06/01/2020.
//  Copyright © 2020 Denis Mullaraj. All rights reserved.
//

@testable import Drive_Safe

class UserDefaultsMock: UserDefaultsProtocol {
    var integers: [String: Int] = [:]
    
    func set(_ value: Int, forKey defaultName: String) {
        integers[defaultName] = value
    }
    
    func integer(forKey defaultName: String) -> Int {
        return integers[defaultName] ?? 0
    }
}
