//
//  ListPlacesInteractor.swift
//  NavitiaSDKUI
//
//  Copyright © 2019 kisio. All rights reserved.
//

import UIKit

protocol ListPlacesBusinessLogic {
    
    var searchFieldType: SearchFieldType? { get set }
    var from: (label: String?, name: String?, id: String)? { get set }
    var to: (label: String?, name: String?, id: String)? { get set }
    
    func updateSearchViewFields(request: ListPlaces.UpdateSearchViewFields.Request)
    func saveHistoryItem(request: ListPlaces.SavePlace.Request)
    func fetchUserLocationAddress(request: ListPlaces.FetchUserLocation.Request)
    func fetchPlaces(request: ListPlaces.FetchPlaces.Request)
    func fetchSavedHistoryItems(request: ListPlaces.FetchHistoryItems.Request)
}

public protocol ListPlacesDataStore {
    
    var searchFieldType: SearchFieldType? { get set }
    var coverage: String? { get set }
    var from: (label: String?, name: String?, id: String)? { get set }
    var to: (label: String?, name: String?, id: String)? { get set }
}

@objc public enum SearchFieldType: Int {
    
    case from
    case to
}

class ListPlacesInteractor: ListPlacesBusinessLogic, ListPlacesDataStore {

    var presenter: ListPlacesPresentationLogic?
    var navitiaWorker = NavitiaWorker()
    var dataBaseWorker = DataBaseWorker()
    
    var coverage: String?
    var from: (label: String?, name: String?, id: String)?
    var to: (label: String?, name: String?, id: String)?
    var searchFieldType: SearchFieldType?
    
    // MARK: - Display Search
    
    func updateSearchViewFields(request: ListPlaces.UpdateSearchViewFields.Request) {
        if let from = request.from {
            self.from = from
        }
        
        if let to = request.to {
            self.to = to
        }
        
        let response = ListPlaces.UpdateSearchViewFields.Response(from: from, to: to)
        self.presenter?.presentDisplayedSearch(response: response)
    }
    
    func saveHistoryItem(request: ListPlaces.SavePlace.Request) {
        guard let coverage = coverage else {
            return
        }
        
        dataBaseWorker.connection()
        dataBaseWorker.saveHistoryItem(coverage: coverage, name: request.place.name, id: request.place.id, type: request.place.type)
    }
    
    // MARK: - Fetch Location
    
    func fetchUserLocationAddress(request: ListPlaces.FetchUserLocation.Request) {
        navitiaWorker.fetchCoord(lon: request.longitude, lat: request.latitude) { (dictAddresses) in
            let response = ListPlaces.FetchUserLocation.Response(userAddress: dictAddresses?.address)
            self.presenter?.presentUserLocation(response: response)
        }
    }
    
    // MARK: - Fetch Places
    
    func fetchPlaces(request: ListPlaces.FetchPlaces.Request) {
        guard let coverage = coverage, !request.query.isEmpty else {
            return
        }
        
        navitiaWorker.fetchPlaces(coverage: coverage, query: request.query, coord: (lat: request.userLat, lon: request.userLon)) { (places) in
            let response = ListPlaces.FetchPlaces.Response(places: places)
            self.presenter?.presentFetchPlaces(response: response)
        }
    }
    
    func fetchSavedHistoryItems(request: ListPlaces.FetchHistoryItems.Request) {
        guard let coverage = coverage else {
            return
        }
        
        dataBaseWorker.connection()
        guard let autcompleteHistory = dataBaseWorker.readValues(coverage: coverage) else {
            return
        }
        
        let response = ListPlaces.FetchHistoryItems.Response(historyItems: autcompleteHistory)
        self.presenter?.presentHistoryPlaces(response: response)
    }
}
