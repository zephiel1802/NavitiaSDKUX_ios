//
//  Journey+Extension.swift
//  NavitiaSDKUI
//
//  Created by Flavien Sicard on 27/08/2018.
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
