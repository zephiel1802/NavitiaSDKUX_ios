//
//  ListPlacesInteractor.swift
//  NavitiaSDKUI
//
//  Copyright © 2019 kisio. All rights reserved.
//

import UIKit

protocol ListPlacesBusinessLogic {
    
    var info: String? { get set }
    var locationAddress: Address? { get set }
    var from: (label: String?, name: String?, id: String)? { get set }
    var to: (label: String?, name: String?, id: String)? { get set }
    
    func displaySearch(request: ListPlaces.DisplaySearch.Request)
    func savePlace(request: ListPlaces.SavePlace.Request)
    func fetchLocation(request: ListPlaces.FetchLocation.Request)
    func fetchJourneys(request: ListPlaces.FetchPlaces.Request)
}

protocol ListPlacesDataStore {
    
    var info: String? { get set }
    var coverage: String? { get set }
    var from: (label: String?, name: String?, id: String)? { get set }
    var to: (label: String?, name: String?, id: String)? { get set }
    var places: Places? { get set }
    var locationAddress: Address? { get set }
    var tab2: [Journeysss]? { get set }
}

class ListPlacesInteractor: ListPlacesBusinessLogic, ListPlacesDataStore {
    
    var presenter: ListPlacesPresentationLogic?
    var navitiaWorker = NavitiaWorker()
    var dataBaseWorker = DataBaseWorker()
    
    var info: String?
    var coverage: String?
    var from: (label: String?, name: String?, id: String)?
    var to: (label: String?, name: String?, id: String)?
    var places: Places?
    var locationAddress: Address?
    var tab2: [Journeysss]?
    
    // MARK: - Display Search
    
    func displaySearch(request: ListPlaces.DisplaySearch.Request) {
        if let from = request.from {
            self.from = from
        }
        if let to = request.to {
            self.to = to
        }
        
        let response = ListPlaces.DisplaySearch.Response(fromLabel: from?.label,
                                                         fromName: from?.name,
                                                         toLabel: to?.label,
                                                         toName: to?.name,
                                                         info: info)
        
        self.presenter?.presentDisplayedSearch(response: response)
    }
    
    func savePlace(request: ListPlaces.SavePlace.Request) {
        guard let coverage = coverage else {
            return
        }
        
        dataBaseWorker.connection()
        dataBaseWorker.buttonSave(coverage: coverage, name: request.place.name, id: request.place.id, type: request.place.type)
    }
    
    // MARK: - Fetch Location
    
    func fetchLocation(request: ListPlaces.FetchLocation.Request) {
        navitiaWorker.fetchCoord(lon: request.longitude, lat: request.latitude) { (dictAddresses) in
            self.locationAddress = dictAddresses?.address
            
            if let places = self.places {
                let response = ListPlaces.FetchPlaces.Response(places: self.places,
                                                               locationAddress: self.locationAddress)
                
                
                self.presenter?.presentSomething(response: response)
            } else if let tab2 = self.tab2 {
                self.presenter?.presentHistoryPlace(response: tab2, locationAddress: self.locationAddress)
            }
        }
    }
    
    // MARK: - Fetch Places
    
    func fetchJourneys(request: ListPlaces.FetchPlaces.Request) {
        guard let coverage = coverage else {
            return
        }
        
        if request.q == "" {
            dataBaseWorker.connection()
            
            let tab = dataBaseWorker.readValues(coverage: coverage)
            self.tab2 = tab
            self.places = nil
            guard let tab2 = tab else {
                return
            }
            
            self.presenter?.presentHistoryPlace(response: tab2, locationAddress: self.locationAddress)
        } else {
            navitiaWorker.fetchPlaces(coverage: coverage, q: request.q, coord: request.coord) { (places) in
                self.places = places
                self.tab2 = nil
                
                let response = ListPlaces.FetchPlaces.Response(places: places,
                                                               locationAddress: self.locationAddress)
                
                self.presenter?.presentSomething(response: response)
            }
        }
    }
}
