//
//  ModeButtonModel.swift
//  NavitiaSDKUI
//
//  Copyright © 2019 kisio. All rights reserved.
//

import Foundation

public struct ModeButtonModel {
    
    public enum ModeType: String {
        case bike = "bike"
        case bss = "bss"
        case car = "car"
        case ridesharing = "ridesharing"
        case walking = "walking"
    }
    
    public enum PoiInfo: String {
        case bssStands = "bss_stands"
        case carPark = "car_park"
    }
    
    public var title: String
    public var icon: String
    public var selected: Bool
    public var mode: ModeType
    public var physicalMode: [String]?
    public var realTime: Bool

    public init(title: String, icon: String, selected: Bool, mode: ModeType, physicalMode: [String]? = nil, realTime: Bool = false) {
        self.title = title
        self.icon = icon
        self.selected = selected
        self.mode = mode
        self.physicalMode = physicalMode
        self.realTime = realTime
    }
}
