//
//  PeriodTests.swift
//  NavitiaSDKUX
//
//  Created by Chakkra CHAK on 10/11/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import XCTest
import NavitiaSDK
import NavitiaSDKUX

class PeriodTests: XCTestCase {
    func testExtensionDate() {
        var period: Period = Period()
        period.begin = "20170928T140500"
        period.end = "20171201T194459"

        XCTAssertNotNil(period.beginDate)
        XCTAssertNotNil(period.endDate)

        XCTAssertEqual(period.beginDate!.description(with: Locale(identifier: "fr_FR")), "jeudi 28 septembre 2017 à 14:05:00 heure d’été d’Europe centrale")
        XCTAssertEqual(period.endDate!.description(with: Locale(identifier: "fr_FR")), "vendredi 1 décembre 2017 à 19:44:59 heure normale d’Europe centrale")
    }
}
