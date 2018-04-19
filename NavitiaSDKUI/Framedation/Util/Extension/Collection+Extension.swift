//
//  Collection+Extension.swift
//  NavitiaSDKUI
//
//  Created by Flavien Sicard on 19/04/2018.
//  Copyright © 2018 kisio. All rights reserved.
//

import Foundation

extension Collection {
    
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
    
}
