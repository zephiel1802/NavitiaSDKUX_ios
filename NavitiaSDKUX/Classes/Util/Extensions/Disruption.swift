import Foundation
import NavitiaSDK

extension Disruption {
    public enum DisruptionLevel: Int {
        case blocking = 3
        case warning = 2
        case information = 1
        case none = 0
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
            return DisruptionLevel.warning
        case "OTHER_EFFECT", "UNKNOWN_EFFECT":
            return DisruptionLevel.information
        default:
            return DisruptionLevel.none
        }
    }
}
