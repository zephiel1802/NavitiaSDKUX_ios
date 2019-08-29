//
//  UIColor+Extension.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import Foundation

extension UIColor {
    
    func contrastColor(brightColor: UIColor = UIColor.white, darkColor: UIColor = UIColor.black) -> UIColor {
        var r, g, b, a: CGFloat
        (r, g, b, a) = (0, 0, 0, 0)
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        let luminance = 0.2126 * r + 0.7152 * g + 0.0722 * b
        return luminance < 0.5 ? darkColor : brightColor
    }
    
    func isEqualWithConversion(_ color: UIColor) -> Bool {
        guard let space = self.cgColor.colorSpace,
            let converted = color.cgColor.converted(to: space, intent: .absoluteColorimetric, options: nil) else {
                return false
        }
        
        return self.cgColor == converted
    }
}
