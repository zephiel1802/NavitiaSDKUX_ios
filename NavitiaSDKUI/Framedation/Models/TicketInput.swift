//
//  TicketInput.swift
//  NavitiaSDKUI
//
//  Created by Adeline Hirsch on 29/08/2019.
//

import Foundation
import UIKit

public struct TicketInput: Codable {
   
    let productId: String
    let ride: Ride
    
    enum CodingKeys : String, CodingKey {
        case productId = "id_product"
        case ride
    }
}

public struct Ride: Codable {
   
    let from: String
    let to: String
    let departureDate: String
    let arrivalDate: String
    let ticketId: String
    
    enum CodingKeys : String, CodingKey {
        case from
        case to
        case departureDate = "datetime_departure"
        case arrivalDate = "datetime_arrival"
        case ticketId = "ticket_id"
    }
}
