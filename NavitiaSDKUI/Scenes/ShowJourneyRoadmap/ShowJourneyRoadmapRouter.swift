//
//  JourneyRoadmapRouter.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit

@objc protocol ShowJourneyRoadmapRoutingLogic {
    
    func routeToListJourneys()
}

protocol ShowJourneyRoadmapDataPassing {
    
    var dataStore: ShowJourneyRoadmapDataStore? { get }
}

class ShowJourneyRoadmapRouter: NSObject, ShowJourneyRoadmapRoutingLogic, ShowJourneyRoadmapDataPassing {
    
    weak var viewController: ShowJourneyRoadmapViewController?
    var dataStore: ShowJourneyRoadmapDataStore?
    
    // MARK: Routing
    
    func routeToListJourneys() {
        guard let viewController = viewController,
            let viewControllers = viewController.navigationController?.viewControllers else {
                return
        }
        
        for navViewController in viewControllers {
            if var listJourneysViewController = navViewController as? ListJourneysViewController {
                passDataToListJourneys(source: viewController, destination: &listJourneysViewController)
                navigateToListJourneys(source: viewController, destination: listJourneysViewController)
            }
        }
    }
    
    // MARK: Navigation
    
    func navigateToListJourneys(source: ShowJourneyRoadmapViewController, destination: ListJourneysViewController) {
        source.navigationController?.popToViewController(destination, animated: true)
        destination.fetchJourneys()
    }
    
    // MARK: Passing Data
    
    func passDataToListJourneys(source: ShowJourneyRoadmapViewController, destination: inout ListJourneysViewController) {
        destination.journeysRequest?.dataFreshness = .realtime
    }
}
