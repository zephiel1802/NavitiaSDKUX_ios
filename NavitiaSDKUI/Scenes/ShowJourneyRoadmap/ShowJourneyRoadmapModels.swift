//
//  ShowJourneyRoadmapModels.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit
import CoreLocation

enum ShowJourneyRoadmap {
    // MARK: Use cases
  
    enum GetRoadmap {
        struct Request {}
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
                var information: (String, String)
                var time: String
                var calorie: String?
                var accessibility: String
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
                var accessibility: String
            }
            
            struct SectionModel {
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
                    var name: String?
                    var network: String?
                    var lat: Double?
                    var lont: Double?
                    var addressName: String?
                    var addressId: String?
                    var stands: Stands?
                }
                
                struct Stands {
                    var status: String?
                    var availability: String?
                    var icon: String?
                }
                
                struct Path {
                    var directionIcon: String
                    var instruction: String
                }
                
                struct DisplayInformations {
                    var commercialMode: String?
                    var color: UIColor?
                    var textColor: UIColor
                    var directionTransit: String
                    var code: String?
                    var network: String?
                }
                
                struct Note {
                    var content: String
                }

                struct Disruption {
                    public enum Level: Int {
                        case none = 100
                        case information = 101
                        case nonblocking = 102
                        case blocking = 103
                    }
                    
                    var color: UIColor
                    var icon: String
                    var title: String
                    var date: String
                    var information: String?
                    var level: Level
                    var accessibility: String
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
                var disruptions: [Disruption]
                var notes: [Note]
                var poi: Poi?
                var icon: String
                var realTime: Bool
                var background: Bool
                var section: Section
            }
            
            struct Frieze {
                var duration: Int32
                var friezeSections: [FriezePresenter.FriezeSection]
                var friezeSectionsWithDisruption: [FriezePresenter.FriezeSection]
            }
            
            struct Emission {
                var journey: (value: Double, unit: String)
                var car: (value: Double, unit: String)?
                var accessibility: String
            }
            
            var ridesharing: Ridesharing?
            var departure: DepartureArrival
            var sections: [SectionModel]?
            var frieze: Frieze
            var arrival: DepartureArrival
            var emission: Emission
            var displayAvoidDisruption: Bool
        }
    }
    
    enum GetMap {
        struct Request {}
        struct Response {
            var journey: Journey
            var journeyRidesharing: Journey?
        }
        struct ViewModel {
            struct sectionPolyline {
                var coordinates: [CLLocationCoordinate2D]
                var color: UIColor
                var section: Section
                var annotation: [CLLocationCoordinate2D]?
            }
            
            var journey: Journey
            var departureCoord: CLLocationCoordinate2D
            var arrivalCoord: CLLocationCoordinate2D
            var ridesharingAnnotation: [CLLocationCoordinate2D]
            var sectionPolylines: [sectionPolyline]
        }
    }
    
    enum FetchBss {
        struct Request {
            var lat: Double
            var lon: Double
            var distance: Int32
            var id: String
            var type: String
            var notify: ((ShowJourneyRoadmap.GetRoadmap.ViewModel.SectionModel.Stands) -> ())
        }
        struct Response {
            var poi: Poi
            var type: String
            var notify: ((ShowJourneyRoadmap.GetRoadmap.ViewModel.SectionModel.Stands) -> ())
        }
        struct ViewModel {}
    }
    
    enum FetchPark {
        struct Request {
            var lat: Double
            var lon: Double
            var distance: Int32
            var id: String
            var notify: ((ShowJourneyRoadmap.GetRoadmap.ViewModel.SectionModel.Stands) -> ())
        }
        struct Response {
            var poi: Poi
            var notify: ((ShowJourneyRoadmap.GetRoadmap.ViewModel.SectionModel.Stands) -> ())
        }
        struct ViewModel {}
    }
}
