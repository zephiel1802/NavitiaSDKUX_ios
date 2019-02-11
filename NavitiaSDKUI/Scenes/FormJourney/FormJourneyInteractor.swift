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
            journeysRequest?.originLabel = from.name
        }
        if let to = request.to {
            journeysRequest?.destinationId = to.id
            journeysRequest?.destinationLabel = to.name
        }
        
        let response = FormJourney.DisplaySearch.Response(fromName: journeysRequest?.originLabel,
                                                         toName: journeysRequest?.destinationLabel)
        
        self.presenter?.presentDisplayedSearch(response: response)
    }
}
