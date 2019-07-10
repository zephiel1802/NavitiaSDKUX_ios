//
// Route.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


open class Route: JSONEncodable, Mappable, Codable {

    public enum IsFrequence: String, Codable { 
        case _false = "False"
    }
    public var direction: Place?
    public var codes: [Code]?
    /** Name of the object */
    public var name: String?
    public var links: [LinkSchema]?
    public var physicalModes: [PhysicalMode]?
    public var isFrequence: IsFrequence?
    public var comments: [Comment]?
    public var directionType: String?
    public var geojson: MultiLineStringSchema?
    public var stopPoints: [StopPoint]?
    public var line: Line?
    /** Identifier of the object */
    public var id: String?

    public init() {}
    required public init?(map: Map) {

    }


    enum CodingKeys: String, CodingKey {
        case direction = "direction"
        case codes = "codes"
        case name = "name"
        case links = "links"
        case physicalModes = "physical_modes"
        case isFrequence = "is_frequence"
        case comments = "comments"
        case directionType = "direction_type"
        case geojson = "geojson"
        case stopPoints = "stop_points"
        case line = "line"
        case id = "id"
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(direction, forKey: .direction)
        try container.encode(codes, forKey: .codes)
        try container.encode(name, forKey: .name)
        try container.encode(links, forKey: .links)
        try container.encode(physicalModes, forKey: .physicalModes)
        try container.encode(isFrequence, forKey: .isFrequence)
        try container.encode(comments, forKey: .comments)
        try container.encode(directionType, forKey: .directionType)
        try container.encode(geojson, forKey: .geojson)
        try container.encode(stopPoints, forKey: .stopPoints)
        try container.encode(line, forKey: .line)
        try container.encode(id, forKey: .id)
    }

    public func mapping(map: Map) {
        direction <- map["direction"]
        codes <- map["codes"]
        name <- map["name"]
        links <- map["links"]
        physicalModes <- map["physical_modes"]
        isFrequence <- map["is_frequence"]
        comments <- map["comments"]
        directionType <- map["direction_type"]
        geojson <- map["geojson"]
        stopPoints <- map["stop_points"]
        line <- map["line"]
        id <- map["id"]
    }

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["direction"] = self.direction?.encodeToJSON()
        nillableDictionary["codes"] = self.codes?.encodeToJSON()
        nillableDictionary["name"] = self.name
        nillableDictionary["links"] = self.links?.encodeToJSON()
        nillableDictionary["physical_modes"] = self.physicalModes?.encodeToJSON()
        nillableDictionary["is_frequence"] = self.isFrequence?.rawValue
        nillableDictionary["comments"] = self.comments?.encodeToJSON()
        nillableDictionary["direction_type"] = self.directionType
        nillableDictionary["geojson"] = self.geojson?.encodeToJSON()
        nillableDictionary["stop_points"] = self.stopPoints?.encodeToJSON()
        nillableDictionary["line"] = self.line?.encodeToJSON()
        nillableDictionary["id"] = self.id

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}
