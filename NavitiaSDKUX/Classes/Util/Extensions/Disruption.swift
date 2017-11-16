import Foundation
import NavitiaSDK

extension Disruption {
    public enum WarningLevel {
        case BLOCKING
        case WARNING
        case INFORMATION
        case NONE
    }

    public var warningLevel: WarningLevel {
        if self.severity == nil {
            return WarningLevel.NONE
        }
        if self.severity!.effect == nil {
            return WarningLevel.NONE
        }
        switch self.severity!.effect! {
        case "NO_SERVICE":
            return WarningLevel.BLOCKING
        case "REDUCED_SERVICE", "STOP_MOVED", "DETOUR", "SIGNIFICANT_DELAYS", "ADDITIONAL_SERVICE", "MODIFIED_SERVICE":
            return WarningLevel.WARNING
        case "OTHER_EFFECT", "UNKNOWN_EFFECT":
            return WarningLevel.INFORMATION
        default:
            return WarningLevel.NONE
        }
    }
}
