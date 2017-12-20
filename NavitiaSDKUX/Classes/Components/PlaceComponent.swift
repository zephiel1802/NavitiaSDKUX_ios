//
//  PlaceComponent.swift
//  RenderTest
//
//  Created by Thomas Noury on 01/08/2017.
//  Copyright © 2017 Kisio. All rights reserved.
//

import Foundation
import Render

extension Components.Common {
    class PlaceComponent: ViewComponent {
        var name: String = ""
        
        override func render() -> NodeType {
            let computedStyles = mergeDictionaries(dict1: nameStyles, dict2: self.styles)
            return ComponentNode(TextComponent(), in: self, props: {(component, hasKey: Bool) in
                component.text = self.name
                component.styles = computedStyles
            })
        }
        
        let nameStyles: [String: Any] = [
            "fontWeight": "bold",
            "marginEnd": config.metrics.marginS,
        ]
    }
}
