//
// LineReport.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


open class LineReport: JSONEncodable, Mappable, Codable {

    public var line: Line?
    public var ptObjects: [PtObject]?

    public init() {}
    required public init?(map: Map) {

    }


    enum CodingKeys: String, CodingKey {
        case line = "line"
        case ptObjects = "pt_objects"
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(line, forKey: .line)
        try container.encode(ptObjects, forKey: .ptObjects)
    }

    public func mapping(map: Map) {
        line <- map["line"]
        ptObjects <- map["pt_objects"]
    }

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["line"] = self.line?.encodeToJSON()
        nillableDictionary["pt_objects"] = self.ptObjects?.encodeToJSON()

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}
