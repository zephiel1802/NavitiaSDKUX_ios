//
//  JourneySolutionRoadmapViewModel.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit

class JourneySolutionRoadmapViewModel: NSObject {

    var journeySolutionRoadmapDidChange: ((JourneySolutionRoadmapViewModel) -> ())?
    var standBikeTime: Timer?
    var bss = [(poi: Poi, notify: ((Poi) -> ()))]()
    
    func refreshBikeStands(run: Bool = true) {
        standBikeTime?.invalidate()
        
        if run {
            standBikeTime = Timer.scheduledTimer(timeInterval: Configuration.bssTimeInterval, target: self, selector: #selector(getBikeStands), userInfo: nil, repeats: true)
            standBikeTime?.fire()
        }
    }
    
    @objc func getBikeStands() {
        guard let navitiaSDK = NavitiaSDKUI.shared.navitiaSDK else {
            return
        }
        
        for (poi, notify) in bss {
            if let lat = poi.coord?.lat, let doubleLat = Double(lat), let lon = poi.coord?.lon, let doubleLon = Double(lon), let id = poi.address?.id {
                let poisRequestBuilder = navitiaSDK.poisApi.newCoverageLonLatUriPoisRequestBuilder()
                    .withLat(doubleLat)
                    .withLon(doubleLon)
                    .withDistance(10)
                    .withUri("poi_types/poi_type:amenity:bicycle_rental/coord/" + id)
                    .withBssStands(true)
                
                poisRequestBuilder.get { (result, error) in
                    guard let poi = result?.pois?.first else {
                        return
                    }

                    notify(poi)
                }
            }
        }

    }
    
}
