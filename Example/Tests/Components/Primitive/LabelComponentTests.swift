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

class LabelComponentTests: XCTestCase {
    func testInit() {
        let labelComponent: LabelComponent = LabelComponent()

        XCTAssertNotNil(labelComponent)
    }

    func testApplyLabelStylesWithSimpleProperties() {
        let labelComponent: LabelComponent = LabelComponent()
        labelComponent.styles = [
            "color": UIColor.blue,
            "numberOfLines": 10,
            "lineBreakMode": NSLineBreakMode.byWordWrapping,
            "fontSize": 22,
            "fontWeight": "bold",
        ]

        let nodeView = Node<UILabel>()
        nodeView.build()
        labelComponent.applyLabelStyles(view: nodeView.view!, layout: nodeView.view!.yoga)

        XCTAssertNotNil(nodeView, "Node<UILabel> should not be nil")
        XCTAssertNotNil(nodeView.view, "Node<UILabel>.view should not be nil")
        XCTAssertEqual(nodeView.view!.textColor, UIColor.blue, "Node<UILabel>.view.textColor should be mapped")
        XCTAssertEqual(nodeView.view!.numberOfLines, 10, "Node<UILabel>.view.numberOfLines should be mapped")
        XCTAssertEqual(nodeView.view!.lineBreakMode, NSLineBreakMode.byWordWrapping, "Node<UILabel>.view.lineBreakMode should be mapped")
        XCTAssertTrue(nodeView.view!.font.fontName.contains("Bold"), "Node<UILabel>.view.font.fontName should be mapped")
        XCTAssertEqual(nodeView.view!.font.pointSize, 22, "Node<UILabel>.view.font.pointSize should be mapped")
    }

    func testApplyLabelStylesWithFontFamilyChanging() {
        let labelComponent: LabelComponent = LabelComponent()
        labelComponent.styles = [
            "fontFamily": "SDKIcons"
        ]

        let nodeView = Node<UILabel>()
        nodeView.build()
        labelComponent.applyLabelStyles(view: nodeView.view!, layout: nodeView.view!.yoga)

        //nodeView.view!.font.fontName
        XCTAssertNotNil(nodeView, "Node<UILabel> should not be nil")
        XCTAssertNotNil(nodeView.view, "Node<UILabel>.view should not be nil")
        // Should have a test checking the fontFamily was mapped
    }
}
