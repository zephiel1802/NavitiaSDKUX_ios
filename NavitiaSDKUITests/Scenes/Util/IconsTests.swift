//
//  IconsTests.swift
//  NavitiaSDKUITests
//
//  Copyright © 2018 kisio. All rights reserved.
//

import XCTest
@testable import NavitiaSDKUI

class IconsTests: XCTestCase {
    
    let unknownIconString = "\u{ffff}"
    let walkingIconString = "\u{ea25}"
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // Mode Icon
    func testModeIconNameEmpty() {
        XCTAssertEqual(Icon("").iconFontCode, unknownIconString)
    }
    
    func testModeIconNameUnknown() {
        XCTAssertEqual(Icon("toto").iconFontCode, unknownIconString)
    }
    
    func testModeIconNameWalking() {
        XCTAssertEqual(Icon("walking").iconFontCode, walkingIconString)
    }
    
    // DisruptionIcon
    func testDisruptionLevelIconUnknown() {
        XCTAssertEqual(Disruption().levelImage(name:"toto"), nil)
    }
    
    func testDisruptionColorUnknown() {
        XCTAssertEqual(Disruption.levelColor(of: .none), "000000")
    }
    
    func testDisruptionColorInformation() {
        XCTAssertEqual(Disruption.levelColor(of: .information), "43B77A")
    }
    
    func testDisruptionColorNonblocking() {
        XCTAssertEqual(Disruption.levelColor(of: .nonblocking), "EF662F")
    }
    
    func testDisruptionColorBlocking() {
        XCTAssertEqual(Disruption.levelColor(of: .blocking), "FF0000")
    }
}
