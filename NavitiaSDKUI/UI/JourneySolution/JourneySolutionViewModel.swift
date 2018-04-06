//
//  JourneySolutionViewModel.swift
//  NavitiaSDKUI
//
//  Created by Flavien Sicard on 23/03/2018.
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit

class JourneySolutionViewModel: NSObject {

    var journeySolutionDidChange: ((JourneySolutionViewModel) -> ())?
    
    var journeys: [Journey] = []
    var journeysRidesharing: [Journey] = []
//    var journeySolutionModels: [JourneySolutionModel] = []
//    var journeyRidesharingSolutionModels: [JourneySolutionModel] = []
    
    func request(with parameters: JourneySolutionViewController.InParameters) {
        if NavitiaSDKUIConfig.shared.navitiaSDK != nil {
            
            let journeyRequestBuilder = NavitiaSDKUIConfig.shared.navitiaSDK.journeysApi.newJourneysRequestBuilder()
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
            journeyRequestBuilder.get { (result, error) in
                if let journeys = result?.journeys {
                    //  self.journeys = journeys
                    self.parseNavitia(journeys: journeys)
                    
                    
                    
                  //  self.journeys = journeys
                    self.journeySolutionDidChange?(self)
                    //  print(journeys)
                }
            }
//            NavitiaSDKUIConfig.shared.navitiaSDK.journeysApi.newJourneysRequestBuilder()
//                .withFrom("2.38;48.84")
//                .withTo("2.29;48.82")
//                .get { (result, error) in
//                    if let journeys = result?.journeys {
//                      //  self.journeys = journeys
//                        self.parseNavitia(journeys: journeys)
//                        self.journeySolutionDidChange?(self)
//                      //  print(journeys)
//                    }
//            }
        }
    }
    
    func parseNavitia(journeys: [Journey]) {
        for journey in journeys {
            if journey.distances?.ridesharing != 0 {
                self.journeysRidesharing.append(journey)
            } else {
                self.journeys.append(journey)
            }
        }
    }
    
}
