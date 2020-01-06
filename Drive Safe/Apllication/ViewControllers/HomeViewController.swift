//
//  HomeViewController.swift
//  Drive Safe
//
//  Created by Denis Mullaraj on 06/01/2020.
//  Copyright © 2020 Denis Mullaraj. All rights reserved.
//

import UIKit
import ARKit

class HomeViewController: UIViewController {

    @IBOutlet weak var secondsEyesClosedLimitTextField: SingleCharUITextField!
    @IBOutlet weak var keepMeSafeButton: UIButton!
    
    var isFaceTrackingSupported: Bool = {
        return ARFaceTrackingConfiguration.isSupported
    }()
    
    var userDefaults: UserDefaultsProtocol = UserDefaults.standard
    
    let defaultEyeClosedSecondsLimit = DriveSafeConfig.DEFAULT_EYECLOSED_SECONDS_LIMIT
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard isFaceTrackingSupported else {
            keepMeSafeButton.isEnabled = false
            MessageAlertController.displayConfirmationDialog("Warning", message: "App requires iPhone X or later in order to use Camera with TrueDepth feature", from: self)
            return
        }
        
        setupTextField()
    }

    @IBAction func secondsForEyesClosedLimitEditingChanged(_ sender: Any) {
        if let secondsTxt = secondsEyesClosedLimitTextField.text, let seconds = Int(secondsTxt) {
            userDefaults.set(seconds, forKey: DriveSafeConfig.SHARED_PREF_EYECLOSED_SECONDS_LIMIT)
        } else {
            userDefaults.set(DriveSafeConfig.DEFAULT_EYECLOSED_SECONDS_LIMIT, forKey: DriveSafeConfig.SHARED_PREF_EYECLOSED_SECONDS_LIMIT)
        }
        hideKeyboard()
    }
    
   
    @IBAction func keepMeSafeTapped(_ sender: Any) {
        navigationController?.pushViewController(KeepEyesOpenViewController(), animated: true)
    }
    
    private func hideKeyboard() {
        view.endEditing(true)
    }

    private func setupTextField() {
        secondsEyesClosedLimitTextField.placeholder = String(describing: defaultEyeClosedSecondsLimit)
        
        let storedEyeClosedSecondsLimit = userDefaults.integer(forKey: DriveSafeConfig.SHARED_PREF_EYECLOSED_SECONDS_LIMIT)
        if  storedEyeClosedSecondsLimit != defaultEyeClosedSecondsLimit, storedEyeClosedSecondsLimit != 0 {
            secondsEyesClosedLimitTextField.insertText(String(describing: userDefaults.integer(forKey: DriveSafeConfig.SHARED_PREF_EYECLOSED_SECONDS_LIMIT)))
        }
    }
}
