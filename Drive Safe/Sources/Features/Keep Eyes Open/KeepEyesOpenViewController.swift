//
//  KeepEyesOpenViewController.swift
//  Drive Safe
//
//  Created by Denis Mullaraj on 06/01/2020.
//  Copyright © 2020 Denis Mullaraj. All rights reserved.
//

import UIKit
import AVFoundation

class KeepEyesOpenViewController: UIViewController {
    var seconds = 0
    
    lazy var settings: SettingsProtocol = {
        return Settings()
    }()
    
    var eyeDetector: EyeDetectorProtocol = {
        return EyeDetector()
    }()
    
    var flickeringView: FlickeringViewProtocol = {
        return FlickeringView(backgroundColor: UIColor.blue)
    }()
    
    var avPlayer: AVAudioPlayerProtocol? = {
        do {
            guard let path = Bundle.main.path(forResource: DriveSafeConfig.RESOURCES_AUDIO_ALARM, ofType:nil) else { fatalError("No alarm sound found!") }
            
            let url = URL(fileURLWithPath: path)
            
            return try AVAudioPlayer(contentsOf: url)
        } catch {
            fatalError("Audio Player couldn't be initialised!")
        }
    }()
    
    private var timer: Timer!
    private lazy var limitEyeClosedInSeconds: Int = {
        return settings.getEyeClosedLimitInSeconds()
    }()
    private var alarmFlickeringColor: FlickerRangeColor = {
        return FlickerRangeColor(color1: UIColor.white, color2: UIColor.red)
    }()
    
    //MARK: ViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eyeDetector.delegate = self
        
        flickeringView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(flickeringView)
        flickeringView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        flickeringView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        flickeringView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        flickeringView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        navigationController?.navigationBar.isTranslucent = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        eyeDetector.start()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(processSeconds), userInfo: nil, repeats: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        timer?.invalidate()
        timer = nil
        seconds = 0
    }
    
    @objc func processSeconds() {
        seconds += 1
    }
}


// MARK: Face detection
extension KeepEyesOpenViewController: EyeDetectorDelegate {
    func eyeBlinkDetected(left: Float, right: Float) {
        process(left, right)
    }
    
    private func process(_ eyeBlinkLeft: Float, _ eyeBlinkRight: Float) {
        if eyeBlinkLeft > 0.5, eyeBlinkRight > 0.5 {
            if seconds >= limitEyeClosedInSeconds {
                avPlayer?.play()
                flickeringView.startFlickeringBackground(between: alarmFlickeringColor)
            }
        } else if eyeBlinkLeft < 0.025, eyeBlinkRight < 0.025 {
            seconds = 0
            flickeringView.stopFlickering(with: UIColor.blue)
        } else {
            seconds = 0
        }
    }
}
