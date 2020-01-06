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
    
    var driveSafeDao: DriveSafeDAO = DriveSafeDAOImpl()
    
    var isFaceTrackingSupported: Bool = {
        return ARFaceTrackingConfiguration.isSupported
    }()
    
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
        driveSafeDao.persistEyeClosedLimitInSeconds(from: secondsEyesClosedLimitTextField.text)
        hideKeyboard()
    }
    
   
    @IBAction func keepMeSafeTapped(_ sender: Any) {
        navigationController?.pushViewController(KeepEyesOpenViewController(), animated: true)
    }
    
    private func hideKeyboard() {
        view.endEditing(true)
    }

    private func setupTextField() {
        let storedEyeClosedLimitInSeconds = driveSafeDao.getEyeClosedLimitInSeconds()
        let defaultEyeClosedSecondsLimit = driveSafeDao.getDefaultEyeClosedLimitInSeconds()
        
        secondsEyesClosedLimitTextField.placeholder = String(describing: defaultEyeClosedSecondsLimit)
        
        if storedEyeClosedLimitInSeconds != driveSafeDao.getDefaultEyeClosedLimitInSeconds() {
            secondsEyesClosedLimitTextField.insertText(String(describing: storedEyeClosedLimitInSeconds))
        }
    }
}
