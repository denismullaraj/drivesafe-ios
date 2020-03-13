//
//  AVAudioPlayerMock.swift
//  Drive SafeTests
//
//  Created by Denis Mullaraj on 29/02/2020.
//  Copyright © 2020 dmullaraj. All rights reserved.
//

@testable import Drive_Safe

class AVAudioPlayerMock: AVAudioPlayerProtocol {
    var playIsCalled = false
    
    func play() -> Bool {
        playIsCalled = true
        return true
    }
}
