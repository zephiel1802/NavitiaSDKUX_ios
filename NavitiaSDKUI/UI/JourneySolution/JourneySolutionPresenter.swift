//
//  JourneySolutionPresenter.swift
//  NavitiaSDKUI
//
//  Created by Flavien Sicard on 24/08/2018.
//

import UIKit

protocol JourneySolutionPresentationLogic {
    
    func presentFetchedJourneys(response: JourneySolution.FetchJourneys.Response)
    
}

class JourneySolutionPresenter: JourneySolutionPresentationLogic {
    
    weak var viewController: JourneySolutionDisplayLogic?
    
    // MARK: - Fetch Journeys
    
    func presentFetchedJourneys(response: JourneySolution.FetchJourneys.Response) {
        
        var displayedJourneys: [JourneySolution.FetchJourneys.ViewModel.DisplayedJourney] = []
        var displayedRidesharings: [JourneySolution.FetchJourneys.ViewModel.DisplayedJourney] = []
        var displayedDisruptions: [JourneySolution.FetchJourneys.ViewModel.DisplayedDisruption] = []
        
        if let journeys = response.journeys.journeys {
            for journey in journeys {
                if let departureDateTime = journey.departureDateTime?.toDate(format: Configuration.date),
                let arrivalDateTime = journey.arrivalDateTime?.toDate(format: Configuration.date),
                let duration = journey.duration,
                let walkingDistance = checkWalkingDistance(walkingDistance: journey.distances?.walking),
                let sections = journey.sections {
                    
                    let walkingDuration = checkWalkingDuration(walkingDuration: journey.durations?.walking)
                    
                    let displayedJourney = JourneySolution.FetchJourneys.ViewModel.DisplayedJourney(departureDateTime: departureDateTime,
                                                                                                    arrivalDateTime: arrivalDateTime,
                                                                                                    duration: duration,
                                                                                                    walkingDuration: walkingDuration,
                                                                                                    walkingDistance: walkingDistance,
                                                                                                    sections: sections)
                    if let ridesharingDistance = journey.distances?.ridesharing, ridesharingDistance > 0 {
                        displayedRidesharings.append(displayedJourney)
                    } else {
                        displayedJourneys.append(displayedJourney)
                    }
                }
            }
        }

        if let disruptions = response.journeys.disruptions {
            let displayedDisruption = JourneySolution.FetchJourneys.ViewModel.DisplayedDisruption(disruptions: disruptions)
            displayedDisruptions.append(displayedDisruption)
        }
        
        let viewModel = JourneySolution.FetchJourneys.ViewModel(displayedJourneys: displayedJourneys,
                                                                displayedRidesharings: displayedRidesharings,
                                                                displayedDisruptions: displayedDisruptions)
        viewController?.displayFetchedJourneys(viewModel: viewModel)
    }
    
    func checkWalkingDuration(walkingDuration: Int32?) -> String? {
        if let walkingDuration = walkingDuration {
            if walkingDuration > 0 {
                return walkingDuration.toStringTime()
            }
            return nil
        }
        return nil
    }
    
    func checkWalkingDistance(walkingDistance: Int32?) -> String? {
        if let walkingDistance = walkingDistance {
            if walkingDistance > 999 {
                return String(format: "%@ %@", walkingDistance.toString(format: "%.01f"), "units_km".localized(withComment: "units_km", bundle: NavitiaSDKUI.shared.bundle))
            } else {
                return String(format: "%@ %@", walkingDistance.toString(), "units_meters".localized(withComment: "meters", bundle: NavitiaSDKUI.shared.bundle))
            }
        }
        return nil
    }
    
}
