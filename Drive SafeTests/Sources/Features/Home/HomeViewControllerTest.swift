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
    
    private var sut: HomeViewController!
    private var userDefaultsMock: UserDefaultsMock!
    
    override func setUp() {
        super.setUp()
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        sut = sb.instantiateViewController(withIdentifier: String(describing: HomeViewController.self)) as? HomeViewController
        
        userDefaultsMock = UserDefaultsMock()
        sut.settings.userDefaults = userDefaultsMock
    }
    
    override func tearDown() {
        sut = nil
        userDefaultsMock = nil
        
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
    
    func test_faceTrackingIsSupported_warningIsNotShown() {
        sut.isFaceTrackingSupported = true
        
        let alertVerifier = AlertVerifier()
        
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(alertVerifier.presentedCount, 0)
    }
    
    func test_settingSecondsTo3_store3AsUserDefaultSeconds() {
        sut.loadViewIfNeeded()
        
        sut.secondsEyesClosedLimitTextField.insertText("3")
        XCTAssertEqual(userDefaultsMock.integer(forKey: DriveSafeConfig.SHARED_PREF_EYECLOSED_SECONDS_LIMIT), 3)
    }
    
    func test_tapping_EnabledKeepMeSafeButton_redirectsTo_keepEyesOpenViewController() {
        sut.isFaceTrackingSupported = true
        sut.loadViewIfNeeded()
        
        let navigation = UINavigationController(rootViewController: sut)
        sut.keepMeSafeButton.sendActions(for: .touchUpInside)
        
        executeRunLoop()
        
        XCTAssertEqual(navigation.viewControllers.count, 2, "navigation stack")
        
        let lastPushedVC = navigation.viewControllers.last
        guard (lastPushedVC as? KeepEyesOpenViewController) != nil else {
            XCTFail("Expected KeepEyesOpenViewController, but was \(String(describing: lastPushedVC))")
            return
        }
    }
}
