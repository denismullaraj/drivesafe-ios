//
//  HomeViewControllerTest.swift
//  Drive SafeTests
//
//  Created by Denis Mullaraj on 06/01/2020.
//  Copyright © 2020 Denis Mullaraj. All rights reserved.
//

import XCTest
@testable import Drive_Safe

class HomeViewControllerTest: XCTestCase {
    
    var sut: HomeViewController!
    
    override func setUp() {
        super.setUp()
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        sut = sb.instantiateViewController(withIdentifier: String(describing: HomeViewController.self)) as? HomeViewController
    }
    
    override func tearDown() {
        sut = nil
        
        super.tearDown()
    }
    
    func test_outletsAreLinked() {
        sut.loadViewIfNeeded()
        
        XCTAssertNotNil(sut.keepMeSafeButton, "keepMeSafeButton is not linked")
        XCTAssertNotNil(sut.secondsEyesClosedLimitTextField, "secondsEyesClosedLimitTextField is not linked")
    }
    
    func test_faceTrackingIsNotSupported_showsWarning() {
        sut.isFaceTrackingSupported = false
        
        let alertVerifier = AlertVerifier()
        
        sut.loadViewIfNeeded()
        
        alertVerifier.verify(
            title: "Warning",
            message: "App requires iPhone X or later in order to use Camera with TrueDepth feature",
            animated: true,
            actions: [
                .default("OK")
            ])
    }

}
