//
// HeatMap1.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


open class HeatMap1: JSONEncodable, Mappable, Codable {

    public var links: [LinkSchema]?
    public var warnings: [BetaEndpoints]?
    public var heatMaps: [HeatMap]?
    public var feedPublishers: [FeedPublisher]?
    public var context: Context?
    public var error: ModelError?


    public init() {}
    required public init?(map: Map) {

    }


    enum CodingKeys: String, CodingKey {
        case links = "links"
        case warnings = "warnings"
        case heatMaps = "heat_maps"
        case feedPublishers = "feed_publishers"
        case context = "context"
        case error = "error"
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(links, forKey: .links)
        try container.encode(warnings, forKey: .warnings)
        try container.encode(heatMaps, forKey: .heatMaps)
        try container.encode(feedPublishers, forKey: .feedPublishers)
        try container.encode(context, forKey: .context)
        try container.encode(error, forKey: .error)
    }

    public func mapping(map: Map) {
        links <- map["links"]
        warnings <- map["warnings"]
        heatMaps <- map["heat_maps"]
        feedPublishers <- map["feed_publishers"]
        context <- map["context"]
        error <- map["error"]
    }

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["links"] = self.links?.encodeToJSON()
        nillableDictionary["warnings"] = self.warnings?.encodeToJSON()
        nillableDictionary["heat_maps"] = self.heatMaps?.encodeToJSON()
        nillableDictionary["feed_publishers"] = self.feedPublishers?.encodeToJSON()
        nillableDictionary["context"] = self.context?.encodeToJSON()
        nillableDictionary["error"] = self.error?.encodeToJSON()

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}
