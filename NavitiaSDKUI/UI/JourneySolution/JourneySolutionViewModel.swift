//
//  JourneySolutionViewModel.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit

class JourneySolutionViewModel: NSObject {

    var journeySolutionDidChange: ((JourneySolutionViewModel) -> ())?
    var journeys = [Journey]()
    var journeysRidesharing = [Journey]()
    var disruptions = [Disruption]()
    var notes = [Note]()
    var loading: Bool = true
    
    func request(with parameters: JourneySolutionViewController.InParameters) {
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
            self.loading = true
            journeyRequestBuilder.get { (result, error) in
                if let result = result {
                    self.parseNavitia(result: result)
                }
                self.loading = false
                self.journeySolutionDidChange?(self)
            }
        }
    }
    
    func parseNavitia(result: Journeys) {
        if let journeys = result.journeys {
            for journey in journeys {
                if let redisharingDistance = journey.distances?.ridesharing {
                    if redisharingDistance > 0 {
                        self.journeysRidesharing.append(journey)
                    } else {
                        self.journeys.append(journey)
                    }
                }
            }
        }
        
        if let disruptions = result.disruptions {
            self.disruptions = disruptions
        }
        
        if let notes = result.notes {
            self.notes = notes
        }
    }
    
}
