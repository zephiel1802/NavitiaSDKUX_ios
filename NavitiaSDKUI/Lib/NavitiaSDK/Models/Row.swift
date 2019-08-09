//
// Row.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


open class Row: JSONEncodable, Mappable, Codable {

    public var stopPoint: StopPoint?
    public var dateTimes: [DateTimeType]?

    public init() {}
    required public init?(map: Map) {

    }


    enum CodingKeys: String, CodingKey {
        case stopPoint = "stop_point"
        case dateTimes = "date_times"
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(stopPoint, forKey: .stopPoint)
        try container.encode(dateTimes, forKey: .dateTimes)
    }

    public func mapping(map: Map) {
        stopPoint <- map["stop_point"]
        dateTimes <- map["date_times"]
    }

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["stop_point"] = self.stopPoint?.encodeToJSON()
        nillableDictionary["date_times"] = self.dateTimes?.encodeToJSON()

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}
