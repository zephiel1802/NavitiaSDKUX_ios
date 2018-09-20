//
//  JourneysWorker.swift
//  NavitiaSDKUI
//
//  Created by Flavien Sicard on 28/08/2018.
//

import Foundation

internal struct JourneysWorker {
    
    func fetchJourneys(journeysRequest: JourneysRequest, completionHandler: @escaping ([Journey]?, [Journey]?, [Disruption]?, [Note]?, Context?) -> Void) {
        if NavitiaSDKUI.shared.navitiaSDK != nil {
            let journeyRequestBuilder = NavitiaSDKUI.shared.navitiaSDK.journeysApi.newJourneysRequestBuilder()
            _ = journeyRequestBuilder.withFrom(journeysRequest.originId)
            _ = journeyRequestBuilder.withTo(journeysRequest.destinationId)
            
            if let datetime = journeysRequest.datetime {
                _ = journeyRequestBuilder.withDatetime(datetime)
            }
            if let datetimeRepresents = journeysRequest.datetimeRepresents {
                _ = journeyRequestBuilder.withDatetimeRepresents(datetimeRepresents)
            }
            if let forbiddenUris = journeysRequest.forbiddenUris {
                _ = journeyRequestBuilder.withForbiddenUris(forbiddenUris)
            }
            if let allowedId = journeysRequest.allowedId {
                _ = journeyRequestBuilder.withAllowedId(allowedId)
            }
            if let firstSectionModes = journeysRequest.firstSectionModes {
                _ = journeyRequestBuilder.withFirstSectionMode(firstSectionModes)
            }
            if let lastSectionModes = journeysRequest.lastSectionModes {
                _ = journeyRequestBuilder.withLastSectionMode(lastSectionModes)
            }
            if let count = journeysRequest.count {
                _ = journeyRequestBuilder.withCount(count)
            }
            if let minNbJourneys = journeysRequest.minNbJourneys {
                _ = journeyRequestBuilder.withMinNbJourneys(minNbJourneys)
            }
            if let maxNbJourneys = journeysRequest.maxNbJourneys {
                _ = journeyRequestBuilder.withMaxNbJourneys(maxNbJourneys)
            }
            if let bssStands = journeysRequest.bssStands {
                _ = journeyRequestBuilder.withBssStands(bssStands)
            }
            
            journeyRequestBuilder.get { (result, error) in
                if let result = result {
                    var journeys: [Journey] = []
                    var ridesharing: [Journey] = []
                    if let allJourneys = result.journeys {
                        for journey in allJourneys {
                            if journey.isRidesharing {
                                ridesharing.append(journey)
                            } else {
                                journeys.append(journey)
                            }
                        }
                    }
                    completionHandler(journeys, ridesharing, result.disruptions, result.notes, result.context)
                } else {
                    completionHandler(nil, nil, nil, nil, nil)
                }
            }
        }
    }
    
    func fetchBss(coord: (lat: Double, lon: Double), distance: Int32, id: String, completionHandler: @escaping (Poi?) -> Void) {
        if NavitiaSDKUI.shared.navitiaSDK != nil {
            let poisRequestBuilder = NavitiaSDKUI.shared.navitiaSDK.poisApi.newCoverageLonLatUriPoisRequestBuilder()
                .withLat(coord.lat)
                .withLon(coord.lon)
                .withDistance(distance)
                .withUri("poi_types/poi_type:amenity:bicycle_rental/coord/" + id)
                .withBssStands(true)
            
            poisRequestBuilder.get { (result, error) in
                completionHandler(result?.pois?.first)
            }
        }
        
    }
    
}
