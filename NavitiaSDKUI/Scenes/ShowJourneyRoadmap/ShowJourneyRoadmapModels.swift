//
//  ShowJourneyRoadmapModels.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//


import UIKit

enum ShowJourneyRoadmap
{
  // MARK: Use cases
  
    enum GetRoadmap
    {
        struct Request {
        }
        struct Response {
            var journey: Journey
            var journeyRidesharing: Journey?
            var disruptions: [Disruption]?
            var notes: [Note]?
            var context: Context
        }
        struct ViewModel {
            struct DepartureArrival {
                enum Mode {
                    case departure
                    case arrival
                }
                var mode: Mode
                var information: String
                var time: String
                var calorie: String?
            }
            struct Ridesharing {
                var network: String
                var departure: String
                var driverPictureURL: String
                var driverNickname: String
                var driverGender: String
                var rating: Float
                var ratingCount: Int32
                var departureAddress: String
                var arrivalAddress: String
                var seatsCount: Int32?
                var price: String
                var deepLink: String
            }
            struct SectionClean {
                enum ModelType: String {
                    case publicTransport = "public_transport"
                    case streetNetwork = "street_network"
                    case waiting = "waiting"
                    case transfer = "transfer"
                    case boarding = "boarding"
                    case landing = "landing"
                    case bssRent = "bss_rent"
                    case bssPutBack = "bss_put_back"
                    case crowFly = "crow_fly"
                    case park = "park"
                    case leaveParking = "leave_parking"
                    case alighting = "alighting"
                    case ridesharing = "ridesharing"
                    case onDemandTransport = "on_demand_transport"
                }
                enum Mode: String {
                    case walking = "walking"
                    case bike = "bike"
                    case car = "car"
                    case bss = "bss"
                    case ridesharing = "ridesharing"
                    case carnopark = "carnopark"
                }
                struct Poi {
                    var name: String
                    var network: String
                    var lat: Double
                    var lont: Double
                    var addressName: String
                    var addressId: String
                    var stands: Stands?
                }
                struct Stands {
                    var availability: String?
                    var icon: String?
                }
                struct Path {
                    var direction: Int32
                    var length: Int32
                    var name: String
                }
                struct DisplayInformations {
                    var commercialMode: String?
                    var color: UIColor?
                    var directionTransit: String
                    var code: String?
                }
                struct Note {
                    var content: String
                }
                
                var type: ModelType
                var mode: Mode?
                
                var from: String
                var to: String
                
                var startTime: String
                var endTime: String
                
                var actionDescription: String?
                var duration: String?
                var path: [Path]?
                var stopDate: [String]
                var displayInformations: DisplayInformations
                var waiting: String?
                
                var disruptions: [Disruption] // A reconstruire
                var notes: [Note]

                var poi: Poi?
                var icon: String
                var bssRealTime: Bool
                
                var background: Bool
                
                // Provisoire
                var section: Section
            }
            struct Emission {
                var journey: (value: Double, unit: String)
                var car: (value: Double, unit:String)?
            }

            var ridesharing: Ridesharing?
            var departure: DepartureArrival
            var sections: [SectionClean]?
            var arrival: DepartureArrival
            var emission: Emission
            
            // Provisoire
            var disruptions: [Disruption]?  // Class: SDK Expert
            var journey: Journey  // Class: SDK Expert
            var ridesharingJourneys: Journey? // Class: SDK Expert
        }
    }
    
    enum GetMap
    {
        struct Request {
        }
        struct Response {
            var journey: Journey
        }
        struct ViewModel {
            var journey: Journey
        }
    }
    
    enum FetchBss {
        struct Request {
            var lat: Double
            var lon: Double
            var distance: Int32 = 10
            var id: String
            var notify: ((ShowJourneyRoadmap.GetRoadmap.ViewModel.SectionClean.Poi) -> ())
        }
        struct Response {
            var poi: Poi
            var notify: ((ShowJourneyRoadmap.GetRoadmap.ViewModel.SectionClean.Poi) -> ())
        }
        struct ViewModel {
            
        }
    }
}
