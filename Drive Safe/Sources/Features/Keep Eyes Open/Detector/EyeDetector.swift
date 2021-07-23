//
//  EyeDetector.swift
//  Drive Safe
//
//  Created by Denis Mullaraj on 09/02/2020.
//  Copyright © 2020 dmullaraj. All rights reserved.
//

import ARKit

protocol EyeDetectorDelegate: AnyObject {
    func eyeBlinkDetected(left: Float, right: Float)
}

protocol EyeDetectorProtocol: AnyObject {
    var delegate: EyeDetectorDelegate? { get set }
    func start()
}

class EyeDetector: NSObject, ARSessionDelegate, EyeDetectorProtocol {
    private var session = ARSession()
    weak var delegate: EyeDetectorDelegate?
    
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
            
            delegate?.eyeBlinkDetected(left: eyeBlinkLeft, right: eyeBlinkRight)
        }
    }
}
