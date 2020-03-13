//
//  FlickeringView.swift
//  Drive Safe
//
//  Created by Denis Mullaraj on 01/03/2020.
//  Copyright © 2020 dmullaraj. All rights reserved.
//

import UIKit

typealias FlickeringViewProtocol = UIView & FlickeringProtocol

struct FlickerRangeColor {
    let color1: UIColor
    let color2: UIColor
}

protocol FlickeringProtocol: class {
    func startFlickeringBackground(between colors: FlickerRangeColor)
    func stopFlickering(with resetColor: UIColor)
}

class FlickeringView: FlickeringViewProtocol {
    init(backgroundColor: UIColor) {
        super.init(frame: CGRect.zero)
        self.backgroundColor = backgroundColor
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startFlickeringBackground(between colors: FlickerRangeColor) {
        backgroundColor = colors.color1
        delay(0.3) {
            self.backgroundColor = colors.color2
        }
    }
    
    func stopFlickering(with resetColor: UIColor) {
        delay(1.5) {
            self.backgroundColor = resetColor
        }
    }
    
    private func delay(_ delay: Double, closure: @escaping ()->()) {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    }
}
