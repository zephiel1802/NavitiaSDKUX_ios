//
//  ShowJourneyRoadmapInteractor.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//


import UIKit

protocol ShowJourneyRoadmapBusinessLogic {
    
    func getRoadmap(request: ShowJourneyRoadmap.GetRoadmap.Request)
    func getMap(request: ShowJourneyRoadmap.GetMap.Request)
    func fetchBss(request: ShowJourneyRoadmap.FetchBss.Request)
    func fetchPark(request: ShowJourneyRoadmap.FetchPark.Request)
}

public protocol ShowJourneyRoadmapDataStore {
    
    var journey: Journey? { get set }
    var journeyRidesharing: Journey? { get set }
    var disruptions: [Disruption]? { get set }
    var notes: [Note]? { get set }
    var context: Context? { get set }
    var maasTickets: String? { get set }
    var totalPrice: (value: Float?, currency: String?)? { get set }
}

class ShowJourneyRoadmapInteractor: ShowJourneyRoadmapBusinessLogic, ShowJourneyRoadmapDataStore {
    
    var presenter: ShowJourneyRoadmapPresentationLogic?
    var journeysWorker = NavitiaWorker()
    var journey: Journey?
    var journeyRidesharing: Journey?
    var disruptions: [Disruption]?
    var notes: [Note]?
    var context: Context?
    var maasTickets: String?
    var totalPrice: (value: Float?, currency: String?)?
  
    // MARK: Get Roadmap
  
    func getRoadmap(request: ShowJourneyRoadmap.GetRoadmap.Request) {
        guard let journey = journey, let context = context else {
            return
        }
        
        let response = ShowJourneyRoadmap.GetRoadmap.Response(journey: journey,
                                                              journeyRidesharing: journeyRidesharing,
                                                              disruptions: disruptions,
                                                              notes: notes,
                                                              context: context,
                                                              maasTickets: getMaasTickets(maasTickets: maasTickets),
                                                              totalPrice: totalPrice)
        presenter?.presentRoadmap(response: response)
    }
    
    // MARK: Get Map
    
    func getMap(request: ShowJourneyRoadmap.GetMap.Request) {
        guard let journey = journey else {
            return
        }
        
        let response = ShowJourneyRoadmap.GetMap.Response(journey: journey,
                                                          journeyRidesharing: journeyRidesharing)
        presenter?.presentMap(response: response)
    }
    
    // MARK: Fetch Bss
    
    func fetchBss(request: ShowJourneyRoadmap.FetchBss.Request) {
        journeysWorker.fetchBss(coord: (lat: request.lat, lon: request.lon),
                                distance: request.distance,
                                id: request.id) { (poi) in
                                    guard let poi = poi else {
                                        return
                                    }
                                    
                                    
                                    let response = ShowJourneyRoadmap.FetchBss.Response(poi: poi, type: request.type, notify: request.notify)
                                    self.presenter?.presentBss(response: response)
        }
    }
    
    // MARK: Fetch Park
    
    func fetchPark(request: ShowJourneyRoadmap.FetchPark.Request) {
        journeysWorker.fetchPark(coord: (lat: request.lat, lon: request.lon),
                                distance: request.distance,
                                id: request.id) { (poi) in
                                    guard let poi = poi else {
                                        return
                                    }
                                    
                                    let response = ShowJourneyRoadmap.FetchPark.Response(poi: poi, notify: request.notify)
                                    self.presenter?.presentPark(response: response)
        }
    }
    
    // MARK: Maas Tickets
    
    private func getMaasTickets(maasTickets: String?) -> [MaasTicket]? {
        guard let maasTickets = maasTickets, let maasTicketsData = maasTickets.data(using: .utf8) else {
            return nil
        }
        
        do {
            return try JSONDecoder().decode([MaasTicket].self, from: maasTicketsData)
        } catch {
            return nil
        }
    }
}
