//
//  Int32+Extension.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import Foundation

extension Int32 {
    
    func toStringTime() -> String {
        let minutes = (self / 60) % 60
        let hours = (self / 3600)
        
        if hours > 0 {
            return String(format: "%1dh%02d", hours, minutes)
        }
        
        return String(format: "%1d %@", minutes, "units_minutes_short".localized())
    }
    
    func toAttributedStringTime(sizeBold: CGFloat = 12.0, sizeNormal: CGFloat = 12.0) -> NSMutableAttributedString {
        let minutes = (self / 60) % 60
        let hours = (self / 3600)
        
        if hours > 0 {
            return NSMutableAttributedString()
                .bold(String(format: "%1dh%02d", hours, minutes), color: Configuration.Color.secondary)
        }
        
        return NSMutableAttributedString()
            .bold(String(format: "%1d", minutes), color: Configuration.Color.secondary, size: sizeBold)
            .normal(String(format: " %@", "units_minutes_short".localized()), color: Configuration.Color.secondary, size: sizeNormal)
    }
    
    func toString() -> String {
        return String(self)
    }
    
    func toString(format: String) -> String {
        return String(format: format, Double(self) / 1000)
    }
    
    func minuteToString() -> String {
        return String(self / 60)
    }
}
