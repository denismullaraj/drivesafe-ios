//
//  FlickeringViewMock.swift
//  Drive SafeTests
//
//  Created by Denis Mullaraj on 01/03/2020.
//  Copyright © 2020 dmullaraj. All rights reserved.
//

@testable import Drive_Safe

class FlickeringViewMock: FlickeringViewProtocol {
    var isStartFlickeringCalled = false
    var isStopFlickeringCalled = false
    func startFlickeringBackground(between colors: FlickerRangeColor) {
        isStartFlickeringCalled = true
    }
    
    func stopFlickering(with resetColor: UIColor) {
        isStopFlickeringCalled = true
    }
}
