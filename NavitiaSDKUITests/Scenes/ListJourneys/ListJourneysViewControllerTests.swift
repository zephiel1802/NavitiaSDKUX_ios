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
        
        sut.journeysRequest = JourneysRequest(originId: "2.3665844;48.8465337", destinationId: "2.2979169;48.8848719")
        
        _ = sut.view
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSUT_CanInstantiateViewController() {
        XCTAssertNotNil(sut)
    }
    
    func testSUT_CollectionViewIsNotNilAfterViewDidLoad() {
        XCTAssertNotNil(sut.journeysCollectionView)

       // sut.viewDidLoad()
        XCTAssertEqual(sut.journeysCollectionView.numberOfSections, 1)
    }
    
    func testLoad() {
        var journeysRequest = JourneysRequest(originId: "2.3665844;48.8465337", destinationId: "2.2979169;48.8848719")
        journeysRequest.originLabel = "Chez moi"
        journeysRequest.destinationLabel = "Au travail"
        
        sut.journeysRequest = journeysRequest
        sut.viewDidLoad()
        XCTAssertEqual(sut.journeysCollectionView.numberOfSections, 1)
    }
    
    func testColorHeader() {
        XCTAssertEqual(sut.fromPinLabel.textColor, .blue)
        XCTAssertEqual(sut.toPinLabel.textColor, .brown)
    }
    
    func testHeaderSearch() {
        XCTAssertEqual(sut.fromLabel.text, "2.3665844;48.8465337")
        XCTAssertEqual(sut.toLabel.text, "2.2979169;48.8848719")
        
        var journeysRequest = JourneysRequest(originId: "2.3665844;48.8465337", destinationId: "2.2979169;48.8848719")
        journeysRequest.originLabel = "Chez moi"
        journeysRequest.destinationLabel = "Au travail"
        
        sut.journeysRequest = journeysRequest
        sut.viewDidLoad()

        XCTAssertEqual(sut.fromLabel.text, "Chez moi")
        XCTAssertEqual(sut.toLabel.text, "Au travail")

        journeysRequest.originLabel = "Chez moi2"
        journeysRequest.destinationLabel = "Au travail2"
        
        sut.journeysRequest = journeysRequest
        sut.viewDidLoad()

        XCTAssertEqual(sut.fromLabel.text, "Chez moi2")
        XCTAssertEqual(sut.toLabel.text, "Au travail2")
    }
    
    func testHeaderSearch2() {
        XCTAssertEqual(sut.fromLabel.text, "2.3665844;48.8465337")
        XCTAssertEqual(sut.toLabel.text, "2.2979169;48.8848719")
        
        var journeysRequest = JourneysRequest(originId: "2.3665844;48.8465337", destinationId: "2.2979169;48.8848719")
        journeysRequest.originLabel = "Chez moi23"
        journeysRequest.destinationLabel = "Au travail23"
        
        sut.journeysRequest = journeysRequest
        sut.viewDidLoad()
        
        XCTAssertEqual(sut.fromLabel.text, "Chez moi23")
        XCTAssertEqual(sut.toLabel.text, "Au travail23")
        
        journeysRequest.originLabel = "Chez moi2"
        journeysRequest.destinationLabel = "Au travail2"
        
        sut.journeysRequest = journeysRequest
        sut.viewDidLoad()
        
        XCTAssertEqual(sut.fromLabel.text, "Chez moi2")
        XCTAssertEqual(sut.toLabel.text, "Au travail2")
    }
    
}
