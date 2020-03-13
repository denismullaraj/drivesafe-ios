//
//  KeepEyesOpenViewControllerTest.swift
//  Drive SafeTests
//
//  Created by Denis Mullaraj on 22/02/2020.
//  Copyright © 2020 dmullaraj. All rights reserved.
//

import XCTest
@testable import Drive_Safe

class KeepEyesOpenViewControllerTest: XCTestCase {
    
    private var sut: KeepEyesOpenViewController!
    private var eyeDetectorSpy: EyeDetectorSpy!
    private var settingsMock: SettingsMock!
    private var audioPlayerMock: AVAudioPlayerMock!
    
    override func setUp() {
        super.setUp()
        
        sut = KeepEyesOpenViewController()
        
        eyeDetectorSpy = EyeDetectorSpy()
        sut.eyeDetector = eyeDetectorSpy
        
        settingsMock = KeepEyesOpenSettings()
        sut.settings = settingsMock
        
        audioPlayerMock = AVAudioPlayerMock()
        sut.avPlayer = audioPlayerMock
    }
    
    override func tearDown() {
        sut = nil
        eyeDetectorSpy = nil
        settingsMock = nil
        audioPlayerMock = nil
        
        super.tearDown()
    }
    
    func test_startingViewController_startsEyeDetectorOnce(){
        sut.loadViewIfNeeded()
        sut.viewWillAppear(false)
        
        XCTAssertEqual(eyeDetectorSpy.startCallCount, 1)
    }
    
    func test_withClosedEyeDetected_limitSecondsPassed_playAlarm(){
        sut.loadViewIfNeeded()
        sut.viewWillAppear(false)
        
        sut.seconds = 4
        
        eyeDetectorSpy.delegate?.eyeBlinkDetected(left: 0.8, right: 0.8)
        
        XCTAssertTrue(audioPlayerMock.playIsCalled)
    }
    
    func test_withClosedEyeDetected_limitSecondsPassed_startsFlickeringOfBackground(){
        sut.loadViewIfNeeded()
        sut.viewWillAppear(false)
        
        let flickeringViewMock = FlickeringViewMock()
        sut.flickeringView = flickeringViewMock
        sut.seconds = 4
        
        eyeDetectorSpy.delegate?.eyeBlinkDetected(left: 0.8, right: 0.8)
        
        XCTAssertTrue(flickeringViewMock.isStartFlickeringCalled)
    }
    
    func test_withOpenEyesDetected_stopsFlickeringOfBackground(){
        sut.loadViewIfNeeded()
        sut.viewWillAppear(false)
        
        let flickeringViewMock = FlickeringViewMock()
        sut.flickeringView = flickeringViewMock
        
        eyeDetectorSpy.delegate?.eyeBlinkDetected(left: 0.015, right: 0.015)
        executeRunLoop()
        
        XCTAssertTrue(flickeringViewMock.isStopFlickeringCalled)
    }
}

private class KeepEyesOpenSettings: SettingsMock {
    override func getEyeClosedLimitInSeconds() -> Int {
        return 4
    }
}
