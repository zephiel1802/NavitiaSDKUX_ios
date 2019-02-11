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
            var from: (name: String, id: String)?
            var to: (name: String, id: String)?
        }
        struct Response {
            var fromName: String?
            var toName: String?
        }
        struct ViewModel {
            var fromName: String
            var toName: String
        }
    }
    
    enum FetchPlaces {
        struct Request {
            var q: String
            var coord: (lat: Double, lon: Double)?
        }
        struct Response {
            var places: Places?
        }
        struct ViewModel {
            enum ModelType {
                case stopArea
                case address
                case poi
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
