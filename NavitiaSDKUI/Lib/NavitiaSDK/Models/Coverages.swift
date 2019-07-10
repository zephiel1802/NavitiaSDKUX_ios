//
// Coverages.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


open class Coverages: JSONEncodable, Mappable, Codable {

    public var regions: [Coverage]?
    public var links: [LinkSchema]?
    public var context: Context?

    public init() {}
    required public init?(map: Map) {

    }


    enum CodingKeys: String, CodingKey {
        case regions = "regions"
        case links = "links"
        case context = "context"
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(regions, forKey: .regions)
        try container.encode(links, forKey: .links)
        try container.encode(context, forKey: .context)
    }

    public func mapping(map: Map) {
        regions <- map["regions"]
        links <- map["links"]
        context <- map["context"]
    }

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["regions"] = self.regions?.encodeToJSON()
        nillableDictionary["links"] = self.links?.encodeToJSON()
        nillableDictionary["context"] = self.context?.encodeToJSON()

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}
