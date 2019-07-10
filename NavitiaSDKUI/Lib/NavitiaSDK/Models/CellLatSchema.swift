//
// CellLatSchema.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


open class CellLatSchema: JSONEncodable, Mappable, Codable {

    public var minLat: Float?
    public var maxLat: Float?
    public var centerLat: Float?

    public init() {}
    required public init?(map: Map) {

    }


    enum CodingKeys: String, CodingKey {
        case minLat = "min_lat"
        case maxLat = "max_lat"
        case centerLat = "center_lat"
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(minLat, forKey: .minLat)
        try container.encode(maxLat, forKey: .maxLat)
        try container.encode(centerLat, forKey: .centerLat)
    }

    public func mapping(map: Map) {
        minLat <- map["min_lat"]
        maxLat <- map["max_lat"]
        centerLat <- map["center_lat"]
    }

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["min_lat"] = self.minLat
        nillableDictionary["max_lat"] = self.maxLat
        nillableDictionary["center_lat"] = self.centerLat

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}
