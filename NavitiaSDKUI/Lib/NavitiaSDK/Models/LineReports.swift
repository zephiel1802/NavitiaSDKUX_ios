//
// LineReports.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


open class LineReports: JSONEncodable, Mappable, Codable {

/** Coding keys for Codable protocol */
    enum CodingKeys: CodingKey {
        case pagination, links, warnings, disruptions, notes, lineReports, feedPublishers, context, error, unknown
    }

    public var pagination: Pagination?
    public var links: [LinkSchema]?
    public var warnings: [BetaEndpoints]?
    public var disruptions: [Disruption]?
    public var notes: [Note]?
    public var lineReports: [LineReport]?
    public var feedPublishers: [FeedPublisher]?
    public var context: Context?
    public var error: ModelError?

    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        pagination = try container.decode(Pagination.self, forKey: .pagination)
        links = try container.decode([LinkSchema].self, forKey: .links)
        warnings = try container.decode([BetaEndpoints].self, forKey: .warnings)
        disruptions = try container.decode([Disruption].self, forKey: .disruptions)
        notes = try container.decode([Note].self, forKey: .notes)
        lineReports = try container.decode([LineReport].self, forKey: .lineReports)
        feedPublishers = try container.decode([FeedPublisher].self, forKey: .feedPublishers)
        context = try container.decode(Context.self, forKey: .context)
        error = try container.decode(ModelError.self, forKey: .error)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(pagination, forKey: .pagination)
        try container.encode(links, forKey: .links)
        try container.encode(warnings, forKey: .warnings)
        try container.encode(disruptions, forKey: .disruptions)
        try container.encode(notes, forKey: .notes)
        try container.encode(lineReports, forKey: .lineReports)
        try container.encode(feedPublishers, forKey: .feedPublishers)
        try container.encode(context, forKey: .context)
        try container.encode(error, forKey: .error)
    }

    public init() {}
    required public init?(map: Map) {

    }


    public func mapping(map: Map) {
        pagination <- map["pagination"]
        links <- map["links"]
        warnings <- map["warnings"]
        disruptions <- map["disruptions"]
        notes <- map["notes"]
        lineReports <- map["line_reports"]
        feedPublishers <- map["feed_publishers"]
        context <- map["context"]
        error <- map["error"]
    }

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["pagination"] = self.pagination?.encodeToJSON()
        nillableDictionary["links"] = self.links?.encodeToJSON()
        nillableDictionary["warnings"] = self.warnings?.encodeToJSON()
        nillableDictionary["disruptions"] = self.disruptions?.encodeToJSON()
        nillableDictionary["notes"] = self.notes?.encodeToJSON()
        nillableDictionary["line_reports"] = self.lineReports?.encodeToJSON()
        nillableDictionary["feed_publishers"] = self.feedPublishers?.encodeToJSON()
        nillableDictionary["context"] = self.context?.encodeToJSON()
        nillableDictionary["error"] = self.error?.encodeToJSON()

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}
