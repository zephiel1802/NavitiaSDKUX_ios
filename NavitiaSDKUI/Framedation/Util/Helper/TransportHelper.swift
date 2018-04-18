//
//  TransportHelper.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import Foundation

enum TypeTransport: String {
    case bike
    case ferry
    case bss
    case bus
    case car
    case finecular
    case metro
    case localtrain
    case rapidtransit
    case longdistancetrain
    case tramway
    case walking
    case ridesharing

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
