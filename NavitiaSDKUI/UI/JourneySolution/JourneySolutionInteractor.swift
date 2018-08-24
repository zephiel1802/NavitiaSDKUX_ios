//
//  JourneySolutionInteractor.swift
//  NavitiaSDKUI
//
//  Created by Flavien Sicard on 24/08/2018.
//

import UIKit

protocol JourneySolutionBusinessLogic {
    
    func fetchJourneys(request: JourneySolution.FetchJourneys.Request)
    
}

protocol JourneySolutionDataStore {
    
    var journeys: Journeys? { get }
    
}

class JourneySolutionInteractor: JourneySolutionBusinessLogic, JourneySolutionDataStore {

    var presenter: JourneySolutionPresentationLogic?
    //var journeyWorker = JourneyWorker()
    
    var journeys: Journeys?
    
    // MARK: - Fetch Journey
    
    func fetchJourneys(request: JourneySolution.FetchJourneys.Request) {
        // // Récupération des Journeys + Stockage en local
        workerFetchJourneys(parameters: request.inParameters) { (journeys) in
            guard let journeys = journeys else {
                return
            }
            
            self.journeys = journeys
            let response = JourneySolution.FetchJourneys.Response(journeys: journeys)
            self.presenter?.presentFetchedJourneys(response: response)
        }
    }

    func workerFetchJourneys(parameters: JourneySolutionViewController.InParameters, completionHandler: @escaping (Journeys?) -> Void) {
        if NavitiaSDKUI.shared.navitiaSDK != nil {
            let journeyRequestBuilder = NavitiaSDKUI.shared.navitiaSDK.journeysApi.newJourneysRequestBuilder()
            _ = journeyRequestBuilder.withFrom(parameters.originId)
            _ = journeyRequestBuilder.withTo(parameters.destinationId)
            
            if let datetime = parameters.datetime {
                _ = journeyRequestBuilder.withDatetime(datetime)
            }
            if let datetimeRepresents = parameters.datetimeRepresents {
                _ = journeyRequestBuilder.withDatetimeRepresents(datetimeRepresents)
            }
            if let forbiddenUris = parameters.forbiddenUris {
                _ = journeyRequestBuilder.withForbiddenUris(forbiddenUris)
            }
            if let allowedId = parameters.allowedId {
                _ = journeyRequestBuilder.withAllowedId(allowedId)
            }
            if let firstSectionModes = parameters.firstSectionModes {
                _ = journeyRequestBuilder.withFirstSectionMode(firstSectionModes)
            }
            if let lastSectionModes = parameters.lastSectionModes {
                _ = journeyRequestBuilder.withLastSectionMode(lastSectionModes)
            }
            if let count = parameters.count {
                _ = journeyRequestBuilder.withCount(count)
            }
            if let minNbJourneys = parameters.minNbJourneys {
                _ = journeyRequestBuilder.withMinNbJourneys(minNbJourneys)
            }
            if let maxNbJourneys = parameters.maxNbJourneys {
                _ = journeyRequestBuilder.withMaxNbJourneys(maxNbJourneys)
            }
            if let bssStands = parameters.bssStands {
                _ = journeyRequestBuilder.withBssStands(bssStands)
            }
            journeyRequestBuilder.get { (result, error) in
                if let result = result {
                    completionHandler(result)
                }
                completionHandler(nil)
            }
        }
    }
    
}
