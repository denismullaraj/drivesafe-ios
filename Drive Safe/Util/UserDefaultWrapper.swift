//
//  UserDefaultWrapper.swift
//  Drive Safe
//
//  Created by Denis Mullaraj on 06/01/2020.
//  Copyright © 2020 Denis Mullaraj. All rights reserved.
//

import Foundation

@propertyWrapper
struct UserDefaultWrapper<Value> {
    let key: String
    let defaultValue: Value
    
    init(key: String, defaultValue: Value) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    var wrappedValue: Value {
        get {
            (UserDefaults.standard.object(forKey: self.key) as? Value) ?? self.defaultValue
        }
        
        set {
            UserDefaults.standard.setValue(newValue, forKey: self.key)
        }
    }
}
