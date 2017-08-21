//
//  ModeComponent.swift
//  RenderTest
//
//  Created by Thomas Noury on 27/07/2017.
//  Copyright © 2017 Kisio. All rights reserved.
//

import Foundation
import Render

class ModeComponent: ViewComponent {
    var name: String = ""
    
    override func render() -> NodeType {
        let computedStyles = mergeDictionaries(dict1: iconStyles, dict2: self.styles)
        return ComponentNode(IconComponent(), in: self, props: {(component, hasKey: Bool) in
            component.name = self.name
            component.styles = computedStyles
        })
    }
    
    let iconStyles = [
        "color": config.colors.darkerGray,
    ]
}
