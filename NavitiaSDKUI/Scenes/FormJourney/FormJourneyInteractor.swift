//
//  FormJourneyInteractor.swift
//  NavitiaSDKUI
//
//  Copyright © 2019 kisio. All rights reserved.
//

import UIKit

protocol FormJourneyBusinessLogic {
    
    var journeysRequest: JourneysRequest? { get set }
    
    func displaySearch(request: FormJourney.DisplaySearch.Request)
    func updateDate(request: FormJourney.UpdateDate.Request)
}

protocol FormJourneyDataStore {
    
    var journeysRequest: JourneysRequest? { get set }
}

class FormJourneyInteractor: FormJourneyBusinessLogic, FormJourneyDataStore {
    
    var presenter: FormJourneyPresentationLogic?
    var journeysRequest: JourneysRequest?

    // MARK: - Display Search
    
    func displaySearch(request: FormJourney.DisplaySearch.Request) {
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
        
        let response = FormJourney.DisplaySearch.Response(fromName: journeysRequest?.originName ?? journeysRequest?.originLabel,
                                                         toName: journeysRequest?.destinationName ?? journeysRequest?.destinationLabel)
        
        self.presenter?.presentDisplayedSearch(response: response)
    }
    
    // MARK: - Update Date
    
    func updateDate(request: FormJourney.UpdateDate.Request) {
        journeysRequest?.datetime = request.date
        journeysRequest?.datetimeRepresents = CoverageRegionJourneysRequestBuilder.DatetimeRepresents(rawValue: request.dateTimeRepresents.rawValue)
    }
}
