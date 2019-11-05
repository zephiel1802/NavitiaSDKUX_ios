//
// Amount.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


open class Amount: JSONEncodable, Mappable, Codable {

    public var value: Float?
    public var unit: String?


    public init() {}
    required public init?(map: Map) {

    }


    enum CodingKeys: String, CodingKey {
        case value = "value"
        case unit = "unit"
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(value, forKey: .value)
        try container.encode(unit, forKey: .unit)
    }

    public func mapping(map: Map) {
        value <- map["value"]
        unit <- map["unit"]
    }

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["value"] = self.value
        nillableDictionary["unit"] = self.unit

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}
