//
//  ContainerComponent.swift
//  RenderTest
//
//  Created by Thomas Noury on 26/07/2017.
//  Copyright © 2017 Kisio. All rights reserved.
//

import Foundation
import Render

class ContainerComponent: ViewComponent {
    var containerSize: String = ""
    
    override func render() -> NodeType {
        let computedStyles: [String: Any] = mergeDictionaries(dict1: smallStyles, dict2: self.styles)
        return ComponentNode(ViewComponent(), in: self, props: {(component, hasKey: Bool) in
            component.styles = computedStyles
        })
    }
    
    let smallStyles = [
        "padding": 10,
    ]
    let standardStyles = [
        "padding": 20,
    ]
}
