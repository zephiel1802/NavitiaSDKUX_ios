//
//  JourneyFormComponent.swift
//  RenderTest
//
//  Created by Thomas Noury on 26/07/2017.
//  Copyright © 2017 Kisio. All rights reserved.
//

import Foundation
import Render
import NavitiaSDK

class JourneyFormComponent: ViewComponent {
    var origin: String = ""
    var destination: String = ""
    
    override func render() -> NodeType {
        let computedStyles = self.styles
        return ComponentNode(FormComponent(), in: self, props: {(component, hasKey: Bool) in
            component.styles = computedStyles
        }).add(children: [
            ComponentNode(AutocompleteInputComponent(), in: self, props: {(component, hasKey: Bool) in
                component.icon = "origin"
                component.iconColor = config.colors.origin
                component.placeName = self.origin
                
            }),
            ComponentNode(SeparatorComponent(), in: self),
            ComponentNode(AutocompleteInputComponent(), in: self, props: {(component, hasKey: Bool) in
                component.icon = "destination"
                component.iconColor = config.colors.destination
                component.placeName = self.destination
            })
        ])
    }
}
