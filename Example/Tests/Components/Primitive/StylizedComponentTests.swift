//
//  StylizedComponentTests.swift
//  NavitiaSDKUX
//
//  Created by Chakkra CHAK on 24/10/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import XCTest
import Render
import NavitiaSDKUX

class StylizedComponentTests: XCTestCase {
    func testInit() {
        let stylizedComponent: StylizedComponent<NilState> = StylizedComponent<NilState>()

        XCTAssertNotNil(stylizedComponent)
    }

    func testApplyStyles() {
        let stylizedComponent: StylizedComponent<NilState> = StylizedComponent<NilState>()
        stylizedComponent.styles = [
            "alpha": CGFloat(0.1),
            "backgroundColor": UIColor.white,
            "borderRadius": 2
        ]

        let nodeView = Node<UIView>()
        nodeView.build()
        stylizedComponent.applyStyles(view: nodeView.view!, layout: nodeView.view!.yoga)

        XCTAssertNotNil(nodeView, "Node<UIView> should not be nil")
        XCTAssertNotNil(nodeView.view, "Node<UIView>.view should not be nil")
        XCTAssertTrue(abs(nodeView.view!.alpha - 0.1) < 0.00001, "Node<UIView>.view.alpha should be mapped")
        XCTAssertEqual(nodeView.view!.backgroundColor, UIColor.white, "Node<UIView>.view.backgroundColor should be mapped")
        XCTAssertEqual(nodeView.view!.cornerRadius, 2, "Node<UIView>.view.cornerRadius should be mapped")
    }
}
