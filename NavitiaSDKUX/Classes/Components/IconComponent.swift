//
//  IconComponent.swift
//  RenderTest
//
//  Created by Thomas Noury on 26/07/2017.
//  Copyright © 2017 Kisio. All rights reserved.
//

import Foundation
import Render

class IconComponent: LabelComponent {
    var name: String = ""
    
    override func render() -> NodeType {
        let computedStyles = mergeDictionaries(dict1: iconStyles, dict2: self.styles)
        return ComponentNode(LabelComponent(), in: self, props: {(component, hasKey: Bool) in
            component.text = String.fontString(name: self.name)
            component.styles = computedStyles
        })
    }
    
    let iconStyles: [String: Any] = [
        "fontFamily": "SDKIcons",
        "fontSize": 24,
    ]
}
