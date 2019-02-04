//
//  ListPlacesInteractor.swift
//  NavitiaSDKUI
//
//  Copyright © 2019 kisio. All rights reserved.
//

import UIKit

protocol ListPlacesBusinessLogic {
    
    func fetchJourneys(request: ListPlaces.FetchPlaces.Request)
}

protocol ListPlacesDataStore {
    
    var info: String { get set }
    var from: (name: String?, id: String)? { get set }
    var to: (name: String?, id: String)? { get set }
}

class ListPlacesInteractor: ListPlacesBusinessLogic, ListPlacesDataStore {
    
    var presenter: ListPlacesPresentationLogic?
    var navitiaWorker = NavitiaWorker()
    
    var info: String = ""
    var from: (name: String?, id: String)?
    var to: (name: String?, id: String)?
    
    // MARK: - Fetch Places
    
    func fetchJourneys(request: ListPlaces.FetchPlaces.Request) {
        navitiaWorker.fetchPlaces(q: request.q, coord: request.coord) { (places) in
            let response = ListPlaces.FetchPlaces.Response(places: places)
            
            self.presenter?.presentSomething(response: response)
        }
    }
}
