//
//  Disruption+Extension.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import Foundation

extension Disruption {
    
    public enum DisruptionLevel: Int {
        case none = 100
        case information = 101
        case nonblocking = 102
        case blocking = 103
    }
    
    public enum DisruptionEffect: String {
        case noService = "NO_SERVICE"
        case reducedService = "REDUCED_SERVICE"
        case stopMoved = "STOP_MOVED"
        case detour = "DETOUR"
        case significantDelays = "SIGNIFICANT_DELAYS"
        case additionalService = "ADDITIONAL_SERVICE"
        case modifiedService = "MODIFIED_SERVICE"
        case otherEffect = "OTHER_EFFECT"
        case unknownEffect = "UNKNOWN_EFFECT"
    }
    
    public var level: DisruptionLevel {
        if self.severity == nil || self.severity!.effect == nil {
            return DisruptionLevel.none
        }
        
        switch self.severity!.effect! {
        case DisruptionEffect.noService.rawValue:
            return DisruptionLevel.blocking
        case DisruptionEffect.reducedService.rawValue, DisruptionEffect.stopMoved.rawValue, DisruptionEffect.detour.rawValue, DisruptionEffect.significantDelays.rawValue, DisruptionEffect.additionalService.rawValue, DisruptionEffect.modifiedService.rawValue:
            return DisruptionLevel.nonblocking
        case DisruptionEffect.otherEffect.rawValue, DisruptionEffect.unknownEffect.rawValue:
            return DisruptionLevel.information
        default:
            return DisruptionLevel.none
        }
    }
    
    public static func highestLevelDisruption(disruptions: [Disruption]) -> HighestLevelDisruption {
        var highestLevel = Disruption.DisruptionLevel.none
        var highestLevelColor = levelColor(of: highestLevel)
        for disruption in disruptions {
            if disruption.level.rawValue > highestLevel.rawValue {
                highestLevel = disruption.level
                
                if let severity = disruption.severity, let severityColor = severity.color {
                    highestLevelColor = severityColor
                }
            }
        }
        
        return HighestLevelDisruption(level: highestLevel, color: highestLevelColor)
    }
    
    public static func levelColor(of disruptionLevel: Disruption.DisruptionLevel) -> String {
        switch disruptionLevel {
        case .blocking: return "A94442"
        case .nonblocking: return "8A6D3B"
        case .information: return "31708F"
        case .none: return "888888"
        }
    }
    
    public static func iconName(of disruptionLevel: Disruption.DisruptionLevel) -> String {
        return "disruption-" + String(describing: disruptionLevel)
    }
    
    public static func message(disruption: Disruption) -> Message? {
        guard let messages = disruption.messages else {
            return nil
        }
        
        return messages[0]
    }
    
}

public class HighestLevelDisruption {
    var level: Disruption.DisruptionLevel
    var color: String
    
    init(level: Disruption.DisruptionLevel = Disruption.DisruptionLevel.none, color: String = "888888") {
        self.level = level
        self.color = color
    }
}
