//
// LineReport.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation

open class LineReport: JSONEncodable, Mappable {

    public var line: Line?
    public var ptObjects: [PtObject]?

    public init() {}
    required public init?(map: Map) {

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
