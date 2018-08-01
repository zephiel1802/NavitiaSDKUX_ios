//
//  JourneySolutionRoadmapViewModel.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit

class JourneySolutionRoadmapViewModel: NSObject {

    var journeySolutionRoadmapDidChange: ((JourneySolutionRoadmapViewModel) -> ())?

    var standBikeTime: Timer!
    var bssPois = [Poi]()
    
    func refreshStandsBike(run: Bool = true) {
        if run {
            standBikeTime = Timer.scheduledTimer(timeInterval: Configuration.bssTimeInterval, target: self, selector: #selector(getStandsBike), userInfo: nil, repeats: true)
        } else {
            standBikeTime.invalidate()
        }
    }
    
    @objc func getStandsBike() {
        guard let navitiaSDK = NavitiaSDKUI.shared.navitiaSDK else {
            return
        }
//
//        let poisRequestBuilder = navitiaSDK.poisApi.newCoverageLonLatUriPoisRequestBuilder()
//            .withLat(47.3261613) //Journeys ... Section bss rent / bss ... to / poi / coord
//            .withLon(5.0450307)
//            .withDistance(10)
//            .withUri("poi_types/poi_type:amenity:bicycle_rental/coord/" + "5.0450307;47.3261613") //Journeys ... Section bss rent / bss ... to / poi .. address // ID
//            .withBssStands(true)
//        poisRequestBuilder.get { (result, error) in
//            print(result?.pois?.first?.address?.name, result?.pois?.first?.stands)
//            guard let stands = result?.pois?.first?.stands else {
//                return
//            }
//
//            print(stands.availablePlaces, stands.availableBikes, stands.totalStands)
//        }
        
        for poi in bssPois {
            
            
            if let lat = poi.coord?.lat, let doubleLat = Double(lat), let lon = poi.coord?.lon, let doubleLon = Double(lon), let id = poi.address?.id {
                let poisRequestBuilder = navitiaSDK.poisApi.newCoverageLonLatUriPoisRequestBuilder()
                    .withLat(doubleLat)
                    .withLon(doubleLon)
                    .withDistance(10)
                    .withUri("poi_types/poi_type:amenity:bicycle_rental/coord/" + id)
                    .withBssStands(true)
                poisRequestBuilder.get { (result, error) in
                    print(result?.pois?.first?.address?.name, result?.pois?.first?.stands)
                    guard let stands = result?.pois?.first?.stands else {
                        return
                    }

                    print(stands.availablePlaces, stands.availableBikes, stands.totalStands)
                }
            }
        }
    }
    
    
}
