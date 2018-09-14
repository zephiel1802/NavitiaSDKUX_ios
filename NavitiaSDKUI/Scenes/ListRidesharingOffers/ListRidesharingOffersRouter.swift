//
//  ListRidesharingOffersRouter.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import Foundation

protocol ListRidesharingOffersRoutingLogic {
    
    func routeToShowJourneyRoadmap()
}

protocol ListRidesharingOffersDataPassing {
    
    var dataStore: ListRidesharingOffersDataStore? { get }
}

class ListRidesharingOffersRouter: NSObject, ListRidesharingOffersRoutingLogic, ListRidesharingOffersDataPassing {
    
    weak var viewController: ListRidesharingOffersViewController?
    var dataStore: ListRidesharingOffersDataStore?
    
    // MARK: Routing
    
    func routeToShowJourneyRoadmap() {
        guard let viewController = viewController, let dataStore = dataStore else {
            return
        }
        
        let destinationVC = viewController.storyboard?.instantiateViewController(withIdentifier: ShowJourneyRoadmapViewController.identifier) as! ShowJourneyRoadmapViewController
        var destinationDS = destinationVC.router!.dataStore!
        
        passDataToShowJourneyRoadmap(source: dataStore, destination: &destinationDS)
        navigateToShowJourneyRoadmap(source: viewController, destination: destinationVC)
    }
    
    // MARK: Navigation

    func navigateToShowJourneyRoadmap(source: ListRidesharingOffersViewController, destination: ShowJourneyRoadmapViewController) {
        source.navigationController?.pushViewController(destination, animated: true)
    }
    
    // MARK: Passing Data
    
    func passDataToShowJourneyRoadmap(source: ListRidesharingOffersDataStore, destination: inout ShowJourneyRoadmapDataStore) {
        destination.journey = source.journey
        destination.disruptions = source.disruptions
        destination.notes = source.notes
        destination.context = source.context
    }
}
