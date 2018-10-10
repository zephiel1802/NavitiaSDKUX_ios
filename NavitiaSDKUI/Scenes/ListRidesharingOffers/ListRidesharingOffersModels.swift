//
//  ListRidesharingOffersModels.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import Foundation

enum ListRidesharingOffers {
    
    // MARK: Use cases
    
    enum GetRidesharingOffers {
        struct Request {}
        struct Response {
            var journey: Journey
            var ridesharingJourneys: [Journey]?
            var disruptions: [Disruption]?
            var notes: [Note]?
            var context: Context
        }
        struct ViewModel {
            struct JourneySummary {
                var duration: Int32
                var sections: [Section] // Class: SDK Expert
            }
            
            struct DisplayedRidesharingOffer {
                var network: String
                var departure: String
                var driverPictureURL: String
                var driverNickname: String
                var driverGender: String
                var rating: Float
                var ratingCount: Int32
                var seatsCount: Int32?
                var price: String
                var accessiblityLabel: String
            }
            
            var journeySummary: JourneySummary
            var displayedRidesharingOffers: [DisplayedRidesharingOffer]
        }
    }
}
