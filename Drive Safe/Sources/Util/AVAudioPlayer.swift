//
//  AVAudioPlayerProtocol.swift
//  Drive Safe
//
//  Created by Denis Mullaraj on 29/02/2020.
//  Copyright © 2020 dmullaraj. All rights reserved.
//

import AVFoundation

protocol AVAudioPlayerProtocol {
    func play() -> Bool
}

extension AVAudioPlayer: AVAudioPlayerProtocol {}
