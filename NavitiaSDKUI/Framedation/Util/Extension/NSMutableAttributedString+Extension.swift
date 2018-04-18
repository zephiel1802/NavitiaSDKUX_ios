//
//  NSMutableAttributedString+Extension.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import Foundation

extension NSMutableAttributedString {
    @discardableResult func bold(_ text: String, color: UIColor = UIColor.black, size: CGFloat = 12.0) -> NSMutableAttributedString {
        let boldString = NSMutableAttributedString(string:text,
                                                   attributes: [.font : UIFont.systemFont(ofSize: size, weight: .bold),
                                                                .foregroundColor: color])
        append(boldString)
        return self
    }
    
    @discardableResult func normal(_ text: String, color: UIColor = UIColor.black, size: CGFloat = 12.0) -> NSMutableAttributedString {
        let normal = NSMutableAttributedString(string:text,
                                               attributes: [.font : UIFont.systemFont(ofSize: size, weight: .regular),
                                                            .foregroundColor: color])
        append(normal)
        return self
    }
    
    @discardableResult func icon(_ iconName: String, color: UIColor = UIColor.black, size: CGFloat = 12.0) -> NSMutableAttributedString {
        if let font = UIFont(name: "SDKIcons", size: size) {
            let icon = NSMutableAttributedString(string: Icon(iconName).iconFontCode,
                                                 attributes: [.font : font,
                             .foregroundColor: color])
            append(icon)
        }

        return self
    }
}

