//
//  ListPlacesModels.swift
//  NavitiaSDKUI
//
//  Copyright © 2019 kisio. All rights reserved.
//

import UIKit

enum ListPlaces {
    
    // MARK: Use cases
    
    enum UpdateSearchViewFields {
        struct Request {
            var from: (label: String?, name: String?, id: String)?
            var to: (label: String?, name: String?, id: String)?
        }
        struct Response {
            var from: (label: String?, name: String?, id: String)?
            var to: (label: String?, name: String?, id: String)?
        }
        struct ViewModel {
            var fromName: String
            var toName: String
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
    
    enum FetchUserLocation {
        struct Request {
            var latitude: Double
            var longitude: Double
        }
        struct Response {
            var userAddress: Address?
        }
        struct ViewModel {
            var userSection: FetchPlaces.ViewModel.DisplayedSection
        }
    }
    
    enum FetchPlaces {
        struct Request {
            var query: String
            var userLat: Double?
            var userLon: Double?
        }
        struct Response {
            var places: Places?
        }
        struct ViewModel {
            enum ModelType: String {
                case administrativeRegion = "administrative_region"
                case stopArea = "stop_area"
                case address = "address"
                case poi = "poi"
                case locationDisabled = "locationDisabled"
                case locationLoading = "locationLoading"
                case locationFound = "locationFound"
                case locationNotFound = "locationNotFound"
            }
            
            struct Place {
                var label: String?
                var name: String?
                var id: String?
                var distance: String?
                var type: ModelType
            }
            
            struct DisplayedSection {
                var name: String?
                var places: [Place]
            }
            
            var displayedSections: [DisplayedSection]
        }
    }
    
    enum FetchHistoryItems {
        struct Request {
            
        }
        struct Response {
            var historyItems: [AutocompletionHistory]
        }
        struct ViewModel {
            
        }
    }
}
