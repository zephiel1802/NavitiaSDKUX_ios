//
//  AutocompleteInputPart.swift
//  RenderTest
//
//  Created by Thomas Noury on 26/07/2017.
//  Copyright © 2017 Kisio. All rights reserved.
//

import Render

extension Components.Journey.Results.FormComponentParts {
    class AutocompleteInputPart: ButtonComponent {
        let PlacePart:Components.Journey.Results.FormComponentParts.PlacePart.Type = Components.Journey.Results.FormComponentParts.PlacePart.self
        
        var icon: String = ""
        var iconColor: UIColor? = nil
        var placeName: String = ""
        
        override func render() -> NodeType {
            let iconColorStyles:[String: Any] = ["color": self.iconColor as Any]
            let iconComputedStyles = mergeDictionaries(dict1: iconColorStyles, dict2: iconStyles)
            let computedStyles = self.styles
            return ComponentNode(ButtonComponent(), in: self, props: {(component, _) in
                component.styles = computedStyles
            }).add(children: [
                ComponentNode(ViewComponent(), in: self, props: {(component, _) in
                    component.styles = self.rowStyles
                }).add(children: [
                    ComponentNode(ViewComponent(), in: self, props: {(component, _) in
                        component.styles = self.containerStyles
                    }).add(children: [
                        ComponentNode(IconComponent(), in: self, props: {(component, _) in
                            component.name = self.icon
                            component.styles = iconComputedStyles
                        }),
                        ComponentNode(ViewComponent(), in: self).add(children: [
                            ComponentNode(PlacePart.init(), in: self, props: {(component, _) in
                                component.name = self.placeName
                            })
                        ])
                    ])
                ])
            ])
        }
        
        let rowStyles: [String: Any] = [
            "flexDirection": YGFlexDirection.row,
        ]
        let containerStyles: [String: Any] = [
            "padding": config.metrics.marginS * 3,
            "flexDirection": YGFlexDirection.row,
            "alignItems": YGAlign.center,
            "paddingRight": config.metrics.margin,
        ]
        let iconStyles: [String: Any] = [
            "width": 32,
            "fontSize": 26,
        ]
        let titleStyles: [String: Any] = [
            "fontWeight": "bold",
            "color": config.colors.darkGray,
        ]
        let placeholderStyles: [String: Any] = [
            "color": config.colors.gray,
            "fontSize": 14,
        ]
    }
}
