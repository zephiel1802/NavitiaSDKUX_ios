//
//  MaasOrder.swift
//  NavitiaSDKUI
//
//  Created by Rachik Abidi on 26/09/2019.
//

import Foundation

struct MaasOrder: Codable {
    
    let orderId: Int?
    let ticketsList: [MaasTicket]?
    
    enum CodingKeys: String, CodingKey {
        case orderId = "id_order"
        case ticketsList = "details"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(orderId, forKey: .orderId)
        try container.encode(ticketsList, forKey: .ticketsList)
    }
}
