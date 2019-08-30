//
//  ListJourneysModels.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit

enum ListJourneys {
    
    // MARK: Use cases
    
    enum DisplaySearch {
        struct Request {
            var from: (label: String?, name: String?, id: String)?
            var to: (label: String?, name: String?, id: String)?
        }
        struct Response {
            var journeysRequest: JourneysRequest
        }
        struct ViewModel {
            var fromName: String?
            var toName: String?
            var dateTime: String
            var date: Date
            var accessibilityHeader: String?
            var accessibilitySwitchButton: String?
        }
    }
    
    enum FetchPhysicalModes {
        struct Request {
            var journeysRequest: JourneysRequest?
        }
        struct Response {
            var physicalModes: [PhysicalMode]?
        }
        struct ViewModel {
            var physicalModes: [String]
        }
    }
    
    enum FetchJourneys {
        struct Request {
            var journeysRequest: JourneysRequest?
        }
        struct Response {
            var journeysRequest: JourneysRequest
            var journeys: ([Journey]?, withRidesharing: [Journey]?)
            var disruptions: [Disruption]?
        }
        struct ViewModel {
            struct DisplayedJourney {
                var dateTime: String
                var duration: NSMutableAttributedString
                var walkingInformation: NSMutableAttributedString?
                var friezeSections: [FriezePresenter.FriezeSection]
                var accessibility: String?
                var ticketsInput: [TicketInput]?
            }
            
            var loaded: Bool
            var displayedJourneys: [DisplayedJourney]
            var displayedRidesharings: [DisplayedJourney]
        }
    }
}
