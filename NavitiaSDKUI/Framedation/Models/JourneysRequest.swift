//
//  JourneysRequest.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import Foundation

public struct JourneysRequest {
    
    public var coverage: String
    public var originId: String?
    public var originLabel: String?
    public var originAddress: String?
    public var destinationId: String?
    public var destinationLabel: String?
    public var destinationAddress: String?
    public var datetime: Date?
    public var datetimeRepresents: CoverageRegionJourneysRequestBuilder.DatetimeRepresents?
    public var forbiddenUris: [String]?
    public var allowedId: [String]?
    public var firstSectionModes: [CoverageRegionJourneysRequestBuilder.FirstSectionMode]?
    public var lastSectionModes: [CoverageRegionJourneysRequestBuilder.LastSectionMode]?
    public var count: Int32?
    public var minNbJourneys: Int32?
    public var maxNbJourneys: Int32?
    public var bssStands: Bool?
    public var directPath: CoverageRegionJourneysRequestBuilder.DirectPath?
    public var addPoiInfos: [CoverageRegionJourneysRequestBuilder.AddPoiInfos]?
    public var dataFreshness: CoverageRegionJourneysRequestBuilder.DataFreshness?
    public var allowedPhysicalModes: [String]?
    public var debugURL: String?
    
    public init(coverage: String) {
        self.coverage = coverage
    }
}

extension JourneysRequest {
    
    var ridesharingIsActive: Bool {
        get {
            if let firstSectionModes = self.firstSectionModes, let _ = firstSectionModes.index(where: { $0 == .ridesharing }) {
                return true
            }
            
            if let lastSectionModes = self.lastSectionModes, let _ = lastSectionModes.index(where: { $0 == .ridesharing }) {
                return true
            }
            
            return false
        }
    }
    
    mutating func switchOriginDestination() {
        let oldOriginId = originId
        let oldOriginLabel = originLabel
        
        originId = destinationId
        originLabel = destinationLabel
        destinationId = oldOriginId
        destinationLabel = oldOriginLabel
    }
}
