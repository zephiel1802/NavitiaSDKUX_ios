//
//  ListJourneysInteractor.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit

protocol ListJourneysBusinessLogic {
    
    var journeysRequest: JourneysRequest? { get set }
    var modeTransportViewSelected: [Bool]? { get set }
    
    func displaySearch(request: ListJourneys.DisplaySearch.Request)
    func updateDate(request: FormJourney.UpdateDate.Request)
    func fetchPhysicalModes(request: ListJourneys.FetchPhysicalModes.Request)
    func fetchJourneys(request: ListJourneys.FetchJourneys.Request)
}

protocol ListJourneysDataStore {
    
    var journeysRequest: JourneysRequest? { get set }
    var modeTransportViewSelected: [Bool]? { get set }
    var physicalModes: [PhysicalMode]? { get }
    var journeys: [Journey]? { get }
    var ridesharingJourneys: [Journey]? { get }
    var disruptions: [Disruption]? { get }
    var notes: [Note]? { get }
    var context: Context? { get }
    var navitiaTickets: [Ticket]? { get set }
    var delegate: JourneyPriceDelegate? { get set }
    var successBookDelegate: JourneySuccessBookDelegate? { get set }
}

internal class ListJourneysInteractor: ListJourneysBusinessLogic, ListJourneysDataStore {
    
    var delegate: JourneyPriceDelegate?
    var successBookDelegate: JourneySuccessBookDelegate?
    var presenter: ListJourneysPresentationLogic?
    var navitiaWorker = NavitiaWorker()
    var journeysRequest: JourneysRequest?
    var modeTransportViewSelected: [Bool]?
    var physicalModes: [PhysicalMode]?
    var journeys: [Journey]?
    var ridesharingJourneys: [Journey]?
    var disruptions: [Disruption]?
    var notes: [Note]?
    var context: Context?
    var navitiaTickets: [Ticket]?
    
    // MARK: - Display Search
    
    func displaySearch(request: ListJourneys.DisplaySearch.Request) {
        if let from = request.from {
            journeysRequest?.originId = from.id
            journeysRequest?.originName = from.name
            journeysRequest?.originLabel = from.label
        }
        if let to = request.to {
            journeysRequest?.destinationId = to.id
            journeysRequest?.destinationName = to.name
            journeysRequest?.destinationLabel = to.label
        }

        if let journeysRequest = journeysRequest {
            let response = ListJourneys.DisplaySearch.Response(journeysRequest: journeysRequest)
            
            self.presenter?.presentDisplayedSearch(response: response)
        }
    }
    
    // MARK: - Update Date
    
    func updateDate(request: FormJourney.UpdateDate.Request) {
        journeysRequest?.datetime = request.date
        journeysRequest?.datetimeRepresents = CoverageRegionJourneysRequestBuilder.DatetimeRepresents(rawValue: request.dateTimeRepresents.rawValue)
    }
    
    // MARK: - Fetch Physical Modes
    
    func fetchPhysicalModes(request: ListJourneys.FetchPhysicalModes.Request) {
        if let journeysRequest = request.journeysRequest {
            self.journeysRequest = journeysRequest
        }
        
        guard let journeysRequest = journeysRequest else {
            return
        }
        
        presenter?.presentFetchedSearchInformation(journeysRequest: journeysRequest)
        
        navitiaWorker.fetchPhysicalMode(coverage: journeysRequest.coverage) { (physicalModes) in
            self.physicalModes = physicalModes
            
            let response = ListJourneys.FetchPhysicalModes.Response(physicalModes: physicalModes)
            
            self.presenter?.presentFetchedPhysicalModes(response: response)
        }
    }
    
    // MARK: - Fetch Journey
    
    func fetchJourneys(request: ListJourneys.FetchJourneys.Request) {
        if let journeysRequest = request.journeysRequest {
            self.journeysRequest = journeysRequest
        }
        
        guard let journeysRequest = journeysRequest else {
            return
        }
        
        presenter?.presentFetchedSearchInformation(journeysRequest: journeysRequest)
        
        navitiaWorker.fetchJourneys(journeysRequest: journeysRequest) { (journeys, ridesharings, disruptions, notes, context, tickets)  in
            self.journeys = journeys
            self.ridesharingJourneys = ridesharings
            self.disruptions = disruptions
            self.notes = notes
            self.context = context
            self.navitiaTickets = tickets
            
            self.updateAddressJourneyRequest(from: journeys?.first?.sections?.first?.from,
                                        to: journeys?.last?.sections?.last?.to)
            
            let response = ListJourneys.FetchJourneys.Response(journeysRequest: journeysRequest,
                                                               journeys: (journeys, withRidesharing: ridesharings),
                                                               tickets: tickets,
                                                               disruptions: disruptions)
            
            self.presenter?.presentFetchedJourneys(response: response)
        }
    }
    
    private func updateAddressJourneyRequest(from: Place?, to: Place?) {
        if journeysRequest?.originName == nil, journeysRequest?.originLabel == nil, let from = from {
            journeysRequest?.originName = from.name
        }
        if journeysRequest?.destinationName == nil, journeysRequest?.destinationLabel == nil, let to = to {
            journeysRequest?.destinationName = to.name
        }
        
        if let journeysRequest = journeysRequest {
            let response = ListJourneys.DisplaySearch.Response(journeysRequest: journeysRequest)
            
            self.presenter?.presentDisplayedSearch(response: response)
        }
    }
}
