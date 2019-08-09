//
// StopSchedules.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


open class StopSchedules: JSONEncodable, Mappable, Codable {

    public var stopSchedules: [StopSchedule]?
    public var pagination: Pagination?
    public var links: [LinkSchema]?
    public var disruptions: [Disruption]?
    public var notes: [Note]?
    public var feedPublishers: [FeedPublisher]?
    public var context: Context?
    public var error: ModelError?
    public var exceptions: [Exception]?

    public init() {}
    required public init?(map: Map) {

    }


    enum CodingKeys: String, CodingKey {
        case stopSchedules = "stop_schedules"
        case pagination = "pagination"
        case links = "links"
        case disruptions = "disruptions"
        case notes = "notes"
        case feedPublishers = "feed_publishers"
        case context = "context"
        case error = "error"
        case exceptions = "exceptions"
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(stopSchedules, forKey: .stopSchedules)
        try container.encode(pagination, forKey: .pagination)
        try container.encode(links, forKey: .links)
        try container.encode(disruptions, forKey: .disruptions)
        try container.encode(notes, forKey: .notes)
        try container.encode(feedPublishers, forKey: .feedPublishers)
        try container.encode(context, forKey: .context)
        try container.encode(error, forKey: .error)
        try container.encode(exceptions, forKey: .exceptions)
    }

    public func mapping(map: Map) {
        stopSchedules <- map["stop_schedules"]
        pagination <- map["pagination"]
        links <- map["links"]
        disruptions <- map["disruptions"]
        notes <- map["notes"]
        feedPublishers <- map["feed_publishers"]
        context <- map["context"]
        error <- map["error"]
        exceptions <- map["exceptions"]
    }

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["stop_schedules"] = self.stopSchedules?.encodeToJSON()
        nillableDictionary["pagination"] = self.pagination?.encodeToJSON()
        nillableDictionary["links"] = self.links?.encodeToJSON()
        nillableDictionary["disruptions"] = self.disruptions?.encodeToJSON()
        nillableDictionary["notes"] = self.notes?.encodeToJSON()
        nillableDictionary["feed_publishers"] = self.feedPublishers?.encodeToJSON()
        nillableDictionary["context"] = self.context?.encodeToJSON()
        nillableDictionary["error"] = self.error?.encodeToJSON()
        nillableDictionary["exceptions"] = self.exceptions?.encodeToJSON()

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}
