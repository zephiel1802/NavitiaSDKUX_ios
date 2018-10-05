//
//  ListJourneysInteractorTests.swift
//  NavitiaSDKUITests
//
//  Copyright © 2018 kisio. All rights reserved.
//

import XCTest
@testable import NavitiaSDKUI

class ListJourneysInteractorTests: XCTestCase {
    
    let originId = "2.3665844;48.8465337"
    let destinationId = "2.2979169;48.8848719"
    
    override func setUp() {
        super.setUp()
        
        NavitiaSDKUI.shared.initialize(token: "")
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testResquetNavitia() {
        var request = ListJourneys.FetchJourneys.Request.init(journeysRequest: JourneysRequest(originId: originId, destinationId: destinationId))
        NavitiaWorker().fetchJourneys(journeysRequest: request.journeysRequest) { (journeys, ridesharings, disruptions) in
            XCTAssert(false)
        }
        
    }
}
