//
//  JourneyRoadmapInteractor.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//


import UIKit

protocol JourneyRoadmapBusinessLogic {
    
    func getRoadmap(request: JourneyRoadmap.GetRoadmap.Request)
    func getMap(request: JourneyRoadmap.GetMap.Request)
}

protocol JourneyRoadmapDataStore {
    
    var journey: Journey? { get set }
    var disruptions: [Disruption]? { get set }
    var notes: [Note]? { get set }
    var context: Context? { get set }
}

class JourneyRoadmapInteractor: JourneyRoadmapBusinessLogic, JourneyRoadmapDataStore {
    var presenter: JourneyRoadmapPresentationLogic?
    var worker: JourneyRoadmapWorker?
    
    var journey: Journey?
    var disruptions: [Disruption]?
    var notes: [Note]?
    var context: Context?
  
  // MARK: Do something
  

    func getRoadmap(request: JourneyRoadmap.GetRoadmap.Request) {
        worker = JourneyRoadmapWorker()
        worker?.doSomeWork()

    guard let journey = journey, let context = context else {
        return
    }
    let response = JourneyRoadmap.GetRoadmap.Response(journey: journey, disruptions: disruptions, notes: notes, context: context)
    presenter?.presentRoadmap(response: response)
  }
    
    func getMap(request: JourneyRoadmap.GetMap.Request) {
        guard let journey = journey else {
            return
        }
        let response = JourneyRoadmap.GetMap.Response(journey: journey)
        presenter?.presentMap(response: response)
    }
}
