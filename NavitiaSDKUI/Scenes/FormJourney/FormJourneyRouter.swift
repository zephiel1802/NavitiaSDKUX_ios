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
    
    var dataStore: FormJourneyDataStore? { get }
}

class FormJourneyRouter: NSObject, FormJourneyRoutingLogic, FormJourneyDataPassing {
    
    weak var viewController: FormJourneyViewController?
    var dataStore: FormJourneyDataStore?
    
    // MARK: Routing
    
    func routeToListJourneys() {
        guard let viewController = viewController,
            let _ = dataStore,
            let destinationVC = viewController.storyboard?.instantiateViewController(withIdentifier: ListJourneysViewController.identifier) as? ListJourneysViewController,
            let fromID = viewController.from?.id,
            let fromName = viewController.from?.name,
            let toID = viewController.to?.id,
            let toName = viewController.to?.name/*,
             var destinationDS = destinationVC.router?.dataStore*/ else {
                return
        }
        
        var journeysRequest = JourneysRequest(originId: fromID, destinationId: toID)
        journeysRequest.originLabel = fromName
        journeysRequest.destinationLabel = toName
        journeysRequest.datetime = viewController.dateFormView.date
        if viewController.dateFormView.departureArrivalSegmentedControl.selectedSegmentIndex == 0 {
            journeysRequest.datetimeRepresents = .departure
        } else {
            journeysRequest.datetimeRepresents = .arrival
        }
        
        destinationVC.journeysRequest = journeysRequest
        
        navigateToListJourneys(source: viewController, destination: destinationVC)
    }
    
    func routeToListPlaces(info: String) {
        guard let viewController = viewController,
            let _ = dataStore,
            let destinationVC = viewController.storyboard?.instantiateViewController(withIdentifier: ListPlacesViewController.identifier) as? ListPlacesViewController/*,
             var destinationDS = destinationVC.router?.dataStore*/ else {
                return
        }
        
        destinationVC.firstBecome = info
        destinationVC.from = viewController.from
        destinationVC.to = viewController.to
        destinationVC.delegate = viewController as ListPlacesViewControllerDelegate
        navigateToListPlaces(source: viewController, destination: destinationVC)
    }
    
    // passDataToListJourneys(source: dataStore, destination: &destinationDS)
    
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
    
    func passDataToListPlaces(source: FormJourneyDataStore, destination: inout ListPlacesDataStore, info: String) {
        destination.info = info
        destination.from = source.from
        destination.to = source.to
    }
}
