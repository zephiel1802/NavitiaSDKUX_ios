//
//  FormJourneyRouter.swift
//  NavitiaSDKUI
//
//  Copyright © 2019 kisio. All rights reserved.
//

import UIKit

@objc protocol FormJourneyRoutingLogic {
    
    func routeToListJourneys()
    func routeToListPlaces(info: String)
}

protocol FormJourneyDataPassing {
    
    var dataStore: FormJourneyDataStore? { get set }
}

class FormJourneyRouter: NSObject, FormJourneyRoutingLogic, FormJourneyDataPassing {
    
    weak var viewController: FormJourneyViewController?
    var dataStore: FormJourneyDataStore?
    
    // MARK: Routing
    
    func routeToListJourneys() {
        guard let viewController = viewController,
            let dataStore = dataStore,
            let destinationVC = viewController.storyboard?.instantiateViewController(withIdentifier: ListJourneysViewController.identifier) as? ListJourneysViewController,
            var destinationDS = destinationVC.router?.dataStore else {
                return
        }

        passDataToListJourneys(source: dataStore, destination: &destinationDS)
        navigateToListJourneys(source: viewController, destination: destinationVC)
    }
    
    func routeToListPlaces(info: String) {
        guard let viewController = viewController,
            let dataStore = dataStore,
            let destinationVC = viewController.storyboard?.instantiateViewController(withIdentifier: ListPlacesViewController.identifier) as? ListPlacesViewController,
             var destinationDS = destinationVC.router?.dataStore else {
                return
        }
        
        destinationVC.delegate = viewController as ListPlacesViewControllerDelegate
        passDataToListPlaces(source: dataStore, destination: &destinationDS, info: info)
        navigateToListPlaces(source: viewController, destination: destinationVC)
    }
    
    // MARK: Navigation
    
    func navigateToListJourneys(source: FormJourneyViewController, destination: ListJourneysViewController) {
        let navigationController = UINavigationController(rootViewController: destination)
        
        navigationController.modalTransitionStyle = .crossDissolve
        navigationController.modalPresentationStyle = .overCurrentContext
        
        source.present(navigationController, animated: true, completion: nil)
    }
    
    func navigateToListPlaces(source: FormJourneyViewController, destination: ListPlacesViewController) {
        let navigationController = UINavigationController(rootViewController: destination)
        
        navigationController.modalTransitionStyle = .crossDissolve
        navigationController.modalPresentationStyle = .overCurrentContext
        
        source.present(navigationController, animated: false, completion: nil)
    }
    
    // MARK: Passing Data
    
    func passDataToListJourneys(source: FormJourneyDataStore, destination: inout ListJourneysDataStore) {
        destination.journeysRequest = source.journeysRequest
        destination.modeTransportViewSelected = source.modeTransportViewSelected
    }
    
    func passDataToListPlaces(source: FormJourneyDataStore, destination: inout ListPlacesDataStore, info: String) {
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
}
