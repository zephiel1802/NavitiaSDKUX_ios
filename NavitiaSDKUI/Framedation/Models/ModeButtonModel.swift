//
//  ModeButtonModel.swift
//  NavitiaSDKUI
//
//  Copyright © 2019 kisio. All rights reserved.
//

import Foundation

@objc public class ModeButtonModel: NSObject {
    
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
    public var firstSectionModes: [ModeType]
    public var lastSectionModes: [ModeType]
    public var physicalMode: [String]?
    public var realTime: Bool

    public init(title: String, icon: String, selected: Bool, firstSectionModes: [ModeType], lastSectionModes: [ModeType], physicalMode: [String]? = nil, realTime: Bool = false) {
        self.title = title
        self.icon = icon
        self.selected = selected
        self.firstSectionModes = firstSectionModes
        self.lastSectionModes = lastSectionModes
        self.physicalMode = physicalMode
        self.realTime = realTime
    }
}
