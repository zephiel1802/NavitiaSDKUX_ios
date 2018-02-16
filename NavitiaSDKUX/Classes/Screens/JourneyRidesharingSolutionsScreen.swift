//
//  JourneyRidesharingDetailsScreen.swift
//  NavitiaSDKUX
//
//  Created by Rachik Abidi on 16/02/2018.
//

import Foundation
import Render
import NavitiaSDK

public struct JourneyRidesharingSolutionsScreenState: StateType {
    public init() {}
    var ridesharingJourney: Journey?
}

open class JourneyRidesharingSolutionsScreen: StylizedComponent<JourneyRidesharingSolutionsScreenState> {
    var navigationController: UINavigationController?
    
    open override func render() -> NodeType {
        return ComponentNode(ScreenComponent(), in: self).add(children: [
            ComponentNode(ScreenHeaderComponent(), in: self, props: { (component, _) in
                component.navigationController = self.navigationController
                component.styles = self.screenHeaderStyle
            }),
            ComponentNode(ScrollViewComponent(), in: self).add(children: [
                
            ])
        ])
    }
    
    let screenHeaderStyle: [String: Any] = [
        "backgroundColor": config.colors.tertiary,
        "height": 20,
    ]
}
