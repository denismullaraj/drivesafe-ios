//
//  HomeViewModel.swift
//  Drive Safe
//
//  Created by Denis Mullaraj on 29.8.22.
//  Copyright © 2022 dmullaraj. All rights reserved.
//

import Foundation

import RxCocoa

struct HomeViewModel {
    
    var isKeyboardHidden: Driver<Bool> {
        isKeyboardHiddenRelay.asDriver(onErrorJustReturn: true)
    }
    
    var secondsPlaceholderText: Driver<String> {
        .just(String(describing: PreferencesService.defaultMaxTimeEyesCanBeClosed))
    }
    
    var secondsText: Driver<String> {
        let storedEyeClosedLimitInSeconds = preferences.maxTimeEyesCanBeClosed
        if storedEyeClosedLimitInSeconds != PreferencesService.defaultMaxTimeEyesCanBeClosed {
            return .just(String(describing: storedEyeClosedLimitInSeconds))
        }
        return .just("")
    }
    
    var didRequestShowNextScreen: Driver<Void> {
        didRequestShowNextScreenRelay.asDriver(onErrorJustReturn: ())
    }
    
    let preferences: PreferencesService

    private let isKeyboardHiddenRelay = PublishRelay<Bool>()
    private let didRequestShowNextScreenRelay = PublishRelay<Void>()

    init(preferences: PreferencesService) {
        self.preferences = preferences
    }
    
    func secondsTextFieldChanged(newValue: String?) {
        if let newLimitText = newValue, let newLimit = Int(newLimitText) {
            preferences.maxTimeEyesCanBeClosed = newLimit
        }
        isKeyboardHiddenRelay.accept(true)
    }
    
    func keepMeSafeButtonTapped() {
        didRequestShowNextScreenRelay.accept(())
    }

}
