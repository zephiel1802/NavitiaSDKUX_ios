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
    
    enum sectionIndex {
        static var walking = 0
        static var walkingTwo = 1
        static var walkingThree = 2
        static var bike = 3
        static var bikeTwo = 4
        static var bikeThree = 5
        static var car = 6
        static var carTwo = 7
        static var carThree = 8
        static var bssRentStands = 9
        static var bssRent = 11
        static var bssPutBackStands = 10
        static var bssPutBack = 12
        static var transfer = 13
        static var crowFly = 14
        static var wainting = 16
        static var publicTransport = 17
        static var waintingTwo = 18
        static var onDemandeTransport = 19
    }
    
    // MARK: - Subject under test
    
    var sut: ShowJourneyRoadmapPresenter!
    var seeds: Seeds!
    var viewModelRoadmap: ShowJourneyRoadmap.GetRoadmap.ViewModel!
    
    // MARK: - Test lifecycle
    
    override func setUp() {
        super.setUp()
        
        setupNavitiaSDKUI()
        setupShowJourneyRoadmapPresenter()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - Test setup
    
    func setupNavitiaSDKUI() {
        NavitiaSDKUI.shared.bundle = Bundle(identifier: "org.kisio.NavitiaSDKUI")
        NavitiaSDKUI.shared.multiNetwork = true
    }
    
    func setupShowJourneyRoadmapPresenter() {
        sut = ShowJourneyRoadmapPresenter()
        seeds = Seeds()
        viewModelRoadmap = getViewModelRoadmap()
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
    
    private func getViewModelRoadmap() -> ShowJourneyRoadmap.GetRoadmap.ViewModel? {
        let showJourneyRoadmapDisplayLogicSpy = ShowJourneyRoadmapDisplayLogicSpy()
        sut.viewController = showJourneyRoadmapDisplayLogicSpy
        
        guard let response = getRoadmapResponse() else {
            XCTFail("Error json String")
            return nil
        }
        
        sut.presentRoadmap(response: response)
        
        return showJourneyRoadmapDisplayLogicSpy.viewModelRoadmap
    }
    
    func testRidesharing() {}
    
    func testDeparture() {
        XCTAssertEqual(viewModelRoadmap.departure.time, "17:05")
        XCTAssertEqual(viewModelRoadmap.departure.mode, .departure)
        XCTAssertEqual(viewModelRoadmap.departure.information, "20 rue Hector Malot (Paris)")
        XCTAssertNil(viewModelRoadmap.departure.calorie)
    }
    
    func testArrival() {
        XCTAssertEqual(viewModelRoadmap.arrival.time, "17:14")
        XCTAssertEqual(viewModelRoadmap.arrival.mode, .arrival)
        XCTAssertEqual(viewModelRoadmap.arrival.information, "MAIRIE DE BEAUCOUZE (Beaucouzé)")
        XCTAssertEqual(viewModelRoadmap.arrival.calorie, "36")
    }
    
    func testEmission() {
        XCTAssertEqual(viewModelRoadmap.emission.car?.value, 2.5682)
        XCTAssertEqual(viewModelRoadmap.emission.car?.unit, "Kg CO2")
        XCTAssertEqual(viewModelRoadmap.emission.journey.value, 0)
        XCTAssertEqual(viewModelRoadmap.emission.journey.unit, "g CO2")
    }
    
    func testPaths() {
        guard let pathViewMode = viewModelRoadmap.sections?[sectionIndex.walking].path else {
            XCTFail("Error json String")
            return
        }
        
        XCTAssertEqual(pathViewMode[0].directionIcon, "arrow_straight")
        XCTAssertEqual(pathViewMode[0].instruction, "Continue on avenue Daumesnil for 125m")
        XCTAssertEqual(pathViewMode[1].directionIcon, "arrow_right")
        XCTAssertEqual(pathViewMode[1].instruction, "Turn right on rue Abel in 125m")
        XCTAssertEqual(pathViewMode[2].directionIcon, "arrow_left")
        XCTAssertEqual(pathViewMode[2].instruction, "Turn left on rue de Prague in 260m")
    }
    
    func testStands() {
        guard let standsViewModel = viewModelRoadmap.sections?[sectionIndex.bssRentStands].poi?.stands else {
            XCTFail("Error json String")
            return
        }
        
        XCTAssertEqual(standsViewModel.availability, "11 bike available")
        XCTAssertNil(standsViewModel.icon)
    }
    
    func testPoi() {
        guard let poiViewModel = viewModelRoadmap.sections?[sectionIndex.bssRentStands].poi else {
            XCTFail("Error json String")
            return
        }
        
        XCTAssertEqual(poiViewModel.name, "Gare Dijon Ville")
        XCTAssertEqual(poiViewModel.network, "DiviaVélodi")
        XCTAssertEqual(poiViewModel.lat, 47.3233083)
        XCTAssertEqual(poiViewModel.lont, 5.0277417)
        XCTAssertEqual(poiViewModel.addressName, "Cour de la Gare")
        XCTAssertEqual(poiViewModel.addressId, "5.0277417;47.3233083")
    }
    
    func testDisruption() {}
    
    func testNotes() {}
    
    func testDisplayInformations() {
        guard let displayInformationsViewModel = viewModelRoadmap.sections?[sectionIndex.publicTransport].displayInformations else {
            XCTFail("Error json String")
            return
        }
        
        XCTAssertEqual(displayInformationsViewModel.commercialMode, "Métro")
        //XCTAssertEqual(displayInformationsViewModel.color, "Métro")
        XCTAssertEqual(displayInformationsViewModel.directionTransit, "La Défense (Grande Arche) (Puteaux)")
        XCTAssertEqual(displayInformationsViewModel.code, "1")
        XCTAssertEqual(displayInformationsViewModel.network, "METRO")
    }
    
    func testWalkingStepView() {
        guard let walkingViewModel = viewModelRoadmap.sections?[sectionIndex.walking],
            let walkingTwoViewModel = viewModelRoadmap.sections?[sectionIndex.walkingTwo],
            let walkingThreeViewModel = viewModelRoadmap.sections?[sectionIndex.walkingThree] else {
            XCTFail("Error json String")
            return
        }

        XCTAssertEqual(walkingViewModel.type, .streetNetwork)
        XCTAssertEqual(walkingViewModel.mode, .walking)
        XCTAssertEqual(walkingViewModel.to, "89 avenue Ledru Rollin (Paris)")
        XCTAssertEqual(walkingViewModel.actionDescription, "To")
        XCTAssertEqual(walkingViewModel.path?.count, 5)
        XCTAssertEqual(walkingViewModel.icon, "walking")
        XCTAssertEqual(walkingViewModel.bssRealTime, false)
        XCTAssertEqual(walkingViewModel.background, false)
        XCTAssertEqual(walkingViewModel.duration, "A 8 minutes walk")
        XCTAssertEqual(walkingTwoViewModel.duration, "A 1 minute walk")
        XCTAssertEqual(walkingThreeViewModel.duration, "Less than a minute walk")
        XCTAssertNil(walkingViewModel.waiting)
        XCTAssertNil(walkingViewModel.poi)
        
        XCTAssertEqual(walkingViewModel.from, "20 rue Hector Malot (Paris)") // TODO: Set with nil
        XCTAssertEqual(walkingViewModel.startTime, "17:05") // TODO: Set with nil
        XCTAssertEqual(walkingViewModel.endTime, "17:14") // TODO: Set with nil
        XCTAssertEqual(walkingViewModel.stopDate.count, 0) // TODO: Set with nil
        XCTAssertNotNil(walkingViewModel.displayInformations) // TODO: Set with nil
        XCTAssertEqual(walkingViewModel.disruptionsClean.count, 0) // TODO: Set with nil
        XCTAssertEqual(walkingViewModel.notes.count, 0) // TODO: Set with nil
    }
    
    func testBikeStepView() {
        guard let bikeViewModel = viewModelRoadmap.sections?[sectionIndex.bike],
            let bikeTwoViewModel = viewModelRoadmap.sections?[sectionIndex.bikeTwo],
            let bikeThreeViewModel = viewModelRoadmap.sections?[sectionIndex.bikeThree] else {
            XCTFail("Error json String")
            return
        }
        
        XCTAssertEqual(bikeViewModel.type, .streetNetwork)
        XCTAssertEqual(bikeViewModel.mode, .bike)
        XCTAssertEqual(bikeViewModel.to, "Cinema Mk2 Bastille (Paris)")
        XCTAssertEqual(bikeViewModel.actionDescription, "To")
        XCTAssertEqual(bikeViewModel.path?.count, 3)
        XCTAssertNil(bikeViewModel.waiting)
        XCTAssertNil(bikeViewModel.poi)
        XCTAssertEqual(bikeViewModel.icon, "bike")
        XCTAssertEqual(bikeViewModel.bssRealTime, false)
        XCTAssertEqual(bikeViewModel.background, false)
        XCTAssertEqual(bikeViewModel.duration, "A 2 minutes ride")
        XCTAssertEqual(bikeTwoViewModel.duration, "A 1 minute ride")
        XCTAssertEqual(bikeThreeViewModel.duration, "Less than a minute ride")

        XCTAssertEqual(bikeViewModel.disruptionsClean.count, 0) // TODO: Set with nil
        XCTAssertEqual(bikeViewModel.notes.count, 0) // TODO: Set with nil
        XCTAssertEqual(bikeViewModel.stopDate.count, 0) // TODO: Set with nil
        XCTAssertNotNil(bikeViewModel.displayInformations) // TODO: Set with nil
        XCTAssertEqual(bikeViewModel.startTime, "17:06") // TODO: Set with nil
        XCTAssertEqual(bikeViewModel.endTime, "17:09") // TODO: Set with nil
        XCTAssertEqual(bikeViewModel.from, "89 avenue Ledru Rollin (Paris)") // TODO: Set with nil
    }
    
    func testCarStepView() {
        guard let carViewModel = viewModelRoadmap.sections?[sectionIndex.car],
            let carTwoViewModel = viewModelRoadmap.sections?[sectionIndex.carTwo],
            let carThreeViewModel = viewModelRoadmap.sections?[sectionIndex.carThree] else {
            XCTFail("Error json String")
            return
        }
        
        XCTAssertEqual(carViewModel.type, .streetNetwork)
        XCTAssertEqual(carViewModel.mode, .car)
        XCTAssertEqual(carViewModel.to, "Parc relais Henri Fréville")
        XCTAssertEqual(carViewModel.actionDescription, "To")
        XCTAssertEqual(carViewModel.path?.count, 17)
        XCTAssertNil(carViewModel.waiting)
        XCTAssertNil(carViewModel.poi)
        XCTAssertEqual(carViewModel.icon, "car")
        XCTAssertEqual(carViewModel.bssRealTime, false)
        XCTAssertEqual(carViewModel.background, false)
        XCTAssertEqual(carViewModel.duration, "A 3 minutes drive")
        XCTAssertEqual(carTwoViewModel.duration, "A 1 minute drive")
        XCTAssertEqual(carThreeViewModel.duration, "Less than a minute drive")

        XCTAssertEqual(carViewModel.from, "Gares (Rennes)") // TODO: Set with nil
        XCTAssertEqual(carViewModel.stopDate.count, 0) // TODO: Set with nil
        XCTAssertNotNil(carViewModel.displayInformations) // TODO: Set with nil
        XCTAssertEqual(carViewModel.disruptionsClean.count, 0) // TODO: Set with nil
        XCTAssertEqual(carViewModel.notes.count, 0) // TODO: Set with nil
        XCTAssertEqual(carViewModel.startTime, "10:08") // TODO: Set with nil
        XCTAssertEqual(carViewModel.endTime, "10:11") // TODO: Set with nil
    }
    
    func testRidesharingStepView() {}
    
    func testBssRentStepView() {
        guard let bssRentStandsViewModel = viewModelRoadmap.sections?[sectionIndex.bssRentStands],
            let bssRentViewModel = viewModelRoadmap.sections?[sectionIndex.bssRent] else {
            XCTFail("Error json String")
            return
        }
        
        XCTAssertEqual(bssRentStandsViewModel.type, .bssRent)
        XCTAssertNil(bssRentStandsViewModel.mode)
        XCTAssertEqual(bssRentStandsViewModel.from, " (Dijon)")
        XCTAssertEqual(bssRentStandsViewModel.to, "Gare Dijon Ville (Dijon)")
        XCTAssertEqual(bssRentStandsViewModel.startTime, "10:12")
        XCTAssertEqual(bssRentStandsViewModel.endTime, "10:14")
        XCTAssertEqual(bssRentStandsViewModel.actionDescription, "Take a DiviaVélodi bike at")
        XCTAssertEqual(bssRentStandsViewModel.path?.count, 0)
        XCTAssertEqual(bssRentStandsViewModel.stopDate.count, 0)
        XCTAssertNotNil(bssRentStandsViewModel.displayInformations) // TODO: Set with nil
        XCTAssertNil(bssRentStandsViewModel.waiting)
        XCTAssertEqual(bssRentStandsViewModel.disruptionsClean.count, 0)
        XCTAssertEqual(bssRentStandsViewModel.notes.count, 0)
        XCTAssertNotNil(bssRentStandsViewModel.poi)
        XCTAssertNotNil(bssRentStandsViewModel.poi?.stands)
        XCTAssertEqual(bssRentStandsViewModel.icon, "bss")
        XCTAssertEqual(bssRentStandsViewModel.background, true)
        XCTAssertEqual(bssRentStandsViewModel.bssRealTime, false)
        
        XCTAssertNil(bssRentViewModel.poi?.stands)
        XCTAssertEqual(bssRentViewModel.bssRealTime, false)
    }
    
    func testBssPutBackStepView() {
        guard let bssPutBackStandsViewModel = viewModelRoadmap.sections?[sectionIndex.bssPutBackStands],
            let bssPutBackViewModel = viewModelRoadmap.sections?[sectionIndex.bssPutBack] else {
            XCTFail("Error json String")
            return
        }
        
        XCTAssertEqual(bssPutBackStandsViewModel.type, .bssPutBack)
        XCTAssertNil(bssPutBackStandsViewModel.mode)
        XCTAssertEqual(bssPutBackStandsViewModel.from, "Général de Gaulle - Clinique (Dijon)")
        XCTAssertEqual(bssPutBackStandsViewModel.to, "14 Cours du Général de Gaulle (Dijon)")
        XCTAssertEqual(bssPutBackStandsViewModel.startTime, "10:23")
        XCTAssertEqual(bssPutBackStandsViewModel.endTime, "10:24")
        XCTAssertEqual(bssPutBackStandsViewModel.actionDescription, "Dock the DiviaVélodi bike at")
        XCTAssertEqual(bssPutBackStandsViewModel.path?.count, 0)
        XCTAssertEqual(bssPutBackStandsViewModel.stopDate.count, 0)
        XCTAssertNotNil(bssPutBackStandsViewModel.displayInformations) // TODO: Set with nil
        XCTAssertNil(bssPutBackStandsViewModel.waiting)
        XCTAssertEqual(bssPutBackStandsViewModel.disruptionsClean.count, 0)
        XCTAssertEqual(bssPutBackStandsViewModel.notes.count, 0)
        XCTAssertNotNil(bssPutBackStandsViewModel.poi)
        XCTAssertNotNil(bssPutBackStandsViewModel.poi?.stands)
        XCTAssertNil(bssPutBackStandsViewModel.poi?.stands?.icon)
        XCTAssertEqual(bssPutBackStandsViewModel.icon, "bss")
        XCTAssertEqual(bssPutBackStandsViewModel.background, true)
        XCTAssertEqual(bssPutBackStandsViewModel.bssRealTime, false)
        
        XCTAssertEqual(bssPutBackViewModel.bssRealTime, false)
        XCTAssertNil(bssPutBackViewModel.poi?.stands)
    }
    
    func testTransferStepView() {
        guard let transferViewModel = viewModelRoadmap.sections?[sectionIndex.transfer] else {
            XCTFail("Error json String")
            return
        }
        
        XCTAssertEqual(transferViewModel.type, .transfer)
        XCTAssertNil(transferViewModel.mode)
        XCTAssertEqual(transferViewModel.from, "GARE DE LA DEFENSE RER A (Puteaux)")
        XCTAssertEqual(transferViewModel.to, "La Défense (Grande Arche) (Puteaux)")
        XCTAssertEqual(transferViewModel.startTime, "17:27")
        XCTAssertEqual(transferViewModel.endTime, "17:31")
        XCTAssertEqual(transferViewModel.actionDescription, "To")
        XCTAssertEqual(transferViewModel.path?.count, 0)
        XCTAssertEqual(transferViewModel.stopDate.count, 0)
        XCTAssertNotNil(transferViewModel.displayInformations) // TODO: Set with nil
        XCTAssertNil(transferViewModel.waiting)
        XCTAssertEqual(transferViewModel.disruptionsClean.count, 0)
        XCTAssertEqual(transferViewModel.notes.count, 0)
        XCTAssertNil(transferViewModel.poi)
        XCTAssertEqual(transferViewModel.icon, "walking")
        XCTAssertEqual(transferViewModel.bssRealTime, false)
        XCTAssertEqual(transferViewModel.background, false)
        XCTAssertEqual(transferViewModel.duration, "A 4 minutes walk")
    }
    
    func testCrowFlyStepView() {
        guard let crowFlyViewModel = viewModelRoadmap.sections?[sectionIndex.crowFly] else {
            XCTFail("Error json String")
            return
        }
        
        XCTAssertEqual(crowFlyViewModel.type, .crowFly)
        XCTAssertEqual(crowFlyViewModel.mode, .walking)
        XCTAssertEqual(crowFlyViewModel.from, "Gare de Lyon (Paris)")
        XCTAssertEqual(crowFlyViewModel.to, "Gare de Lyon (Paris)")
        XCTAssertEqual(crowFlyViewModel.startTime, "17:11")
        XCTAssertEqual(crowFlyViewModel.endTime, "17:11")
        XCTAssertEqual(crowFlyViewModel.actionDescription, "To")
        XCTAssertEqual(crowFlyViewModel.path?.count, 0)
        XCTAssertEqual(crowFlyViewModel.stopDate.count, 0)
        XCTAssertNotNil(crowFlyViewModel.displayInformations) // TODO: Set with nil
        XCTAssertNil(crowFlyViewModel.waiting)
        XCTAssertEqual(crowFlyViewModel.disruptionsClean.count, 0)
        XCTAssertEqual(crowFlyViewModel.notes.count, 0)
        XCTAssertNil(crowFlyViewModel.poi)
        XCTAssertEqual(crowFlyViewModel.icon, "crow_fly")
        XCTAssertEqual(crowFlyViewModel.bssRealTime, false)
        XCTAssertEqual(crowFlyViewModel.background, false)
        XCTAssertNil(crowFlyViewModel.duration)
    }
    
    func testPublicTransportStepView() {
        guard let publicTransportViewModel = viewModelRoadmap.sections?[sectionIndex.publicTransport] else {
            XCTFail("Error json String")
            return
        }
        
        XCTAssertEqual(publicTransportViewModel.type, .publicTransport)
        XCTAssertNil(publicTransportViewModel.mode)
        XCTAssertEqual(publicTransportViewModel.from, "Gare de Lyon (Paris)")
        XCTAssertEqual(publicTransportViewModel.to, "Esplanade de la Défense (Courbevoie)")
        XCTAssertEqual(publicTransportViewModel.startTime, "17:11")
        XCTAssertEqual(publicTransportViewModel.endTime, "17:35")
        XCTAssertEqual(publicTransportViewModel.actionDescription, "Take the Métro")
        XCTAssertEqual(publicTransportViewModel.path?.count, 0)
        XCTAssertEqual(publicTransportViewModel.stopDate.count, 16)
        XCTAssertNotNil(publicTransportViewModel.displayInformations)
        XCTAssertEqual(publicTransportViewModel.waiting, "Wait 3 minutes")
        XCTAssertEqual(publicTransportViewModel.disruptionsClean.count, 0)
        XCTAssertEqual(publicTransportViewModel.notes.count, 0)
        XCTAssertNil(publicTransportViewModel.poi)
        XCTAssertEqual(publicTransportViewModel.icon, "metro")
        XCTAssertEqual(publicTransportViewModel.bssRealTime, false)
        XCTAssertEqual(publicTransportViewModel.background, true)
        XCTAssertNil(publicTransportViewModel.duration)
    }
    
    func testOnDemandTransportStepView() {
        guard let onDemandTransportViewModel = viewModelRoadmap.sections?[sectionIndex.onDemandeTransport] else {
            XCTFail("Error json String")
            return
        }
        
        XCTAssertEqual(onDemandTransportViewModel.type, .onDemandTransport)
        XCTAssertNil(onDemandTransportViewModel.mode)
        XCTAssertEqual(onDemandTransportViewModel.from, "EGLISE DE SAINT CLEMENT (Saint-Clément-de-la-Place)")
        XCTAssertEqual(onDemandTransportViewModel.to, "MAIRIE DE BEAUCOUZE (Beaucouzé)")
        XCTAssertEqual(onDemandTransportViewModel.startTime, "18:00")
        XCTAssertEqual(onDemandTransportViewModel.endTime, "18:20")
        XCTAssertEqual(onDemandTransportViewModel.actionDescription, "Take the Bus")
        XCTAssertEqual(onDemandTransportViewModel.path?.count, 0)
        XCTAssertEqual(onDemandTransportViewModel.stopDate.count, 1)
        XCTAssertNotNil(onDemandTransportViewModel.displayInformations)
        XCTAssertEqual(onDemandTransportViewModel.waiting, "Wait 33 minutes")
        XCTAssertEqual(onDemandTransportViewModel.disruptionsClean.count, 0)
        XCTAssertEqual(onDemandTransportViewModel.notes.count, 0)
        XCTAssertNil(onDemandTransportViewModel.poi)
        XCTAssertEqual(onDemandTransportViewModel.icon, "bus-tad")
        XCTAssertEqual(onDemandTransportViewModel.bssRealTime, false)
        XCTAssertEqual(onDemandTransportViewModel.background, true)
        XCTAssertNil(onDemandTransportViewModel.duration)
    }
}
