//
//  PricedTicket.swift
//  NavitiaSDKUI
//
//  Created by Adeline Hirsch on 29/08/2019.
//

import Foundation
import UIKit

public struct PricedTicket: Codable {
    
    let productId: Int
    let name: String
    let shortDescription: String?
    var price: Double
    var priceWithTax: Double
    let taxRate: Double
    let defaultCategoryId: Int
    let active: Bool
    let customType: String?
    let currency: String
    let maxQuantity: Int
    let imageUrl: String
    let displayOrder: Int
    let legalTerm: String?
    let geoInfo: MaasGeoInfo
    let links: [LinkSchema]?
    let ticketId: String
    
    enum CodingKeys: String, CodingKey {
        
        case productId = "id_product"
        case name
        case shortDescription = "description_short"
        case price
        case priceWithTax = "price_with_tax"
        case taxRate = "tax_rate"
        case defaultCategoryId = "id_category_default"
        case active
        case customType = "custom_type"
        case currency
        case maxQuantity = "max_quantity"
        case imageUrl = "url_image"
        case displayOrder = "display_order"
        case legalTerm = "legal_term"
        case geoInfo = "geo_info"
        case links
        case ticketId = "ticket_id"
    }
}

struct MaasGeoInfo: Codable {
    
    let departure: MaasGeoInfoPlace
    let arrival: MaasGeoInfoPlace
    
    enum CodingKeys: String, CodingKey {
        case departure
        case arrival
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(departure, forKey: .departure)
        try container.encode(arrival, forKey: .arrival)
    }
}

struct MaasGeoInfoPlace: Codable {
    
    let name: String
    let coord: MaasGeoInfoCoord
    let label: String?
    let gtfsStopCode: String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case coord
        case label
        case gtfsStopCode = "gtfs_stop_code"
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(coord, forKey: .coord)
        try container.encode(label, forKey: .label)
        try container.encode(gtfsStopCode, forKey: .gtfsStopCode)
    }
}

struct MaasGeoInfoCoord: Codable {
    
    let lat: String
    let lon: String
    
    enum CodingKeys: String, CodingKey {
        case lat
        case lon
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(lat, forKey: .lat)
        try container.encode(lon, forKey: .lon)
    }
}
