//
//  JourneySolutionModels.swift
//  NavitiaSDKUI
//
//  Created by Flavien Sicard on 24/08/2018.
//

import UIKit

enum JourneySolution {
    
    // MARK: Use cases
    
    enum FetchJourneys {
        
        struct Request {
            var inParameters: JourneySolutionViewController.InParameters
        }
        
        struct Response {
            var journeys: Journeys
        }
        
        struct ViewModel {
            struct DisplayedJourney {
                var departureDateTime: Date // EN STRIN?  !
                var arrivalDateTime: Date
                var duration: Int32 // Non Formaté - EN SECONDE
                var walkingDuration: String? // Formaté
                var walkingDistance: String // Formaté
                var sections: [Section]
            }
            struct DisplayedDisruption {
                var disruptions: [Disruption]
            }
            var displayedJourneys: [DisplayedJourney]
            var displayedRidesharings: [DisplayedJourney]
            var displayedDisruptions: [DisplayedDisruption]
        }
        
    }
    
}
