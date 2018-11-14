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
    
    public var level: DisruptionLevel {
        guard let effect = self.severity?.effect else {
            return DisruptionLevel.none
        }
        
        switch effect {
        case .noService:
            return DisruptionLevel.blocking
        case .reducedService, .stopMoved, .detour, .significantDelays, .additionalService, .modifiedService:
            return DisruptionLevel.nonblocking
        case .otherEffect, .unknownEffect:
            return DisruptionLevel.information
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
        
        return messages.first
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
