//
//  Icons.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import Foundation

public struct Icon {
    
    internal var value: String
    
    public init(_ value: String) {
        self.value = value
    }
    
    var iconFontCode: String {
        get {
            if let value = iconFontCodes[value] {
                return value
            }
            return "\u{ffff}"
        }
    }
}

let iconFontCodes:[String: String] = [
    "address": "\u{ea02}",
    "administrative-region": "\u{ea03}",
    "air": "\u{ea04}",
    "arrow-details-down": "\u{ea05}",
    "arrow-details-up": "\u{ea06}",
    "arrow-direction-left": "\u{ea07}",
    "arrow-direction-right": "\u{ea08}",
    "arrow-direction-straight": "\u{ea09}",
    "arrow-left-long": "\u{ea0a}",
    "arrow-right-long": "\u{ea0b}",
    "arrow-right": "\u{ea0c}",
    "bike": "\u{ea0d}",
    "ferry": "\u{ea0e}",
    "bss": "\u{ea0f}",
    "bus": "\u{ea10}",
    "calendar": "\u{ea11}",
    "car": "\u{ea12}",
    "clock": "\u{ea13}",
    "coach": "\u{ea14}",
    "destination": "\u{ea15}",
    "direction": "\u{ea16}",
    "edit": "\u{ea17}",
    "funicular": "\u{ea18}",
    "geolocation": "\u{ea19}",
    "home": "\u{ea1a}",
    "location-pin": "\u{ea15}",
    "line-diagram-stop": "\u{e900}",
    "metro": "\u{ea1b}",
    "notice": "\u{ea1c}",
    "origin": "\u{ea1d}",
    "poi": "\u{ea1e}",
    "realtime": "\u{ea1f}",
    "stop": "\u{ea21}",
    "localtrain": "\u{ea23}",
    "train": "\u{ea23}",
    "rapidtransit": "\u{ea23}",
    "longdistancetrain": "\u{ea23}",
    "tramway": "\u{ea24}",
    "walking": "\u{ea25}",
    "work": "\u{ea26}",
    "circle-filled": "\u{ea27}",
    "circle": "\u{ea28}",
    "disruption-blocking": "\u{ea29}",
    "disruption-nonblocking": "\u{ea2a}",
    "disruption-information": "\u{ea2b}",
    "ridesharing": "\u{ea2c}",
    "crow_fly": "\u{e90d}",
    "phone-tad": "\u{e913}",
    "bus-tad": "\u{e911}",
    "taxi-tad": "\u{e910}",
    "car-tad": "\u{e90e}",
    "carpark": "\u{e914}",
    "park": "\u{e915}",
    "option": "\u{e916}"
]

public class Modes {
    
    public init() {
    }
    
    public func getMode(section: Section?, roadmap: Bool = false) -> String {
        switch section!.type! {
        case .publicTransport:
            return getPhysicalMode(section: section).lowercased()
        case .transfer:
            return "walking"
        case .waiting:
            return section?.type?.rawValue ?? ""
        case .streetNetwork:
            return section?.mode?.rawValue ?? ""
        case .bssRent:
            return "bss"
        case .bssPutBack:
            return "bss"
        case .crowFly:
            return "crow_fly"
        case .onDemandTransport:
            return "bus-tad"
        case .park:
            return "car"
        case .ridesharing:
            return "ridesharing"
        default:
            return section?.mode?.rawValue ?? ""
        }
    }
    
    private func getPhysicalMode(section: Section?) -> String {
        let id = getPhysicalModeId(section: section)
        
        var modeData = id.split(separator: ":").map(String.init)
        
        return modeData[1]
    }
    
    private func getPhysicalModeId(section: Section?) -> String {
        for link in section!.links! {
            if link.type == "physical_mode" {
                return link.id!
            }
        }
        
        return ""
    }
}
