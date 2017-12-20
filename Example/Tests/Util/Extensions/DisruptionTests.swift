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

        XCTAssertEqual(disruption.level, Disruption.DisruptionLevel.nonblocking)
    }

    func testExtensionDisruptionWithStopMoved() {
        let disruption: Disruption = Disruption()
        disruption.severity = Severity()
        disruption.severity!.effect = "STOP_MOVED"

        XCTAssertEqual(disruption.level, Disruption.DisruptionLevel.nonblocking)
    }

    func testExtensionDisruptionWithDetour() {
        let disruption: Disruption = Disruption()
        disruption.severity = Severity()
        disruption.severity!.effect = "DETOUR"

        XCTAssertEqual(disruption.level, Disruption.DisruptionLevel.nonblocking)
    }

    func testExtensionDisruptionWithSignificantDelays() {
        let disruption: Disruption = Disruption()
        disruption.severity = Severity()
        disruption.severity!.effect = "SIGNIFICANT_DELAYS"

        XCTAssertEqual(disruption.level, Disruption.DisruptionLevel.nonblocking)
    }

    func testExtensionDisruptionWithAdditionalService() {
        let disruption: Disruption = Disruption()
        disruption.severity = Severity()
        disruption.severity!.effect = "ADDITIONAL_SERVICE"

        XCTAssertEqual(disruption.level, Disruption.DisruptionLevel.nonblocking)
    }

    func testExtensionDisruptionWithModifiedService() {
        let disruption: Disruption = Disruption()
        disruption.severity = Severity()
        disruption.severity!.effect = "MODIFIED_SERVICE"

        XCTAssertEqual(disruption.level, Disruption.DisruptionLevel.nonblocking)
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
    
    func testHighestLevelIsBlocking() {
        let disruptions: [Disruption] = [
            { () in
                let disruption: Disruption = Disruption()
                disruption.severity = { () in
                    let severity: Severity = Severity()
                    severity.effect = "NO_SERVICE"
                    return severity
                }()
                return disruption
            } (),
            { () in
                let disruption: Disruption = Disruption()
                disruption.severity = { () in
                    let severity: Severity = Severity()
                    severity.effect = "DETOUR"
                    return severity
                }()
                return disruption
            } (),
            { () in
                let disruption: Disruption = Disruption()
                disruption.severity = { () in
                    let severity: Severity = Severity()
                    severity.effect = "DETOUR"
                    return severity
                }()
                return disruption
            } (),
        ]
        
        XCTAssertEqual(Disruption.getHighestLevelFrom(disruptions: disruptions), Disruption.DisruptionLevel.blocking)
    }
    
    func testHighestLevelIsNonBlocking() {
        let disruptions: [Disruption] = [
        { () in
            let disruption: Disruption = Disruption()
            disruption.severity = { () in
                let severity: Severity = Severity()
                severity.effect = "OTHER_EFFECT"
                return severity
            }()
            return disruption
            } (),
        { () in
            let disruption: Disruption = Disruption()
            disruption.severity = { () in
                let severity: Severity = Severity()
                severity.effect = "DETOUR"
                return severity
            }()
            return disruption
            } (),
        { () in
            let disruption: Disruption = Disruption()
            disruption.severity = { () in
                let severity: Severity = Severity()
                severity.effect = "OTHER_EFFECT"
                return severity
            }()
            return disruption
            } (),
        ]
        
        XCTAssertEqual(Disruption.getHighestLevelFrom(disruptions: disruptions), Disruption.DisruptionLevel.nonblocking)
    }
    
    func testHighestLevelIsInfo() {
        let disruptions: [Disruption] = [
        { () in
            let disruption: Disruption = Disruption()
            disruption.severity = { () in
                let severity: Severity = Severity()
                severity.effect = "OTHER_EFFECT"
                return severity
            }()
            return disruption
            } (),
        { () in
            let disruption: Disruption = Disruption()
            disruption.severity = { () in
                let severity: Severity = Severity()
                severity.effect = "OTHER_EFFECT"
                return severity
            }()
            return disruption
            } (),
        { () in
            let disruption: Disruption = Disruption()
            disruption.severity = { () in
                let severity: Severity = Severity()
                severity.effect = "OTHER_EFFECT"
                return severity
            }()
            return disruption
            } (),
        ]
        
        XCTAssertEqual(Disruption.getHighestLevelFrom(disruptions: disruptions), Disruption.DisruptionLevel.information)
    }
}
