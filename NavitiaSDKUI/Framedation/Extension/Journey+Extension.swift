//
//  Journey+Extension.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import Foundation

extension Journey {
    
    var isRidesharing: Bool {
        get {
            if let ridesharingDistance = distances?.ridesharing, ridesharingDistance > 0 {
                return true
            }
            return false
        }
    }
    
}
