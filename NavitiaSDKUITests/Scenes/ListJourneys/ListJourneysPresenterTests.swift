//
//  ListJourneysPresenterTests.swift
//  NavitiaSDKUITests
//
//  Copyright © 2018 kisio. All rights reserved.
//

import XCTest
@testable import NavitiaSDKUI

class ListJourneysPresenterTests: XCTestCase {
    
    // MARK: - Subject under test
    
    var sut: ListJourneysPresenter!
    var seeds: Seeds!
    
    // MARK: - Test lifecycle
    
    override func setUp() {
        super.setUp()
        setupListJourneysPresenter()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - Test setup
    
    func setupListJourneysPresenter() {
        NavitiaSDKUI.shared.bundle = Bundle(identifier: "org.kisio.NavitiaSDKUI")
        
        sut = ListJourneysPresenter()
        seeds = Seeds()
    }
    
    // MARK: - Test doubles
    
    class ListJourneysDisplayLogicSpy: ListJourneysDisplayLogic {
        var callbackFetchedPhysicalModesJourneysCalled = false
        var displaySearchJourneysCalled = false
        var displayFetchedJourneysCalled = false
        var fetchPhysicalModesViewModel: ListJourneys.FetchPhysicalModes.ViewModel!
        var displaySearchViewModel: ListJourneys.DisplaySearch.ViewModel!
        var fetchJourneysViewModel: ListJourneys.FetchJourneys.ViewModel!
        
        func callbackFetchedPhysicalModes(viewModel: ListJourneys.FetchPhysicalModes.ViewModel) {
            callbackFetchedPhysicalModesJourneysCalled = true
            self.fetchPhysicalModesViewModel = viewModel
        }
        
        func displaySearch(viewModel: ListJourneys.DisplaySearch.ViewModel) {
            displaySearchJourneysCalled = true
            self.displaySearchViewModel = viewModel
        }
        
        func displayFetchedJourneys(viewModel: ListJourneys.FetchJourneys.ViewModel) {
            displayFetchedJourneysCalled = true
            self.fetchJourneysViewModel = viewModel
        }
        
    }
    
    // MARK: - Tests
    
    func testPresent() {
        let listJourneysDisplayLogicSpy = ListJourneysDisplayLogicSpy()
        sut.viewController = listJourneysDisplayLogicSpy
        
        let journeysRequest = JourneysRequest(coverage: "fr-idf")
        journeysRequest.originId = "2.3665844;48.8465337"
        journeysRequest.originName = "Home"
        journeysRequest.destinationId = "2.2979169;48.8848719"
        journeysRequest.destinationName = "Destination"
    }
    
    func testPresentFetchedOrdersShouldFormatFetchedOrdersForDisplay() {
        let listJourneysDisplayLogicSpy = ListJourneysDisplayLogicSpy()
        sut.viewController = listJourneysDisplayLogicSpy
        let journeysRequest = JourneysRequest(coverage: "fr-idf")
        journeysRequest.originId = "2.3665844;48.8465337"
        journeysRequest.destinationId = "2.2979169;48.8848719"
        
        let response = ListJourneys.FetchJourneys.Response(journeysRequest: journeysRequest,
                                                           journeys: (seeds.journeys, withRidesharing: seeds.ridesharing),
                                                           disruptions: seeds.disruptions)
        
        sut.presentFetchedJourneys(response: response)
        guard let viewModel = listJourneysDisplayLogicSpy.fetchJourneysViewModel else {
            XCTFail("Error json String")
            
            return
        }
        
        XCTAssertEqual(viewModel.displayedJourneys.count, 2)
        XCTAssertEqual(viewModel.displayedRidesharings.count, 1)
    }
    
    func testPresentFetchedOrdersShouldAskViewControllerToDisplayFetchedOrders() {
        let listJourneysDisplayLogicSpy = ListJourneysDisplayLogicSpy()
        sut.viewController = listJourneysDisplayLogicSpy
        
        let journeysRequest = JourneysRequest(coverage: "fr-idf")
        
        let response = ListJourneys.FetchJourneys.Response(journeysRequest: journeysRequest,
                                                           journeys: (nil, withRidesharing: nil),
                                                           disruptions: nil)
        sut.presentFetchedJourneys(response: response)
        
        XCTAssert(listJourneysDisplayLogicSpy.displayFetchedJourneysCalled, "Presenting fetched orders should ask view controller to display them")
    }
}
