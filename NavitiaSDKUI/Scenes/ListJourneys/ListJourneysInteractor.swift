//
//  ListJourneysInteractor.swift
//  NavitiaSDKUI
//
//  Created by Flavien Sicard on 24/08/2018.
//

import UIKit

protocol ListJourneysBusinessLogic {
    
    func fetchJourneys(request: ListJourneys.FetchJourneys.Request)
    
}

protocol ListJourneysDataStore {
    
    var journeys: [Journey]? { get }
    var ridesharings: [Journey]? { get }
    var disruptions: [Disruption]? { get }
    
}

internal class ListJourneysInteractor: ListJourneysBusinessLogic, ListJourneysDataStore {

    var presenter: ListJourneysPresentationLogic?
    var journeysWorker = JourneysWorker()
    
    var journeys: [Journey]?
    var ridesharings: [Journey]?
    var disruptions: [Disruption]?
    
    // MARK: - Fetch Journey
    
    func fetchJourneys(request: ListJourneys.FetchJourneys.Request) {
        presenter?.presentFetchedSeachInformation(journeysRequest: request.journeysRequest)
        
        journeysWorker.fetchJourneys(journeysRequest: request.journeysRequest) { (journeys, ridesharings, disruptions) in
            self.journeys = journeys
            self.ridesharings = ridesharings
            self.disruptions = disruptions
            
            let response = ListJourneys.FetchJourneys.Response(journeysRequest: request.journeysRequest,
                                                                  journeys: (journeys, withRidesharing: ridesharings),
                                                                  disruptions: disruptions)
            
            self.presenter?.presentFetchedJourneys(response: response)
        }
    }
    
}
