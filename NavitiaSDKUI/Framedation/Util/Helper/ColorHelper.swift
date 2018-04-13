//
//  ColorHelper.swift
//  NavitiaSDKUI
//
//  Created by Flavien Sicard on 13/04/2018.
//  Copyright © 2018 kisio. All rights reserved.
//

import Foundation

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
