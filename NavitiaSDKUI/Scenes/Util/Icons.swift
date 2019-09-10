//
//  Icons.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import Foundation

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
