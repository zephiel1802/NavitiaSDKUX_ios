//
//  MaasJourney.swift
//  NavitiaSDKUI
//
//  Created by Adeline Hirsch on 30/09/2019.
//

import Foundation

struct MaasJourney: Encodable {
    
    let context: Context?
    let disruptions: [Disruption]?
    let journeys: [Journey]
    let tickets: [Ticket]?
    let hermaasTickets: [PricedTicket]?
    
    enum CodingKeys: String, CodingKey {
        case context
        case disruptions
        case journeys
        case tickets
        case hermaasTickets = "hermaas_tickets"
    }
}
