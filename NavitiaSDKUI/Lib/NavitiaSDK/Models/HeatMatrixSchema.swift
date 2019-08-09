//
// HeatMatrixSchema.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


open class HeatMatrixSchema: JSONEncodable, Mappable, Codable {

    public var lineHeaders: [LineHeadersSchema]?
    public var lines: [LinesSchema]?

    public init() {}
    required public init?(map: Map) {

    }


    enum CodingKeys: String, CodingKey {
        case lineHeaders = "line_headers"
        case lines = "lines"
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(lineHeaders, forKey: .lineHeaders)
        try container.encode(lines, forKey: .lines)
    }

    public func mapping(map: Map) {
        lineHeaders <- map["line_headers"]
        lines <- map["lines"]
    }

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["line_headers"] = self.lineHeaders?.encodeToJSON()
        nillableDictionary["lines"] = self.lines?.encodeToJSON()

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}
