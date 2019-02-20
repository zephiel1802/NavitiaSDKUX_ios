//
//  ListPlacesModels.swift
//  NavitiaSDKUI
//
//  Copyright © 2019 kisio. All rights reserved.
//

import UIKit

enum ListPlaces {
    
    // MARK: Use cases
    
    enum DisplaySearch {
        struct Request {
            var from: (label: String?, name: String?, id: String)?
            var to: (label: String?, name: String?, id: String)?
        }
        struct Response {
            var from: (label: String?, name: String?, id: String)?
            var to: (label: String?, name: String?, id: String)?
            var info: String?
        }
        struct ViewModel {
            var fromName: String?
            var toName: String?
            var info: String?
        }
    }
    
    enum SavePlace {
        struct Request {
            var place: (name: String, id: String, type: String)
        }
        struct Response {
            var dictAddresses: DictAddresses
        }
        struct ViewModel {
            
        }
    }
    
    enum FetchLocation {
        struct Request {
            var latitude: Double
            var longitude: Double
        }
        struct Response {
            var dictAddresses: DictAddresses
        }
        struct ViewModel {}
    }
    
    enum FetchPlaces {
        struct Request {
            var q: String
            var coord: (lat: Double, lon: Double)?
        }
        struct Response {
            var places: Places?
            var locationAddress: Address?
        }
        struct ViewModel {
            enum ModelType: String {
                case stopArea = "stop_area"
                case address = "address"
                case poi = "poi"
                case location = "location"
            }
            
            struct Place {
                var name: String
                var id: String
                var type: ModelType
            }
            
            struct DisplayedSections {
                var name: String?
                var places: [Place]
            }
            
            var displayedSections: [DisplayedSections]
        }
    }
}
