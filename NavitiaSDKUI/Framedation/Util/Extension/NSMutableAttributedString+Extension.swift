//
//  NSMutableAttributedString+Extension.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import Foundation

extension NSMutableAttributedString {
    
    @discardableResult func normal(_ text: String, color: UIColor = UIColor.black, size: CGFloat = 12.0, underline: Bool = false) -> NSMutableAttributedString {
        let normal = NSMutableAttributedString(string:text,
                                               attributes: [.font : UIFont.systemFont(ofSize: size, weight: .regular),
                                                            .foregroundColor: color])
        append(normal)
        if underline {
            addAttribute(.underlineStyle, value: NSUnderlineStyle.styleSingle.rawValue, range: NSRange(location: 0, length: text.count))
        }
        return self
    }
    
    @discardableResult func semiBold(_ text: String, color: UIColor = UIColor.black, size: CGFloat = 12.0, underline: Bool = false) -> NSMutableAttributedString {
        let normal = NSMutableAttributedString(string:text,
                                               attributes: [.font : UIFont.systemFont(ofSize: size, weight: .semibold),
                                                            .foregroundColor: color])
        append(normal)
        if underline {
            addAttribute(.underlineStyle, value: NSUnderlineStyle.styleSingle.rawValue, range: NSRange(location: 0, length: text.count))
        }
        return self
    }
    
    @discardableResult func bold(_ text: String, color: UIColor = UIColor.black, size: CGFloat = 12.0, underline: Bool = false) -> NSMutableAttributedString {
        let boldString = NSMutableAttributedString(string:text,
                                                   attributes: [.font : UIFont.systemFont(ofSize: size, weight: .bold),
                                                                .foregroundColor: color])
        append(boldString)
        if underline {
            addAttribute(.underlineStyle, value: NSUnderlineStyle.styleSingle.rawValue, range: NSRange(location: 0, length: text.count))
        }
        return self
    }
    
    @discardableResult func icon(_ iconName: String, color: UIColor = UIColor.black, size: CGFloat = 12.0) -> NSMutableAttributedString {
        if let font = UIFont(name: Configuration.fontIconsName, size: size) {
            let icon = NSMutableAttributedString(string: Icon(iconName).iconFontCode,
                                                 attributes: [.font : font,
                             .foregroundColor: color])
            append(icon)
        }
        return self
    }
    
}

