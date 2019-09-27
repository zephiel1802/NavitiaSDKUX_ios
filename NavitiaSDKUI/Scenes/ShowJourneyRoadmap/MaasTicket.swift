//
//  MaasTicket.swift
//  MaasSDK
//
//  Created by Rachik Abidi on 31/07/2019.
//

import Foundation

struct MaasTicket: Codable {
    
    let productId: Int
    let ticketId: String?
    let ticket: TicketDetails
    let from: String?
    let to: String?
    let departureDatetime: String?
    let arrivalDatetime: String?
    let physicalMode: String?
    
    enum CodingKeys: String, CodingKey {
        
        case productId = "id_product"
        case ticketId = "ticket_id"
        case ticket
        case from
        case to
        case departureDatetime = "departure_date_time"
        case arrivalDatetime = "arrival_date_time"
        case physicalMode = "physical_mode"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(productId, forKey: .productId)
        try container.encode(ticketId, forKey: .ticketId)
        try container.encode(ticket, forKey: .ticket)
        try container.encode(from, forKey: .from)
        try container.encode(to, forKey: .to)
        try container.encode(departureDatetime, forKey: .departureDatetime)
        try container.encode(arrivalDatetime, forKey: .arrivalDatetime)
        try container.encode(physicalMode, forKey: .physicalMode)
    }
}

struct TicketDetails: Codable {
    
    let data: TicketData?
    let image: String?
    let status: String?
    
    enum CodingKeys: String, CodingKey {
        case data
        case image
        case status
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(data, forKey: .data)
        try container.encode(image, forKey: .image)
        try container.encode(status, forKey: .status)
    }
}

struct TicketData: Codable {
    
    let id: String?
    let type: String?
    let driverInfo: DriverInfo?
    let transportInfo: TransportInfo?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case type
        case driverInfo
        case transportInfo
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(type, forKey: .type)
        try container.encode(driverInfo, forKey: .driverInfo)
        try container.encode(transportInfo, forKey: .transportInfo)
    }
}

struct DriverInfo: Codable {
    
    let driverId: String
    let name: String
    let phone: String
    
    enum CodingKeys: String, CodingKey {
        case driverId = "id"
        case name
        case phone
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(driverId, forKey: .driverId)
        try container.encode(name, forKey: .name)
        try container.encode(phone, forKey: .phone)
    }
}

struct TransportInfo: Codable {
    
    let transportId: String
    let model: String
    let description: String?
    
    enum CodingKeys: String, CodingKey {
        case transportId = "id"
        case model
        case description
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(transportId, forKey: .transportId)
        try container.encode(model, forKey: .model)
        try container.encode(description, forKey: .description)
    }
}
