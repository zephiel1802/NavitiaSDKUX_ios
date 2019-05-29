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
    func routeToBack()
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
            let dataStore = dataStore,
            let destinationVC = viewController.storyboard?.instantiateViewController(withIdentifier: ListPlacesViewController.identifier) as? ListPlacesViewController,
            var destinationDS = destinationVC.router?.dataStore else {
                return
        }

        destinationVC.delegate = viewController
        passDataToListPlaces(source: dataStore, destination: &destinationDS, info: info)
        navigateToListPlaces(source: viewController, destination: destinationVC)
    }
    
    func routeToBack() {
        guard let viewController = viewController,
            let dataStore = dataStore else {
                return
        }
        
        if let navController = viewController.presentingViewController as? UINavigationController {
            for vc in navController.viewControllers {
                if let destinationVC = vc as? FormJourneyViewController, var destinationDS = destinationVC.router?.dataStore {
                    passDataToFormJourney(source: dataStore, destination: &destinationDS)
                    destinationVC.interactor?.displaySearch(request: FormJourney.DisplaySearch.Request())
                }
            }
        }
        
        navigateToBack(source: viewController)
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
        
        source.present(navigationController, animated: false, completion: nil)
    }
    
    func navigateToBack(source: ListJourneysViewController) {
        if source.isRootViewController() {
            source.dismiss(animated: true, completion: nil)
        } else {
            source.navigationController?.popViewController(animated: true)
        }
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
    
    func passDataToListPlaces(source: ListJourneysDataStore, destination: inout ListPlacesDataStore, info: String) {
        if let fromId = source.journeysRequest?.originId {
            destination.from = (label: source.journeysRequest?.originLabel,
                                name: source.journeysRequest?.originName,
                                id: fromId)
        }
        if let toId = source.journeysRequest?.destinationId {
            destination.to = (label: source.journeysRequest?.destinationLabel,
                              name: source.journeysRequest?.destinationName,
                              id: toId)
        }
        
        destination.info = info
        destination.coverage = source.journeysRequest?.coverage
    }
    
    func passDataToFormJourney(source: ListJourneysDataStore, destination: inout FormJourneyDataStore) {
        destination.journeysRequest = source.journeysRequest
        destination.journeysRequest?.dataFreshness = nil
        destination.modeTransportViewSelected = source.modeTransportViewSelected
    }
}
