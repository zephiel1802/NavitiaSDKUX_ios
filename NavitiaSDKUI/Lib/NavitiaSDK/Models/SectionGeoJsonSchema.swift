//
// SectionGeoJsonSchema.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


open class SectionGeoJsonSchema: JSONEncodable, Mappable, Codable {

    public var type: String?
    public var properties: [SectionGeoJsonSchemaProperties]?
    public var coordinates: [[Double]]?

    public init() {}
    required public init?(map: Map) {

    }


    enum CodingKeys: String, CodingKey {
        case type = "type"
        case properties = "properties"
        case coordinates = "coordinates"
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
        try container.encode(properties, forKey: .properties)
        try container.encode(coordinates, forKey: .coordinates)
    }

    public func mapping(map: Map) {
        type <- map["type"]
        properties <- map["properties"]
        coordinates <- map["coordinates"]
    }

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["type"] = self.type
        nillableDictionary["properties"] = self.properties?.encodeToJSON()
        nillableDictionary["coordinates"] = self.coordinates?.encodeToJSON()

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}
