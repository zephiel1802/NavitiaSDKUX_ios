//
//  UIView+Extension.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import Foundation

extension UIView {
    
    public func setShadow(color: CGColor = UIColor.black.cgColor,
                          offset: CGSize = CGSize(width: 0, height: 0),
                          opacity: Float = 0.1,
                          radius: CGFloat = 5) {
        layer.masksToBounds = false
        layer.shadowColor = color
        layer.shadowOffset = offset
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
    }
    
    public func removeShadow() {
        layer.masksToBounds = true
        layer.shadowColor = UIColor.clear.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowOpacity = 0
        layer.shadowRadius = 0
    }
}
