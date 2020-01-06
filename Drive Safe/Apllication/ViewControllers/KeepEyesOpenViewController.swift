//
//  KeepEyesOpenViewController.swift
//  Drive Safe
//
//  Created by Denis Mullaraj on 06/01/2020.
//  Copyright © 2020 Denis Mullaraj. All rights reserved.
//

import UIKit
import ARKit

class KeepEyesOpenViewController: UIViewController {

    var session: ARSession!
    var timer : Timer!
    var seconds = 0
    
    var limitEyeClosedInSeconds = UserDefaults.standard.integer(forKey: DriveSafeConfig.SHARED_PREF_EYECLOSED_SECONDS_LIMIT)
    
    var avPlayer: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isTranslucent = false
        
        session = ARSession()
        session.delegate = self
        
        timer = Timer()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(KeepEyesOpenViewController.processSeconds), userInfo: nil, repeats: true)
        
        let path = Bundle.main.path(forResource: DriveSafeConfig.RESOURCES_AUDIO_ALARM, ofType:nil)!
        let url = URL(fileURLWithPath: path)
        do {
            avPlayer = try AVAudioPlayer(contentsOf: url)
        } catch {
            // couldn't load file :(
        }
        view.backgroundColor = UIColor.blue
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard ARFaceTrackingConfiguration.isSupported else { fatalError("iPhone X required") }
        
        let config = ARFaceTrackingConfiguration()
        session.run(config, options: [.resetTracking, .removeExistingAnchors])
    }
}

// MARK: Face detection
extension KeepEyesOpenViewController: ARSessionDelegate {
    
    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        if let faceAnchor = anchors.first as? ARFaceAnchor {
            process(with: faceAnchor)
        }
    }
    
    private func process(with faceAnchor: ARFaceAnchor) {
        var blendShapes: [ARFaceAnchor.BlendShapeLocation: Any] = faceAnchor.blendShapes
        
        guard let eyeBlinkLeft = blendShapes[.eyeBlinkLeft] as? Float else { return }
        guard let eyeBlinkRight = blendShapes[.eyeBlinkRight] as? Float else { return }
        
        if eyeBlinkLeft > 0.5, eyeBlinkRight > 0.5 {
            if seconds >= limitEyeClosedInSeconds {
                avPlayer?.play()
                view.backgroundColor = UIColor.white
                delay(0.3) {
                    self.view.backgroundColor = UIColor.red
                }
            }
            
        } else if eyeBlinkLeft < 0.025, eyeBlinkRight < 0.025 {
            seconds = 0
            delay(1.5) {
                self.view.backgroundColor = UIColor.blue
            }
        } else {
            seconds = 0
        }
    }
    
    private func delay(_ delay: Double, closure: @escaping ()->()) {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    }
}

// MARK: Timer processing
extension KeepEyesOpenViewController {
    
    @objc func processSeconds() {
        seconds += 1
    }
}
