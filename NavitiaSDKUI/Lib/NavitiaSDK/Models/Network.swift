//
// Network.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


open class Network: JSONEncodable, Mappable, Codable {

    public var codes: [Code]?
    /** Identifier of the object */
    public var id: String?
    public var links: [LinkSchema]?
    /** Name of the object */
    public var name: String?

    public init() {}
    required public init?(map: Map) {

    }


    enum CodingKeys: String, CodingKey {
        case codes = "codes"
        case id = "id"
        case links = "links"
        case name = "name"
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(codes, forKey: .codes)
        try container.encode(id, forKey: .id)
        try container.encode(links, forKey: .links)
        try container.encode(name, forKey: .name)
    }

    public func mapping(map: Map) {
        codes <- map["codes"]
        id <- map["id"]
        links <- map["links"]
        name <- map["name"]
    }

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["codes"] = self.codes?.encodeToJSON()
        nillableDictionary["id"] = self.id
        nillableDictionary["links"] = self.links?.encodeToJSON()
        nillableDictionary["name"] = self.name

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}
