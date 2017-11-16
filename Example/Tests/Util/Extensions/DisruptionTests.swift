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
        var disruption: Disruption = Disruption()

        disruption.severity = nil

        XCTAssertEqual(disruption.warningLevel, Disruption.WarningLevel.NONE)
    }

    func testExtensionDisruptionWithNoService() {
        // GIVEN
        var disruption: Disruption = Disruption()
        disruption.severity = Severity()

        // WHEN
        disruption.severity!.effect = "NO_SERVICE"

        // THEN
        XCTAssertEqual(disruption.warningLevel, Disruption.WarningLevel.BLOCKING)
    }

    func testExtensionDisruptionWithReducedService() {
        var disruption: Disruption = Disruption()
        disruption.severity = Severity()

        disruption.severity!.effect = "REDUCED_SERVICE"

        XCTAssertEqual(disruption.warningLevel, Disruption.WarningLevel.WARNING)
    }

    func testExtensionDisruptionWithStopMoved() {
        var disruption: Disruption = Disruption()
        disruption.severity = Severity()

        disruption.severity!.effect = "STOP_MOVED"

        XCTAssertEqual(disruption.warningLevel, Disruption.WarningLevel.WARNING)
    }

    func testExtensionDisruptionWithDetour() {
        var disruption: Disruption = Disruption()
        disruption.severity = Severity()

        disruption.severity!.effect = "DETOUR"

        XCTAssertEqual(disruption.warningLevel, Disruption.WarningLevel.WARNING)
    }

    func testExtensionDisruptionWithSignificantDelays() {
        var disruption: Disruption = Disruption()
        disruption.severity = Severity()

        disruption.severity!.effect = "SIGNIFICANT_DELAYS"

        XCTAssertEqual(disruption.warningLevel, Disruption.WarningLevel.WARNING)
    }

    func testExtensionDisruptionWithAdditionalService() {
        var disruption: Disruption = Disruption()
        disruption.severity = Severity()

        disruption.severity!.effect = "ADDITIONAL_SERVICE"

        XCTAssertEqual(disruption.warningLevel, Disruption.WarningLevel.WARNING)
    }

    func testExtensionDisruptionWithModifiedService() {
        var disruption: Disruption = Disruption()
        disruption.severity = Severity()

        disruption.severity!.effect = "MODIFIED_SERVICE"

        XCTAssertEqual(disruption.warningLevel, Disruption.WarningLevel.WARNING)
    }

    func testExtensionDisruptionWithOtherEffect() {
        var disruption: Disruption = Disruption()
        disruption.severity = Severity()

        disruption.severity!.effect = "OTHER_EFFECT"

        XCTAssertEqual(disruption.warningLevel, Disruption.WarningLevel.INFORMATION)
    }

    func testExtensionDisruptionWithUnknownEffect() {
        var disruption: Disruption = Disruption()
        disruption.severity = Severity()

        disruption.severity!.effect = "UNKNOWN_EFFECT"

        XCTAssertEqual(disruption.warningLevel, Disruption.WarningLevel.INFORMATION)
    }

    func testExtensionDisruptionWithNilEffect() {
        var disruption: Disruption = Disruption()
        disruption.severity = Severity()

        disruption.severity!.effect = nil

        XCTAssertEqual(disruption.warningLevel, Disruption.WarningLevel.NONE)
    }

    func testExtensionDisruptionWithNewEffect() {
        var disruption: Disruption = Disruption()
        disruption.severity = Severity()

        disruption.severity!.effect = "UMADBRO?"

        XCTAssertEqual(disruption.warningLevel, Disruption.WarningLevel.NONE)
    }
}
