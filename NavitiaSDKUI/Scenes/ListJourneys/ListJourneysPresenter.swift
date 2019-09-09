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
        
        let viewModel = ListJourneys.DisplaySearch.ViewModel(fromName: response.journeysRequest.originLabel ?? response.journeysRequest.originName ?? response.journeysRequest.originId,
                                                            toName: response.journeysRequest.destinationLabel ?? response.journeysRequest.destinationName ?? response.journeysRequest.destinationId,
                                                            dateTime: dateTime,
                                                            date: response.journeysRequest.datetime ?? Date(),
                                                            accessibilityHeader: getHeaderAccessibility(origin: response.journeysRequest.originLabel ?? "",
                                                                                                        destination: response.journeysRequest.destinationLabel ?? "",
                                                                                                        dateTime: response.journeysRequest.datetime ?? Date()),           accessibilitySwitchButton: getAccessibilitySwitchButton())
        
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
    
    private func appendDisplayedJourneys(journeys: [Journey]?, disruptions: [Disruption]?, tickets: [Ticket]?) -> [ListJourneys.FetchJourneys.ViewModel.DisplayedJourney] {
        var displayedJourneys = [ListJourneys.FetchJourneys.ViewModel.DisplayedJourney]()
        
        guard let journeys = journeys else {
            return displayedJourneys
        }
        
        for journey in journeys {
            if let displayedJourney = getDisplayedJourney(journey: journey, disruptions: disruptions, tickets: tickets) {
                displayedJourneys.append(displayedJourney)
            }
        }
        
        return displayedJourneys
    }
    
    func presentFetchedJourneys(response: ListJourneys.FetchJourneys.Response) {
        let displayedJourneys = appendDisplayedJourneys(journeys: response.journeys.0, disruptions: response.disruptions, tickets: response.tickets)
        let displayedRidesharings = appendDisplayedJourneys(journeys: response.journeys.withRidesharing, disruptions: response.disruptions, tickets: response.tickets)
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
    
    private func getDisplayedJourney(journey: Journey?, disruptions: [Disruption]?, tickets: [Ticket]?) -> ListJourneys.FetchJourneys.ViewModel.DisplayedJourney? {
        guard let journey = journey,
            let dateTime = getDisplayedJourneyDateTime(journey: journey),
            let duration = getDisplayedJourneyDuration(journey: journey) else {
                return nil
        }
        
        let friezeSections = FriezePresenter().getDisplayedJourneySections(journey: journey, disruptions: disruptions)
        let accessibility = getJourneyAccessibility(duration: duration.string, sections: journey.sections, disruptions: disruptions)
        let ticketsInput = getTickets(journey: journey, tickets: tickets)
        
        if journey.isRidesharing {
            return ListJourneys.FetchJourneys.ViewModel.DisplayedJourney(dateTime: dateTime,
                                                                            duration: duration,
                                                                            walkingInformation: nil,
                                                                            friezeSections: friezeSections,
                                                                            accessibility: accessibility,
                                                                            ticketsInput: ticketsInput.ticketInputList,
                                                                            pricedTicket: ticketsInput.pricedTickets)
        }
        
        let walkingInformation = getDisplayedJourneyWalkingInformation(journey: journey)
        
        return ListJourneys.FetchJourneys.ViewModel.DisplayedJourney(dateTime: dateTime,
                                                                        duration: duration,
                                                                        walkingInformation: walkingInformation,
                                                                        friezeSections: friezeSections,
                                                                        accessibility: accessibility,
                                                                        ticketsInput: ticketsInput.ticketInputList,
                                                                        pricedTicket: ticketsInput.pricedTickets)
    }
    
    private func getTickets(journey: Journey, tickets: [Ticket]?) -> (ticketInputList: [TicketInput], pricedTickets: [PricedTicket]) {
        guard let sections = journey.sections else {
            return ([],[])
        }
        
        var ticketInputList:[TicketInput] = []
        var pricedTicketList:[PricedTicket] = []
        
        for section in sections {
            let ticketLink = section.links?.first(where: { (item) -> Bool in
                return item.type == "ticket"
            })
            
            if let ticketId = ticketLink?.id {
                if section.mode == .taxi {
                    ticketInputList.append(getTicketInput(section: section, productId: "3", ticketId: ticketId))
                    
                } else if section.type == .publicTransport {
                    
                    if let navitiaTicket = tickets?.first(where: { (item) -> Bool in
                        return item.id == ticketId
                    }), let cost = navitiaTicket.cost,
                        let price = Double(cost.value ?? "0.0") {
                        
                        if price > 0.0, cost.currency == "centime" {
                            pricedTicketList.append(getPricedTicket(ticketId: ticketId,
                                                                    priceWithTaxInEur: price/100))
                        } else if (navitiaTicket.sourceId ?? "").contains("ONL:ns") {
                            ticketInputList.append(getTicketInput(section: section, productId: "1", ticketId: ticketId))
                        } else if (navitiaTicket.sourceId ?? "").contains("NLSYN") {
                            ticketInputList.append(getTicketInput(section: section, productId: "2", ticketId: ticketId))
                        }
                    }
                }
            }
        }
        
        return (ticketInputList, pricedTicketList)
    }
    
    private func getTicketInput(section: Section, productId: String, ticketId: String) -> TicketInput {
        let ride = Ride(from: section.from?.id ?? "",
                        to: section.to?.id ?? "",
                        departureDate: section.departureDateTime ?? "",
                        arrivalDate: section.arrivalDateTime ?? "",
                        ticketId: ticketId)
        return TicketInput(productId: productId, ride: ride)
    }
    
    private func getPricedTicket(ticketId: String, priceWithTaxInEur: Double) -> PricedTicket {
        let pricedTicket = PricedTicket(productId: 0,
                                        name: "",
                                        price: nil,
                                        priceWithTax: priceWithTaxInEur,
                                        taxRate: nil,
                                        currency: "Eur",
                                        ticketId: ticketId)
        return pricedTicket
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
                                                                                 color: Configuration.Color.main,
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
