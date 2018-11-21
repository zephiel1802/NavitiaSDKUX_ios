//
//  JourneysRequest.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import Foundation

public struct JourneysRequest {
    
    public var originId: String
    public var originLabel: String?
    public var destinationId: String
    public var destinationLabel: String?
    public var datetime: Date?
    public var datetimeRepresents: JourneysRequestBuilder.DatetimeRepresents?
    public var forbiddenUris: [String]?
    public var allowedId: [String]?
    public var firstSectionModes: [JourneysRequestBuilder.FirstSectionMode]?
    public var lastSectionModes: [JourneysRequestBuilder.LastSectionMode]?
    public var count: Int32?
    public var minNbJourneys: Int32?
    public var maxNbJourneys: Int32?
    public var bssStands: Bool?
    public var directPath: JourneysRequestBuilder.DirectPath?
    public var addPoiInfos: [JourneysRequestBuilder.AddPoiInfos]?
    public var debugURL: String?
    
    public init(originId: String, destinationId: String) {
        self.originId = originId
        self.destinationId = destinationId
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
