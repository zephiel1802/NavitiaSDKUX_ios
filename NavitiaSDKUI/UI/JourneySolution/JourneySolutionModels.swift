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
            var parameters: JourneySolutionViewController.InParameters
            var journeys: Journeys?
        }
        
        struct ViewModel {
            struct SearchInformation {
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
            var searchInformation: SearchInformation
            var displayedJourneys: [DisplayedJourney]
            var displayedRidesharings: [DisplayedJourney]
            var displayedDisruptions: [Disruption]
        }
        
    }
    
}
