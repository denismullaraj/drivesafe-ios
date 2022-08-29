//
//  DependencyContainer.swift
//  Drive Safe
//
//  Created by Denis Mullaraj on 29.8.22.
//  Copyright © 2022 dmullaraj. All rights reserved.
//

import UIKit
import CoreData

final class DependencyContainer {
    private lazy var preferences = PreferencesService()
}

extension DependencyContainer: ViewControllerFactory {
    func makeHomeViewController() -> HomeViewController {
        let vm = HomeViewModel(preferences: preferences)
        return HomeViewController(viewmodel: vm, factory: self)
    }
    
    func makeKeepEyesOpenViewController() -> KeepEyesOpenViewController {
        let vm = KeepEyesOpenViewModel(preferences: preferences)
        let vc = KeepEyesOpenViewController(viewmodel: vm)
        let detector = EyeDetector()
        vc.viewIsReady = detector.start
        detector.didDetectEyesOpened = vc.stopAlarm
        detector.didDetectEyesClosed = vc.playAlarmIfNeeded
        detector.didFailEyesDetection = vc.resetTimer
        return vc
    }
}
