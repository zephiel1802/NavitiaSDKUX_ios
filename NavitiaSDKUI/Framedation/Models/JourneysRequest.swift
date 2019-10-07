//
//  JourneysRequest.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import Foundation

@objc public class JourneysRequest: NSObject {
    
    public var coverage: String
    public var originId: String?
    public var originLabel: String?
    public var originName: String?
    public var destinationId: String?
    public var destinationLabel: String?
    public var destinationName: String?
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
            if let firstSectionModes = self.firstSectionModes, let _ = firstSectionModes.firstIndex(where: { $0 == .ridesharing }) {
                return true
            }
            
            if let lastSectionModes = self.lastSectionModes, let _ = lastSectionModes.firstIndex(where: { $0 == .ridesharing }) {
                return true
            }
            
            return false
        }
    }
    
    func switchOriginDestination() {
        let oldOriginId = originId
        let oldOriginLabel = originLabel
        let oldOriginName = originName
        
        originId = destinationId
        originLabel = destinationLabel
        originName = destinationName
        destinationId = oldOriginId
        destinationLabel = oldOriginLabel
        destinationName = oldOriginName
    }
}
