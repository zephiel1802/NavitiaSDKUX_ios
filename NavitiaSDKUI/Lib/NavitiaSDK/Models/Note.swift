//
// Note.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


open class Note: JSONEncodable, Mappable, Codable {

/** Coding keys for Codable protocol */
    enum CodingKeys: CodingKey {
        case category, type, value, commentType, id, unknown
    }

    public enum Category: String, Codable { 
        case comment = "comment"
        case terminus = "terminus"
    }
    public var category: Category?
    public var type: String?
    public var value: String?
    public var commentType: String?
    public var id: String?

    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        category = try container.decode(Category.self, forKey: .category)
        type = try container.decode(String.self, forKey: .type)
        value = try container.decode(String.self, forKey: .value)
        commentType = try container.decode(String.self, forKey: .commentType)
        id = try container.decode(String.self, forKey: .id)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(category, forKey: .category)
        try container.encode(type, forKey: .type)
        try container.encode(value, forKey: .value)
        try container.encode(commentType, forKey: .commentType)
        try container.encode(id, forKey: .id)
    }

    public init() {}
    required public init?(map: Map) {

    }


    public func mapping(map: Map) {
        category <- map["category"]
        type <- map["type"]
        value <- map["value"]
        commentType <- map["comment_type"]
        id <- map["id"]
    }

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["category"] = self.category?.rawValue
        nillableDictionary["type"] = self.type
        nillableDictionary["value"] = self.value
        nillableDictionary["comment_type"] = self.commentType
        nillableDictionary["id"] = self.id

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}
