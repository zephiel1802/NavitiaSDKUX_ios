//
//  SeparatorComponent.swift
//  RenderTest
//
//  Created by Thomas Noury on 26/07/2017.
//  Copyright © 2017 Kisio. All rights reserved.
//

import Foundation
import Render

class SeparatorComponent: ViewComponent {
    override func render() -> NodeType {
        let computedStyles = mergeDictionaries(dict1: lineStyles, dict2: self.styles)
        return ComponentNode(ViewComponent(), in: self, props: {(component, hasKey: Bool) in
            component.styles = computedStyles
        })
    }
    
    let lineStyles: [String: Any] = [
        "height": 1,
        "backgroundColor": config.colors.secondary,
    ]
}
