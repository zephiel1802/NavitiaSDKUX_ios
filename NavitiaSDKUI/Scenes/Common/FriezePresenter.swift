//
//  FriezePresenter.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit

class FriezePresenter: NSObject {

    struct FriezeSection {
        var color: UIColor
        var name: String?
        var icon: String
        var disruptionIcon: String?
        var disruptionColor: String?
        var duration: Int32?
    }
    
    private func validDisplayedJourneySections(section: Section, count: Int) -> Bool {
        if let duration = section.duration, duration <= 180 && section.mode == .walking && count > 1 {
            return false
        }
        
        if (section.type == .streetNetwork && (section.mode == .walking || section.mode == .car || section.mode == .bike)) ||
            (section.type != .transfer &&
                section.type != .waiting &&
                section.type != .leaveParking &&
                section.type != .bssRent &&
                section.type != .bssPutBack &&
                section.type != .park &&
                section.type != .alighting &&
                section.type != .crowFly) {
            return true
        }
        
        return false
    }
    
    internal func getDisplayedJourneySections(journey: Journey, disruptions: [Disruption]?) -> [FriezeSection] {
        guard let sections = journey.sections else {
            return []
        }
        
        var sectionsClean = [FriezeSection]()
        
        for section in sections {
            if validDisplayedJourneySections(section: section, count: sections.count) {
                let icon = Modes().getModeIcon(section: section)
                let color = section.displayInformations?.color?.toUIColor() ?? .black
                var name = section.displayInformations?.code
                if name?.isEmpty ?? true {
                    name = section.displayInformations?.commercialMode
                }
                
                var disruptionIcon: String? = nil
                var disruptionColor: String? = nil
                
                if let disruptions = disruptions, disruptions.count > 0 {
                    let sectionDisruptions = section.disruptions(disruptions: disruptions)
                    if sectionDisruptions.count > 0 {
                        let highestDisruption = Disruption.highestLevelDisruption(disruptions: sectionDisruptions)
                        disruptionIcon = Disruption.iconName(of: highestDisruption.level)
                        disruptionColor = highestDisruption.color
                    }
                }
                
                let sectionClean = FriezePresenter.FriezeSection(color: color,
                                                                 name: name,
                                                                 icon: icon,
                                                                 disruptionIcon: disruptionIcon,
                                                                 disruptionColor: disruptionColor,
                                                                 duration: section.duration)
                sectionsClean.append(sectionClean)
            }
        }
        
        return sectionsClean
    }
}
