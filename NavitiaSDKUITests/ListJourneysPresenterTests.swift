//
//  ListJourneysPresenterTests.swift
//  NavitiaSDKUITests
//
//  Created by Flavien Sicard on 03/09/2018.
//  Copyright © 2018 kisio. All rights reserved.
//

import XCTest
@testable import NavitiaSDKUI

class ListJourneysPresenterTests: XCTestCase {
    
    let originId = "2.3665844;48.8465337"
    let destinationId = "2.2979169;48.8848719"
    
    let dateTime = Date(timeIntervalSince1970: 1535980251)
    let dateTimeFormatted = "Departure : Mon 03 Sep - 13:10"
    
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
    
    func testHeaderInformationsLoading() {
        var journeysRequest = JourneysRequest(originId: originId, destinationId: destinationId)
        journeysRequest.datetime = dateTime
        
        let headerInformations = ListJourneysPresenter().getDisplayedHeaderInformations(journeysRequest: journeysRequest)
        testOrigin(origin: headerInformations?.origin)
        testDestination(destination: headerInformations?.destination)
        testDateTime(dateTime: headerInformations?.dateTime)
    }
    
    func testOrigin(origin: NSMutableAttributedString?) {
        let expectedResult = NSMutableAttributedString().bold(originId, color: UIColor(red: 64/255, green: 64/255, blue: 64/255, alpha: 1.0), size: 11)

        guard let origin = origin else {
            return XCTAssert(false)
        }
        XCTAssertTrue(expectedResult.isEqual(to: origin), "Origin attributed string")
    }
    
    func testDestination(destination: NSMutableAttributedString?) {
        let expectedResult = NSMutableAttributedString().bold(destinationId, color: UIColor(red: 64/255, green: 64/255, blue: 64/255, alpha: 1.0), size: 11)
        
        guard let destination = destination else {
            return XCTAssert(false)
        }
        XCTAssertTrue(expectedResult.isEqual(to: destination), "Destination attributed string")
    }
    
    func testDateTime(dateTime: NSMutableAttributedString?) {
        let expectedResult = NSMutableAttributedString().bold(dateTimeFormatted, color: Configuration.Color.white, size: 12)
        
        guard let dateTime = dateTime else {
            return XCTAssert(false)
        }
        XCTAssertTrue(expectedResult.isEqual(to: dateTime), "Date time attributed string")
    }
    
}
