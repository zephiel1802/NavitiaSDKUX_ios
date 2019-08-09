//
// CalendarException.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


open class CalendarException: JSONEncodable, Mappable, Codable {

    public var type: String?
    public var datetime: String?

    public init() {}
    required public init?(map: Map) {

    }


    enum CodingKeys: String, CodingKey {
        case type = "type"
        case datetime = "datetime"
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
        try container.encode(datetime, forKey: .datetime)
    }

    public func mapping(map: Map) {
        type <- map["type"]
        datetime <- map["datetime"]
    }

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["type"] = self.type
        nillableDictionary["datetime"] = self.datetime

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}
