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
    
    var viewIsReady: () -> Void = {}
    
    var seconds = 0
    var flickeringView: FlickeringViewProtocol = FlickeringView(backgroundColor: UIColor.blue)
    
    var avPlayer: AVAudioPlayerProtocol? = {
        do {
            guard let path = Bundle.main.path(forResource: "alarm.wav", ofType:nil) else { fatalError("No alarm sound found!") }
            
            let url = URL(fileURLWithPath: path)
            
            return try AVAudioPlayer(contentsOf: url)
        } catch {
            fatalError("Audio Player couldn't be initialised!")
        }
    }()
    
    private var timer: Timer!
    
    private var alarmFlickeringColor: FlickerRangeColor = {
        return FlickerRangeColor(color1: UIColor.white, color2: UIColor.red)
    }()
    
    private let viewmodel: KeepEyesOpenViewModel
    
    //MARK: - Lifecycle
    
    init(viewmodel: KeepEyesOpenViewModel) {
        self.viewmodel = viewmodel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupMainView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewIsReady()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.processSeconds()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        stopTimer()
    }
    
    func playAlarmIfNeeded() {
        if seconds >= viewmodel.preferences.maxTimeEyesCanBeClosed {
            avPlayer?.play()
            flickeringView.startFlickeringBackground(between: alarmFlickeringColor)
        }
    }
    
    func stopAlarm() {
        resetTimer()
        flickeringView.stopFlickering(with: UIColor.blue)
    }
    
    func resetTimer() {
        seconds = 0
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
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
        seconds = 0
    }

    @objc private func processSeconds() {
        seconds += 1
    }
}
