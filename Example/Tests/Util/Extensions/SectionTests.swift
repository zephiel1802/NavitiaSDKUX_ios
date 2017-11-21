import XCTest
import NavitiaSDK
import NavitiaSDKUX

class SectionTests: XCTestCase {
    var journeysResponse: Journeys? = nil

    override func setUp() {
        super.setUp()

        continueAfterFailure = false
        do {
            let pathUrl = URL(
                fileURLWithPath: "journeysWithDisruptionsResponse.json",
                relativeTo: Bundle(for: type(of: self)).resourceURL
            )
            let contentFile = try String(contentsOf: pathUrl)
            journeysResponse = Journeys(JSONString: contentFile)
            continueAfterFailure = true
        } catch {
            XCTAssertTrue(false, "Test file not loaded\n")
        }
    }

    func testExtensionSectionWithValidDisruptionsAndIncludedDate() {
        let section: Section = journeysResponse!.journeys!.first!.sections![1]

        let matchingDisruptions: [Disruption] = section.getMatchingDisruptions(
            from: journeysResponse!.disruptions,
            for: Date()
        )

        XCTAssertEqual(matchingDisruptions.count, 1)
        XCTAssertEqual(matchingDisruptions[0].cause!, "Travaux")
        XCTAssertEqual(matchingDisruptions[0].status!, Disruption.Status.active)
        XCTAssertEqual(matchingDisruptions[0].messages![0].text!, "En raison de travaux rue Henri Dunant et rue Chevalier de Kermelec, du lundi 02 octobre 2017 au vendredi 01 décembre 2017, la ligne 10 est déviée dans les deux sens.   Les arrêts \"J.Loth\" sont reportés aux arrêts \"Savina\" - Non Accessible PMR  L?arrêt \"Sécurité Sociale\" en direction de Kervouyec est reporté au poteau provisoire situé rue de la République. - Non Accessible PMR")
        XCTAssertEqual(matchingDisruptions[0].applicationPeriods![0].begin!, "20170928T140500")
        XCTAssertEqual(matchingDisruptions[0].applicationPeriods![0].end!, "20171201T194459")
    }

    func testExtensionSectionWithEmptyDisruptions() {
        let section: Section = journeysResponse!.journeys!.first!.sections![1]

        let matchingDisruptions: [Disruption] = section.getMatchingDisruptions(from: [], for: Date())

        XCTAssertEqual(matchingDisruptions.count, 0)
    }

    func testExtensionSectionWithNilDisruptions() {
        let section: Section = journeysResponse!.journeys!.first!.sections![1]

        let matchingDisruptions: [Disruption] = section.getMatchingDisruptions(
            from: nil,
            for: Date()
        )

        XCTAssertEqual(matchingDisruptions.count, 0)
    }

    func testExtensionSectionWithValidDisruptionsAndDateBefore() {
        let section: Section = journeysResponse!.journeys!.first!.sections![1]

        let matchingDisruptions: [Disruption] = section.getMatchingDisruptions(
            from: journeysResponse!.disruptions,
            for: Date.navitiaDateFormatter.date(from: "20160928T140500")
        )

        XCTAssertEqual(matchingDisruptions.count, 0)
    }

    func testExtensionSectionWithValidDisruptionsAndDateAfter() {
        let section: Section = journeysResponse!.journeys!.first!.sections![1]

        let matchingDisruptions: [Disruption] = section.getMatchingDisruptions(
            from: journeysResponse!.disruptions,
            for: Date.navitiaDateFormatter.date(from: "20180928T140500")
        )

        XCTAssertEqual(matchingDisruptions.count, 0)
    }
}
