//
// Contributors.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


open class Contributors: JSONEncodable, Mappable, Codable {

    public var pagination: Pagination?
    public var contributors: [Contributor]?
    public var links: [LinkSchema]?
    public var disruptions: [Disruption]?
    public var notes: [Note]?
    public var feedPublishers: [FeedPublisher]?
    public var context: Context?
    public var error: ModelError?

    public init() {}
    required public init?(map: Map) {

    }


    enum CodingKeys: String, CodingKey {
        case pagination = "pagination"
        case contributors = "contributors"
        case links = "links"
        case disruptions = "disruptions"
        case notes = "notes"
        case feedPublishers = "feed_publishers"
        case context = "context"
        case error = "error"
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(pagination, forKey: .pagination)
        try container.encode(contributors, forKey: .contributors)
        try container.encode(links, forKey: .links)
        try container.encode(disruptions, forKey: .disruptions)
        try container.encode(notes, forKey: .notes)
        try container.encode(feedPublishers, forKey: .feedPublishers)
        try container.encode(context, forKey: .context)
        try container.encode(error, forKey: .error)
    }

    public func mapping(map: Map) {
        pagination <- map["pagination"]
        contributors <- map["contributors"]
        links <- map["links"]
        disruptions <- map["disruptions"]
        notes <- map["notes"]
        feedPublishers <- map["feed_publishers"]
        context <- map["context"]
        error <- map["error"]
    }

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["pagination"] = self.pagination?.encodeToJSON()
        nillableDictionary["contributors"] = self.contributors?.encodeToJSON()
        nillableDictionary["links"] = self.links?.encodeToJSON()
        nillableDictionary["disruptions"] = self.disruptions?.encodeToJSON()
        nillableDictionary["notes"] = self.notes?.encodeToJSON()
        nillableDictionary["feed_publishers"] = self.feedPublishers?.encodeToJSON()
        nillableDictionary["context"] = self.context?.encodeToJSON()
        nillableDictionary["error"] = self.error?.encodeToJSON()

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}
