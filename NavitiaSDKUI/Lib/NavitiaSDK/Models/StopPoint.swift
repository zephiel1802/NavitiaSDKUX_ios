//
// StopPoint.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


open class StopPoint: JSONEncodable, Mappable, Codable {

    public enum Equipments: String, Codable { 
        case wheelchairAccessibility = "has_wheelchair_accessibility"
        case bikeAccepted = "has_bike_accepted"
        case airConditioned = "has_air_conditioned"
        case visualAnnouncement = "has_visual_announcement"
        case audibleAnnouncement = "has_audible_announcement"
        case appropriateEscort = "has_appropriate_escort"
        case appropriateSignage = "has_appropriate_signage"
        case schoolVehicle = "has_school_vehicle"
        case wheelchairBoarding = "has_wheelchair_boarding"
        case sheltered = "has_sheltered"
        case elevator = "has_elevator"
        case escalator = "has_escalator"
        case bikeDepot = "has_bike_depot"
    }
    public var comment: String?
    public var commercialModes: [CommercialMode]?
    public var stopArea: StopArea?
    public var links: [LinkSchema]?
    public var administrativeRegions: [Admin]?
    public var physicalModes: [PhysicalMode]?
    public var comments: [Comment]?
    public var label: String?
    public var equipments: [Equipments]?
    public var codes: [Code]?
    public var coord: Coord?
    public var equipmentDetails: [EquipmentDetails]?
    public var address: Address?
    public var fareZone: FareZone?
    /** Identifier of the object */
    public var id: String?
    /** Name of the object */
    public var name: String?


    public init() {}
    required public init?(map: Map) {

    }


    enum CodingKeys: String, CodingKey {
        case comment = "comment"
        case commercialModes = "commercial_modes"
        case stopArea = "stop_area"
        case links = "links"
        case administrativeRegions = "administrative_regions"
        case physicalModes = "physical_modes"
        case comments = "comments"
        case label = "label"
        case equipments = "equipments"
        case codes = "codes"
        case coord = "coord"
        case equipmentDetails = "equipment_details"
        case address = "address"
        case fareZone = "fare_zone"
        case id = "id"
        case name = "name"
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(comment, forKey: .comment)
        try container.encode(commercialModes, forKey: .commercialModes)
        try container.encode(stopArea, forKey: .stopArea)
        try container.encode(links, forKey: .links)
        try container.encode(administrativeRegions, forKey: .administrativeRegions)
        try container.encode(physicalModes, forKey: .physicalModes)
        try container.encode(comments, forKey: .comments)
        try container.encode(label, forKey: .label)
        try container.encode(equipments, forKey: .equipments)
        try container.encode(codes, forKey: .codes)
        try container.encode(coord, forKey: .coord)
        try container.encode(equipmentDetails, forKey: .equipmentDetails)
        try container.encode(address, forKey: .address)
        try container.encode(fareZone, forKey: .fareZone)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
    }

    public func mapping(map: Map) {
        comment <- map["comment"]
        commercialModes <- map["commercial_modes"]
        stopArea <- map["stop_area"]
        links <- map["links"]
        administrativeRegions <- map["administrative_regions"]
        physicalModes <- map["physical_modes"]
        comments <- map["comments"]
        label <- map["label"]
        equipments <- map["equipments"]
        codes <- map["codes"]
        coord <- map["coord"]
        equipmentDetails <- map["equipment_details"]
        address <- map["address"]
        fareZone <- map["fare_zone"]
        id <- map["id"]
        name <- map["name"]
    }

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["comment"] = self.comment
        nillableDictionary["commercial_modes"] = self.commercialModes?.encodeToJSON()
        nillableDictionary["stop_area"] = self.stopArea?.encodeToJSON()
        nillableDictionary["links"] = self.links?.encodeToJSON()
        nillableDictionary["administrative_regions"] = self.administrativeRegions?.encodeToJSON()
        nillableDictionary["physical_modes"] = self.physicalModes?.encodeToJSON()
        nillableDictionary["comments"] = self.comments?.encodeToJSON()
        nillableDictionary["label"] = self.label
        nillableDictionary["equipments"] = self.equipments?.map({$0.rawValue}).encodeToJSON()
        nillableDictionary["codes"] = self.codes?.encodeToJSON()
        nillableDictionary["coord"] = self.coord?.encodeToJSON()
        nillableDictionary["equipment_details"] = self.equipmentDetails?.encodeToJSON()
        nillableDictionary["address"] = self.address?.encodeToJSON()
        nillableDictionary["fare_zone"] = self.fareZone?.encodeToJSON()
        nillableDictionary["id"] = self.id
        nillableDictionary["name"] = self.name

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}
