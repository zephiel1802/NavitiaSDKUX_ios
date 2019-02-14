//
//  ListPlacesModels.swift
//  NavitiaSDKUI
//
//  Copyright © 2019 kisio. All rights reserved.
//

import UIKit
import SQLite3

enum ListPlaces {
    
    // MARK: Use cases
    
    enum DisplaySearch {
        struct Request {
            var from: (name: String, id: String)?
            var to: (name: String, id: String)?
        }
        struct Response {
            var fromName: String?
            var toName: String?
            var info: String?
        }
        struct ViewModel {
            var fromName: String
            var toName: String
            var info: String?
            
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
            enum ModelType {
                case stopArea
                case address
                case poi
                case location
            }
            
            struct Place {
                var name: String
                var id: String
            }
            
            struct Section {
                var type: ModelType
                var name: String?
                var places: [Place]
            }
            
            var sections: [Section]
        }
    }
}
