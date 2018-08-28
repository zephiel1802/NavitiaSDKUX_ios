//
//  TransportHelper.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import Foundation

enum ModeTransport: String {
    case bike = "bike"
    case ferry = "ferry"
    case bss = "bss"
    case bus = "bus"
    case car = "car"
    case finecular = "finecular"
    case metro = "metro"
    case localtrain = "localtrain"
    case rapidtransit = "rapidtransit"
    case longdistancetrain = "longdistancetrain"
    case tramway = "tramway"
    case walking = "walking"
    case ridesharing = "ridesharing"
}

enum TypeTransport: String {
    case publicTransport = "public_transport"
    case transfer = "transfer"
    case streetNetwork = "street_network"
    case ridesharing = "ridesharing"
    case waiting = "waiting"
    case crowFly = "crow_fly"
    case leaveParking = "leave_parking"
    case bssRent = "bss_rent"
    case bssPutBack = "bss_put_back"
}

enum TypeDisruption: String {
    case blocking
    case nonblocking
    case information
}

enum TypeStep: String {
    case departure
    case arrival
}
