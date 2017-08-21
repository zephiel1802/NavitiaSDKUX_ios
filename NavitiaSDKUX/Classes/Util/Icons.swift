//
//  Icons.swift
//  RenderTest
//
//  Created by Thomas Noury on 01/08/2017.
//  Copyright © 2017 Kisio. All rights reserved.
//

import Foundation
import UIKit

func fetchIcon(name: String) -> String {
    if (config.iconFontCodes[name] != nil) {
        return config.iconFontCodes[name]!
    } else {
        return "\u{ffff}"
    }
}

public extension String {
    public static func fontString(name: String) -> String {
        return fetchIcon(name: name)
    }
}

public extension UIFont {
    class func iconFontOfSize(name: String, size: CGFloat) -> UIFont {
        let font = UIFont(name: name, size: size)
        if (font != nil) {
            return font!
        } else {
            NSLog("Font " + name + " not found")
            return UIFont.systemFont(ofSize: 14)
        }
    }
}

public extension NSMutableAttributedString {
    public static func fontAwesomeAttributedString(name: String, suffix: String?, iconSize: CGFloat, suffixSize: CGFloat?) -> NSMutableAttributedString {
        var iconString = fetchIcon(name: name)
        var suffixFontSize = iconSize

        if let suffix = suffix {
            iconString = iconString + suffix
        }
        if let suffixSize = suffixSize {
            suffixFontSize = suffixSize
        }

        let iconAttributed = NSMutableAttributedString(string: iconString, attributes: [NSFontAttributeName:UIFont(name: "HelveticaNeue", size: suffixFontSize)!])
        iconAttributed.addAttribute(NSFontAttributeName, value: UIFont.iconFontOfSize(name: "Product", size: iconSize), range: NSRange(location: 0, length: 1))
        
        return iconAttributed
    }
}
