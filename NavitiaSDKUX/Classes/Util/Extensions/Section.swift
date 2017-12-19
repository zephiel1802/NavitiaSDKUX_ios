import Foundation

import NavitiaSDK

extension Section {
    public func getMatchingDisruptions(from disruptions: [Disruption]?) -> [Disruption] {
        if (disruptions == nil) {
            return []
        }

        let linkIdsWithDisruption: [String] = self.displayInformations!.links!.filter { link in
            return (link.type == "disruption" && link.id != nil)
        }.map { link -> String in
            return link.id!
        }

        return disruptions!.filter { disruption in
            return (disruption.id != nil && linkIdsWithDisruption.contains(disruption.id!) && disruption.applicationPeriods != nil)
        }
    }
}
