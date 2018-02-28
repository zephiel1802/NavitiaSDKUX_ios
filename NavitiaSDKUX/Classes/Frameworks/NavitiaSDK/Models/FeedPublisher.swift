//
// FeedPublisher.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation

open class FeedPublisher: JSONEncodable, Mappable {

    public var url: String?
    public var id: String?
    public var license: String?
    public var name: String?

    public init() {}
    required public init?(map: Map) {

    }


    public func mapping(map: Map) {
        url <- map["url"]
        id <- map["id"]
        license <- map["license"]
        name <- map["name"]
    }

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["url"] = self.url
        nillableDictionary["id"] = self.id
        nillableDictionary["license"] = self.license
        nillableDictionary["name"] = self.name

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}
