//
//  JourneySolutionViewRouter.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit

@objc protocol JourneySolutionViewRoutingLogic {
    
    func routeToJourneySolutionRidesharing(indexPath: IndexPath)
    func routeToJourneySolutionRoadmap(indexPath: IndexPath)
    
}

protocol JourneySolutionDataPassing {
    
    var dataStore: JourneySolutionDataStore? { get }
    
}

internal class JourneySolutionRouter: NSObject, JourneySolutionViewRoutingLogic, JourneySolutionDataPassing {
    
    weak var viewController: JourneySolutionViewController?
    var dataStore: JourneySolutionDataStore?

    // MARK: Routing
    
    func routeToJourneySolutionRidesharing(indexPath: IndexPath) {
        guard let viewController = viewController, let dataStore = dataStore else {
            return
        }
        
        var destinationVC = viewController.storyboard?.instantiateViewController(withIdentifier: JourneySolutionRidesharingViewController.identifier) as! JourneySolutionRidesharingViewController
        
        passDataToJourneySolutionRidesharing(source: dataStore, destination: &destinationVC, index: indexPath)
        navigateToJourneySolutionRidesharing(source: viewController, destination: destinationVC)
    }
    
    func routeToJourneySolutionRoadmap(indexPath: IndexPath) {
        guard let viewController = viewController, let dataStore = dataStore else {
            return
        }
        
        var destinationVC = viewController.storyboard?.instantiateViewController(withIdentifier: JourneySolutionRoadmapViewController.identifier) as! JourneySolutionRoadmapViewController
        
        passDataToJourneySolutionRoadmap(source: dataStore, destination: &destinationVC, index: indexPath)
        navigateToJourneySolutionRoadmap(source: viewController, destination: destinationVC)
    }
    
    // MARK: Navigation
    
    func navigateToJourneySolutionRidesharing(source: JourneySolutionViewController, destination: JourneySolutionRidesharingViewController) {
        source.navigationController?.pushViewController(destination, animated: true)
    }
    
    func navigateToJourneySolutionRoadmap(source: JourneySolutionViewController, destination: JourneySolutionRoadmapViewController) {
        source.navigationController?.pushViewController(destination, animated: true)
    }
    
    // MARK: Passing Data
    
    func passDataToJourneySolutionRidesharing(source: JourneySolutionDataStore, destination: inout JourneySolutionRidesharingViewController, index: IndexPath) {
        destination.disruptions = source.disruptions
        destination.journey = source.ridesharings?[index.row - 1]  // -1 because "Header Ridesharing"
    }
    
    func passDataToJourneySolutionRoadmap(source: JourneySolutionDataStore, destination: inout JourneySolutionRoadmapViewController, index: IndexPath) {
        destination.disruptions = source.disruptions
        destination.journey = source.journeys?[index.row]
    }
    
}
