//
//  StylizedComponentTests.swift
//  NavitiaSDKUX
//
//  Created by Chakkra CHAK on 24/10/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import XCTest
import Render
import NavitiaSDKUX

class StylizedComponentTests: XCTestCase {
    func testInit() {
        let stylizedComponent = StylizedComponent<NilState>()

        XCTAssertNotNil(stylizedComponent)
    }
}
