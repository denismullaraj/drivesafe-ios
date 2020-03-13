//
//  EyeDetectorSpy.swift
//  Drive SafeTests
//
//  Created by Denis Mullaraj on 23/02/2020.
//  Copyright © 2020 dmullaraj. All rights reserved.
//

@testable import Drive_Safe

class EyeDetectorSpy: EyeDetectorProtocol {
    var delegate: EyeDetectorDelegate?
    var startCallCount = 0
    
    func start() {
        startCallCount += 1
    }
}
