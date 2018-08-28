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
            var journeysRequest: JourneysRequest
        }
        
        struct Response {
            var journeysRequest: JourneysRequest
            var journeys: ([Journey]?, withRidesharing: [Journey]?)
            var disruptions: [Disruption]?
        }
        
        struct ViewModel {
            struct HeaderInformations {
                var dateTime: NSMutableAttributedString
                var origin: NSMutableAttributedString
                var destination: NSMutableAttributedString
            }
            struct DisplayedJourney {
                var dateTime: NSMutableAttributedString
                var duration: NSMutableAttributedString
                var walkingInformation: NSMutableAttributedString?
                var sections: [Section]
            }
            
            var loaded: Bool
            var headerInformations: HeaderInformations
            var displayedJourneys: [DisplayedJourney]
            var displayedRidesharings: [DisplayedJourney]
            var disruptions: [Disruption] // Class: SDK Expert
        }
        
    }
    
}
