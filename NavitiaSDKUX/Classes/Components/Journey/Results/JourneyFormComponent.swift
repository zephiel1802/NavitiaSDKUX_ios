//
//  JourneyFormComponent.swift
//  RenderTest
//
//  Created by Thomas Noury on 26/07/2017.
//  Copyright © 2017 Kisio. All rights reserved.
//

import Foundation

extension Components.Journey.Results {
    class JourneyFormComponent: ViewComponent {
        let AutocompleteInputPart:Components.Journey.Results.FormComponentParts.AutocompleteInputPart.Type = Components.Journey.Results.FormComponentParts.AutocompleteInputPart.self
        let SeparatorPart:Components.Journey.Results.Parts.SeparatorPart.Type = Components.Journey.Results.Parts.SeparatorPart.self
        
        var origin: String = ""
        var destination: String = ""
        
        override func render() -> NodeType {
            let computedStyles = self.styles
            return ComponentNode(FormComponent(), in: self, props: {(component, _) in
                component.styles = computedStyles
            }).add(children: [
                ComponentNode(AutocompleteInputPart.init(), in: self, props: {(component, _) in
                    component.icon = "location-pin"
                    component.iconColor = config.colors.origin
                    component.placeName = self.origin
                    
                }),
                ComponentNode(SeparatorPart.init(), in: self),
                ComponentNode(AutocompleteInputPart.init(), in: self, props: {(component, _) in
                    component.icon = "location-pin"
                    component.iconColor = config.colors.destination
                    component.placeName = self.destination
                })
            ])
        }
    }
}
