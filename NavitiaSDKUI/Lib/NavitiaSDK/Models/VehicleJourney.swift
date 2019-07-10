//
// VehicleJourney.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


open class VehicleJourney: JSONEncodable, Mappable, Codable {

    public var comment: String?
    public var codes: [Code]?
    /** Name of the object */
    public var name: String?
    public var journeyPattern: JourneyPattern?
    public var disruptions: [LinkSchema]?
    public var calendars: [Calendar]?
    public var stopTimes: [StopTime]?
    public var comments: [Comment]?
    public var validityPattern: ValidityPattern?
    /** Identifier of the object */
    public var id: String?
    public var trip: Trip?

    public init() {}
    required public init?(map: Map) {

    }


    enum CodingKeys: String, CodingKey {
        case comment = "comment"
        case codes = "codes"
        case name = "name"
        case journeyPattern = "journey_pattern"
        case disruptions = "disruptions"
        case calendars = "calendars"
        case stopTimes = "stop_times"
        case comments = "comments"
        case validityPattern = "validity_pattern"
        case id = "id"
        case trip = "trip"
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(comment, forKey: .comment)
        try container.encode(codes, forKey: .codes)
        try container.encode(name, forKey: .name)
        try container.encode(journeyPattern, forKey: .journeyPattern)
        try container.encode(disruptions, forKey: .disruptions)
        try container.encode(calendars, forKey: .calendars)
        try container.encode(stopTimes, forKey: .stopTimes)
        try container.encode(comments, forKey: .comments)
        try container.encode(validityPattern, forKey: .validityPattern)
        try container.encode(id, forKey: .id)
        try container.encode(trip, forKey: .trip)
    }

    public func mapping(map: Map) {
        comment <- map["comment"]
        codes <- map["codes"]
        name <- map["name"]
        journeyPattern <- map["journey_pattern"]
        disruptions <- map["disruptions"]
        calendars <- map["calendars"]
        stopTimes <- map["stop_times"]
        comments <- map["comments"]
        validityPattern <- map["validity_pattern"]
        id <- map["id"]
        trip <- map["trip"]
    }

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["comment"] = self.comment
        nillableDictionary["codes"] = self.codes?.encodeToJSON()
        nillableDictionary["name"] = self.name
        nillableDictionary["journey_pattern"] = self.journeyPattern?.encodeToJSON()
        nillableDictionary["disruptions"] = self.disruptions?.encodeToJSON()
        nillableDictionary["calendars"] = self.calendars?.encodeToJSON()
        nillableDictionary["stop_times"] = self.stopTimes?.encodeToJSON()
        nillableDictionary["comments"] = self.comments?.encodeToJSON()
        nillableDictionary["validity_pattern"] = self.validityPattern?.encodeToJSON()
        nillableDictionary["id"] = self.id
        nillableDictionary["trip"] = self.trip?.encodeToJSON()

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}
