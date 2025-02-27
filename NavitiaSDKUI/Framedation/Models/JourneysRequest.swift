//
//  JourneysRequest.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import Foundation

@objc public class JourneysRequest: NSObject {
    
    public enum TravelerType: String {
        case luggage = "luggage"
        case wheelchair = "wheelchair"
        case standard = "standard"
        case fast_walker = "fast_walker"
        case slow_walker = "slow_walker"
        
        func stringValue() -> String {
            return self.rawValue.lowercased()
        }
    }
    
    public enum Speed: Double {
        case slow = 0.66
        case medium = 1.12
        case fast = 1.78
        
        func doubleValue() -> Double {
            return self.rawValue
        }
    }
    
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
    public var travelerType: TravelerType?
    public var directPathMode: [CoverageRegionJourneysRequestBuilder.DirectPathMode]? {
        get {
            return getDirectPathMode()
        }
    }
    
    public init(coverage: String) {
        self.coverage = coverage
    }
    
    private func getDirectPathMode() -> [CoverageRegionJourneysRequestBuilder.DirectPathMode] {
        var directPathModeList:[CoverageRegionJourneysRequestBuilder.DirectPathMode] = [.walking]
        let physicalModeList = allowedPhysicalModes ?? []
        let firstSectionModeList = firstSectionModes ?? []
        let lastSectionModeList = lastSectionModes ?? []
        
        let taxiValue = CoverageLonLatJourneysRequestBuilder.DirectPathMode.taxi.rawValue
        if physicalModeList.contains(where: { item -> Bool in
            return item.lowercased().contains(taxiValue)
        }) || firstSectionModeList.contains(where: { item -> Bool in
            return item.rawValue == taxiValue
        }) || lastSectionModeList.contains(where: { item -> Bool in
            return item.rawValue == taxiValue
        }) {
            directPathModeList.append(.taxi)
        }
        
        let bikeValue = CoverageLonLatJourneysRequestBuilder.DirectPathMode.bike.rawValue
        if firstSectionModeList.contains(where: { item -> Bool in
            return item.rawValue == bikeValue
        }) || lastSectionModeList.contains(where: { item -> Bool in
            return item.rawValue == bikeValue
        }) {
            directPathModeList.append(.bike)
        }
        
        return directPathModeList
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
