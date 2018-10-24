//
//  ShowJourneyRoadmapInteractorTests.swift
//  NavitiaSDKUITests
//
//  Copyright © 2018 kisio. All rights reserved.
//

import XCTest
@testable import NavitiaSDKUI

class ShowJourneyRoadmapInteractorTests: XCTestCase {
    
    // MARK: - Subject under test
    
    var sut: ShowJourneyRoadmapInteractor!
    
    override func setUp() {
        super.setUp()
        
        setupShowJourneyRoadmapInteractor()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - Test setup
    
    func setupShowJourneyRoadmapInteractor() {
        sut = ShowJourneyRoadmapInteractor()
    }
    
    // MARK: - Test doubles
    
    class ShowJourneyRoadmapPresentationLogicSpy: ShowJourneyRoadmapPresentationLogic {
        var presentRoadmapCalled = false
        var presentMapCalled = false
        var presentBssCalled = false
        
        func presentRoadmap(response: ShowJourneyRoadmap.GetRoadmap.Response) {
            presentRoadmapCalled = true
        }
        
        func presentMap(response: ShowJourneyRoadmap.GetMap.Response) {
            presentMapCalled = true
        }
        
        func presentBss(response: ShowJourneyRoadmap.FetchBss.Response) {
            presentBssCalled = true
        }
    }
    
    // MARK: - Tests
    
    func testGetRoadmap() {
        let showJourneyRoadmapPresentationLogicSpy = ShowJourneyRoadmapPresentationLogicSpy()
        sut.presenter = showJourneyRoadmapPresentationLogicSpy
        sut.journey = Journey()
        sut.context = Context()
        
        let request = ShowJourneyRoadmap.GetRoadmap.Request()
        sut.getRoadmap(request: request)
        
        XCTAssert(showJourneyRoadmapPresentationLogicSpy.presentRoadmapCalled, "GetRidesharingOffers() should ask presenter to format journeys")
    }
    
    func testGetMap() {
        let showJourneyRoadmapPresentationLogicSpy = ShowJourneyRoadmapPresentationLogicSpy()
        sut.presenter = showJourneyRoadmapPresentationLogicSpy
        sut.journey = Journey()
        sut.context = Context()
        
        let request = ShowJourneyRoadmap.GetMap.Request()
        sut.getMap(request: request)
        
        XCTAssert(showJourneyRoadmapPresentationLogicSpy.presentMapCalled, "GetRidesharingOffers() should ask presenter to format journeys")
    }
}
