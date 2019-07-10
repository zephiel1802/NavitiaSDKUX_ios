//
// Place.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


open class Place: JSONEncodable, Mappable, Codable {

    public enum EmbeddedType: String, Codable { 
        case line = "line"
        case journeyPattern = "journey_pattern"
        case vehicleJourney = "vehicle_journey"
        case stopPoint = "stop_point"
        case stopArea = "stop_area"
        case network = "network"
        case physicalMode = "physical_mode"
        case commercialMode = "commercial_mode"
        case connection = "connection"
        case journeyPatternPoint = "journey_pattern_point"
        case company = "company"
        case route = "route"
        case poi = "poi"
        case contributor = "contributor"
        case address = "address"
        case poitype = "poitype"
        case administrativeRegion = "administrative_region"
        case calendar = "calendar"
        case lineGroup = "line_group"
        case impact = "impact"
        case dataset = "dataset"
        case trip = "trip"
    }
    public var embeddedType: EmbeddedType?
    public var stopPoint: StopPoint?
    public var administrativeRegion: Admin?
    /** Name of the object */
    public var name: String?
    /** Distance to the object in meters */
    public var distance: String?
    public var address: Address?
    public var poi: Poi?
    public var quality: Int32?
    /** Identifier of the object */
    public var id: String?
    public var stopArea: StopArea?

    public init() {}
    required public init?(map: Map) {

    }


    enum CodingKeys: String, CodingKey {
        case embeddedType = "embedded_type"
        case stopPoint = "stop_point"
        case administrativeRegion = "administrative_region"
        case name = "name"
        case distance = "distance"
        case address = "address"
        case poi = "poi"
        case quality = "quality"
        case id = "id"
        case stopArea = "stop_area"
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(embeddedType, forKey: .embeddedType)
        try container.encode(stopPoint, forKey: .stopPoint)
        try container.encode(administrativeRegion, forKey: .administrativeRegion)
        try container.encode(name, forKey: .name)
        try container.encode(distance, forKey: .distance)
        try container.encode(address, forKey: .address)
        try container.encode(poi, forKey: .poi)
        try container.encode(quality, forKey: .quality)
        try container.encode(id, forKey: .id)
        try container.encode(stopArea, forKey: .stopArea)
    }

    public func mapping(map: Map) {
        embeddedType <- map["embedded_type"]
        stopPoint <- map["stop_point"]
        administrativeRegion <- map["administrative_region"]
        name <- map["name"]
        distance <- map["distance"]
        address <- map["address"]
        poi <- map["poi"]
        quality <- map["quality"]
        id <- map["id"]
        stopArea <- map["stop_area"]
    }

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["embedded_type"] = self.embeddedType?.rawValue
        nillableDictionary["stop_point"] = self.stopPoint?.encodeToJSON()
        nillableDictionary["administrative_region"] = self.administrativeRegion?.encodeToJSON()
        nillableDictionary["name"] = self.name
        nillableDictionary["distance"] = self.distance
        nillableDictionary["address"] = self.address?.encodeToJSON()
        nillableDictionary["poi"] = self.poi?.encodeToJSON()
        nillableDictionary["quality"] = self.quality?.encodeToJSON()
        nillableDictionary["id"] = self.id
        nillableDictionary["stop_area"] = self.stopArea?.encodeToJSON()

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}
