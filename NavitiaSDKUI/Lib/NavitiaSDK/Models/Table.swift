//
// Table.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


open class Table: JSONEncodable, Mappable, Codable {

/** Coding keys for Codable protocol */
    enum CodingKeys: CodingKey {
        case headers, rows, unknown
    }

    public var headers: [Header]?
    public var rows: [Row]?

    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        headers = try container.decode([Header].self, forKey: .headers)
        rows = try container.decode([Row].self, forKey: .rows)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(headers, forKey: .headers)
        try container.encode(rows, forKey: .rows)
    }

    public init() {}
    required public init?(map: Map) {

    }


    public func mapping(map: Map) {
        headers <- map["headers"]
        rows <- map["rows"]
    }

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["headers"] = self.headers?.encodeToJSON()
        nillableDictionary["rows"] = self.rows?.encodeToJSON()

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}
