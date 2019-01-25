//
//  JourneySolutionPresenter.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit

protocol ListJourneysPresentationLogic {
    
    func presentFetchedSearchInformation(journeysRequest: JourneysRequest)
    func presentFetchedJourneys(response: ListJourneys.FetchJourneys.Response)
}

class ListJourneysPresenter: ListJourneysPresentationLogic {

    weak var viewController: ListJourneysDisplayLogic?
    
    func presentFetchedSearchInformation(journeysRequest: JourneysRequest) {
        guard let headerInformations = getDisplayedHeaderInformations(journeysRequest: journeysRequest) else {
            return
        }
        
        let viewModel = ListJourneys.FetchJourneys.ViewModel(loaded: false,
                                                             headerInformations: headerInformations,
                                                             accessibilityHeader: "journey_research_in_progress".localized(),
                                                             accessibilitySwitchButton: nil,
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
        guard let headerInformations = getDisplayedHeaderInformations(journey: response.journeys.0?.first ?? response.journeys.withRidesharing?.first, journeysRequest: response.journeysRequest) else {
            return
        }
        
        let displayedJourneys = appendDisplayedJourneys(journeys: response.journeys.0, disruptions: response.disruptions)
        let displayedRidesharings = appendDisplayedJourneys(journeys: response.journeys.withRidesharing, disruptions: response.disruptions)
        let viewModel = ListJourneys.FetchJourneys.ViewModel(loaded: true,
                                                             headerInformations: headerInformations,
                                                             accessibilityHeader: getHeaderAccessibility(origin: headerInformations.origin, destination: headerInformations.destination, dateTime: headerInformations.dateTimeDate),
                                                             accessibilitySwitchButton: getAccessibilitySwitchButton(),
                                                             displayedJourneys: displayedJourneys,
                                                             displayedRidesharings: displayedRidesharings)
        
        viewController?.displayFetchedJourneys(viewModel: viewModel)
    }
    
    // MARK: - Displayed Header Informations
    
    internal func getDisplayedHeaderInformations(journeysRequest: JourneysRequest) -> ListJourneys.FetchJourneys.ViewModel.HeaderInformations? {
        guard let dateTime = getDisplayedHeaderInformationsDateTime(dateTime: journeysRequest.datetime, datetimeRepresents: journeysRequest.datetimeRepresents) else {
            return nil
        }
        
        let headerInformations = ListJourneys.FetchJourneys.ViewModel.HeaderInformations(dateTime: dateTime,
                                                                                         dateTimeDate: journeysRequest.datetime,
                                                                                         origin: journeysRequest.originLabel ?? journeysRequest.originId,
                                                                                         destination: journeysRequest.destinationLabel ?? journeysRequest.destinationId)
        
        return headerInformations
    }
    
    internal func getDisplayedHeaderInformations(journey: Journey? = nil,
                                                 journeysRequest: JourneysRequest? = nil) -> ListJourneys.FetchJourneys.ViewModel.HeaderInformations? {
        guard let journeysRequest = journeysRequest else {
            return nil
        }
        
        if let journey = journey {
            guard let dateTime = getDisplayedHeaderInformationsDateTime(dateTime: journeysRequest.datetime ?? journey.departureDateTime?.toDate(format: Configuration.date),
                                                                        datetimeRepresents: journeysRequest.datetimeRepresents) else {
                                                                            return nil
            }
            
            let headerInformations = ListJourneys.FetchJourneys.ViewModel.HeaderInformations(dateTime: dateTime,
                                                                                             dateTimeDate: journeysRequest.datetime ?? journey.departureDateTime?.toDate(format: Configuration.date),
                                                                                             origin: journeysRequest.originLabel ?? journey.sections?.first?.from?.name ?? "",
                                                                                             destination: journeysRequest.destinationLabel ?? journey.sections?.last?.to?.name ?? "")
            
            return headerInformations
        }
        
        let displayedInformations = getDisplayedHeaderInformations(journeysRequest: journeysRequest)
        
        return displayedInformations
    }
    
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
    
    private func getDisplayedHeaderInformationsDateTime(dateTime: Date?, datetimeRepresents: JourneysRequestBuilder.DatetimeRepresents?) -> String? {
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
        
        if journey.isRidesharing {
            return ListJourneys.FetchJourneys.ViewModel.DisplayedJourney(dateTime: dateTime,
                                                                            duration: duration,
                                                                            walkingInformation: nil,
                                                                            friezeSections: friezeSections,
                                                                            accessibility: accessibility)
        }
        
        let walkingInformation = getDisplayedJourneyWalkingInformation(journey: journey)
        
        return ListJourneys.FetchJourneys.ViewModel.DisplayedJourney(dateTime: dateTime,
                                                                        duration: duration,
                                                                        walkingInformation: walkingInformation,
                                                                        friezeSections: friezeSections,
                                                                        accessibility: accessibility)
    }
    
    private func getDisplayedJourneyDateTime(journey: Journey) -> String? {
        guard let departureDateTime = journey.departureDateTime?.toDate(format: Configuration.date)?.toString(format: Configuration.time),
            let arrivalDateTime = journey.arrivalDateTime?.toDate(format: Configuration.date)?.toString(format: Configuration.time) else {
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
