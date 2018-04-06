//
//  Int32+Extension.swift
//  NavitiaSDKUI
//
//  Created by Flavien Sicard on 28/03/2018.
//  Copyright © 2018 kisio. All rights reserved.
//

import Foundation

extension Int32 {
    
    func toString(allowedUnits: NSCalendar.Unit) -> String? {
        let formatter = DateComponentsFormatter()
        
        formatter.unitsStyle = .abbreviated
        formatter.allowedUnits = allowedUnits
        formatter.zeroFormattingBehavior = [ .dropAll ]
        return formatter.string(from: TimeInterval(self))
    }
    
    func toString() -> String {
        return String(self)
    }
}
