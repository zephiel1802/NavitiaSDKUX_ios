//
// Channel.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


open class Channel: JSONEncodable, Mappable, Codable {

/** Coding keys for Codable protocol */
    enum CodingKeys: CodingKey {
        case contentType, id, types, name, unknown
    }

    public enum Types: String, Codable { 
        case web = "web"
        case sms = "sms"
        case email = "email"
        case mobile = "mobile"
        case notification = "notification"
        case twitter = "twitter"
        case facebook = "facebook"
        case unknownType = "unknown_type"
        case title = "title"
        case beacon = "beacon"
    }
    public var contentType: String?
    public var id: String?
    public var types: [Types]?
    public var name: String?

    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        contentType = try container.decode(String.self, forKey: .contentType)
        id = try container.decode(String.self, forKey: .id)
        types = try container.decode([Types].self, forKey: .types)
        name = try container.decode(String.self, forKey: .name)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(contentType, forKey: .contentType)
        try container.encode(id, forKey: .id)
        try container.encode(types, forKey: .types)
        try container.encode(name, forKey: .name)
    }

    public init() {}
    required public init?(map: Map) {

    }


    public func mapping(map: Map) {
        contentType <- map["content_type"]
        id <- map["id"]
        types <- map["types"]
        name <- map["name"]
    }

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["content_type"] = self.contentType
        nillableDictionary["id"] = self.id
        nillableDictionary["types"] = self.types?.map({$0.rawValue}).encodeToJSON()
        nillableDictionary["name"] = self.name

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}
