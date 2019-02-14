//
//  ListPlacesInteractor.swift
//  NavitiaSDKUI
//
//  Copyright © 2019 kisio. All rights reserved.
//

import UIKit

protocol ListPlacesBusinessLogic {
    
    var locationAddress: Address? { get set }
    var from: (name: String, id: String)? { get set }
    var to: (name: String, id: String)? { get set }
    
    func displaySearch(request: ListPlaces.DisplaySearch.Request)
    func fetchLocation(request: ListPlaces.FetchLocation.Request)
    func fetchJourneys(request: ListPlaces.FetchPlaces.Request)
}

protocol ListPlacesDataStore {
    
    var info: String? { get set }
    var coverage: String? { get set }
    var from: (name: String, id: String)? { get set }
    var to: (name: String, id: String)? { get set }
    var places: Places? { get set }
    var locationAddress: Address? { get set }
}

class ListPlacesInteractor: ListPlacesBusinessLogic, ListPlacesDataStore {
    
    var presenter: ListPlacesPresentationLogic?
    var navitiaWorker = NavitiaWorker()
    
    var info: String?
    var coverage: String?
    var from: (name: String, id: String)?
    var to: (name: String, id: String)?
    var places: Places?
    var locationAddress: Address?
    
    // MARK: - Display Search
    
    func displaySearch(request: ListPlaces.DisplaySearch.Request) {
        if let from = request.from {
            self.from = from
        }
        if let to = request.to {
            self.to = to
        }
        
        let response = ListPlaces.DisplaySearch.Response(fromName: from?.name,
                                                         toName: to?.name,
                                                         info: info)
        
        self.presenter?.presentDisplayedSearch(response: response)
    }
    
    // MARK: - Fetch Location
    
    func fetchLocation(request: ListPlaces.FetchLocation.Request) {
        navitiaWorker.fetchCoord(lon: request.longitude, lat: request.latitude) { (dictAddresses) in
            self.locationAddress = dictAddresses?.address
            
            let response = ListPlaces.FetchPlaces.Response(places: self.places,
                                                           locationAddress: self.locationAddress)
            
            self.presenter?.presentSomething(response: response)
        }
    }
    
    // MARK: - Fetch Places
    
    func fetchJourneys(request: ListPlaces.FetchPlaces.Request) {
        guard let coverage = coverage else {
            return
        }
        
        navitiaWorker.fetchPlaces(coverage: coverage, q: request.q, coord: request.coord) { (places) in
            self.places = places
            
            let response = ListPlaces.FetchPlaces.Response(places: places,
                                                           locationAddress: self.locationAddress)
            
            self.presenter?.presentSomething(response: response)
        }
    }
}
