//
//  EyeDetector.swift
//  Drive Safe
//
//  Created by Denis Mullaraj on 09/02/2020.
//  Copyright © 2020 dmullaraj. All rights reserved.
//

import ARKit

protocol EyeDetectorProtocol: AnyObject {
    func start()
}

class EyeDetector: NSObject, ARSessionDelegate, EyeDetectorProtocol {
    var didDetectEyesClosed: () -> Void = {}
    var didDetectEyesOpened: () -> Void = {}
    var didFailEyesDetection: () -> Void = {}
    
    private let session = ARSession()
    
    override init() {
        super.init()
        session.delegate = self
    }
    
    func start() {
        let config = ARFaceTrackingConfiguration()
        session.run(config, options: [.resetTracking, .removeExistingAnchors])
    }
    
    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        if let faceAnchor = anchors.first as? ARFaceAnchor {
            let blendShapes: [ARFaceAnchor.BlendShapeLocation: Any] = faceAnchor.blendShapes
            
            guard let eyeBlinkLeft = blendShapes[.eyeBlinkLeft] as? Float else { return }
            guard let eyeBlinkRight = blendShapes[.eyeBlinkRight] as? Float else { return }
            
            if eyeBlinkLeft > 0.5, eyeBlinkRight > 0.5 {
                didDetectEyesClosed()
            } else if eyeBlinkLeft < 0.025, eyeBlinkRight < 0.025 {
                didDetectEyesOpened()
            } else {
                didFailEyesDetection()
            }
        }
    }
}
