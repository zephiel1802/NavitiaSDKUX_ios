//
// Coverage.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


open class Coverage: JSONEncodable, Mappable, Codable {

    public var status: String?
    /** Creation date of the dataset */
    public var datasetCreatedAt: String?
    /** Name of the coverage */
    public var name: String?
    /** Beginning of the production period. We only have data on this production period */
    public var startProductionDate: String?
    /** GeoJSON of the shape of the coverage */
    public var shape: String?
    /** End of the production period. We only have data on this production period */
    public var endProductionDate: String?
    public var error: CoverageError?
    /** Datetime of the last data loading */
    public var lastLoadAt: String?
    /** Identifier of the coverage */
    public var id: String?

    public init() {}
    required public init?(map: Map) {

    }


    enum CodingKeys: String, CodingKey {
        case status = "status"
        case datasetCreatedAt = "dataset_created_at"
        case name = "name"
        case startProductionDate = "start_production_date"
        case shape = "shape"
        case endProductionDate = "end_production_date"
        case error = "error"
        case lastLoadAt = "last_load_at"
        case id = "id"
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(status, forKey: .status)
        try container.encode(datasetCreatedAt, forKey: .datasetCreatedAt)
        try container.encode(name, forKey: .name)
        try container.encode(startProductionDate, forKey: .startProductionDate)
        try container.encode(shape, forKey: .shape)
        try container.encode(endProductionDate, forKey: .endProductionDate)
        try container.encode(error, forKey: .error)
        try container.encode(lastLoadAt, forKey: .lastLoadAt)
        try container.encode(id, forKey: .id)
    }

    public func mapping(map: Map) {
        status <- map["status"]
        datasetCreatedAt <- map["dataset_created_at"]
        name <- map["name"]
        startProductionDate <- map["start_production_date"]
        shape <- map["shape"]
        endProductionDate <- map["end_production_date"]
        error <- map["error"]
        lastLoadAt <- map["last_load_at"]
        id <- map["id"]
    }

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["status"] = self.status
        nillableDictionary["dataset_created_at"] = self.datasetCreatedAt
        nillableDictionary["name"] = self.name
        nillableDictionary["start_production_date"] = self.startProductionDate
        nillableDictionary["shape"] = self.shape
        nillableDictionary["end_production_date"] = self.endProductionDate
        nillableDictionary["error"] = self.error?.encodeToJSON()
        nillableDictionary["last_load_at"] = self.lastLoadAt
        nillableDictionary["id"] = self.id

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}
