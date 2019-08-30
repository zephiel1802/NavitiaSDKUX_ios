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
    
    private func appendDisplayedJourneys(journeys: [Journey]?, disruptions: [Disruption]?) -> [ListJourneys.FetchJourneys.ViewModel.DisplayedJourney] {
        var displayedJourneys = [ListJourneys.FetchJourneys.ViewModel.DisplayedJourney]()
        
        guard let journeys = journeys else {
            return displayedJourneys
        }
        
        for journey in journeys {
            if let displayedJourney = getDisplayedJourney(journey: journey, disruptions: disruptions) {
                displayedJourneys.append(displayedJourney)
            }
        }
        
        return displayedJourneys
    }
    
    
    func presentFetchedJourneys(response: ListJourneys.FetchJourneys.Response) {
        let displayedJourneys = appendDisplayedJourneys(journeys: response.journeys.0, disruptions: response.disruptions)
        let displayedRidesharings = appendDisplayedJourneys(journeys: response.journeys.withRidesharing, disruptions: response.disruptions)
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
    
    private func getDisplayedJourney(journey: Journey?, disruptions: [Disruption]?) -> ListJourneys.FetchJourneys.ViewModel.DisplayedJourney? {
        guard let journey = journey,
            let dateTime = getDisplayedJourneyDateTime(journey: journey),
            let duration = getDisplayedJourneyDuration(journey: journey) else {
                return nil
        }
        
        let friezeSections = FriezePresenter().getDisplayedJourneySections(journey: journey, disruptions: disruptions)
        let accessibility = getJourneyAccessibility(duration: duration.string, sections: journey.sections, disruptions: disruptions)
        let ticketsInput = getTickets(journey: journey)
        
        if journey.isRidesharing {
            return ListJourneys.FetchJourneys.ViewModel.DisplayedJourney(dateTime: dateTime,
                                                                            duration: duration,
                                                                            walkingInformation: nil,
                                                                            friezeSections: friezeSections,
                                                                            accessibility: accessibility,
                                                                            ticketsInput: ticketsInput)
        }
        
        let walkingInformation = getDisplayedJourneyWalkingInformation(journey: journey)
        
        return ListJourneys.FetchJourneys.ViewModel.DisplayedJourney(dateTime: dateTime,
                                                                        duration: duration,
                                                                        walkingInformation: walkingInformation,
                                                                        friezeSections: friezeSections,
                                                                        accessibility: accessibility,
                                                                        ticketsInput: ticketsInput)
    }
    
    private func getTickets(journey: Journey) -> [TicketInput] {
        var ticketInputList:[TicketInput] = []
        let ticketLink = journey.links?.first(where: { (item) -> Bool in
            return item.type == "ticket"
        })
        let ticketId = ticketLink?.id ?? ""
        
        for section in journey.sections ?? [] {
            let ride = Ride(from: section.from?.id ?? "",
                            to: section.to?.id ?? "",
                            departureDate: section.departureDateTime ?? "",
                            arrivalDate: section.arrivalDateTime ?? "",
                            ticketId: ticketId)
            
            let ticketInput = TicketInput(productId: ticketId, ride: ride)
            ticketInputList.append(ticketInput)
        }
        
        return ticketInputList
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
