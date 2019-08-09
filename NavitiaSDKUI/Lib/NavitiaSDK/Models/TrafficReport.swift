//
// TrafficReport.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


open class TrafficReport: JSONEncodable, Mappable, Codable {

    public var vehicleJourneys: [VehicleJourney]?
    public var lines: [Line]?
    public var network: Network?
    public var stopAreas: [StopArea]?

    public init() {}
    required public init?(map: Map) {

    }


    enum CodingKeys: String, CodingKey {
        case vehicleJourneys = "vehicle_journeys"
        case lines = "lines"
        case network = "network"
        case stopAreas = "stop_areas"
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(vehicleJourneys, forKey: .vehicleJourneys)
        try container.encode(lines, forKey: .lines)
        try container.encode(network, forKey: .network)
        try container.encode(stopAreas, forKey: .stopAreas)
    }

    public func mapping(map: Map) {
        vehicleJourneys <- map["vehicle_journeys"]
        lines <- map["lines"]
        network <- map["network"]
        stopAreas <- map["stop_areas"]
    }

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["vehicle_journeys"] = self.vehicleJourneys?.encodeToJSON()
        nillableDictionary["lines"] = self.lines?.encodeToJSON()
        nillableDictionary["network"] = self.network?.encodeToJSON()
        nillableDictionary["stop_areas"] = self.stopAreas?.encodeToJSON()

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}
