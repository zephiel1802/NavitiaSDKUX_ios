//
// CellLonSchema.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


open class CellLonSchema: JSONEncodable, Mappable, Codable {

    public var minLon: Float?
    public var centerLon: Float?
    public var maxLon: Float?

    public init() {}
    required public init?(map: Map) {

    }


    enum CodingKeys: String, CodingKey {
        case minLon = "min_lon"
        case centerLon = "center_lon"
        case maxLon = "max_lon"
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(minLon, forKey: .minLon)
        try container.encode(centerLon, forKey: .centerLon)
        try container.encode(maxLon, forKey: .maxLon)
    }

    public func mapping(map: Map) {
        minLon <- map["min_lon"]
        centerLon <- map["center_lon"]
        maxLon <- map["max_lon"]
    }

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["min_lon"] = self.minLon
        nillableDictionary["center_lon"] = self.centerLon
        nillableDictionary["max_lon"] = self.maxLon

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}
