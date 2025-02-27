//
// Context.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


open class Context: JSONEncodable, Mappable, Codable {

    /** Timezone of any datetime in the response, default value Africa/Abidjan (UTC) */
    public var timezone: String?
    /** The datetime of the request (considered as \&quot;now\&quot;) */
    public var currentDatetime: String?
    public var carDirectPath: CO2?


    public init() {}
    required public init?(map: Map) {

    }


    enum CodingKeys: String, CodingKey {
        case timezone = "timezone"
        case currentDatetime = "current_datetime"
        case carDirectPath = "car_direct_path"
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(timezone, forKey: .timezone)
        try container.encode(currentDatetime, forKey: .currentDatetime)
        try container.encode(carDirectPath, forKey: .carDirectPath)
    }

    public func mapping(map: Map) {
        timezone <- map["timezone"]
        currentDatetime <- map["current_datetime"]
        carDirectPath <- map["car_direct_path"]
    }

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["timezone"] = self.timezone
        nillableDictionary["current_datetime"] = self.currentDatetime
        nillableDictionary["car_direct_path"] = self.carDirectPath?.encodeToJSON()

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}
