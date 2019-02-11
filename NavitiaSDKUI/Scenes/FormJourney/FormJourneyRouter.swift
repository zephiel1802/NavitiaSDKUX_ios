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
            let destinationVC = viewController.storyboard?.instantiateViewController(withIdentifier: ListJourneysViewController.identifier) as? ListJourneysViewController/*,
             var destinationDS = destinationVC.router?.dataStore*/ else {
                return
        }
        

        dataStore?.journeysRequest?.datetime = viewController.dateFormView.date
//        dataStore?.journeysRequest?.firstSectionModes = [.walking, .bike, .car]
//        dataStore?.journeysRequest?.lastSectionModes = [.walking, .bike, .car]
        if viewController.dateFormView.departureArrivalSegmentedControl.selectedSegmentIndex == 0 {
            dataStore?.journeysRequest?.datetimeRepresents = .departure
        } else {
            dataStore?.journeysRequest?.datetimeRepresents = .arrival
        }

        
        destinationVC.journeysRequest = dataStore?.journeysRequest
        
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

        if let fromId = source.journeysRequest?.originId, let fromLabel = source.journeysRequest?.originLabel {
            destination.from = (name: fromLabel, id: fromId)
        }
        if let toId = source.journeysRequest?.destinationId, let toLabel = source.journeysRequest?.destinationLabel {
            destination.to = (name: toLabel, id: toId)
        }
        
        destination.coverage = source.journeysRequest?.coverage
    }
}
