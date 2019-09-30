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
        var textColor: UIColor
        var name: String?
        var icon: String
        var disruptionIcon: String?
        var disruptionColor: String?
        var disruptionLevel: Int?
        var duration: Int32?
        var hasBadge: Bool
        var ticketId: String?
        var productId: Int?
    }
    
    private func validDisplayedJourneySections(section: Section, count: Int) -> Bool {
        if let duration = section.duration, duration <= Configuration.minWalkingValueFrieze && section.mode == .walking && count > 1 {
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
    
    private func getName(section: Section) -> String? {
        if let code = section.displayInformations?.code, !code.isEmpty {
            return code
        }
        
        return section.displayInformations?.commercialMode
    }

    private func getColor(section: Section) -> UIColor {
        if section.displayInformations?.color?.toUIColor() == section.displayInformations?.textColor?.toUIColor() {
            return Configuration.Color.white
        }
        
        return section.displayInformations?.color?.toUIColor() ?? Configuration.Color.white
    }
    
    private func getTextColor(section: Section) -> UIColor {
        if section.displayInformations?.color?.toUIColor() == section.displayInformations?.textColor?.toUIColor() {
            return Configuration.Color.black
        }
        
        return section.displayInformations?.textColor?.toUIColor() ?? Configuration.Color.black
    }
    
    private func getIcon(section: Section) -> String {
        return Modes().getMode(section: section)
    }
    
    private func getDisruptionInformations(section: Section, disruptions: [Disruption]?) -> (icon: String?, color: String?, level: Int?) {
        var icon: String? = nil
        var color: String? = nil
        var level: Int? = nil
        
        if let disruptions = disruptions, disruptions.count > 0 {
            let sectionDisruptions = section.disruptions(disruptions: disruptions)
            
            if sectionDisruptions.count > 0 {
                let highestDisruption = Disruption.highestLevelDisruption(disruptions: sectionDisruptions)
                
                level = highestDisruption.level.rawValue
                icon = Disruption.iconName(of: highestDisruption.level)
                color = highestDisruption.color
            }
        }
        
        return (icon: icon, color: color, level: level)
    }
    
    internal func getDisplayedJourneySections(navitiaTickets: [Ticket]?,
                                              journey: Journey,
                                              disruptions: [Disruption]?,
                                              withDisruptionLevel isShowingLevel: Bool = false) -> [FriezeSection] {
        var friezeSections = [FriezeSection]()
        
        guard let sections = journey.sections else {
            return friezeSections
        }
        
        for section in sections {
            if validDisplayedJourneySections(section: section, count: sections.count) {
                let name = getName(section: section)
                let color = getColor(section: section)
                let textColor = getTextColor(section: section)
                let icon = getIcon(section: section)
                let disruptionInfo = getDisruptionInformations(section: section, disruptions: disruptions)
                let ticketId = section.links?.first(where: { (item) -> Bool in
                    return item.type == "ticket"
                })?.id
                let targetTicket = navitiaTickets?.first(where: { (ticket) -> Bool in
                    return ticket.id == ticketId
                })
                
                var productId = -1
                if let sourceIds = NavitiaSDKUI.shared.sourceIds, let targetSourceId = targetTicket?.sourceId {
                    productId = sourceIds[targetSourceId] ?? -1
                }
                
                let friezeSection = FriezePresenter.FriezeSection(color: color,
                                                                  textColor: textColor,
                                                                  name: name,
                                                                  icon: icon,
                                                                  disruptionIcon: disruptionInfo.icon,
                                                                  disruptionColor: disruptionInfo.color,
                                                                  disruptionLevel: disruptionInfo.level,
                                                                  duration: section.duration,
                                                                  hasBadge: false,
                                                                  ticketId: ticketId,
                                                                  productId: productId)

                if isShowingLevel && disruptionInfo.level == Disruption.DisruptionLevel.blocking.rawValue {
                    friezeSections.append(friezeSection)
                } else if !isShowingLevel {
                    friezeSections.append(friezeSection)
                }
            }
        }
        
        return friezeSections
    }
    
    internal func getDisplayedJourneyPrice(priceModel: PricesModel?) -> String {
        guard let priceModel = priceModel else {
            return ""
        }
        
        switch priceModel.state {
        case .full_price:
            if let price = priceModel.totalPrice {
                return String(format: "price".localized(), price)
            } else {
                return ""
            }
        case .incomplete_price:
            if let price = priceModel.totalPrice {
                let priceText = String(format: "price".localized(), price)
                return String(format: "%@ %@", "from".localized(), priceText)
            } else {
                return ""
            }
        case .unavailable_price:
            return "price_unavailable".localized()
        default:
            return ""
        }
    }
}
