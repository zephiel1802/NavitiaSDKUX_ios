//
//  ListJourneysViewControllerTests.swift
//  NavitiaSDKUITests
//
//  Copyright © 2018 kisio. All rights reserved.
//

import XCTest
import UIKit
@testable import NavitiaSDKUI

class ListJourneysViewControllerTests: XCTestCase {
    
    var sut: ListJourneysViewController!
    var storyboard: UIStoryboard!
    
    override func setUp() {
        super.setUp()
        
        setupNavitiaSDKUI()
        setupListJourneysViewController()
    }
    
    func setupNavitiaSDKUI() {
        NavitiaSDKUI.shared.bundle = Bundle(identifier: "org.kisio.NavitiaSDKUI")
        NavitiaSDKUI.shared.originColor = UIColor.blue
        NavitiaSDKUI.shared.destinationColor = UIColor.brown
    }
    
    func setupListJourneysViewController() {
        storyboard = UIStoryboard(name: "Journey", bundle: NavitiaSDKUI.shared.bundle)
        sut = storyboard.instantiateInitialViewController() as! ListJourneysViewController
        
        let journeysRequest = JourneysRequest(coverage: "fr-idf")
        journeysRequest.originId = "2.3665844;48.8465337"
        journeysRequest.destinationId = "2.2979169;48.8848719"
        
        sut.journeysRequest = journeysRequest
        
        _ = sut.view
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testSUT_CanInstantiateViewController() {
        XCTAssertNotNil(sut)
    }
    
    func testSUT_CollectionViewIsNotNilAfterViewDidLoad() {
        XCTAssertNotNil(sut.journeysCollectionView)
        XCTAssertEqual(sut.journeysCollectionView.numberOfSections, 1)
    }
    
    func testColorHeader() {
        XCTAssertEqual(sut.searchView.originPinImageView.tintColor, .blue)
        XCTAssertEqual(sut.searchView.destinationPinImageView.tintColor, .brown)
    }
}
