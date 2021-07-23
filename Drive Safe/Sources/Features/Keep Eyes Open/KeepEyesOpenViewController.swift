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
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupMainView()
        setupEyeDetector()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        eyeDetector.start()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.processSeconds()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        stopTimer()
    }
    
    //MARK: - Helpers
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.isTranslucent = false
    }
    
    private func setupMainView() {
        flickeringView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(flickeringView)
        NSLayoutConstraint.activate([
            flickeringView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            flickeringView.topAnchor.constraint(equalTo: view.topAnchor),
            flickeringView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            flickeringView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupEyeDetector() {
        eyeDetector.delegate = self
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
        seconds = 0
    }

    @objc private func processSeconds() {
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
