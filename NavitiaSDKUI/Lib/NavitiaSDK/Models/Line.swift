//
// Line.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


open class Line: JSONEncodable, Mappable, Codable {

    public var comment: String?
    public var properties: [Property]?
    public var code: String?
    public var network: Network?
    public var links: [LinkSchema]?
    public var color: String?
    public var routes: [Route]?
    public var geojson: MultiLineStringSchema?
    public var textColor: String?
    public var physicalModes: [PhysicalMode]?
    public var codes: [Code]?
    public var comments: [Comment]?
    public var closingTime: String?
    public var openingTime: String?
    public var commercialMode: CommercialMode?
    /** Identifier of the object */
    public var id: String?
    public var lineGroups: [LineGroup]?
    /** Name of the object */
    public var name: String?


    public init() {}
    required public init?(map: Map) {

    }


    enum CodingKeys: String, CodingKey {
        case comment = "comment"
        case properties = "properties"
        case code = "code"
        case network = "network"
        case links = "links"
        case color = "color"
        case routes = "routes"
        case geojson = "geojson"
        case textColor = "text_color"
        case physicalModes = "physical_modes"
        case codes = "codes"
        case comments = "comments"
        case closingTime = "closing_time"
        case openingTime = "opening_time"
        case commercialMode = "commercial_mode"
        case id = "id"
        case lineGroups = "line_groups"
        case name = "name"
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(comment, forKey: .comment)
        try container.encode(properties, forKey: .properties)
        try container.encode(code, forKey: .code)
        try container.encode(network, forKey: .network)
        try container.encode(links, forKey: .links)
        try container.encode(color, forKey: .color)
        try container.encode(routes, forKey: .routes)
        try container.encode(geojson, forKey: .geojson)
        try container.encode(textColor, forKey: .textColor)
        try container.encode(physicalModes, forKey: .physicalModes)
        try container.encode(codes, forKey: .codes)
        try container.encode(comments, forKey: .comments)
        try container.encode(closingTime, forKey: .closingTime)
        try container.encode(openingTime, forKey: .openingTime)
        try container.encode(commercialMode, forKey: .commercialMode)
        try container.encode(id, forKey: .id)
        try container.encode(lineGroups, forKey: .lineGroups)
        try container.encode(name, forKey: .name)
    }

    public func mapping(map: Map) {
        comment <- map["comment"]
        properties <- map["properties"]
        code <- map["code"]
        network <- map["network"]
        links <- map["links"]
        color <- map["color"]
        routes <- map["routes"]
        geojson <- map["geojson"]
        textColor <- map["text_color"]
        physicalModes <- map["physical_modes"]
        codes <- map["codes"]
        comments <- map["comments"]
        closingTime <- map["closing_time"]
        openingTime <- map["opening_time"]
        commercialMode <- map["commercial_mode"]
        id <- map["id"]
        lineGroups <- map["line_groups"]
        name <- map["name"]
    }

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["comment"] = self.comment
        nillableDictionary["properties"] = self.properties?.encodeToJSON()
        nillableDictionary["code"] = self.code
        nillableDictionary["network"] = self.network?.encodeToJSON()
        nillableDictionary["links"] = self.links?.encodeToJSON()
        nillableDictionary["color"] = self.color
        nillableDictionary["routes"] = self.routes?.encodeToJSON()
        nillableDictionary["geojson"] = self.geojson?.encodeToJSON()
        nillableDictionary["text_color"] = self.textColor
        nillableDictionary["physical_modes"] = self.physicalModes?.encodeToJSON()
        nillableDictionary["codes"] = self.codes?.encodeToJSON()
        nillableDictionary["comments"] = self.comments?.encodeToJSON()
        nillableDictionary["closing_time"] = self.closingTime
        nillableDictionary["opening_time"] = self.openingTime
        nillableDictionary["commercial_mode"] = self.commercialMode?.encodeToJSON()
        nillableDictionary["id"] = self.id
        nillableDictionary["line_groups"] = self.lineGroups?.encodeToJSON()
        nillableDictionary["name"] = self.name

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}
