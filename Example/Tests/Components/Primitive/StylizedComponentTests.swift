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

    func testApplyStylesWithSimpleProperties() {
        let stylizedComponent: StylizedComponent<NilState> = StylizedComponent<NilState>()
        stylizedComponent.styles = [
            "alpha": CGFloat(0.1),
            "backgroundColor": UIColor.white,
            "borderRadius": 2,
            "direction": YGDirection.LTR,
            "flexDirection": YGFlexDirection.column,
            "justifyContent": YGJustify.center,
            "alignContent": YGAlign.auto,
            "alignItems": YGAlign.flexStart,
            "alignSelf": YGAlign.baseline,
            "position": YGPositionType.relative,
            "flexWrap": YGWrap.noWrap,
            "overflow": YGOverflow.hidden,
            "display": YGDisplay.flex,
            "flexGrow": 2,
            "flexShrink": 3,
            "flexBasis": CGFloat(4),
            "left": 5,
            "top": 6,
            "right": 7,
            "bottom": 8,
            "start": 9,
            "end": 10,
            "marginLeft": 11,
            "marginTop": 12,
            "marginRight": 13,
            "marginBottom": 14,
            "marginStart": 15,
            "marginEnd": 16,
            "marginHorizontal": 17,
            "marginVertical": 18,
            "margin": 19,
            "paddingLeft": 20,
            "paddingTop": 21,
            "paddingRight": 22,
            "paddingBottom": 23,
            "paddingStart": 24,
            "paddingEnd": 25,
            "paddingHorizontal": 26,
            "paddingVertical": 27,
            "padding": 28,
            "borderLeftWidth": 29,
            "borderTopWidth": 30,
            "borderRightWidth": 31,
            "borderBottomWidth": 32,
            "borderStartWidth": 33,
            "borderEndWidth": 34,
            "borderWidth": 40,
            "borderColor": UIColor.blue,
            "width": 35,
            "height": 41,
            "minWidth": 36,
            "minHeight": 37,
            "maxWidth": 38,
            "maxHeight": 39,
            "shadowRadius": 0.2,
            "shadowOpacity": 0.3,
            "shadowColor": UIColor.black,
            "shadowOffset": "Whatever"
        ]

        let nodeView = Node<UIView>()
        nodeView.build()
        stylizedComponent.applyStyles(view: nodeView.view!, layout: nodeView.view!.yoga)

        XCTAssertNotNil(nodeView, "Node<UIView> should not be nil")
        XCTAssertNotNil(nodeView.view, "Node<UIView>.view should not be nil")
        XCTAssertTrue(abs(nodeView.view!.alpha - 0.1) < 0.00001, "Node<UIView>.view.alpha should be mapped")
        XCTAssertEqual(nodeView.view!.backgroundColor, UIColor.white, "Node<UIView>.view.backgroundColor should be mapped")
        XCTAssertEqual(nodeView.view!.cornerRadius, 2, "Node<UIView>.view.cornerRadius should be mapped")
        XCTAssertEqual(nodeView.view!.yoga.direction, YGDirection.LTR, "Node<UIView>.view.yoga.direction should be mapped")
        XCTAssertEqual(nodeView.view!.yoga.flexDirection, YGFlexDirection.column, "Node<UIView>.view.yoga.flexDirection should be mapped")
        XCTAssertEqual(nodeView.view!.yoga.justifyContent, YGJustify.center, "Node<UIView>.view.yoga.justifyContent should be mapped")
        XCTAssertEqual(nodeView.view!.yoga.alignContent, YGAlign.auto, "Node<UIView>.view.yoga.alignContent should be mapped")
        XCTAssertEqual(nodeView.view!.yoga.alignItems, YGAlign.flexStart, "Node<UIView>.view.yoga.alignItems should be mapped")
        XCTAssertEqual(nodeView.view!.yoga.alignSelf, YGAlign.baseline, "Node<UIView>.view.yoga.alignSelf should be mapped")
        XCTAssertEqual(nodeView.view!.yoga.position, YGPositionType.relative, "Node<UIView>.view.yoga.position should be mapped")
        XCTAssertEqual(nodeView.view!.yoga.flexWrap, YGWrap.noWrap, "Node<UIView>.view.yoga.flexWrap should be mapped")
        XCTAssertEqual(nodeView.view!.yoga.overflow, YGOverflow.hidden, "Node<UIView>.view.yoga.overflow should be mapped")
        XCTAssertEqual(nodeView.view!.yoga.display, YGDisplay.flex, "Node<UIView>.view.yoga.display should be mapped")
        XCTAssertEqual(nodeView.view!.yoga.flexGrow, 2, "Node<UIView>.view.yoga.flexGrow should be mapped")
        XCTAssertEqual(nodeView.view!.yoga.flexShrink, 3, "Node<UIView>.view.yoga.flexShrink should be mapped")
        XCTAssertEqual(nodeView.view!.yoga.flexBasis, 4, "Node<UIView>.view.yoga.flexBasis should be mapped")
        XCTAssertEqual(nodeView.view!.yoga.left, 5, "Node<UIView>.view.yoga.left should be mapped")
        XCTAssertEqual(nodeView.view!.yoga.top, 6, "Node<UIView>.view.yoga.top should be mapped")
        XCTAssertEqual(nodeView.view!.yoga.right, 7, "Node<UIView>.view.yoga.right should be mapped")
        XCTAssertEqual(nodeView.view!.yoga.bottom, 8, "Node<UIView>.view.yoga.bottom should be mapped")
        XCTAssertEqual(nodeView.view!.yoga.start, 9, "Node<UIView>.view.yoga.start should be mapped")
        XCTAssertEqual(nodeView.view!.yoga.end, 10, "Node<UIView>.view.yoga.end should be mapped")
        XCTAssertEqual(nodeView.view!.yoga.marginLeft, 11, "Node<UIView>.view.yoga.marginLeft should be mapped")
        XCTAssertEqual(nodeView.view!.yoga.marginTop, 12, "Node<UIView>.view.yoga.marginTop should be mapped")
        XCTAssertEqual(nodeView.view!.yoga.marginRight, 13, "Node<UIView>.view.yoga.marginRight should be mapped")
        XCTAssertEqual(nodeView.view!.yoga.marginBottom, 14, "Node<UIView>.view.yoga.marginBottom should be mapped")
        XCTAssertEqual(nodeView.view!.yoga.marginStart, 15, "Node<UIView>.view.yoga.marginStart should be mapped")
        XCTAssertEqual(nodeView.view!.yoga.marginEnd, 16, "Node<UIView>.view.yoga.marginEnd should be mapped")
        XCTAssertEqual(nodeView.view!.yoga.marginHorizontal, 17, "Node<UIView>.view.yoga.marginHorizontal should be mapped")
        XCTAssertEqual(nodeView.view!.yoga.marginVertical, 18, "Node<UIView>.view.yoga.marginVertical should be mapped")
        XCTAssertEqual(nodeView.view!.yoga.margin, 19, "Node<UIView>.view.yoga.margin should be mapped")
        XCTAssertEqual(nodeView.view!.yoga.paddingLeft, 20, "Node<UIView>.view.yoga.paddingLeft should be mapped")
        XCTAssertEqual(nodeView.view!.yoga.paddingTop, 21, "Node<UIView>.view.yoga.paddingTop should be mapped")
        XCTAssertEqual(nodeView.view!.yoga.paddingRight, 22, "Node<UIView>.view.yoga.paddingRight should be mapped")
        XCTAssertEqual(nodeView.view!.yoga.paddingBottom, 23, "Node<UIView>.view.yoga.paddingBottom should be mapped")
        XCTAssertEqual(nodeView.view!.yoga.paddingStart, 24, "Node<UIView>.view.yoga.paddingStart should be mapped")
        XCTAssertEqual(nodeView.view!.yoga.paddingEnd, 25, "Node<UIView>.view.yoga.paddingEnd should be mapped")
        XCTAssertEqual(nodeView.view!.yoga.paddingHorizontal, 26, "Node<UIView>.view.yoga.paddingHorizontal should be mapped")
        XCTAssertEqual(nodeView.view!.yoga.paddingVertical, 27, "Node<UIView>.view.yoga.paddingVertical should be mapped")
        XCTAssertEqual(nodeView.view!.yoga.padding, 28, "Node<UIView>.view.yoga.padding should be mapped")
        XCTAssertEqual(nodeView.view!.yoga.borderLeftWidth, 29, "Node<UIView>.view.yoga.borderLeftWidth should be mapped")
        XCTAssertEqual(nodeView.view!.yoga.borderTopWidth, 30, "Node<UIView>.view.yoga.borderTopWidth should be mapped")
        XCTAssertEqual(nodeView.view!.yoga.borderRightWidth, 31, "Node<UIView>.view.yoga.borderRightWidth should be mapped")
        XCTAssertEqual(nodeView.view!.yoga.borderBottomWidth, 32, "Node<UIView>.view.yoga.borderBottomWidth should be mapped")
        XCTAssertEqual(nodeView.view!.yoga.borderStartWidth, 33, "Node<UIView>.view.yoga.borderStartWidth should be mapped")
        XCTAssertEqual(nodeView.view!.yoga.borderEndWidth, 34, "Node<UIView>.view.yoga.borderEndWidth should be mapped")
        XCTAssertEqual(nodeView.view!.layer.borderWidth, 40, "Node<UIView>.view.layer.borderWidth should be mapped")
        XCTAssertEqual(nodeView.view!.layer.borderColor, UIColor.blue.cgColor, "Node<UIView>.view.layer.borderColor should be mapped")
        XCTAssertEqual(nodeView.view!.yoga.width, 35, "Node<UIView>.view.yoga.width should be mapped")
        XCTAssertEqual(nodeView.view!.yoga.height, 41, "Node<UIView>.view.yoga.height should be mapped")
        XCTAssertEqual(nodeView.view!.yoga.minWidth, 36, "Node<UIView>.view.yoga.minWidth should be mapped")
        XCTAssertEqual(nodeView.view!.yoga.minHeight, 37, "Node<UIView>.view.yoga.minHeight should be mapped")
        XCTAssertEqual(nodeView.view!.yoga.maxWidth, 38, "Node<UIView>.view.yoga.maxWidth should be mapped")
        XCTAssertEqual(nodeView.view!.yoga.maxHeight, 39, "Node<UIView>.view.yoga.maxHeight should be mapped")
        XCTAssertEqual(nodeView.view!.layer.shadowRadius, 0.2, "Node<UIView>.view.layer.shadowRadius should be mapped")
        XCTAssertEqual(nodeView.view!.layer.shadowOpacity, 0.3, "Node<UIView>.view.layer.shadowOpacity should be mapped")
        XCTAssertEqual(nodeView.view!.layer.shadowColor, UIColor.black.cgColor, "Node<UIView>.view.layer.shadowColor should be mapped")
        //XCTAssertEqual(nodeView.view!.layer.masksToBounds, false, "Node<UIView>.view.layer.masksToBounds should be mapped")
        XCTAssertEqual(nodeView.view!.layer.shadowOffset, CGSize(width: 0, height: 0), "Node<UIView>.view.layer.shadowOffset should be mapped")
    }
}
