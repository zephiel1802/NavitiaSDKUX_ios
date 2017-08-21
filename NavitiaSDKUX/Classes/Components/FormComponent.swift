//
//  FormComponent.swift
//  RenderTest
//
//  Created by Thomas Noury on 26/07/2017.
//  Copyright © 2017 Kisio. All rights reserved.
//

import Foundation
import Render

class FormComponent: ViewComponent {
    override func render() -> NodeType {
        let computedStyles = mergeDictionaries(dict1: formStyles, dict2: self.styles)
        return ComponentNode(ViewComponent(), in: self, props: {(component, hasKey: Bool) in
            component.styles = computedStyles
        })
    }
    
    let formStyles: [String: Any] = [
        "backgroundColor": config.colors.white,
        "borderRadius": config.metrics.radius,
    ]
}
