//
//  Int32+Extension.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import Foundation

extension Int32 {
    
    func toStringTime() -> String {
        // let seconds = self % 60
        let minutes = (self / 60) % 60
        let hours = (self / 3600)
        
        if hours > 0 {
            return String(format: "%1dh%02d", hours, minutes)
        }
        return String(format: "%1d min", minutes)
    }
    
    func toAttributedStringTime(sizeBold: CGFloat = 12.0, sizeNormal: CGFloat = 12.0) -> NSMutableAttributedString {
        let minutes = (self / 60) % 60
        let hours = (self / 3600)
        
        if hours > 0 {
            return NSMutableAttributedString()
                .bold("%1dh%02d", color: Configuration.Color.tertiary)
        }
        return NSMutableAttributedString()
            .bold(String(format: "%1d", minutes), color: Configuration.Color.tertiary, size: sizeBold)
            .normal(" min", color: Configuration.Color.tertiary, size: sizeNormal)
    }
    
    func toString() -> String {
        return String(self)
    }
    
    func toString(format: String) -> String {
        let tmp = Double(self)
        return String(format: format, tmp / 1000)
    }
    
    func minuteToString() -> String {
        return String(self / 60)
    }
    
}
