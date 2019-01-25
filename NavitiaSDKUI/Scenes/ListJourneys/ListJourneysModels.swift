//
//  ListJourneysModels.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit

enum ListJourneys {
    
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
                var dateTime: String
                var dateTimeDate: Date?
                var origin: String
                var destination: String
            }
            
            struct DisplayedJourney {
                var dateTime: String
                var duration: NSMutableAttributedString
                var walkingInformation: NSMutableAttributedString?
                var friezeSections: [FriezePresenter.FriezeSection]
                var accessibility: String?
            }
            
            var loaded: Bool
            var headerInformations: HeaderInformations
            var accessibilityHeader: String?
            var accessibilitySwitchButton: String?
            var displayedJourneys: [DisplayedJourney]
            var displayedRidesharings: [DisplayedJourney]
        }
    }
}
