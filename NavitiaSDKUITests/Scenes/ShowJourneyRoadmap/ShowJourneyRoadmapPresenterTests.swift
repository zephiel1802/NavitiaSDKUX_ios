//
//  ShowJourneyRoadmapPresenterTests.swift
//  NavitiaSDKUITests
//
//  Created by Flavien Sicard on 25/10/2018.
//  Copyright © 2018 kisio. All rights reserved.
//

import XCTest
@testable import NavitiaSDKUI

class ShowJourneyRoadmapPresenterTests: XCTestCase {
    
    // MARK: - Subject under test
    
    var sut: ShowJourneyRoadmapPresenter!
    var seeds: Seeds!
    
    // MARK: - Test lifecycle
    
    override func setUp() {
        super.setUp()
        setupShowJourneyRoadmapPresenter()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - Test setup
    
    func setupShowJourneyRoadmapPresenter() {
        NavitiaSDKUI.shared.bundle = Bundle(identifier: "org.kisio.NavitiaSDKUI")
        
        sut = ShowJourneyRoadmapPresenter()
        seeds = Seeds()
    }
    
    // MARK: - Test doubles
    
    class ShowJourneyRoadmapDisplayLogicSpy: ShowJourneyRoadmapDisplayLogic {
        var displayRoadmapCalled = false
        var displayMapCalled = false
        var viewModelRoadmap: ShowJourneyRoadmap.GetRoadmap.ViewModel!
        var viewModelMap: ShowJourneyRoadmap.GetMap.ViewModel!
        
        func displayRoadmap(viewModel: ShowJourneyRoadmap.GetRoadmap.ViewModel) {
            displayRoadmapCalled = true
            viewModelRoadmap = viewModel
        }
        
        func displayMap(viewModel: ShowJourneyRoadmap.GetMap.ViewModel) {
            displayMapCalled = true
            viewModelMap = viewModel
        }
    }
    
    private func getRoadmapResponse() -> ShowJourneyRoadmap.GetRoadmap.Response? {
        guard let journey = seeds.journeys?.first, let context = seeds.context else {
            return nil
        }
        
        let response = ShowJourneyRoadmap.GetRoadmap.Response(journey: journey,
                                                              journeyRidesharing: nil,
                                                              disruptions: seeds.disruptions,
                                                              notes: seeds.notes,
                                                              context: context)
        
        return response
    }
    
    func testDeparture() {
        let showJourneyRoadmapDisplayLogicSpy = ShowJourneyRoadmapDisplayLogicSpy()
        sut.viewController = showJourneyRoadmapDisplayLogicSpy
        
        guard let response = getRoadmapResponse() else {
            XCTFail("Error json String")
            return
        }
        
        sut.presentRoadmap(response: response)
        
        guard let viewModel = showJourneyRoadmapDisplayLogicSpy.viewModelRoadmap else {
            XCTFail("Error json String")
            return
        }
        
        XCTAssertEqual(viewModel.departure.time, "17:05")
        XCTAssertEqual(viewModel.departure.mode, .departure)
        XCTAssertEqual(viewModel.departure.information, "20 rue Hector Malot (Paris)")
        XCTAssertEqual(viewModel.departure.calorie, nil)
    }
    
    func testArrival() {
        let showJourneyRoadmapDisplayLogicSpy = ShowJourneyRoadmapDisplayLogicSpy()
        sut.viewController = showJourneyRoadmapDisplayLogicSpy
        
        guard let response = getRoadmapResponse() else {
            XCTFail("Error json String")
            return
        }
        
        sut.presentRoadmap(response: response)
        
        guard let viewModel = showJourneyRoadmapDisplayLogicSpy.viewModelRoadmap else {
            XCTFail("Error json String")
            return
        }
        
        XCTAssertEqual(viewModel.arrival.time, "17:14")
        XCTAssertEqual(viewModel.arrival.mode, .arrival)
        XCTAssertEqual(viewModel.arrival.information, "MAIRIE DE BEAUCOUZE (Beaucouzé)")
        if let calorie = viewModel.arrival.calorie {
            XCTAssertEqual(calorie, "36")
        } else {
            XCTFail("Fail")
        }
    }
    
    func testEmission() {
        let showJourneyRoadmapDisplayLogicSpy = ShowJourneyRoadmapDisplayLogicSpy()
        sut.viewController = showJourneyRoadmapDisplayLogicSpy
        
        guard let response = getRoadmapResponse() else {
            XCTFail("Error json String")
            return
        }
        
        sut.presentRoadmap(response: response)
        
        guard let viewModel = showJourneyRoadmapDisplayLogicSpy.viewModelRoadmap else {
            XCTFail("Error json String")
            return
        }
        
        XCTAssertEqual(viewModel.emission.car!.value, 128.5214268232)
        XCTAssertEqual(viewModel.emission.car!.unit, "g CO2")
        XCTAssertEqual(viewModel.emission.journey.value, 0)
        XCTAssertEqual(viewModel.emission.journey.unit, "g CO2")
    }
    
    func testWalkingStepView() {
        let showJourneyRoadmapDisplayLogicSpy = ShowJourneyRoadmapDisplayLogicSpy()
        sut.viewController = showJourneyRoadmapDisplayLogicSpy
        
        guard let response = getRoadmapResponse() else {
            XCTFail("Error json String")
            return
        }
        
        sut.presentRoadmap(response: response)
        
        guard let viewModel = showJourneyRoadmapDisplayLogicSpy.viewModelRoadmap else {
            XCTFail("Error json String")
            return
        }

        XCTAssertEqual(viewModel.sections?[0].type, .streetNetwork)
        XCTAssertEqual(viewModel.sections?[0].mode, .walking)
        XCTAssertEqual(viewModel.sections?[0].from, "20 rue Hector Malot (Paris)")
        XCTAssertEqual(viewModel.sections?[0].to, "89 avenue Ledru Rollin (Paris)")
        XCTAssertEqual(viewModel.sections?[0].startTime, "17:05")
        XCTAssertEqual(viewModel.sections?[0].endTime, "17:14")
        XCTAssertEqual(viewModel.sections?[0].actionDescription, "To")
        XCTAssertEqual(viewModel.sections?[0].path?.count, 6)
        XCTAssertEqual(viewModel.sections?[0].stopDate.count, 0)
        XCTAssertNil(viewModel.sections?[0].displayInformations.code)
        XCTAssertEqual(viewModel.sections?[0].displayInformations.color, UIColor.black)
        XCTAssertNil(viewModel.sections?[0].displayInformations.commercialMode)
        XCTAssertEqual(viewModel.sections?[0].displayInformations.directionTransit, "")
        XCTAssertNil(viewModel.sections?[0].displayInformations.network)
        XCTAssertNil(viewModel.sections?[0].waiting)
        XCTAssertEqual(viewModel.sections?[0].disruptionsClean.count, 0)
        XCTAssertEqual(viewModel.sections?[0].notes.count, 0)
        XCTAssertNil(viewModel.sections?[0].poi)
        XCTAssertEqual(viewModel.sections?[0].icon, "walking")
        XCTAssertEqual(viewModel.sections?[0].bssRealTime, false)
        XCTAssertEqual(viewModel.sections?[0].background, false)
        XCTAssertEqual(viewModel.sections![0].duration!, "A 8 minutes walk")
        XCTAssertEqual(viewModel.sections![1].duration!, "A 1 minute walk")
        XCTAssertEqual(viewModel.sections![2].duration!, "Less than a minute walk")
    }
    
    func testRideStepView() {
        let showJourneyRoadmapDisplayLogicSpy = ShowJourneyRoadmapDisplayLogicSpy()
        sut.viewController = showJourneyRoadmapDisplayLogicSpy
        
        guard let response = getRoadmapResponse() else {
            XCTFail("Error json String")
            return
        }
        
        sut.presentRoadmap(response: response)
        
        guard let viewModel = showJourneyRoadmapDisplayLogicSpy.viewModelRoadmap else {
            XCTFail("Error json String")
            return
        }
        
        XCTAssertEqual(viewModel.sections?[3].type, .streetNetwork)
        XCTAssertEqual(viewModel.sections?[3].mode, .bike)
        XCTAssertEqual(viewModel.sections?[3].from, "89 avenue Ledru Rollin (Paris)")
        XCTAssertEqual(viewModel.sections?[3].to, "Cinema Mk2 Bastille (Paris)")
        XCTAssertEqual(viewModel.sections?[3].startTime, "17:06")
        XCTAssertEqual(viewModel.sections?[3].endTime, "17:09")
        XCTAssertEqual(viewModel.sections?[3].actionDescription, "To")
        XCTAssertEqual(viewModel.sections?[3].path?.count, 3)
        XCTAssertEqual(viewModel.sections?[3].stopDate.count, 0)
        XCTAssertNil(viewModel.sections?[3].displayInformations.code)
        XCTAssertEqual(viewModel.sections?[3].displayInformations.color, UIColor.black)
        XCTAssertNil(viewModel.sections?[3].displayInformations.commercialMode)
        XCTAssertEqual(viewModel.sections?[3].displayInformations.directionTransit, "")
        XCTAssertNil(viewModel.sections?[3].displayInformations.network)
        XCTAssertNil(viewModel.sections?[3].waiting)
        XCTAssertEqual(viewModel.sections?[3].disruptionsClean.count, 0)
        XCTAssertEqual(viewModel.sections?[3].notes.count, 0)
        XCTAssertNil(viewModel.sections?[3].poi)
        XCTAssertEqual(viewModel.sections?[3].icon, "bike")
        XCTAssertEqual(viewModel.sections?[3].bssRealTime, false)
        XCTAssertEqual(viewModel.sections?[3].background, false)
        XCTAssertEqual(viewModel.sections![3].duration!, "A 2 minutes ride")
        XCTAssertEqual(viewModel.sections![4].duration!, "A 1 minute ride")
        XCTAssertEqual(viewModel.sections![5].duration!, "Less than a minute ride")
    }
    
    func testCarStepView() {
        let showJourneyRoadmapDisplayLogicSpy = ShowJourneyRoadmapDisplayLogicSpy()
        sut.viewController = showJourneyRoadmapDisplayLogicSpy
        
        guard let response = getRoadmapResponse() else {
            XCTFail("Error json String")
            return
        }
        
        sut.presentRoadmap(response: response)
        
        guard let viewModel = showJourneyRoadmapDisplayLogicSpy.viewModelRoadmap else {
            XCTFail("Error json String")
            return
        }
        
        XCTAssertEqual(viewModel.sections?[6].type, .streetNetwork)
        XCTAssertEqual(viewModel.sections?[6].mode, .car)
        XCTAssertEqual(viewModel.sections?[6].from, "Gares (Rennes)")
        XCTAssertEqual(viewModel.sections?[6].to, "Parc relais Henri Fréville")
        XCTAssertEqual(viewModel.sections?[6].startTime, "10:08")
        XCTAssertEqual(viewModel.sections?[6].endTime, "10:11")
        XCTAssertEqual(viewModel.sections?[6].actionDescription, "To")
        XCTAssertEqual(viewModel.sections?[6].path?.count, 17)
        XCTAssertEqual(viewModel.sections?[6].stopDate.count, 0)
        XCTAssertNil(viewModel.sections?[6].displayInformations.code)
        XCTAssertEqual(viewModel.sections?[6].displayInformations.color, UIColor.black)
        XCTAssertNil(viewModel.sections?[6].displayInformations.commercialMode)
        XCTAssertEqual(viewModel.sections?[6].displayInformations.directionTransit, "")
        XCTAssertNil(viewModel.sections?[6].displayInformations.network)
        XCTAssertNil(viewModel.sections?[6].waiting)
        XCTAssertEqual(viewModel.sections?[6].disruptionsClean.count, 0)
        XCTAssertEqual(viewModel.sections?[6].notes.count, 0)
        XCTAssertNil(viewModel.sections?[6].poi)
        XCTAssertEqual(viewModel.sections?[6].icon, "car")
        XCTAssertEqual(viewModel.sections?[6].bssRealTime, false)
        XCTAssertEqual(viewModel.sections?[6].background, false)
        XCTAssertEqual(viewModel.sections?[6].duration, "A 3 minutes drive")
        XCTAssertEqual(viewModel.sections?[7].duration, "A 1 minute drive")
        XCTAssertEqual(viewModel.sections?[8].duration, "Less than a minute drive")
    }
    
    func testBssRentStepView() {
        let showJourneyRoadmapDisplayLogicSpy = ShowJourneyRoadmapDisplayLogicSpy()
        sut.viewController = showJourneyRoadmapDisplayLogicSpy
        
        guard let response = getRoadmapResponse() else {
            XCTFail("Error json String")
            return
        }
        
        sut.presentRoadmap(response: response)
        
        guard let viewModel = showJourneyRoadmapDisplayLogicSpy.viewModelRoadmap else {
            XCTFail("Error json String")
            return
        }
        
        XCTAssertEqual(viewModel.sections?[9].type, .bssRent)
        XCTAssertNil(viewModel.sections?[9].mode)
        XCTAssertEqual(viewModel.sections?[9].from, " (Dijon)")
        XCTAssertEqual(viewModel.sections?[9].to, "Gare Dijon Ville (Dijon)")
        XCTAssertEqual(viewModel.sections?[9].startTime, "10:12")
        XCTAssertEqual(viewModel.sections?[9].endTime, "10:14")
        XCTAssertEqual(viewModel.sections?[9].actionDescription, "Take a DiviaVélodi bike at")
        XCTAssertEqual(viewModel.sections?[9].path?.count, 0)
        XCTAssertEqual(viewModel.sections?[9].stopDate.count, 0)
        XCTAssertNil(viewModel.sections?[9].displayInformations.code)
        XCTAssertEqual(viewModel.sections?[9].displayInformations.color, UIColor.black)
        XCTAssertNil(viewModel.sections?[9].displayInformations.commercialMode)
        XCTAssertEqual(viewModel.sections?[9].displayInformations.directionTransit, "")
        XCTAssertNil(viewModel.sections?[9].displayInformations.network)
        XCTAssertNil(viewModel.sections?[9].waiting)
        XCTAssertEqual(viewModel.sections?[9].disruptionsClean.count, 0)
        XCTAssertEqual(viewModel.sections?[9].notes.count, 0)
    //    XCTAssertEqual(viewModel.sections?[9].poi)
        XCTAssertEqual(viewModel.sections?[9].icon, "bss")
        XCTAssertEqual(viewModel.sections?[9].background, true)
        XCTAssertEqual(viewModel.sections?[9].bssRealTime, false)

        XCTAssertEqual(viewModel.sections?[11].bssRealTime, false)
    }
    
    func testBssPutBackStepView() {
        let showJourneyRoadmapDisplayLogicSpy = ShowJourneyRoadmapDisplayLogicSpy()
        sut.viewController = showJourneyRoadmapDisplayLogicSpy
        
        guard let response = getRoadmapResponse() else {
            XCTFail("Error json String")
            return
        }
        
        sut.presentRoadmap(response: response)
        
        guard let viewModel = showJourneyRoadmapDisplayLogicSpy.viewModelRoadmap else {
            XCTFail("Error json String")
            return
        }
        
        XCTAssertEqual(viewModel.sections?[10].type, .bssPutBack)
        XCTAssertNil(viewModel.sections?[10].mode)
        XCTAssertEqual(viewModel.sections?[10].from, "Général de Gaulle - Clinique (Dijon)")
        XCTAssertEqual(viewModel.sections?[10].to, "14 Cours du Général de Gaulle (Dijon)")
        XCTAssertEqual(viewModel.sections?[10].startTime, "10:23")
        XCTAssertEqual(viewModel.sections?[10].endTime, "10:24")
        XCTAssertEqual(viewModel.sections?[10].actionDescription, "Dock the DiviaVélodi bike at")
        XCTAssertEqual(viewModel.sections?[10].path?.count, 0)
        XCTAssertEqual(viewModel.sections?[10].stopDate.count, 0)
        XCTAssertNil(viewModel.sections?[10].displayInformations.code)
        XCTAssertEqual(viewModel.sections?[10].displayInformations.color, UIColor.black)
        XCTAssertNil(viewModel.sections?[10].displayInformations.commercialMode)
        XCTAssertEqual(viewModel.sections?[10].displayInformations.directionTransit, "")
        XCTAssertNil(viewModel.sections?[10].displayInformations.network)
        XCTAssertNil(viewModel.sections?[10].waiting)
        XCTAssertEqual(viewModel.sections?[10].disruptionsClean.count, 0)
        XCTAssertEqual(viewModel.sections?[10].notes.count, 0)
        //    XCTAssertEqual(viewModel.sections?[10].poi)
        XCTAssertEqual(viewModel.sections?[10].icon, "bss")
        XCTAssertEqual(viewModel.sections?[10].background, true)
        XCTAssertEqual(viewModel.sections?[10].bssRealTime, false)
        
        XCTAssertEqual(viewModel.sections?[12].bssRealTime, false)
    }
    
}
