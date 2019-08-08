//
//  FormJourneyModels.swift
//  NavitiaSDKUI
//
//  Copyright © 2019 kisio. All rights reserved.
//

import UIKit

enum FormJourney {
    
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
            var bikeImage: UIImage?
            var busImage: UIImage?
            var carImage: UIImage?
            var taxiImage: UIImage?
            var trainImage: UIImage?
            var metroImage: UIImage?
            var originImage: UIImage?
            var destinationImage: UIImage?
        }
    }
    
    enum UpdateDate {
        struct Request {
            public enum DatetimeRepresents: String {
                case arrival = "arrival"
                case departure = "departure"
            }
            
            var date: Date
            var dateTimeRepresents: DatetimeRepresents
        }
        struct Response {
        }
        struct ViewModel {
        }
    }
}
