//
//  NSMutableAttributedString+Extension.swift
//  NavitiaSDKUI
//
//  Created by Flavien Sicard on 29/03/2018.
//  Copyright © 2018 kisio. All rights reserved.
//

import Foundation

extension NSMutableAttributedString {
    @discardableResult func bold(_ text: String) -> NSMutableAttributedString {
        let attrs: [NSAttributedStringKey: Any] = [.font : UIFont.systemFont(ofSize: 12.0, weight: .bold)]
        let boldString = NSMutableAttributedString(string:text, attributes: attrs)
        append(boldString)

        return self
    }
    
    @discardableResult func normal(_ text: String) -> NSMutableAttributedString {
        let attrs: [NSAttributedStringKey: Any] = [.font : UIFont.systemFont(ofSize: 12.0, weight: .regular)]
        let normal = NSMutableAttributedString(string:text, attributes: attrs)
        append(normal)

        return self
    }
}
