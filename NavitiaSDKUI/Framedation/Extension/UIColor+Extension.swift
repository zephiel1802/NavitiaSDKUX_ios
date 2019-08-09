//
//  UIColor+Extension.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import Foundation

extension UIColor {
    
    func contrastColor(brightColor: UIColor = UIColor.white, darkColor: UIColor = UIColor.black) -> UIColor {
        var r = CGFloat(0)
        var g = CGFloat(0)
        var b = CGFloat(0)
        var a = CGFloat(0)
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        return (1 - ((0.299 * r) + (0.587 * g) + (0.114 * b))) > 0.5 ? darkColor : brightColor
    }
    
    func isEqualWithConversion(_ color: UIColor) -> Bool {
        guard let space = self.cgColor.colorSpace,
            let converted = color.cgColor.converted(to: space, intent: .absoluteColorimetric, options: nil) else {
                return false
        }
        
        return self.cgColor == converted
    }
}
