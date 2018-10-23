//
//  JourneyRoadmapRouter.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//


import UIKit

@objc protocol ShowJourneyRoadmapRoutingLogic {}

protocol ShowJourneyRoadmapDataPassing {
    
    var dataStore: ShowJourneyRoadmapDataStore? { get }
}

class ShowJourneyRoadmapRouter: NSObject, ShowJourneyRoadmapRoutingLogic, ShowJourneyRoadmapDataPassing {
    
    weak var viewController: ShowJourneyRoadmapViewController?
    var dataStore: ShowJourneyRoadmapDataStore?
}
