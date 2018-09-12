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
}

protocol ShowJourneyRoadmapDataStore {
    
    var journey: Journey? { get set }
    var disruptions: [Disruption]? { get set }
    var notes: [Note]? { get set }
    var context: Context? { get set }
}

class ShowJourneyRoadmapInteractor: ShowJourneyRoadmapBusinessLogic, ShowJourneyRoadmapDataStore {
    
    var presenter: ShowJourneyRoadmapPresentationLogic?
    var journeysWorker = JourneysWorker()
    var journey: Journey?
    var disruptions: [Disruption]?
    var notes: [Note]?
    var context: Context?
  
    // MARK: Get Roadmap
  
    func getRoadmap(request: ShowJourneyRoadmap.GetRoadmap.Request) {
        guard let journey = journey, let context = context else {
            return
        }
        
        let response = ShowJourneyRoadmap.GetRoadmap.Response(journey: journey, disruptions: disruptions, notes: notes, context: context)
        presenter?.presentRoadmap(response: response)
    }
    
    // MARK: Get Map
    
    func getMap(request: ShowJourneyRoadmap.GetMap.Request) {
        guard let journey = journey else {
            return
        }
        
        let response = ShowJourneyRoadmap.GetMap.Response(journey: journey)
        presenter?.presentMap(response: response)
    }
    
    // MARK: FetchBss
    
    func fetchBss(request: ShowJourneyRoadmap.FetchBss.Request) {
        journeysWorker.fetchBss(coord: (lat: request.lat, lon: request.lon), distance: request.distance, id: request.id) { (poi) in
            guard let poi = poi else {
                return
            }
            
            let response = ShowJourneyRoadmap.FetchBss.Response(poi: poi, notify: request.notify)
            self.presenter?.presentBss(response: response)
        }
    }
}
