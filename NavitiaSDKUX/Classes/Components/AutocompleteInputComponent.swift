//
//  AutocompleteInputComponent.swift
//  RenderTest
//
//  Created by Thomas Noury on 26/07/2017.
//  Copyright © 2017 Kisio. All rights reserved.
//

import Render

class AutocompleteInputComponent: ButtonComponent {
    let PlaceComponent:Components.Common.PlaceComponent.Type = Components.Common.PlaceComponent.self
    
    var icon: String = ""
    var iconColor: UIColor? = nil
    var placeName: String = ""
    
    override func render() -> NodeType {
        let iconColorStyles:[String: Any] = ["color": self.iconColor as Any]
        let iconComputedStyles = mergeDictionaries(dict1: iconColorStyles, dict2: iconStyles)
        let computedStyles = self.styles
        return ComponentNode(ButtonComponent(), in: self, props: {(component, hasKey: Bool) in
            component.styles = computedStyles
        }).add(children: [
            ComponentNode(ViewComponent(), in: self, props: {(component, hasKey: Bool) in
                component.styles = self.rowStyles
            }).add(children: [
                ComponentNode(ViewComponent(), in: self, props: {(component, hasKey: Bool) in
                    component.styles = self.containerStyles
                }).add(children: [
                    ComponentNode(IconComponent(), in: self, props: {(component, hasKey: Bool) in
                        component.name = self.icon
                        component.styles = iconComputedStyles
                    }),
                    ComponentNode(ViewComponent(), in: self).add(children: [
                        ComponentNode(PlaceComponent.init(), in: self, props: {(component, hasKey: Bool) in
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
        "padding": 12,
        "flexDirection": YGFlexDirection.row,
        "alignItems": YGAlign.center,
        "paddingRight": 8,
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
