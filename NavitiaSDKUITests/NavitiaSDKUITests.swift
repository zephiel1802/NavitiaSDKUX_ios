//
//  NavitiaSDKUITests.swift
//  NavitiaSDKUITests
//
//  Copyright © 2018 kisio. All rights reserved.
//

import XCTest
@testable import NavitiaSDKUI

class NavitiaSDKUITests: XCTestCase {
    
    override func setUp() {
        super.setUp()

        NavitiaSDKUI.shared.bundle = Bundle(identifier: "org.kisio.NavitiaSDKUI")
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
    
    func test1() {
        var resquet = ListJourneys.FetchJourneys.Request.init(journeysRequest: JourneysRequest(originId: "12", destinationId: "13"))
        
        if resquet.journeysRequest.originId == "12" && resquet.journeysRequest.destinationId == "12" {
            XCTAssert(true)
        } else {
            XCTAssert(false)
        }
    }
    
}
