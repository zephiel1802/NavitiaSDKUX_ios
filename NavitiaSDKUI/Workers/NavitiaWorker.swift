//
//  NavitiaWorker.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import Foundation

typealias NavitiaFetchJourneysCompletionHandler = ([Journey]?, [Journey]?, [Disruption]?, [Note]?, Context?) -> Void

protocol NavitiaWorkerProtocol {
    
    func fetchJourneys(journeysRequest: JourneysRequest, completionHandler: @escaping NavitiaFetchJourneysCompletionHandler)
}

class NavitiaWorker: NavitiaWorkerProtocol {
    
    func fetchJourneys(journeysRequest: JourneysRequest, completionHandler: @escaping NavitiaFetchJourneysCompletionHandler) {
        if NavitiaSDKUI.shared.navitiaSDK != nil {
            let journeyRequestBuilder = NavitiaSDKUI.shared.navitiaSDK.journeysApi.newCoverageRegionJourneysRequestBuilder()
                .withRegion(journeysRequest.coverage)
                .withFrom(journeysRequest.originId)
                .withTo(journeysRequest.destinationId)
                .withDatetime(journeysRequest.datetime)
                .withDatetimeRepresents(journeysRequest.datetimeRepresents)
                .withForbiddenUris(journeysRequest.forbiddenUris)
                .withAllowedId(journeysRequest.allowedId)
                .withFirstSectionMode(journeysRequest.firstSectionModes)
                .withLastSectionMode(journeysRequest.lastSectionModes)
                .withCount(journeysRequest.count)
                .withMinNbJourneys(journeysRequest.minNbJourneys)
                .withMaxNbJourneys(journeysRequest.maxNbJourneys)
                .withBssStands(journeysRequest.bssStands)
                .withAddPoiInfos(journeysRequest.addPoiInfos)
                .withDirectPath(journeysRequest.directPath)
                .withDebugURL(journeysRequest.debugURL)
                .withDataFreshness(journeysRequest.dataFreshness)
            
            journeyRequestBuilder.get { (result, error) in
                if let result = result {
                    let journeys = self.parseJourneyResponse(result: result)
                    completionHandler(journeys.journeys, journeys.Ridesharing, journeys.disruptions, journeys.notes, journeys.context)
                } else {
                    completionHandler(nil, nil, nil, nil, nil)
                }
            }
        }
    }

    internal func parseJourneyResponse(result: Journeys) -> (journeys: [Journey]?, Ridesharing: [Journey]?, disruptions: [Disruption]?, notes: [Note]?, context: Context?) {
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
        
        return (journeys, ridesharing, result.disruptions, result.notes, result.context)
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
    
    func fetchPark(coord: (lat: Double, lon: Double), distance: Int32, id: String, completionHandler: @escaping (Poi?) -> Void) {
        if NavitiaSDKUI.shared.navitiaSDK != nil {
            let poisRequestBuilder = NavitiaSDKUI.shared.navitiaSDK.poisApi.newCoverageLonLatUriPoisRequestBuilder()
                .withLat(coord.lat)
                .withLon(coord.lon)
                .withDistance(distance)
                .withUri("poi_types/poi_type:amenity:parking/coord/" + id)
                .withAddPoiInfos([.carPark])
            
            poisRequestBuilder.get { (result, error) in
                completionHandler(result?.pois?.first)
            }
        }
    }
    
    func fetchPlaces(coverage: String, q: String, coord: (lat: Double, lon: Double)? = nil, completionHandler: @escaping (Places?) -> Void) {
        if NavitiaSDKUI.shared.navitiaSDK != nil {
            let placesRequestBuilder = NavitiaSDKUI.shared.navitiaSDK.placesApi.newCoverageRegionPlacesRequestBuilder()
                .withRegion(coverage)
                .withQ(q)
            
            if let coord = coord {
                placesRequestBuilder.from = String(format: "%d;%d", coord.lon, coord.lat)
            }
            
            placesRequestBuilder.get { (result, error) in
                completionHandler(result)
            }
        }
    }
    
    func fetchPhysicalMode(coverage: String, completionHandler: @escaping ([PhysicalMode]?) -> Void) {
        if NavitiaSDKUI.shared.navitiaSDK != nil {
            let physicalModesRequestBuilder = NavitiaSDKUI.shared.navitiaSDK.physicalModesApi.newCoverageRegionPhysicalModesRequestBuilder()
                .withRegion(coverage)
            
            physicalModesRequestBuilder.get { (result, error) in
                completionHandler(result?.physicalModes)
            }
        }
    }
}
