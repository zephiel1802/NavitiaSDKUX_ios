//
//  ListRidesharingOffersInteractorTests.swift
//  NavitiaSDKUITests
//
//  Copyright © 2018 kisio. All rights reserved.
//

import XCTest
@testable import NavitiaSDKUI

class ListRidesharingOffersInteractorTests: XCTestCase {
    
    // MARK: - Subject under test
    
    var sut: ListRidesharingOffersInteractor!
    
    override func setUp() {
        super.setUp()
        
        setupListRidesharingOffersInteractor()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - Test setup
    
    func setupListRidesharingOffersInteractor() {
        sut = ListRidesharingOffersInteractor()
    }
    
    // MARK: - Test doubles
    
    class ListRidesharingOffersPresentationLogicSpy: ListRidesharingOffersPresentationLogic {
        var presentRidesharingOffersCalled = false

        func presentRidesharingOffers(response: ListRidesharingOffers.GetRidesharingOffers.Response) {
            presentRidesharingOffersCalled = true
        }
    }
    
    // MARK: - Tests
    
    func testFetchJourneysShouldAskNavitiaWorkerToFetchJourneysAndPresenterToFormatResult() {
        let listRidesharingOffersPresentationLogicSpy = ListRidesharingOffersPresentationLogicSpy()
        sut.presenter = listRidesharingOffersPresentationLogicSpy
        sut.journey = Journey()
        sut.context = Context()
        
        let request = ListRidesharingOffers.GetRidesharingOffers.Request()
        sut.getRidesharingOffers(request: request)
        
        XCTAssert(listRidesharingOffersPresentationLogicSpy.presentRidesharingOffersCalled, "GetRidesharingOffers() should ask presenter to format journeys")
    }
}
