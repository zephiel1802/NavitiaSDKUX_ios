//
//  ShowJourneyRoadmapPresenterTests.swift
//  NavitiaSDKUITests
//
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
                                                              journeyPriceModel: nil,
                                                              disruptions: seeds.disruptions,
                                                              notes: seeds.notes,
                                                              context: context,
                                                              navitiaTickets: nil,
                                                              maasOrderId: 0,
                                                              maasTickets: [],
                                                              totalPrice: (1.0, "Euros"))
        
        return response
    }
    
    private func getViewModelRoadmap() -> ShowJourneyRoadmap.GetRoadmap.ViewModel? {
        let showJourneyRoadmapDisplayLogicSpy = ShowJourneyRoadmapDisplayLogicSpy()
        sut.viewController = showJourneyRoadmapDisplayLogicSpy
        
        guard let response = getRoadmapResponse() else {
            XCTFail("getRoadmapResponse() - Error")
            
            return nil
        }
        
        sut.presentRoadmap(response: response)
        
        return showJourneyRoadmapDisplayLogicSpy.viewModelRoadmap
    }
    
    func testRidesharing() {}
    
    func testDepartureStep() {
        let departureViewModel = viewModelRoadmap.departure
        
        XCTAssertEqual(departureViewModel.time, "17:05")
        XCTAssertEqual(departureViewModel.mode, .departure)
        XCTAssertEqual(departureViewModel.information.0, "Departure :\n")
        XCTAssertEqual(departureViewModel.information.1, "20 rue Hector Malot (Paris)")
        XCTAssertNil(departureViewModel.calorie)
    }
    
    func testArrivalStep() {
        let arrivalViewModel = viewModelRoadmap.arrival
        
        XCTAssertEqual(arrivalViewModel.time, "17:14")
        XCTAssertEqual(arrivalViewModel.mode, .arrival)
        XCTAssertEqual(arrivalViewModel.information.0, "Arrival :\n")
        XCTAssertEqual(arrivalViewModel.information.1, "MAIRIE DE BEAUCOUZE (Beaucouzé)")
        XCTAssertEqual(arrivalViewModel.calorie, "36")
    }
    
    func testEmissionStep() {
        let emissionViewModel = viewModelRoadmap.emission
        
        XCTAssertEqual(emissionViewModel.car?.value, 2.5681999)
        XCTAssertEqual(emissionViewModel.car?.unit, "Kg CO2")
        XCTAssertEqual(emissionViewModel.journey.value, 0)
        XCTAssertEqual(emissionViewModel.journey.unit, "g CO2")
    }
    
    func testPaths() {
        guard let pathViewMode = viewModelRoadmap.sections?[sectionIndex.walking].path else {
            XCTFail("Get path for walking section - Error")
            
            return
        }
        
        XCTAssertEqual(pathViewMode[0].directionIcon, "arrow_straight_direction")
        XCTAssertEqual(pathViewMode[0].instruction, "Continue on avenue Daumesnil for 125m")
        XCTAssertEqual(pathViewMode[1].directionIcon, "arrow_right_direction")
        XCTAssertEqual(pathViewMode[1].instruction, "Turn right on rue Abel in 125m")
        XCTAssertEqual(pathViewMode[2].directionIcon, "arrow_left_direction")
        XCTAssertEqual(pathViewMode[2].instruction, "Turn left on rue de Prague in 260m")
    }
    
    func testStands() {
        guard let standsViewModel = viewModelRoadmap.sections?[sectionIndex.bssRentStands].poi?.stands else {
            XCTFail("Get stands for bss rent section - Error")
            
            return
        }
        
        XCTAssertEqual(standsViewModel.availability, "11 available bikes")
        XCTAssertNil(standsViewModel.icon)
    }
    
    func testPoi() {
        guard let poiViewModel = viewModelRoadmap.sections?[sectionIndex.bssRentStands].poi else {
            XCTFail("Get poi for bss rent section - Error")
            
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
            XCTFail("Get display informations for public transport - Error")
            
            return
        }
        
        XCTAssertEqual(displayInformationsViewModel.commercialMode, "Métro")
        XCTAssertEqual(displayInformationsViewModel.directionTransit, "La Défense (Grande Arche) (Puteaux)")
        XCTAssertEqual(displayInformationsViewModel.code, "1")
        XCTAssertEqual(displayInformationsViewModel.network, "METRO")
    }
    
    func testWalkingStepsView() {
        guard let walkingViewModel = viewModelRoadmap.sections?[sectionIndex.walking],
            let walkingTwoViewModel = viewModelRoadmap.sections?[sectionIndex.walkingTwo],
            let walkingThreeViewModel = viewModelRoadmap.sections?[sectionIndex.walkingThree] else {
            XCTFail("Get view models for walking section - Error")
                
            return
        }

        XCTAssertEqual(walkingViewModel.type, .streetNetwork)
        XCTAssertEqual(walkingViewModel.mode, .walking)
        XCTAssertEqual(walkingViewModel.to, "89 avenue Ledru Rollin (Paris)")
        XCTAssertEqual(walkingViewModel.actionDescription, "To")
        XCTAssertEqual(walkingViewModel.path?.count, 5)
        XCTAssertEqual(walkingViewModel.icon, "walking")
        XCTAssertEqual(walkingViewModel.realTime, false)
        XCTAssertEqual(walkingViewModel.background, false)
        XCTAssertEqual(walkingViewModel.duration, "A 8 minute walk")
        XCTAssertEqual(walkingTwoViewModel.duration, "A 1 minute walk")
        XCTAssertEqual(walkingThreeViewModel.duration, "Less than a minute walk")
        XCTAssertNil(walkingViewModel.waiting)
        XCTAssertNil(walkingViewModel.poi)
        
        // TODO: Set with nil
        XCTAssertEqual(walkingViewModel.from, "20 rue Hector Malot (Paris)")
        XCTAssertEqual(walkingViewModel.startTime, "17:05")
        XCTAssertEqual(walkingViewModel.endTime, "17:14")
        XCTAssertEqual(walkingViewModel.stopDate.count, 0)
        XCTAssertEqual(walkingViewModel.disruptions.count, 0)
        XCTAssertEqual(walkingViewModel.notes.count, 0)
        XCTAssertNotNil(walkingViewModel.displayInformations)
    }
    
    func testBikeStepsView() {
        guard let bikeViewModel = viewModelRoadmap.sections?[sectionIndex.bike],
            let bikeTwoViewModel = viewModelRoadmap.sections?[sectionIndex.bikeTwo],
            let bikeThreeViewModel = viewModelRoadmap.sections?[sectionIndex.bikeThree] else {
            XCTFail("Get view models for bike section - Error")
                
            return
        }
        
        XCTAssertEqual(bikeViewModel.type, .streetNetwork)
        XCTAssertEqual(bikeViewModel.mode, .bike)
        XCTAssertEqual(bikeViewModel.to, "Cinema Mk2 Bastille (Paris)")
        XCTAssertEqual(bikeViewModel.actionDescription, "To")
        XCTAssertEqual(bikeViewModel.path?.count, 3)
        XCTAssertEqual(bikeViewModel.icon, "bike")
        XCTAssertEqual(bikeViewModel.realTime, false)
        XCTAssertEqual(bikeViewModel.background, false)
        XCTAssertEqual(bikeViewModel.duration, "A 2 minute ride")
        XCTAssertEqual(bikeTwoViewModel.duration, "A 1 minute ride")
        XCTAssertEqual(bikeThreeViewModel.duration, "Less than a minute ride")
        XCTAssertNil(bikeViewModel.waiting)
        XCTAssertNil(bikeViewModel.poi)

        // TODO: Set with nil
        XCTAssertEqual(bikeViewModel.disruptions.count, 0)
        XCTAssertEqual(bikeViewModel.notes.count, 0)
        XCTAssertEqual(bikeViewModel.stopDate.count, 0)
        XCTAssertEqual(bikeViewModel.startTime, "17:06")
        XCTAssertEqual(bikeViewModel.endTime, "17:09")
        XCTAssertEqual(bikeViewModel.from, "89 avenue Ledru Rollin (Paris)")
        XCTAssertNotNil(bikeViewModel.displayInformations)
    }
    
    func testCarStepsView() {
        guard let carViewModel = viewModelRoadmap.sections?[sectionIndex.car],
            let carTwoViewModel = viewModelRoadmap.sections?[sectionIndex.carTwo],
            let carThreeViewModel = viewModelRoadmap.sections?[sectionIndex.carThree] else {
            XCTFail("Get view models for car section - Error")
                
            return
        }
        
        XCTAssertEqual(carViewModel.type, .streetNetwork)
        XCTAssertEqual(carViewModel.mode, .car)
        XCTAssertEqual(carViewModel.to, "Parc relais Henri Fréville")
        XCTAssertEqual(carViewModel.actionDescription, "To")
        XCTAssertEqual(carViewModel.path?.count, 17)
        XCTAssertEqual(carViewModel.icon, "car")
        XCTAssertEqual(carViewModel.realTime, false)
        XCTAssertEqual(carViewModel.background, false)
        XCTAssertEqual(carViewModel.duration, "A 3 minute drive")
        XCTAssertEqual(carTwoViewModel.duration, "A 1 minute drive")
        XCTAssertEqual(carThreeViewModel.duration, "Less than a minute drive")
        XCTAssertNil(carViewModel.waiting)
        XCTAssertNotNil(carViewModel.poi)

        // TODO: Set with nil
        XCTAssertEqual(carViewModel.from, "Gares (Rennes)")
        XCTAssertEqual(carViewModel.stopDate.count, 0)
        XCTAssertEqual(carViewModel.disruptions.count, 0)
        XCTAssertEqual(carViewModel.notes.count, 0)
        XCTAssertEqual(carViewModel.startTime, "10:08")
        XCTAssertEqual(carViewModel.endTime, "10:11")
        XCTAssertNotNil(carViewModel.displayInformations)
    }
    
    func testRidesharingStepView() {}
    
    func testBssRentStepsView() {
        guard let bssRentStandsViewModel = viewModelRoadmap.sections?[sectionIndex.bssRentStands],
            let bssRentViewModel = viewModelRoadmap.sections?[sectionIndex.bssRent] else {
            XCTFail("Get view models for bss rent section - Error")
                
            return
        }
        
        XCTAssertEqual(bssRentStandsViewModel.type, .bssRent)
        XCTAssertEqual(bssRentStandsViewModel.to, "Gare Dijon Ville (Dijon)")
        XCTAssertEqual(bssRentStandsViewModel.actionDescription, "Take a DiviaVélodi bike at")
        XCTAssertEqual(bssRentStandsViewModel.icon, "bss")
        XCTAssertEqual(bssRentStandsViewModel.background, true)
        XCTAssertEqual(bssRentStandsViewModel.realTime, false)
        XCTAssertEqual(bssRentViewModel.realTime, false)
        XCTAssertNotNil(bssRentStandsViewModel.poi)
        XCTAssertNotNil(bssRentStandsViewModel.poi?.stands)
        XCTAssertNil(bssRentStandsViewModel.mode)
        XCTAssertNil(bssRentStandsViewModel.waiting)
        XCTAssertNil(bssRentViewModel.poi?.stands)
        
        // TODO: Set with nil
        XCTAssertEqual(bssRentStandsViewModel.from, " (Dijon)")
        XCTAssertEqual(bssRentStandsViewModel.startTime, "10:12")
        XCTAssertEqual(bssRentStandsViewModel.endTime, "10:14")
        XCTAssertEqual(bssRentStandsViewModel.path?.count, 0)
        XCTAssertEqual(bssRentStandsViewModel.stopDate.count, 0)
        XCTAssertEqual(bssRentStandsViewModel.disruptions.count, 0)
        XCTAssertEqual(bssRentStandsViewModel.notes.count, 0)
        XCTAssertNotNil(bssRentStandsViewModel.displayInformations)
    }
    
    func testBssPutBackStepsView() {
        guard let bssPutBackStandsViewModel = viewModelRoadmap.sections?[sectionIndex.bssPutBackStands],
            let bssPutBackViewModel = viewModelRoadmap.sections?[sectionIndex.bssPutBack] else {
            XCTFail("Get view models for bss put back section - Error")
                
            return
        }
        
        XCTAssertEqual(bssPutBackStandsViewModel.type, .bssPutBack)
        XCTAssertEqual(bssPutBackStandsViewModel.to, "14 Cours du Général de Gaulle (Dijon)")
        XCTAssertEqual(bssPutBackStandsViewModel.actionDescription, "Dock the DiviaVélodi bike at")
        XCTAssertEqual(bssPutBackStandsViewModel.icon, "bss")
        XCTAssertEqual(bssPutBackStandsViewModel.background, true)
        XCTAssertEqual(bssPutBackStandsViewModel.realTime, false)
        XCTAssertEqual(bssPutBackViewModel.realTime, false)
        XCTAssertNotNil(bssPutBackStandsViewModel.poi)
        XCTAssertNotNil(bssPutBackStandsViewModel.poi?.stands)
        XCTAssertNil(bssPutBackViewModel.poi?.stands)
        XCTAssertNil(bssPutBackStandsViewModel.mode)
        XCTAssertNil(bssPutBackStandsViewModel.waiting)
        XCTAssertNil(bssPutBackStandsViewModel.poi?.stands?.icon)
        
        // TODO: Set with nil
        XCTAssertEqual(bssPutBackStandsViewModel.from, "Général de Gaulle - Clinique (Dijon)")
        XCTAssertEqual(bssPutBackStandsViewModel.startTime, "10:23")
        XCTAssertEqual(bssPutBackStandsViewModel.endTime, "10:24")
        XCTAssertEqual(bssPutBackStandsViewModel.path?.count, 0)
        XCTAssertEqual(bssPutBackStandsViewModel.stopDate.count, 0)
        XCTAssertEqual(bssPutBackStandsViewModel.disruptions.count, 0)
        XCTAssertEqual(bssPutBackStandsViewModel.notes.count, 0)
        XCTAssertNotNil(bssPutBackStandsViewModel.displayInformations)
    }
    
    func testTransferStepView() {
        guard let transferViewModel = viewModelRoadmap.sections?[sectionIndex.transfer] else {
            XCTFail("Get view model for transfer section - Error")
            
            return
        }
        
        XCTAssertEqual(transferViewModel.type, .transfer)
        XCTAssertEqual(transferViewModel.to, "La Défense (Grande Arche) (Puteaux)")
        XCTAssertEqual(transferViewModel.actionDescription, "To")
        XCTAssertEqual(transferViewModel.icon, "walking")
        XCTAssertEqual(transferViewModel.realTime, false)
        XCTAssertEqual(transferViewModel.background, false)
        XCTAssertEqual(transferViewModel.duration, "A 4 minute walk")
        XCTAssertNil(transferViewModel.mode)
        XCTAssertNil(transferViewModel.waiting)
        
        // TODO: Set with nil
        XCTAssertEqual(transferViewModel.from, "GARE DE LA DEFENSE RER A (Puteaux)")
        XCTAssertEqual(transferViewModel.startTime, "17:27")
        XCTAssertEqual(transferViewModel.endTime, "17:31")
        XCTAssertEqual(transferViewModel.path?.count, 0)
        XCTAssertEqual(transferViewModel.stopDate.count, 0)
        XCTAssertEqual(transferViewModel.disruptions.count, 0)
        XCTAssertEqual(transferViewModel.notes.count, 0)
        XCTAssertNotNil(transferViewModel.displayInformations)
        XCTAssertNil(transferViewModel.poi)
    }
    
    func testCrowFlyStepView() {
        guard let crowFlyViewModel = viewModelRoadmap.sections?[sectionIndex.crowFly] else {
            XCTFail("Get view model for crow fly section - Error")
            
            return
        }
        
        XCTAssertEqual(crowFlyViewModel.type, .crowFly)
        XCTAssertEqual(crowFlyViewModel.mode, .walking)
        XCTAssertEqual(crowFlyViewModel.to, "Gare de Lyon (Paris)")
        XCTAssertEqual(crowFlyViewModel.actionDescription, "To")
        XCTAssertEqual(crowFlyViewModel.icon, "crow_fly")
        XCTAssertEqual(crowFlyViewModel.realTime, false)
        XCTAssertEqual(crowFlyViewModel.background, false)
        XCTAssertNil(crowFlyViewModel.waiting)
        XCTAssertNil(crowFlyViewModel.duration)
        XCTAssertNil(crowFlyViewModel.poi)
        
        // TODO: Set with nil
        XCTAssertEqual(crowFlyViewModel.from, "Gare de Lyon (Paris)")
        XCTAssertEqual(crowFlyViewModel.startTime, "17:11")
        XCTAssertEqual(crowFlyViewModel.endTime, "17:11")
        XCTAssertEqual(crowFlyViewModel.path?.count, 0)
        XCTAssertEqual(crowFlyViewModel.stopDate.count, 0)
        XCTAssertEqual(crowFlyViewModel.disruptions.count, 0)
        XCTAssertEqual(crowFlyViewModel.notes.count, 0)
        XCTAssertNotNil(crowFlyViewModel.displayInformations)
    }
    
    func testPublicTransportStepView() {
        guard let publicTransportViewModel = viewModelRoadmap.sections?[sectionIndex.publicTransport] else {
            XCTFail("Get view model for public transport section - Error")
            
            return
        }
        
        XCTAssertEqual(publicTransportViewModel.type, .publicTransport)
        XCTAssertEqual(publicTransportViewModel.from, "Gare de Lyon (Paris)")
        XCTAssertEqual(publicTransportViewModel.to, "Esplanade de la Défense (Courbevoie)")
        XCTAssertEqual(publicTransportViewModel.startTime, "17:11")
        XCTAssertEqual(publicTransportViewModel.endTime, "17:35")
        XCTAssertEqual(publicTransportViewModel.actionDescription, "Take the Métro")
        XCTAssertEqual(publicTransportViewModel.stopDate.count, 16)
        XCTAssertEqual(publicTransportViewModel.waiting, "Wait 3 minutes")
        XCTAssertEqual(publicTransportViewModel.disruptions.count, 0)
        XCTAssertEqual(publicTransportViewModel.notes.count, 0)
        XCTAssertEqual(publicTransportViewModel.icon, "metro")
        XCTAssertEqual(publicTransportViewModel.realTime, false)
        XCTAssertEqual(publicTransportViewModel.background, true)
        XCTAssertNotNil(publicTransportViewModel.displayInformations)
        XCTAssertNil(publicTransportViewModel.mode)
        XCTAssertNil(publicTransportViewModel.duration)
        XCTAssertNil(publicTransportViewModel.poi)
        
        // TODO: Set with nil
        XCTAssertEqual(publicTransportViewModel.path?.count, 0)
    }
    
    func testOnDemandTransportStepView() {
        guard let onDemandTransportViewModel = viewModelRoadmap.sections?[sectionIndex.onDemandeTransport] else {
            XCTFail("Get view model for on demand transport section - Error")
            
            return
        }
        
        XCTAssertEqual(onDemandTransportViewModel.type, .onDemandTransport)
        XCTAssertEqual(onDemandTransportViewModel.from, "EGLISE DE SAINT CLEMENT (Saint-Clément-de-la-Place)")
        XCTAssertEqual(onDemandTransportViewModel.to, "MAIRIE DE BEAUCOUZE (Beaucouzé)")
        XCTAssertEqual(onDemandTransportViewModel.startTime, "18:00")
        XCTAssertEqual(onDemandTransportViewModel.endTime, "18:20")
        XCTAssertEqual(onDemandTransportViewModel.actionDescription, "Take the Bus")
        XCTAssertEqual(onDemandTransportViewModel.path?.count, 0)
        XCTAssertEqual(onDemandTransportViewModel.stopDate.count, 1)
        XCTAssertEqual(onDemandTransportViewModel.waiting, "Wait 33 minutes")
        XCTAssertEqual(onDemandTransportViewModel.disruptions.count, 0)
        XCTAssertEqual(onDemandTransportViewModel.notes.count, 0)
        XCTAssertEqual(onDemandTransportViewModel.icon, "bus-tad")
        XCTAssertEqual(onDemandTransportViewModel.realTime, false)
        XCTAssertEqual(onDemandTransportViewModel.background, true)
        XCTAssertNotNil(onDemandTransportViewModel.displayInformations)
        XCTAssertNil(onDemandTransportViewModel.duration)
        XCTAssertNil(onDemandTransportViewModel.mode)
        XCTAssertNil(onDemandTransportViewModel.poi)
        
        // TODO: Set with nil
        XCTAssertEqual(onDemandTransportViewModel.path?.count, 0)
    }
}
