//
//  MaasTicket.swift
//  MaasSDK
//
//  Created by Rachik Abidi on 31/07/2019.
//

import Foundation

internal struct MaasTicket: Codable {
    
    let productId: Int
    let ticket: TicketDetails
    let from: String?
    let to: String?
    let departureDatetime: String?
    let arrivalDatetime: String?
    let physicalMode: String?
    
    enum CodingKeys: String, CodingKey {
        
        case productId = "id_product"
        case ticket
        case from
        case to
        case departureDatetime = "departure_date_time"
        case arrivalDatetime = "arrival_date_time"
        case physicalMode = "physical_mode"
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(productId, forKey: .productId)
        try container.encode(ticket, forKey: .ticket)
        try container.encode(from, forKey: .from)
        try container.encode(to, forKey: .to)
        try container.encode(departureDatetime, forKey: .departureDatetime)
        try container.encode(arrivalDatetime, forKey: .arrivalDatetime)
        try container.encode(physicalMode, forKey: .physicalMode)
    }
}

internal struct TicketDetails: Codable {
    
    let image: String?
    let status: String?
    
    enum CodingKeys: String, CodingKey {
        case image
        case status
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(image, forKey: .image)
        try container.encode(status, forKey: .status)
    }
}
