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
    
    func test_linkedToStorybard() {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let sut = sb.instantiateViewController(withIdentifier: String(describing: HomeViewController.self))
        XCTAssertNotNil(sut)
    }
    
    func test_outletsAreLinked() {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let sut = sb.instantiateViewController(withIdentifier: String(describing: HomeViewController.self)) as! HomeViewController
        
        sut.loadViewIfNeeded()
        
        XCTAssertNotNil(sut.keepMeSafeButton, "keepMeSafeButton is not linked")
        XCTAssertNotNil(sut.secondsEyesClosedLimitTextField, "secondsEyesClosedLimitTextField is not linked")
    }

}
