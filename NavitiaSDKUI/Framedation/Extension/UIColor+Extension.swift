//
//  UIColor+Extension.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import Foundation

extension UIColor {
    
    func contrastColor(brightColor: UIColor = UIColor.white, darkColor: UIColor = UIColor.black) -> UIColor {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        red = red < 0.04045 ? red / 12.92 : pow((red + 0.055) / 1.055, 2.4);
        green = green < 0.04045 ? green / 12.92 : pow((green + 0.055) / 1.055, 2.4);
        blue = blue < 0.04045 ? blue / 12.92 : pow((blue + 0.055) / 1.055, 2.4);
        
        let luminance = 0.2126 * red + 0.7152 * green + 0.0722 * blue
        return luminance > 0.5 ? darkColor : brightColor
    }
    
    func isEqualWithConversion(_ color: UIColor) -> Bool {
        guard let space = self.cgColor.colorSpace,
            let converted = color.cgColor.converted(to: space, intent: .absoluteColorimetric, options: nil) else {
                return false
        }
        
        return self.cgColor == converted
    }
}
