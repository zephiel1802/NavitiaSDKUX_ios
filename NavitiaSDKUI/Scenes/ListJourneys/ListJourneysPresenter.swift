//
//  JourneySolutionPresenter.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit

protocol ListJourneysPresentationLogic {
    
    func presentDisplayedSearch(response: ListJourneys.DisplaySearch.Response)
    func presentFetchedPhysicalModes(response: ListJourneys.FetchPhysicalModes.Response)
    func presentFetchedSearchInformation(journeysRequest: JourneysRequest)
    func presentFetchedJourneys(response: ListJourneys.FetchJourneys.Response)
}

class ListJourneysPresenter: ListJourneysPresentationLogic {
    
    weak var viewController: ListJourneysDisplayLogic?
    
    func presentDisplayedSearch(response: ListJourneys.DisplaySearch.Response) {
        guard let dateTime = getDisplayedHeaderInformationsDateTime(dateTime: response.journeysRequest.datetime ?? Date(), datetimeRepresents: response.journeysRequest.datetimeRepresents) else {
            return
        }
        
        let fromName = response.journeysRequest.originLabel ?? response.journeysRequest.originName ?? response.journeysRequest.originId
        let toName = response.journeysRequest.destinationLabel ?? response.journeysRequest.destinationName ?? response.journeysRequest.destinationId
        let accessibilityHeader = getHeaderAccessibility(origin: response.journeysRequest.originLabel ?? "",
                                                         destination: response.journeysRequest.destinationLabel ?? "",
                                                         dateTime: response.journeysRequest.datetime ?? Date())
        let viewModel = ListJourneys.DisplaySearch.ViewModel(fromName: fromName,
                                                             toName: toName,
                                                             dateTime: dateTime,
                                                             date: response.journeysRequest.datetime ?? Date(),
                                                             accessibilityHeader: accessibilityHeader,
                                                             accessibilitySwitchButton: getAccessibilitySwitchButton())
        
        viewController?.displaySearch(viewModel: viewModel)
    }
    
    func presentFetchedPhysicalModes(response: ListJourneys.FetchPhysicalModes.Response) {
        let listPhysicalModes = getListPhysicalModes(physicalModes: response.physicalModes)
        
        let viewModel = ListJourneys.FetchPhysicalModes.ViewModel(physicalModes: listPhysicalModes)
        
        viewController?.callbackFetchedPhysicalModes(viewModel: viewModel)
    }
    
    private func getListPhysicalModes(physicalModes: [PhysicalMode]?) -> [String] {
        var listPhysicalModes = [String]()
        
        guard let physicalModes = physicalModes else {
            return listPhysicalModes
        }
        
        for item in physicalModes {
            if let id = item.id {
                listPhysicalModes.append(id)
            }
        }
        
        return listPhysicalModes
    }
    
    func presentFetchedSearchInformation(journeysRequest: JourneysRequest) {
        let viewModel = ListJourneys.FetchJourneys.ViewModel(loaded: false,
                                                             displayedJourneys: [],
                                                             displayedRidesharings: [])
        
        viewController?.displayFetchedJourneys(viewModel: viewModel)
    }
    
    // MARK: - Fetch Journeys
    
    private func appendDisplayedJourneys(journeys: [Journey]?,
                                         disruptions: [Disruption]?,
                                         navitiaTickets: [Ticket]?) -> [ListJourneys.FetchJourneys.ViewModel.DisplayedJourney] {
        var displayedJourneys = [ListJourneys.FetchJourneys.ViewModel.DisplayedJourney]()
        
        guard let journeys = journeys else {
            return displayedJourneys
        }
        
        for journey in journeys {
            if let displayedJourney = getDisplayedJourney(journey: journey,
                                                          disruptions: disruptions,
                                                          navitiaTickets: navitiaTickets) {
                displayedJourneys.append(displayedJourney)
            }
        }
        
        return displayedJourneys
    }
    
    func presentFetchedJourneys(response: ListJourneys.FetchJourneys.Response) {
        let displayedJourneys = appendDisplayedJourneys(journeys: response.journeys.0,
                                                        disruptions: response.disruptions,
                                                        navitiaTickets: response.tickets)
        let displayedRidesharings = appendDisplayedJourneys(journeys: response.journeys.withRidesharing,
                                                            disruptions: response.disruptions,
                                                            navitiaTickets: response.tickets)
        let viewModel = ListJourneys.FetchJourneys.ViewModel(loaded: true,
                                                             displayedJourneys: displayedJourneys,
                                                             displayedRidesharings: displayedRidesharings)
        
        viewController?.displayFetchedJourneys(viewModel: viewModel)
    }
    
    // MARK: - Displayed Header Informations
    
    private func getHeaderAccessibility(origin: String, destination: String, dateTime: Date?) -> String? {
        var accessibilityLabel = String(format: "reminder_of_the_research".localized(), origin, destination)
        
        if let dateTime = dateTime {
            let day = DateFormatter.localizedString(from: dateTime, dateStyle: .medium, timeStyle: .none)
            let hourComponents = Foundation.Calendar.current.dateComponents([.hour, .minute], from: dateTime)
            
            if let hours = DateComponentsFormatter.localizedString(from: hourComponents, unitsStyle: .spellOut) {
                accessibilityLabel.append(String(format: "departure_on_at".localized(), day, hours))
            }
        }
        
        return accessibilityLabel
    }
    
    private func getAccessibilitySwitchButton() -> String? {
        return "reverse_departure_and_arrival".localized()
    }
    
    private func getDisplayedHeaderInformationsDateTime(dateTime: Date?, datetimeRepresents: CoverageRegionJourneysRequestBuilder.DatetimeRepresents?) -> String? {
        guard let departureDateTime = dateTime?.toString(format: Configuration.timeJourneySolution) else {
            return nil
        }
        
        if datetimeRepresents == .arrival {
            return String(format: "%@ %@", "arrival_with_colon".localized(), departureDateTime)
        }
        
        return String(format: "%@ %@", "departure_with_colon".localized(), departureDateTime)
    }
    
    private func getDisplayedHeaderInformationsOrigin(origin: String?) -> NSMutableAttributedString? {
        guard let origin = origin else {
            return nil
        }
        
        return NSMutableAttributedString().bold(origin,
                                                color: Configuration.Color.headerTitle,
                                                size: 11)
    }
    
    private func getDisplayedHeaderInformationsDestination(destination: String?) -> NSMutableAttributedString? {
        guard let destination = destination else {
            return nil
        }
        
        return NSMutableAttributedString().bold(destination,
                                                color: Configuration.Color.headerTitle,
                                                size: 11)
    }
    
    // MARK: - Displayed Journey
    
    private func getDisplayedJourney(journey: Journey?,
                                     disruptions: [Disruption]?,
                                     navitiaTickets: [Ticket]?) -> ListJourneys.FetchJourneys.ViewModel.DisplayedJourney? {
        guard let journey = journey,
            let dateTime = getDisplayedJourneyDateTime(journey: journey),
            let duration = getDisplayedJourneyDuration(journey: journey) else {
                return nil
        }
        
        let friezeSections = FriezePresenter().getDisplayedJourneySections(navitiaTickets: navitiaTickets,
                                                                           journey: journey,
                                                                           disruptions: disruptions)
        let accessibility = getJourneyAccessibility(duration: duration.string, sections: journey.sections, disruptions: disruptions)
        var walkingInformation: NSMutableAttributedString? = nil
        
        if !journey.isRidesharing {
            walkingInformation = getDisplayedJourneyWalkingInformation(journey: journey)
        }
        
        var priceModel: PricesModel?
        if let sectionsList = journey.sections {
            priceModel = getPriceModel(sectionsList: sectionsList, navitiaTickets: navitiaTickets)
        }
        
        return ListJourneys.FetchJourneys.ViewModel.DisplayedJourney(dateTime: dateTime,
                                                                     duration: duration,
                                                                     walkingInformation: walkingInformation,
                                                                     friezeSections: friezeSections,
                                                                     accessibility: accessibility,
                                                                     priceModel: priceModel)
    }
    
    private func getPriceModel(sectionsList: [Section], navitiaTickets: [Ticket]?) -> PricesModel? {
        var ticketInputList = [TicketInput]()
        var pricedTicketList = [PricedTicket]()
        var unbookableSectionIdList = [String]()
        
        for section in sectionsList {
            if section.type != .onDemandTransport, let sourceIds = NavitiaSDKUI.shared.sourceIds {
                if section.type == .streetNetwork,
                    section.mode == .taxi,
                    let taxiProductId = sourceIds["taxi"] {
                    // *************** TAXI ********************
                    // Taxi's ticket will be returned by hermaas
                    //******************************************
                    
                    ticketInputList.append(getTicketInput(section: section,
                                                          productId: taxiProductId,
                                                          ticketId: ""))
                } else if let ticketId = section.links?.first(where: { $0.type == "ticket" })?.id, section.type == .publicTransport {
                    // *************** PUBLIC TRANSPORT ***********
                    // Public transport's ticket will be return by hermaas only if price is equal to 0
                    // ********************************************
                    if let targetNavitiaTicket = navitiaTickets?.first(where: { $0.id == ticketId }),
                        let navitiaSourceId = targetNavitiaTicket.sourceId,
                        let productId = getProductId(requestedSourceId: navitiaSourceId, sourceIds: sourceIds) {
                        if let cost = targetNavitiaTicket.cost,
                            cost.currency == "centime",
                            let costValue = cost.value,
                            let price = Double(costValue),
                            price > 0.0 {
                            // This is a bookable Navitia Ticket with valid price
                            let randomMaasGeoInfoCoord = MaasGeoInfoCoord(lat: "", lon: "")
                            let maasGeoInfoPlace = MaasGeoInfoPlace(name: "", coord: randomMaasGeoInfoCoord, label: nil, gtfsStopCode: nil)
                            let maasGeoInfo = MaasGeoInfo(departure: maasGeoInfoPlace, arrival: maasGeoInfoPlace)
                            let pricedNavitiaTicket = PricedTicket(productId: productId,
                                                                   name: "",
                                                                   shortDescription: "",
                                                                   price: 0,
                                                                   priceWithTax: price / 100,
                                                                   taxRate: 0,
                                                                   defaultCategoryId: -1,
                                                                   active: false,
                                                                   customType: nil,
                                                                   currency: "Eur",
                                                                   maxQuantity: 0,
                                                                   imageUrl: "",
                                                                   displayOrder: 0,
                                                                   legalTerm: "",
                                                                   geoInfo: maasGeoInfo,
                                                                   links: nil,
                                                                   ticketId: ticketId)
                            pricedTicketList.append(pricedNavitiaTicket)
                            ticketInputList.append(getTicketInput(section: section,
                                                                  productId: productId,
                                                                  ticketId: ticketId))
                        } else {
                            // We should call Hermaas to get the price for this ticket since we don't have an available price
                            ticketInputList.append(getTicketInput(section: section,
                                                                  productId: productId,
                                                                  ticketId: ticketId))
                        }
                    } else if let sectionId = section.id {
                        // The source ID or the ticket ID is not found, so the ticket is unbookable
                        unbookableSectionIdList.append(sectionId)
                    }
                }
            } else if section.type == .publicTransport || section.type == .onDemandTransport, let sectionId = section.id {
                // If there is no ticket, than the provider is not supported yet
                unbookableSectionIdList.append(sectionId)
            }
        }
        
        let priceModel = PricesModel(state: ticketInputList.count == 0 && unbookableSectionIdList.count > 0 ? .unbookable : .no_price,
                                     totalPrice: nil,
                                     navitiaPricedTickets: pricedTicketList,
                                     ticketsInput: ticketInputList,
                                     hermaasPricedTickets: nil,
                                     unbookableSectionIdList: unbookableSectionIdList,
                                     unexpectedErrorTicketList: [])
        return priceModel
    }
    
    private func getProductId(requestedSourceId: String, sourceIds: [String: Int]) -> Int? {
        guard let targetKey = sourceIds.keys.first(where: { (key) -> Bool in
            return requestedSourceId.contains(key)
        }) else {
            return nil
        }
        
        return sourceIds[targetKey]
    }
    
    private func getTicketInput(section: Section, productId: Int?, ticketId: String) -> TicketInput {
        let ride = Ride(from: section.from?.id ?? "",
                        to: section.to?.id ?? "",
                        departureDate: section.departureDateTime ?? "",
                        arrivalDate: section.arrivalDateTime ?? "",
                        ticketId: ticketId)
        return TicketInput(productId: productId, ride: ride)
    }
    
    private func getDisplayedJourneyDateTime(journey: Journey) -> String? {
        guard let departureDateTime = journey.departureDateTime?.toDate(format: Configuration.datetime)?.toString(format: Configuration.time),
            let arrivalDateTime = journey.arrivalDateTime?.toDate(format: Configuration.datetime)?.toString(format: Configuration.time) else {
                return nil
        }
        
        return String(format: "%@ - %@", departureDateTime, arrivalDateTime)
    }
    
    private func getDisplayedJourneyDuration(journey: Journey) -> NSMutableAttributedString? {
        guard let duration = journey.duration else {
            return nil
        }
        
        let durationAttributedString = NSMutableAttributedString()
        
        if journey.isRidesharing {
            durationAttributedString.append(NSMutableAttributedString().semiBold(String(format: "%@ ", "about".localized()),
                                                                                 color: Configuration.Color.secondary,
                                                                                 size: 12.5))
        }
        durationAttributedString.append(duration.toAttributedStringTime(sizeBold: 12.5, sizeNormal: 12.5))
        
        return durationAttributedString
    }
    
    private func getDisplayedJourneyWalkingInformation(journey: Journey) -> NSMutableAttributedString? {
        guard let duration = getDisplayedJourneyWalkingDuration(journey: journey), duration >= 60 else {
            return nil
        }
        
        return NSMutableAttributedString()
            .normal(String(format: "%@ ", "with".localized()), color: Configuration.Color.gray)
            .bold(duration.toStringTime(), color: Configuration.Color.gray)
            .normal(String(format: " %@", "walking".localized()), color: Configuration.Color.gray)
    }
    
    private func getDisplayedJourneyWalkingDuration(journey: Journey) -> Int32? {
        guard let walkingDuration = journey.durations?.walking else {
            return nil
        }
        
        if walkingDuration > 0 {
            return walkingDuration
        }
        
        return nil
    }
    
    private func getDisplayedJourneyWalkingDistance(journey: Journey) -> String? {
        guard let walkingDistance = journey.distances?.walking else {
            return nil
        }
        
        if walkingDistance > 999 {
            return String(format: "%@ %@", walkingDistance.toString(format: "%.01f"), "units_km".localized())
        }
        
        return String(format: "%@ %@", walkingDistance.toString(), "units_meters".localized())
    }
    
    private func getJourneyAccessibility(duration: String, sections: [Section]?, disruptions: [Disruption]?) -> String? {
        guard let sections = sections else {
            return nil
        }
        
        let accessibilitySections = getAccessibilitySections(sections: sections, disruptions: disruptions)
        var modes: String = ""
        
        for (index, accessibilitySection) in accessibilitySections.enumerated() {
            if accessibilitySections.count == index + 1 && accessibilitySections.count > 1 {
                modes.append(String(format: " %@.", "and".localized()))
            }
            modes.append(accessibilitySection)
        }
        
        return String(format: "%@,%@", duration, modes)
    }
    
    private func getAccessibilitySections(sections: [Section], disruptions: [Disruption]?) -> [String] {
        var accessibilitySections = [String]()
        
        for section in sections {
            var accessibilityString = ""
            
            if let commercialMode = section.displayInformations?.commercialMode {
                accessibilityString.append(String(format: " %@ ", commercialMode))
                if let code = section.displayInformations?.code {
                    if section.type == .onDemandTransport {
                        accessibilityString.append(String(format: "dial_a_ride".localized(), code))
                    } else {
                        accessibilityString.append(String(format: " %@ ", code))
                    }
                }
            } else if let mode = section.mode, mode != .walking || sections.count == 1 {
                let mode = Modes().getMode(section: section)
                accessibilityString.append(String(format: " %@", "\(mode)_noun".localized()))
            } else {
                continue
            }
            
            if getDisruption(section: section, disruptionsCount: disruptions?.count) {
                accessibilityString.append(String(format: " %@", "disrupted".localized()))
            }
            
            accessibilitySections.append(String(format: "%@.", accessibilityString))
        }
        
        return accessibilitySections
    }
    
    func getDisruption(section: Section, disruptionsCount: Int?) -> Bool {
        guard let disruptionsCount = disruptionsCount else {
            return false
        }
        
        if disruptionsCount > 0, let displayInformations = section.displayInformations, let displayInformationsLinks = displayInformations.links {
            for linkSchema in displayInformationsLinks {
                if let schemaType = linkSchema.type, schemaType == "disruption" {
                    return true
                }
            }
        }
        
        return false
    }
}
