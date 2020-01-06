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

    //MARK: Properties
    var session = ARSession()
    var timer : Timer!
    var seconds = 0
    
    var limitEyeClosedInSeconds: Int = {
        let driveSafeDao = DriveSafeDAOImpl()
        return driveSafeDao.getEyeClosedLimitInSeconds()
    }()
    
    lazy var avPlayer: AVAudioPlayer? = {
        do {
            guard let path = Bundle.main.path(forResource: DriveSafeConfig.RESOURCES_AUDIO_ALARM, ofType:nil) else { fatalError("No alarm sound found!") }
            
            let url = URL(fileURLWithPath: path)
            
            return try AVAudioPlayer(contentsOf: url)
        } catch {
            fatalError("Audio Player couldn't be initialised!")
        }
    }()
    
    
    //MARK: ViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        session.delegate = self
        
        view.backgroundColor = UIColor.blue
        navigationController?.navigationBar.isTranslucent = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let config = ARFaceTrackingConfiguration()
        session.run(config, options: [.resetTracking, .removeExistingAnchors])
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(processSeconds), userInfo: nil, repeats: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        timer?.invalidate()
        timer = nil
        seconds = 0
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
