import Foundation
import NavitiaSDK

public func getHighestLevelFrom(disruptions: [Disruption]) -> Disruption.DisruptionLevel {
    var highestLevel: Disruption.DisruptionLevel = Disruption.DisruptionLevel.none
    for disruption in disruptions {
        if disruption.level.rawValue > highestLevel.rawValue {
            highestLevel = disruption.level
        }
    }
    return highestLevel
}

public func getStringOf(disruptionLevel: Disruption.DisruptionLevel) -> String {
    switch disruptionLevel {
    case .blocking: return "blocking"
    case .nonblocking: return "nonblocking"
    case .information: return "information"
    case .none: return "none"
    }
}

public func getColorOf(disruptionLevel: Disruption.DisruptionLevel) -> String {
    switch disruptionLevel {
    case .blocking: return "A94442"
    case .nonblocking: return "8A6D3B"
    case .information: return "31708F"
    case .none: return "888888"
    }
}
