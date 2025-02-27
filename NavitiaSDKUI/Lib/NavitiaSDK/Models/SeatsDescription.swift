//
// SeatsDescription.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


open class SeatsDescription: JSONEncodable, Mappable, Codable {

    public var available: Int32?
    public var total: Int32?


    public init() {}
    required public init?(map: Map) {

    }


    enum CodingKeys: String, CodingKey {
        case available = "available"
        case total = "total"
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(available, forKey: .available)
        try container.encode(total, forKey: .total)
    }

    public func mapping(map: Map) {
        available <- map["available"]
        total <- map["total"]
    }

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["available"] = self.available?.encodeToJSON()
        nillableDictionary["total"] = self.total?.encodeToJSON()

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}
