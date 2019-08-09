//
// Stands.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


open class Stands: JSONEncodable, Mappable, Codable {

    public enum Status: String, Codable { 
        case unavailable = "unavailable"
        case closed = "closed"
        case open = "open"
    }
    public var status: Status?
    public var availablePlaces: Int32?
    public var availableBikes: Int32?
    public var totalStands: Int32?

    public init() {}
    required public init?(map: Map) {

    }


    enum CodingKeys: String, CodingKey {
        case status = "status"
        case availablePlaces = "available_places"
        case availableBikes = "available_bikes"
        case totalStands = "total_stands"
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(status, forKey: .status)
        try container.encode(availablePlaces, forKey: .availablePlaces)
        try container.encode(availableBikes, forKey: .availableBikes)
        try container.encode(totalStands, forKey: .totalStands)
    }

    public func mapping(map: Map) {
        status <- map["status"]
        availablePlaces <- map["available_places"]
        availableBikes <- map["available_bikes"]
        totalStands <- map["total_stands"]
    }

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["status"] = self.status?.rawValue
        nillableDictionary["available_places"] = self.availablePlaces?.encodeToJSON()
        nillableDictionary["available_bikes"] = self.availableBikes?.encodeToJSON()
        nillableDictionary["total_stands"] = self.totalStands?.encodeToJSON()

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}
