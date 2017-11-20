//
//  DisruptionTests.swift
//  NavitiaSDKUX
//
//  Created by Chakkra CHAK on 16/11/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import XCTest
import NavitiaSDK
import NavitiaSDKUX

class DisruptionTests: XCTestCase {
    func testExtensionDisruptionWithSeverityNull() {
        let disruption: Disruption = Disruption()
        disruption.severity = nil

        XCTAssertEqual(disruption.level, Disruption.DisruptionLevel.none)
    }

    func testExtensionDisruptionWithNoService() {
        let disruption: Disruption = Disruption()
        disruption.severity = Severity()
        disruption.severity!.effect = "NO_SERVICE"

        XCTAssertEqual(disruption.level, Disruption.DisruptionLevel.blocking)
    }

    func testExtensionDisruptionWithReducedService() {
        let disruption: Disruption = Disruption()
        disruption.severity = Severity()
        disruption.severity!.effect = "REDUCED_SERVICE"

        XCTAssertEqual(disruption.level, Disruption.DisruptionLevel.warning)
    }

    func testExtensionDisruptionWithStopMoved() {
        let disruption: Disruption = Disruption()
        disruption.severity = Severity()
        disruption.severity!.effect = "STOP_MOVED"

        XCTAssertEqual(disruption.level, Disruption.DisruptionLevel.warning)
    }

    func testExtensionDisruptionWithDetour() {
        let disruption: Disruption = Disruption()
        disruption.severity = Severity()
        disruption.severity!.effect = "DETOUR"

        XCTAssertEqual(disruption.level, Disruption.DisruptionLevel.warning)
    }

    func testExtensionDisruptionWithSignificantDelays() {
        let disruption: Disruption = Disruption()
        disruption.severity = Severity()
        disruption.severity!.effect = "SIGNIFICANT_DELAYS"

        XCTAssertEqual(disruption.level, Disruption.DisruptionLevel.warning)
    }

    func testExtensionDisruptionWithAdditionalService() {
        let disruption: Disruption = Disruption()
        disruption.severity = Severity()
        disruption.severity!.effect = "ADDITIONAL_SERVICE"

        XCTAssertEqual(disruption.level, Disruption.DisruptionLevel.warning)
    }

    func testExtensionDisruptionWithModifiedService() {
        let disruption: Disruption = Disruption()
        disruption.severity = Severity()
        disruption.severity!.effect = "MODIFIED_SERVICE"

        XCTAssertEqual(disruption.level, Disruption.DisruptionLevel.warning)
    }

    func testExtensionDisruptionWithOtherEffect() {
        let disruption: Disruption = Disruption()
        disruption.severity = Severity()
        disruption.severity!.effect = "OTHER_EFFECT"

        XCTAssertEqual(disruption.level, Disruption.DisruptionLevel.information)
    }

    func testExtensionDisruptionWithUnknownEffect() {
        let disruption: Disruption = Disruption()
        disruption.severity = Severity()
        disruption.severity!.effect = "UNKNOWN_EFFECT"

        XCTAssertEqual(disruption.level, Disruption.DisruptionLevel.information)
    }

    func testExtensionDisruptionWithNilEffect() {
        let disruption: Disruption = Disruption()
        disruption.severity = Severity()
        disruption.severity!.effect = nil

        XCTAssertEqual(disruption.level, Disruption.DisruptionLevel.none)
    }

    func testExtensionDisruptionWithNewEffect() {
        let disruption: Disruption = Disruption()
        disruption.severity = Severity()
        disruption.severity!.effect = "UMADBRO?"

        XCTAssertEqual(disruption.level, Disruption.DisruptionLevel.none)
    }
}
