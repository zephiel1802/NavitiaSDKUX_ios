//
//  ListJourneysInteractorTests.swift
//  NavitiaSDKUITests
//
//  Copyright © 2018 kisio. All rights reserved.
//

import XCTest
@testable import NavitiaSDKUI

class ListJourneysInteractorTests: XCTestCase {
    
    // MARK: - Subject under test
    
    var sut: ListJourneysInteractor!
    
    override func setUp() {
        super.setUp()
        
        setupListJourneysInteractor()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - Test setup
    
    func setupListJourneysInteractor() {
        sut = ListJourneysInteractor()
    }
    
    // MARK: - Test doubles
    
    class ListJourneysPresentationLogicSpy: ListJourneysPresentationLogic {
        
        var presentFetchedSearchInformationCalled = false
        var presentFetchedJourneysCalled = false
        var presentDisplayedSearchCalled =  false
        var presentFetchedPhysicalModesCalled = false
        
        func presentFetchedSearchInformation(journeysRequest: JourneysRequest) {
            presentFetchedSearchInformationCalled = true
        }
        
        func presentFetchedJourneys(response: ListJourneys.FetchJourneys.Response) {
            presentFetchedJourneysCalled = true
        }
        
        func presentDisplayedSearch(response: ListJourneys.DisplaySearch.Response) {
            presentDisplayedSearchCalled = true
        }
        
        func presentFetchedPhysicalModes(response: ListJourneys.FetchPhysicalModes.Response) {
            presentFetchedPhysicalModesCalled = true
        }
    }
    
    class NavitiaWorkerSpy: NavitiaWorker {
        var fetchJourneysCalled = false
        
        override func fetchJourneys(journeysRequest: JourneysRequest, completionHandler: @escaping ([Journey]?, [Journey]?, [Disruption]?, [Note]?, Context?) -> Void) {
            fetchJourneysCalled = true
            completionHandler([], [], [], [], nil)
        }
    }
    
    // MARK: - Tests
    
    func testFetchJourneysShouldAskNavitiaWorkerToFetchJourneysAndPresenterToFormatResult() {
        let listJourneysPresentationLogicSpy = ListJourneysPresentationLogicSpy()
        let navitiaWorkerSpy = NavitiaWorkerSpy()
        sut.presenter = listJourneysPresentationLogicSpy
        sut.navitiaWorker = navitiaWorkerSpy
        
        let request = ListJourneys.FetchJourneys.Request(journeysRequest: JourneysRequest(coverage: ""))
        sut.fetchJourneys(request: request)
        
        XCTAssert(navitiaWorkerSpy.fetchJourneysCalled, "FetchJourneys() should ask NavitiaWorker to fetch journeys")
        XCTAssert(listJourneysPresentationLogicSpy.presentFetchedJourneysCalled, "FetchJourneys() should ask presenter to format journeys result")
        XCTAssert(listJourneysPresentationLogicSpy.presentFetchedSearchInformationCalled, "FetchJourneys() should ask presenter to format header result")
    }
}
