//
//  JourneySolutionViewRouter.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit

@objc protocol JourneySolutionViewRoutingLogic {
    
    func routeToJourneySolutionRidesharing()
    func routeToJourneySolutionRoadmap()
    
}

protocol JourneySolutionDataPassing {
    
//    var dataStore: CreateOrderDataStore? { get }
    
}

class JourneySolutionRouter: NSObject, JourneySolutionViewRoutingLogic, JourneySolutionDataPassing {
    
    weak var viewController: JourneySolutionViewController?
    var dataStore: JourneySolutionDataStore?

    // MARK: Routing
    
    func routeToJourneySolutionRidesharing() {
        guard let viewController = viewController else {
            return
        }
        
        var destinationVC = viewController.storyboard?.instantiateViewController(withIdentifier: JourneySolutionRidesharingViewController.identifier) as! JourneySolutionRidesharingViewController
//        var destinationDS = destinationVC.router!.dataStore
        
     //   passDataToJourneySolutionRidesharing(source: viewController._viewModel, destination: &destinationVC)  // Normalement c'est le DSStore
        navigateToJourneySolutionRidesharing(source: viewController, destination: destinationVC)
    }
    
    func routeToJourneySolutionRoadmap() {
        guard let viewController = viewController else {
            return
        }
        
        var destinationVC = viewController.storyboard?.instantiateViewController(withIdentifier: JourneySolutionRoadmapViewController.identifier) as! JourneySolutionRoadmapViewController
        //        var destinationDS = destinationVC.router!.dataStore
        
       // passDataToJourneySolutionRoadmap(source: viewController._viewModel, destination: &destinationVC)  // Normalement c'est le DSStore
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
    
    func passDataToJourneySolutionRidesharing(source: JourneySolutionViewModel, destination: inout JourneySolutionRidesharingViewController) {
        destination.disruptions = source.disruptions
        destination.journey = source.journeysRidesharing[source.indexRidesharing!]
    }
    
    func passDataToJourneySolutionRoadmap(source: JourneySolutionViewModel, destination: inout JourneySolutionRoadmapViewController) {
        destination.disruptions = source.disruptions
        destination.journey = source.journeys[source.indexJourney!]
    }
    
}
