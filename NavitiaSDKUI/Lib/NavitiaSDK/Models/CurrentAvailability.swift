//
// CurrentAvailability.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


open class CurrentAvailability: JSONEncodable, Mappable, Codable {

    public enum Status: String, Codable { 
        case unknown = "unknown"
        case available = "available"
        case unavailable = "unavailable"
    }
    public var status: Status?
    public var effect: Effect?
    public var cause: Cause?
    public var periods: [Period]?
    public var updatedAt: String?


    public init() {}
    required public init?(map: Map) {

    }


    enum CodingKeys: String, CodingKey {
        case status = "status"
        case effect = "effect"
        case cause = "cause"
        case periods = "periods"
        case updatedAt = "updated_at"
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(status, forKey: .status)
        try container.encode(effect, forKey: .effect)
        try container.encode(cause, forKey: .cause)
        try container.encode(periods, forKey: .periods)
        try container.encode(updatedAt, forKey: .updatedAt)
    }

    public func mapping(map: Map) {
        status <- map["status"]
        effect <- map["effect"]
        cause <- map["cause"]
        periods <- map["periods"]
        updatedAt <- map["updated_at"]
    }

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["status"] = self.status?.rawValue
        nillableDictionary["effect"] = self.effect?.encodeToJSON()
        nillableDictionary["cause"] = self.cause?.encodeToJSON()
        nillableDictionary["periods"] = self.periods?.encodeToJSON()
        nillableDictionary["updated_at"] = self.updatedAt

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}
