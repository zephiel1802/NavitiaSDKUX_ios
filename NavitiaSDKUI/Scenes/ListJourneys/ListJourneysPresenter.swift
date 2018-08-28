//
//  JourneySolutionPresenter.swift
//  NavitiaSDKUI
//
//  Created by Flavien Sicard on 24/08/2018.
//

import UIKit

protocol ListJourneysPresentationLogic {
    
    func presentFetchedSeachInformation(journeysRequest: JourneysRequest)
    func presentFetchedJourneys(response: ListJourneys.FetchJourneys.Response)
    
}

internal class ListJourneysPresenter: ListJourneysPresentationLogic {

    weak var viewController: ListJourneysDisplayLogic?
    
    func presentFetchedSeachInformation(journeysRequest: JourneysRequest) {
        guard let headerInformations = _getDisplayedHeaderInformations(journeysRequest: journeysRequest) else {
            return
        }
        
        let viewModel = ListJourneys.FetchJourneys.ViewModel(loaded: false,
                                                                headerInformations: headerInformations,
                                                                displayedJourneys: [],
                                                                displayedRidesharings: [],
                                                                disruptions: [])
        viewController?.displayFetchedJourneys(viewModel: viewModel)
    }
    
    // MARK: - Fetch Journeys
    
    func presentFetchedJourneys(response: ListJourneys.FetchJourneys.Response) {

        var displayedJourneys: [ListJourneys.FetchJourneys.ViewModel.DisplayedJourney] = []
        var displayedRidesharings: [ListJourneys.FetchJourneys.ViewModel.DisplayedJourney] = []
        
        if let journeys = response.journeys.0 {
            for journey in journeys {
                if let displayedJourney = _getDisplayedJourney(journey: journey) {
                    displayedJourneys.append(displayedJourney)
                }
            }

        }
        if let journeys = response.journeys.withRidesharing {
            for journey in journeys {
                if let displayedJourney = _getDisplayedJourney(journey: journey) {
                    displayedRidesharings.append(displayedJourney)
                }
            }
        }
        
        guard let headerInformations = _getDisplayedHeaderInformations(journey: response.journeys.0?.first ?? response.journeys.withRidesharing?.first, journeysRequest: response.journeysRequest) else {
            return
        }
        
        let viewModel = ListJourneys.FetchJourneys.ViewModel(loaded: true,
                                                                headerInformations: headerInformations,
                                                                displayedJourneys: displayedJourneys,
                                                                displayedRidesharings: displayedRidesharings,
                                                                disruptions: response.disruptions ?? [])
        viewController?.displayFetchedJourneys(viewModel: viewModel)
    }
    
    // MARK: - Displayed Header Informations
    
    private func _getDisplayedHeaderInformations(journeysRequest: JourneysRequest) -> ListJourneys.FetchJourneys.ViewModel.HeaderInformations? {
        guard
            let origin = _getDisplayedHeaderInformationsOrigin(origin: journeysRequest.originLabel ?? journeysRequest.originId),
            let destination = _getDisplayedHeaderInformationsDestination(destination: journeysRequest.destinationLabel ?? journeysRequest.destinationId) else {
                return nil
        }
        let dateTime = _getDisplayedHeaderInformationsDateTime(departureDateTime: journeysRequest.datetime)
        
        return ListJourneys.FetchJourneys.ViewModel.HeaderInformations(dateTime: dateTime,
                                                                         origin: origin,
                                                                         destination: destination)
    }
    
    private func _getDisplayedHeaderInformations(journey: Journey? = nil,
                                                 journeysRequest: JourneysRequest? = nil) -> ListJourneys.FetchJourneys.ViewModel.HeaderInformations? {
        guard let journeysRequest = journeysRequest else {
            return nil
        }
        if let journey = journey {
            guard
                let origin = _getDisplayedHeaderInformationsOrigin(origin: journeysRequest.originLabel ?? journey.sections?.first?.from?.name),
                let destination = _getDisplayedHeaderInformationsDestination(destination: journeysRequest.destinationLabel ?? journey.sections?.last?.to?.name) else {
                    return nil
            }
            let dateTime = _getDisplayedHeaderInformationsDateTime(departureDateTime: journeysRequest.datetime ?? journey.departureDateTime?.toDate(format: Configuration.date))
            
            return ListJourneys.FetchJourneys.ViewModel.HeaderInformations(dateTime: dateTime,
                                                                             origin: origin,
                                                                             destination: destination)
        }
        return _getDisplayedHeaderInformations(journeysRequest: journeysRequest)
    }
    
    private func _getDisplayedHeaderInformationsDateTime(departureDateTime: Date?) -> NSMutableAttributedString {
        guard let departureDateTime = departureDateTime?.toString(format: Configuration.timeJourneySolution) else {
            return NSMutableAttributedString()
        }
        
        return NSMutableAttributedString().bold(String(format: "%@ : %@",
                                                       "departure".localized(withComment: "Departure : ", bundle: NavitiaSDKUI.shared.bundle),
                                                       departureDateTime),
                                                color: UIColor.white,
                                                size: 12)
    }
    
    private func _getDisplayedHeaderInformationsOrigin(origin: String?) -> NSMutableAttributedString? {
        guard let origin = origin else {
            return nil
        }
        
        return NSMutableAttributedString().bold(origin,
                                                color: UIColor(red: 64/255, green: 64/255, blue: 64/255, alpha: 1.0),
                                                size: 11)
    }
    
    private func _getDisplayedHeaderInformationsDestination(destination: String?) -> NSMutableAttributedString? {
        guard let destination = destination else {
            return nil
        }
        
        return NSMutableAttributedString().bold(destination,
                                                color: UIColor(red: 64/255, green: 64/255, blue: 64/255, alpha: 1.0),
                                                size: 11)
    }
    
    // MARK: - Displayed Journey
    
    private func _getDisplayedJourney(journey: Journey?) -> ListJourneys.FetchJourneys.ViewModel.DisplayedJourney? {
        guard
            let journey = journey,
            let dateTime = _getDisplayedJourneyDateTime(journey: journey),
            let duration = _getDisplayedJourneyDuration(journey: journey) else {
                return nil
        }
        
        if journey.isRidesharing {
            return ListJourneys.FetchJourneys.ViewModel.DisplayedJourney(dateTime: dateTime,
                                                                            duration: duration,
                                                                            walkingInformation: nil,
                                                                            sections: journey.sections ?? [])
        }
        
        let walkingInformation = _getDisplayedJourneyWalkingInformation(journey: journey)
        
        return ListJourneys.FetchJourneys.ViewModel.DisplayedJourney(dateTime: dateTime,
                                                                        duration: duration,
                                                                        walkingInformation: walkingInformation,
                                                                        sections: journey.sections ?? [])
    }
    
    private func _getDisplayedJourneyDateTime(journey: Journey) -> NSMutableAttributedString? {
        guard
            let departureDateTime = journey.departureDateTime?.toDate(format: Configuration.date)?.toString(format: Configuration.time),
            let arrivalDateTime = journey.arrivalDateTime?.toDate(format: Configuration.date)?.toString(format: Configuration.time) else {
            return nil
        }
        
        return NSMutableAttributedString().bold(String(format: "%@ - %@",
                                                       departureDateTime,
                                                       arrivalDateTime))
    }
    
    private func _getDisplayedJourneyDuration(journey: Journey) -> NSMutableAttributedString? {
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
    
    
    
    private func _getDisplayedJourneyWalkingInformation(journey: Journey) -> NSMutableAttributedString? {
        guard let duration = _getDisplayedJourneyWalkingDuration(journey: journey),
            let distance = _getDisplayedJourneyWalkingDistance(journey: journey) else {
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
    
    private func _getDisplayedJourneyWalkingDuration(journey: Journey) -> Int32? {
        guard let walkingDuration = journey.durations?.walking else {
            return nil
        }
        
        if walkingDuration > 0 {
            return walkingDuration
        }
        return nil
    }
    
    private func _getDisplayedJourneyWalkingDistance(journey: Journey) -> String? {
        guard let walkingDistance = journey.distances?.walking else {
            return nil
        }
        
        if walkingDistance > 999 {
            return String(format: "%@ %@", walkingDistance.toString(format: "%.01f"), "units_km".localized(withComment: "units_km", bundle: NavitiaSDKUI.shared.bundle))
        }
        return String(format: "%@ %@", walkingDistance.toString(), "units_meters".localized(withComment: "meters", bundle: NavitiaSDKUI.shared.bundle))
    }
    
}
