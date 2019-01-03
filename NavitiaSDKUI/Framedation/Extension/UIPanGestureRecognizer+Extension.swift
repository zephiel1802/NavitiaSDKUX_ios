//
//  UIPanGestureRecognizer+Extension.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit

public extension UIPanGestureRecognizer {
    
    func isDown(theViewYouArePassing: UIView) -> Bool {
        return velocity(in: theViewYouArePassing).y > 0 ? true : false
    }
    
    func isUp(theViewYouArePassing: UIView) -> Bool {
        return velocity(in: theViewYouArePassing).y <= 0 ? true : false
    }
}
