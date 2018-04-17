//
//  JourneySolutionModel.swift
//  NavitiaSDKUI
//
//  Created by Flavien Sicard on 26/03/2018.
//  Copyright © 2018 kisio. All rights reserved.
//

import Foundation

class JourneySolutionModel {
    
    let departureDateTime: Date
    let arrivalDateTime: Date
    let duration: Int32
    let durationWalking: Int32
    let distanceWalking: Int32
    let distances: (car: Int32, walking: Int32, ridesharing: Int32, bike: Int32)
    
    init(journey: Journey) {
        self.departureDateTime = journey.departureDateTime?.toDate(format: FormatConfiguration.date) ?? Date()
        self.arrivalDateTime = journey.arrivalDateTime?.toDate(format: FormatConfiguration.date) ?? Date()
        self.duration = journey.durations?.total ?? 0
        self.durationWalking = journey.durations?.walking ?? 0
        self.distanceWalking = journey.distances?.walking ?? 0
        
        self.distances = (car: journey.distances?.car ?? 0,
                          walking: journey.distances?.walking ?? 0,
                          ridesharing: journey.distances?.ridesharing ?? 0,
                          bike: journey.distances?.bike ?? 0)
    }
    
}

class JourneySolutionSectionModel {
    
    
}
