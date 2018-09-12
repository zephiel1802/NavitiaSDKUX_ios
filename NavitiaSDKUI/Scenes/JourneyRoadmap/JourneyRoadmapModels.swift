//
//  JourneyRoadmapModels.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//


import UIKit

enum JourneyRoadmap
{
  // MARK: Use cases
  
    enum GetRoadmap
    {
        struct Request {
        }
        struct Response {
            var journey: Journey
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
                var mode: Mode  // departure  Arrival
                var information: String // journey.section?.first?.from?.name // journey.sections?.last?.to?.name
                var time: String // journey.arrivalDateTime?.toDate(format: Configuration.date)?.toString(format: Configuration.time) = journey.arrivalDateTime?.toDate(format: Configuration.date)?.toString(format: Configuration.time)
                var calorie: String? // String(format: "%d", Int((Double(walkingDistance) * Configuration.caloriePerSecWalking + Double(bikeDistance) * Configuration.caloriePerSecBike).rounded()))
            }
            
            struct DisplayInformations {
                var commercialMode: String?
                var color: UIColor?
                var directionTransit: String
                var code: String?
                // section.displayInformations?.direction
                // var color // displayINforamtions?.color - optional
                // var
            }
            struct Section {
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
                
                
                var type: ModelType // section.type
                var mode: Mode?

                var from: String
                var to: String // last.to.name - Optional
                var startTime: String //section.departureDateTime?.toDate(format: Configuration.date)?.toString(format: Configuration.time) ?? ""
                var endTime: String //section.arrivalDateTime?.toDate(format: Configuration.date)?.toString(format: Configuration.time)
                var time: String?
                var path: [Path]?
                
                var stopDate: [String]

                var displayInformations: DisplayInformations
                var waiting: String?
                var disruptions: [Disruption]
                var poi: Poi?
                var icon: String
                
            }
            struct Emission {
                var journeyValue: Double
               
                // var value journey
                // var value car ?
                // var unit
            }
            // var mode: String
            // var time: String
            // var direction: String
            // var path: [Path]?
        
            var departure: DepartureArrival
            var arrival: DepartureArrival
            var emission: Emission
            
            var sections: [Section]?
            // Provisoire
            var disruptions: [Disruption]?
            var journey: Journey
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
}
