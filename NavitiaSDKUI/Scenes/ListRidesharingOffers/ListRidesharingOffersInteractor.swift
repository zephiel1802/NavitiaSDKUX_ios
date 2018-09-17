//
//  ListRidesharingOffersInteractor.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import Foundation

protocol ListRidesharingOffersBusinessLogic {
    
    func getRidesharingOffers(request: ListRidesharingOffers.GetRidesharingOffers.Request)
}

protocol ListRidesharingOffersDataStore {
    
    var journey: Journey? { get set }
    var ridesharingJourneys: [Journey]? { get set }
    var disruptions: [Disruption]? { get set }
    var notes: [Note]? { get set }
    var context: Context? { get set }
}

internal class ListRidesharingOffersInteractor: ListRidesharingOffersBusinessLogic, ListRidesharingOffersDataStore {
    
    var presenter: ListRidesharingOffersPresentationLogic?
    var journey: Journey?
    var ridesharingJourneys: [Journey]?
    var disruptions: [Disruption]?
    var notes: [Note]?
    var context: Context?
    
    func getRidesharingOffers(request: ListRidesharingOffers.GetRidesharingOffers.Request) {
        guard let journey = journey, let context = context else {
            return
        }
        
        ridesharingJourneys = getRidesharingJourneys(journeySections: journey.sections)
        
        let response = ListRidesharingOffers.GetRidesharingOffers.Response(journey: journey,
                                                                           ridesharingJourneys: ridesharingJourneys,
                                                                           disruptions: disruptions,
                                                                           notes: notes,
                                                                           context: context)
        presenter?.presentRidesharingOffers(response: response)
    }
    
    private func getRidesharingJourneys(journeySections: [Section]?) -> [Journey]? {
        guard let journeySections = journeySections else {
            return nil
        }
        
        for section in journeySections {
            if let mode = section.mode, mode == .ridesharing {
                return section.ridesharingJourneys
            }
        }
        
        return nil
    }
    
}
