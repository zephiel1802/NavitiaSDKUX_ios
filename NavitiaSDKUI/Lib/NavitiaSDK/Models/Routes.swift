//
// Routes.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


open class Routes: JSONEncodable, Mappable, Codable {

/** Coding keys for Codable protocol */
    enum CodingKeys: CodingKey {
        case pagination, links, disruptions, notes, feedPublishers, context, error, routes, unknown
    }

    public var pagination: Pagination?
    public var links: [LinkSchema]?
    public var disruptions: [Disruption]?
    public var notes: [Note]?
    public var feedPublishers: [FeedPublisher]?
    public var context: Context?
    public var error: ModelError?
    public var routes: [Route]?

    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        pagination = try container.decode(Pagination.self, forKey: .pagination)
        links = try container.decode([LinkSchema].self, forKey: .links)
        disruptions = try container.decode([Disruption].self, forKey: .disruptions)
        notes = try container.decode([Note].self, forKey: .notes)
        feedPublishers = try container.decode([FeedPublisher].self, forKey: .feedPublishers)
        context = try container.decode(Context.self, forKey: .context)
        error = try container.decode(ModelError.self, forKey: .error)
        routes = try container.decode([Route].self, forKey: .routes)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(pagination, forKey: .pagination)
        try container.encode(links, forKey: .links)
        try container.encode(disruptions, forKey: .disruptions)
        try container.encode(notes, forKey: .notes)
        try container.encode(feedPublishers, forKey: .feedPublishers)
        try container.encode(context, forKey: .context)
        try container.encode(error, forKey: .error)
        try container.encode(routes, forKey: .routes)
    }

    public init() {}
    required public init?(map: Map) {

    }


    public func mapping(map: Map) {
        pagination <- map["pagination"]
        links <- map["links"]
        disruptions <- map["disruptions"]
        notes <- map["notes"]
        feedPublishers <- map["feed_publishers"]
        context <- map["context"]
        error <- map["error"]
        routes <- map["routes"]
    }

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["pagination"] = self.pagination?.encodeToJSON()
        nillableDictionary["links"] = self.links?.encodeToJSON()
        nillableDictionary["disruptions"] = self.disruptions?.encodeToJSON()
        nillableDictionary["notes"] = self.notes?.encodeToJSON()
        nillableDictionary["feed_publishers"] = self.feedPublishers?.encodeToJSON()
        nillableDictionary["context"] = self.context?.encodeToJSON()
        nillableDictionary["error"] = self.error?.encodeToJSON()
        nillableDictionary["routes"] = self.routes?.encodeToJSON()

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}
