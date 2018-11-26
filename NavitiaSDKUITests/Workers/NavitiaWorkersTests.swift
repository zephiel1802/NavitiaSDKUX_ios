//
//  NavitiaWorkersTests.swift
//  NavitiaSDKUITests
//
//  Copyright © 2018 kisio. All rights reserved.
//

import XCTest
@testable import NavitiaSDKUI

class NavitiaWorkersTests: XCTestCase {
    
    var sut: NavitiaWorker!
    
    // MARK: - Test lifecycle
    
    override func setUp() {
        super.setUp()
        
        setupNavitiaWorker()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - Test setup
    
    func setupNavitiaWorker() {
        sut = NavitiaWorker()
    }
    
    class NavitiaWorkerSpy: NavitiaWorker {
        
        var fetchJourneysCalled = false
        var parseJourneyResponseCalled = false
        
        override func fetchJourneys(journeysRequest: JourneysRequest?, completionHandler: @escaping NavitiaFetchJourneysCompletionHandler) {
            let journeys = self.parseJourneyResponse(result: Seeds.init().navitiaResponse!)
            completionHandler(journeys.journeys, journeys.Ridesharing, journeys.disruptions, journeys.notes, journeys.context)
        }
        
        override func parseJourneyResponse(result: Journeys) -> (journeys: [Journey]?, Ridesharing: [Journey]?, disruptions: [Disruption]?, notes: [Note]?, context: Context?) {
            parseJourneyResponseCalled = true
            return super.parseJourneyResponse(result: result)
        }
    }
    
    // MARK: - Tests
    
    func testFetchJourneysShouldReturnResponseNavitia() {
        let navitiaWorkerSpy = NavitiaWorkerSpy()
        
        navitiaWorkerSpy.fetchJourneys(journeysRequest: nil) { (journeys, journeysRidesharing, disruption, notes, context) in
            XCTAssertEqual(journeys?.count, 2)
            XCTAssertEqual(journeysRidesharing?.count, 1)
            XCTAssertNotNil(disruption?.count)
            XCTAssertNotNil(notes?.count)
            XCTAssertNotNil(context)
        }
        
        XCTAssert(navitiaWorkerSpy.parseJourneyResponseCalled, "GetRidesharingOffers() should ask presenter to format journeys")
    }
}
