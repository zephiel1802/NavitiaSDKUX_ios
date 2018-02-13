//
//  Color.swift
//  RenderTest
//
//  Created by Thomas Noury on 02/08/2017.
//  Copyright © 2017 Kisio. All rights reserved.
//

import UIKit

public func getHexadecimalColorWithFallback(_ hex: String?) -> String {
    if (hex == nil) {
        return "000000"
    }

    return hex!
}

public func getUIColorFromHexadecimal(hex: String) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }
    
    if ((cString.characters.count) != 6) {
        return UIColor.gray
    }
    
    var rgbValue:UInt32 = 0
    Scanner(string: cString).scanHexInt32(&rgbValue)
    
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}

public func contrastColor(color: UIColor, brightColor: UIColor = UIColor.white, darkColor: UIColor = UIColor.black) -> UIColor {
    var r = CGFloat(0)
    var g = CGFloat(0)
    var b = CGFloat(0)
    var a = CGFloat(0)
    
    color.getRed(&r, green: &g, blue: &b, alpha: &a)
    
    // Counting the perceptive luminance - human eye favors green color...
    let luminance = 1 - ((0.299 * r) + (0.587 * g) + (0.114 * b))
    
    return luminance < 0.5 ? darkColor : brightColor
}
