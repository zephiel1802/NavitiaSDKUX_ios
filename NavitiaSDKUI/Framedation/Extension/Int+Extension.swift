//
//  Int+Extension.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import Foundation

extension Int {
    
    func toDateFormat() -> String {
        return self < 10 ? String(format: "0%d", self) : String(self)
    }
}
