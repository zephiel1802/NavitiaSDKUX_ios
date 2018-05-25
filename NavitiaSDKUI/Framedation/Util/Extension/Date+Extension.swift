//
//  Date+Extension.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import Foundation

extension Date {
    
    func toString(format: String) -> String {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
}


extension Disruption {
    public enum DisruptionLevel: Int {
        case none
        case information
        case nonblocking
        case blocking
    }
    
    public var level: DisruptionLevel {
        if self.severity == nil {
            return DisruptionLevel.none
        }
        if self.severity!.effect == nil {
            return DisruptionLevel.none
        }
        switch self.severity!.effect! {
        case "NO_SERVICE":
            return DisruptionLevel.blocking
        case "REDUCED_SERVICE", "STOP_MOVED", "DETOUR", "SIGNIFICANT_DELAYS", "ADDITIONAL_SERVICE", "MODIFIED_SERVICE":
            return DisruptionLevel.nonblocking
        case "OTHER_EFFECT", "UNKNOWN_EFFECT":
            return DisruptionLevel.information
        default:
            return DisruptionLevel.none
        }
    }
    
    public static func getHighestLevelFrom(disruptions: [Disruption]) -> Disruption.DisruptionLevel {
        var highestLevel: Disruption.DisruptionLevel = Disruption.DisruptionLevel.none
        for disruption in disruptions {
            if disruption.level.rawValue > highestLevel.rawValue {
                highestLevel = disruption.level
            }
        }
        return highestLevel
    }
    
    public static func getIconName(of disruptionLevel: Disruption.DisruptionLevel) -> String {
        return "disruption-" + String(describing: disruptionLevel)
    }
    
    public static func getLevelColor(of disruptionLevel: Disruption.DisruptionLevel) -> String {
        switch disruptionLevel {
        case .blocking: return "A94442"
        case .nonblocking: return "8A6D3B"
        case .information: return "31708F"
        case .none: return "888888"
        }
    }
}

extension Message {
    public var escapedText: String? {
        
        guard let data = self.text?.data(using: .utf8) else {
            return nil
        }
        
        guard let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil) else {
            return nil
        }
        
        var finalStr = String.init(attributedString.string)
        if finalStr.last == "\n" {
            finalStr.removeLast()
        }
        return finalStr


    }
}


