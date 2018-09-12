//
//  ListJourneysRouter.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit

@objc protocol ListJourneysViewRoutingLogic {
    
    func routeToJourneySolutionRidesharing(indexPath: IndexPath)
    func routeToJourneySolutionRoadmap(indexPath: IndexPath)
    
}

protocol ListJourneysDataPassing {
    
    var dataStore: ListJourneysDataStore? { get }
    
}

internal class ListJourneysRouter: NSObject, ListJourneysViewRoutingLogic, ListJourneysDataPassing {
    
    weak var viewController: ListJourneysViewController?
    var dataStore: ListJourneysDataStore?

    // MARK: Routing
    
    func routeToJourneySolutionRidesharing(indexPath: IndexPath) {
        guard let viewController = viewController, let dataStore = dataStore else {
            return
        }
        
        var destinationVC = viewController.storyboard?.instantiateViewController(withIdentifier: JourneySolutionRidesharingViewController.identifier) as! JourneySolutionRidesharingViewController
        //var destinationDS = destinationVC.router!.dataStore!
        
        passDataToJourneySolutionRidesharing(source: dataStore, destination: &destinationVC, index: indexPath)
        navigateToJourneySolutionRidesharing(source: viewController, destination: destinationVC)
    }
    
    func routeToJourneySolutionRoadmap(indexPath: IndexPath) {
        guard let viewController = viewController, let dataStore = dataStore else {
            return
        }
        
        let destinationVC = viewController.storyboard?.instantiateViewController(withIdentifier: JourneyRoadmapViewController.identifier) as! JourneyRoadmapViewController
        var destinationDS = destinationVC.router!.dataStore!
        
        passDataToJourneySolutionRoadmap(source: dataStore, destination: &destinationDS, index: indexPath)
        navigateToJourneySolutionRoadmap(source: viewController, destination: destinationVC)
    }
    
    // MARK: Navigation
    
    func navigateToJourneySolutionRidesharing(source: ListJourneysViewController, destination: JourneySolutionRidesharingViewController) {
        source.navigationController?.pushViewController(destination, animated: true)
    }
    
    func navigateToJourneySolutionRoadmap(source: ListJourneysViewController, destination: JourneyRoadmapViewController) {
        source.navigationController?.pushViewController(destination, animated: true)
    }
    
    // MARK: Passing Data
    
    func passDataToJourneySolutionRidesharing(source: ListJourneysDataStore, destination: inout JourneySolutionRidesharingViewController, index: IndexPath) {
        destination.disruptions = source.disruptions
        destination.journey = source.ridesharings?[index.row - 1]  // -1 because "Header Ridesharing"
    }
    
    func passDataToJourneySolutionRoadmap(source: ListJourneysDataStore, destination: inout JourneyRoadmapDataStore, index: IndexPath) {
        destination.journey = source.journeys?[index.row]
        destination.disruptions = source.disruptions
        destination.notes = source.notes
        destination.context = source.context
    }
    
}
