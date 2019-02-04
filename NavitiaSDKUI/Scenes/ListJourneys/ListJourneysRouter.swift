//
//  ListJourneysRouter.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit

@objc protocol ListJourneysViewRoutingLogic {
    
    func routeToListRidesharingOffers(indexPath: IndexPath)
    func routeToJourneySolutionRoadmap(indexPath: IndexPath)
    func routeToListPlaces(info: String)
}

protocol ListJourneysDataPassing {
    
    var dataStore: ListJourneysDataStore? { get }
}

internal class ListJourneysRouter: NSObject, ListJourneysViewRoutingLogic, ListJourneysDataPassing {
    
    weak var viewController: ListJourneysViewController?
    var dataStore: ListJourneysDataStore?

    // MARK: Routing
    
    func routeToListRidesharingOffers(indexPath: IndexPath) {
        guard let viewController = viewController,
            let dataStore = dataStore,
            let destinationVC = viewController.storyboard?.instantiateViewController(withIdentifier: ListRidesharingOffersViewController.identifier) as? ListRidesharingOffersViewController,
            var destinationDS = destinationVC.router?.dataStore else {
            return
        }
        
        passDataToListRidesharingOffers(source: dataStore, destination: &destinationDS, index: indexPath)
        navigateToListRidesharingOffers(source: viewController, destination: destinationVC)
    }
    
    func routeToJourneySolutionRoadmap(indexPath: IndexPath) {
        guard let viewController = viewController,
            let dataStore = dataStore,
            let destinationVC = viewController.storyboard?.instantiateViewController(withIdentifier: ShowJourneyRoadmapViewController.identifier) as? ShowJourneyRoadmapViewController,
            var destinationDS = destinationVC.router?.dataStore else {
            return
        }
        
        passDataToJourneySolutionRoadmap(source: dataStore, destination: &destinationDS, index: indexPath)
        navigateToJourneySolutionRoadmap(source: viewController, destination: destinationVC)
    }
    
    func routeToListPlaces(info: String) {
        guard let viewController = viewController,
            let _ = dataStore,
            let destinationVC = viewController.storyboard?.instantiateViewController(withIdentifier: ListPlacesViewController.identifier) as? ListPlacesViewController/*,
             var destinationDS = destinationVC.router?.dataStore*/ else {
                return
        }
        
        destinationVC.firstBecome = info
        if let originId = viewController.journeysRequest?.originId,
            let destinationId = viewController.journeysRequest?.destinationId {
            destinationVC.from = (name: viewController.journeysRequest?.originLabel, id: originId)
            destinationVC.to = (name: viewController.journeysRequest?.destinationLabel, id: destinationId)
        }
        destinationVC.delegate = viewController
        navigateToListPlaces(source: viewController, destination: destinationVC)
    }
    
    // MARK: Navigation
    
    func navigateToListRidesharingOffers(source: ListJourneysViewController, destination: ListRidesharingOffersViewController) {
        source.navigationController?.pushViewController(destination, animated: true)
    }
    
    func navigateToJourneySolutionRoadmap(source: ListJourneysViewController, destination: ShowJourneyRoadmapViewController) {
        source.navigationController?.pushViewController(destination, animated: true)
    }
    
    func navigateToListPlaces(source: ListJourneysViewController, destination: ListPlacesViewController) {
        let navigationController = UINavigationController(rootViewController: destination)
        
        navigationController.modalTransitionStyle = .crossDissolve
        navigationController.modalPresentationStyle = .overCurrentContext
        source.present(navigationController, animated: true, completion: nil)
    }
    
    // MARK: Passing Data
    
    func passDataToListRidesharingOffers(source: ListJourneysDataStore, destination: inout ListRidesharingOffersDataStore, index: IndexPath) {
        destination.journey = source.ridesharingJourneys?[index.row - 1] // The first index.row refers to the ridesharing header view
        destination.disruptions = source.disruptions
        destination.notes = source.notes
        destination.context = source.context
    }
    
    func passDataToJourneySolutionRoadmap(source: ListJourneysDataStore, destination: inout ShowJourneyRoadmapDataStore, index: IndexPath) {
        destination.journey = source.journeys?[index.row]
        destination.disruptions = source.disruptions
        destination.notes = source.notes
        destination.context = source.context
    }
}
