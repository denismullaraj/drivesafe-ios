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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard ARFaceTrackingConfiguration.isSupported else {
            keepMeSafeButton.isEnabled = false
            MessageAlertController.displayConfirmationDialog("Warning", message: "App requires iPhone X or later in order to use Camera with TrueDepth feature", from: self)
            return
        }
    }

    @IBAction func secondsForEyesClosedLimitEditingChanged(_ sender: Any) {
        if let secondsTxt = secondsEyesClosedLimitTextField.text, let seconds = Int(secondsTxt) {
            UserDefaults.standard.set(seconds, forKey: DriveSafeConfig.SHARED_PREF_EYECLOSED_SECONDS_LIMIT)
        }
        hideKeyboard()
    }
    
   
    @IBAction func keepMeSafeTapped(_ sender: Any) {
        navigationController?.pushViewController(KeepEyesOpenViewController(), animated: true)
    }
    
    private func hideKeyboard() {
        view.endEditing(true)
    }

}
