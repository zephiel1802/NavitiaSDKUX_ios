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
                                                             accessibilityHeader: "journey-research-in-progress".localized(bundle: NavitiaSDKUI.shared.bundle),
                                                             accessibilitySwitchButton: nil,
                                                             displayedJourneys: [],
                                                             displayedRidesharings: [],
                                                             disruptions: [])
        
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
                                                             accessibilityHeader: getAccessibilityHeader(origin: headerInformations.originString, destination: headerInformations.destinationString, dateTime: headerInformations.dateTimeDate),
                                                             accessibilitySwitchButton: getAccessibilitySwitchButton(),
                                                             displayedJourneys: displayedJourneys,
                                                             displayedRidesharings: displayedRidesharings,
                                                             disruptions: response.disruptions ?? [])
        
        viewController?.displayFetchedJourneys(viewModel: viewModel)
    }
    
    // MARK: - Displayed Header Informations
    
    internal func getDisplayedHeaderInformations(journeysRequest: JourneysRequest) -> ListJourneys.FetchJourneys.ViewModel.HeaderInformations? {
        guard let origin = getDisplayedHeaderInformationsOrigin(origin: journeysRequest.originLabel ?? journeysRequest.originId),
            let destination = getDisplayedHeaderInformationsDestination(destination: journeysRequest.destinationLabel ?? journeysRequest.destinationId) else {
                return nil
        }
        
        let dateTime = getDisplayedHeaderInformationsDateTime(departureDateTime: journeysRequest.datetime)
        let headerInformations = ListJourneys.FetchJourneys.ViewModel.HeaderInformations(dateTime: dateTime,
                                                                                         dateTimeDate: journeysRequest.datetime,
                                                                                         origin: origin,
                                                                                         originString: journeysRequest.originLabel ?? journeysRequest.originId,
                                                                                         destination: destination,
                                                                                         destinationString: journeysRequest.destinationLabel ?? journeysRequest.destinationId)
        
        return headerInformations
    }
    
    internal func getDisplayedHeaderInformations(journey: Journey? = nil,
                                                 journeysRequest: JourneysRequest? = nil) -> ListJourneys.FetchJourneys.ViewModel.HeaderInformations? {
        guard let journeysRequest = journeysRequest else {
            return nil
        }
        
        if let journey = journey {
            guard let origin = getDisplayedHeaderInformationsOrigin(origin: journeysRequest.originLabel ?? journey.sections?.first?.from?.name),
                let destination = getDisplayedHeaderInformationsDestination(destination: journeysRequest.destinationLabel ?? journey.sections?.last?.to?.name) else {
                    return nil
            }
            let dateTime = getDisplayedHeaderInformationsDateTime(departureDateTime: journeysRequest.datetime ?? journey.departureDateTime?.toDate(format: Configuration.date))
            let headerInformations = ListJourneys.FetchJourneys.ViewModel.HeaderInformations(dateTime: dateTime,
                                                                                             dateTimeDate: journeysRequest.datetime ?? journey.departureDateTime?.toDate(format: Configuration.date),
                                                                                             origin: origin,
                                                                                             originString: journeysRequest.originLabel ?? journey.sections?.first?.from?.name ?? "",
                                                                                             destination: destination,
                                                                                             destinationString: journeysRequest.destinationLabel ?? journey.sections?.last?.to?.name ?? "")
            
            return headerInformations
        }
        
        let displayedInformations = getDisplayedHeaderInformations(journeysRequest: journeysRequest)
        
        return displayedInformations
    }
    
    private func getAccessibilityHeader(origin: String, destination: String, dateTime: Date?) -> String? {
        var accessibilityLabel = String(format: "reminder-of-the-research".localized(bundle: NavitiaSDKUI.shared.bundle), origin, destination)
         
        if let dateTime = dateTime {
            let day = DateFormatter.localizedString(from: dateTime, dateStyle: .medium, timeStyle: .none)
            let hourComponents = Foundation.Calendar.current.dateComponents([.hour, .minute], from: dateTime)
            
            if let hours = DateComponentsFormatter.localizedString(from: hourComponents, unitsStyle: .spellOut) {
                accessibilityLabel += String(format: "departure-the".localized(bundle: NavitiaSDKUI.shared.bundle), day, hours)
            }
        }
        
        return accessibilityLabel
    }
    
    
    private func getAccessibilitySwitchButton() -> String? {
        return "reverse-departure-and-arrival".localized(bundle: NavitiaSDKUI.shared.bundle)
    }
    
    private func getDisplayedHeaderInformationsDateTime(departureDateTime: Date?) -> NSMutableAttributedString {
        guard let departureDateTime = departureDateTime?.toString(format: Configuration.timeJourneySolution) else {
            return NSMutableAttributedString()
        }
        
        return NSMutableAttributedString().bold(String(format: "%@ : %@",
                                                       "departure".localized(withComment: "Departure : ", bundle: NavitiaSDKUI.shared.bundle),
                                                       departureDateTime),
                                                color: Configuration.Color.white,
                                                size: 12)
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
        
        let accessibility = getAccessibilityJourney(duration: duration.string, sections: journey.sections, disruptions: disruptions)
        
        if journey.isRidesharing {
            return ListJourneys.FetchJourneys.ViewModel.DisplayedJourney(dateTime: dateTime,
                                                                            duration: duration,
                                                                            walkingInformation: nil,
                                                                            sections: journey.sections ?? [],
                                                                            accessibility: accessibility)
        }
        
        let walkingInformation = getDisplayedJourneyWalkingInformation(journey: journey)
        
        return ListJourneys.FetchJourneys.ViewModel.DisplayedJourney(dateTime: dateTime,
                                                                        duration: duration,
                                                                        walkingInformation: walkingInformation,
                                                                        sections: journey.sections ?? [],
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
            durationAttributedString.append(NSMutableAttributedString().semiBold(String(format: "%@ ", "about".localized(bundle: NavitiaSDKUI.shared.bundle)),
                                                                                 color: Configuration.Color.main,
                                                                                 size: 12.5))
        }
        durationAttributedString.append(duration.toAttributedStringTime(sizeBold: 12.5, sizeNormal: 12.5))
        
        return durationAttributedString
    }
    
    private func getDisplayedJourneyWalkingInformation(journey: Journey) -> NSMutableAttributedString? {
        guard let duration = getDisplayedJourneyWalkingDuration(journey: journey),
            let distance = getDisplayedJourneyWalkingDistance(journey: journey) else {
                return nil
        }
        
        if duration < 60 {
            return NSMutableAttributedString()
                .normal(String(format: "%@ %@",
                               "less_than_a".localized(withComment: "less than a", bundle: NavitiaSDKUI.shared.bundle),
                               "units_minute".localized(withComment: "minute", bundle: NavitiaSDKUI.shared.bundle)),
                        color: Configuration.Color.gray)
                .bold(duration.toStringTime(), color: Configuration.Color.gray)
                .normal(String(format: " %@ (%@)",
                               "walking".localized(withComment: "walking", bundle: NavitiaSDKUI.shared.bundle),
                               distance),
                        color: Configuration.Color.gray)
        } else {
            return NSMutableAttributedString()
                .normal(String(format: "%@ ",
                               "with".localized(withComment: "with", bundle: NavitiaSDKUI.shared.bundle)),
                        color: Configuration.Color.gray)
                .bold(duration.toStringTime(), color: Configuration.Color.gray)
                .normal(String(format: " %@ (%@)",
                               "walking".localized(withComment: "walking", bundle: NavitiaSDKUI.shared.bundle),
                               distance),
                        color: Configuration.Color.gray)
        }
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
            return String(format: "%@ %@", walkingDistance.toString(format: "%.01f"), "units_km".localized(withComment: "units_km", bundle: NavitiaSDKUI.shared.bundle))
        }
        
        return String(format: "%@ %@", walkingDistance.toString(), "units_meters".localized(withComment: "meters", bundle: NavitiaSDKUI.shared.bundle))
    }
    
    private func getAccessibilityJourney(duration: String, sections: [Section]?, disruptions: [Disruption]?) -> String? {
        guard let sections = sections else {
            return nil
        }
        
        var modes: String = ""
        
        for section in sections {
            if let commercialMode = section.displayInformations?.commercialMode {
                modes += ",\(commercialMode)"
                if let code = section.displayInformations?.code {
                    modes += " \(code)"
                }
            } else if let mode = section.mode {
                modes += String(format: ", %@", "\(mode)-noun".localized(bundle: NavitiaSDKUI.shared.bundle))
            }
            
            if getDisruption(section: section, disruptions: disruptions) {
                modes += String(format: " %@", "disrupted".localized(bundle: NavitiaSDKUI.shared.bundle))
            }
        }
        
        return duration + "," + modes
    }
    
    func getDisruption(section: Section, disruptions: [Disruption]?) -> Bool {
        guard let disruptions = disruptions else {
            return false
        }
        
        if disruptions.count > 0, let displayInformations = section.displayInformations, let displayInformationsLinks = displayInformations.links {
            for linkSchema in displayInformationsLinks {
                if let schemaType = linkSchema.type, schemaType == "disruption" {
                    return true
                }
            }
        }
        
        return false
    }
}
