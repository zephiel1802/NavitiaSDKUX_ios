//
//  ListRidesharingOffersPresenterTests.swift
//  NavitiaSDKUITests
//
//  Copyright © 2018 kisio. All rights reserved.
//

import XCTest
@testable import NavitiaSDKUI

class ListRidesharingOffersPresenterTests: XCTestCase {
    
    // MARK: - Subject under test
    
    var sut: ListRidesharingOffersPresenter!
    var seeds: Seeds!
    
    // MARK: - Test lifecycle
    
    override func setUp() {
        super.setUp()
        
        setupNavitiaSDKUI()
        setupListRidesharingOffersPresenter()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - Test setup
    
    func setupNavitiaSDKUI() {
        NavitiaSDKUI.shared.bundle = Bundle(identifier: "org.kisio.NavitiaSDKUI")
    }
    
    func setupListRidesharingOffersPresenter() {
        sut = ListRidesharingOffersPresenter()
        seeds = Seeds()
    }
    
    // MARK: - Test doubles
    
    class ListRidesharingOffersDisplayLogicSpy: ListRidesharingOffersDisplayLogic {
        
        var displayRidesharingOffersCalled = false
        var viewModel: ListRidesharingOffers.GetRidesharingOffers.ViewModel!
        
        func displayRidesharingOffers(viewModel: ListRidesharingOffers.GetRidesharingOffers.ViewModel) {
            displayRidesharingOffersCalled = true
            self.viewModel = viewModel
        }
    }
    
    private func getRidesharingOfferstResponse() -> ListRidesharingOffers.GetRidesharingOffers.Response? {
        guard let journey = seeds.ridesharing?.first, let context = seeds.context else {
            return nil
        }
        
        let ridesharingJourneys = ListRidesharingOffersInteractor().getRidesharingJourneys(journeySections: journey.sections)
        let response = ListRidesharingOffers.GetRidesharingOffers.Response(journey: journey,
                                                                           ridesharingJourneys: ridesharingJourneys,
                                                                           disruptions: seeds.disruptions,
                                                                           notes: seeds.notes,
                                                                           context: context)
        
        return response
    }
    
    func testDisplayedRidesharingOffer() {
        let listRidesharingOffersDisplayLogicSpy = ListRidesharingOffersDisplayLogicSpy()
        sut.viewController = listRidesharingOffersDisplayLogicSpy
        
        guard let response = getRidesharingOfferstResponse() else {
            XCTFail("getRidesharingOfferstResponse() - Error")
            
            return
        }
        
        sut.presentRidesharingOffers(response: response)
        
        guard let viewModel = listRidesharingOffersDisplayLogicSpy.viewModel else {
            XCTFail("Get view model for ridesharing offers - Error")
            
            return
        }
        
        XCTAssertEqual(viewModel.displayedRidesharingOffers.count, 8)
        
        if let first = viewModel.displayedRidesharingOffers.first {
            XCTAssertEqual(first.network, "STAR Covoiturage")
            XCTAssertEqual(first.departure, "16h30")
            XCTAssertEqual(first.driverPictureURL, "https://dummyimage.com/128x128/B2EBF2/000.png?text=NP")
            XCTAssertEqual(first.driverNickname, "Nicolas  P.")
            XCTAssertEqual(first.driverGender, "male")
            XCTAssertEqual(first.rating, 0)
            XCTAssertEqual(first.ratingCount, 0)
            XCTAssertEqual(first.seatsCount, 4)
            XCTAssertEqual(first.price, "0.0")
        }
    }
    
    func testPresentFetchedOrdersShouldAskViewControllerToDisplayFetchedOrders() {
        let listRidesharingOffersDisplayLogicSpy = ListRidesharingOffersDisplayLogicSpy()
        sut.viewController = listRidesharingOffersDisplayLogicSpy
        
        guard let response = getRidesharingOfferstResponse() else {
            XCTFail("getRidesharingOfferstResponse() - Error")
            
            return
        }

        sut.presentRidesharingOffers(response: response)
        
        XCTAssert(listRidesharingOffersDisplayLogicSpy.displayRidesharingOffersCalled, "Presenting fetched orders should ask view controller to display them")
    }
}
